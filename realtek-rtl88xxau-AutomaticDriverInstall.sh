#!/bin/bash

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root. Use 'sudo' before this script."
        exit 1
    fi
}

check_distribution() {
    if [[ -f /etc/debian_version ]]; then
        PACKAGE_MANAGER="apt-get"
    elif [[ -f /etc/redhat-release ]]; then
        PACKAGE_MANAGER="dnf"
    else
        echo "Unsupported Linux distribution. bye!"
        exit 1
    fi
}

install_git() {
    if ! command -v git &> /dev/null; then
        echo "git is not installed. Installing..."
        sudo "$PACKAGE_MANAGER" install git -y
    fi
}

install_kernel_headers() {
    echo "Installing kernel headers..."
    echo "Updating package repositories..."
    sudo "$PACKAGE_MANAGER" update -y || { echo "Failed to update repositories. Exiting."; exit 1; }
    LATEST_HEADERS=$(apt-cache search linux-headers-$(uname -r) 2>/dev/null | grep "^linux-headers" | awk '{print $1}' | sort -V | tail -n 1)
    if [[ -z "$LATEST_HEADERS" ]]; then
        echo "Could not find specific kernel headers for $(uname -r). Trying generic headers"
        LATEST_HEADERS="linux-headers-generic"
    fi

    echo "Installing or reinstalling: $LATEST_HEADERS"
    if ! sudo "$PACKAGE_MANAGER" install -y --reinstall "$LATEST_HEADERS"; then
        echo "Failed to install kernel headers: $LATEST_HEADERS. Exiting."
        exit 1
    fi
    echo "Kernel headers installed successfully: $LATEST_HEADERS"
}


update_system() {
    echo "Setting DEBIAN_FRONTEND to noninteractive for updates."
    export DEBIAN_FRONTEND=noninteractive

    echo "Installing updates and upgrades. Give it some time."
    sudo "$PACKAGE_MANAGER" update -y && \
    sudo "$PACKAGE_MANAGER" upgrade -y && \
    sudo "$PACKAGE_MANAGER" dist-upgrade -y
}

check_existing_driver() {
    if lsmod | grep -q "88XXau"; then
        echo "Driver already installed."

        # Ask the user if they want to remove the existing driver
        read -p "Do you want to remove the existing installation? (y/n): " REMOVE_CHOICE

        if [[ "$REMOVE_CHOICE" == "Y" || "$REMOVE_CHOICE" == "y" ]]; then
            echo "Removing existing driver installation."

            # Unload the kernel module
            sudo rmmod 88XXau
            if [[ $? -ne 0 ]]; then
                echo "Failed to remove the driver from the kernel. Exiting."
                exit 1
            fi

            # Check if DKMS is managing the module and remove it
            if command -v dkms &> /dev/null; then
                # Need to specify the module and version for removal
                sudo dkms remove rtl8812au/<version> --all
                if [[ $? -ne 0 ]]; then
                    echo "Failed to remove the driver using DKMS. Continuing to manual removal..."
                fi
            fi

            # Manually remove the driver files from /lib/modules
            DRIVER_PATH="/lib/modules/$(uname -r)/kernel/drivers/net/wireless/88XXau.ko"
            if [[ -f "$DRIVER_PATH" ]]; then
                sudo rm -f "$DRIVER_PATH"
                echo "Driver files removed from $DRIVER_PATH."
            else
                echo "Driver files not found in $DRIVER_PATH. They might have already been removed."
            fi

            sudo depmod -a

            echo "Driver uninstalled successfully."
        else
            echo "Skipping driver removal."
            exit 0
        fi
    fi
}

install_drivers() {
        echo "Installing drivers"

        echo "Cloning the rtl88xxau repository from aircrack-ng..."
        sudo apt-get install dkms
        git clone https://github.com/n0ss/realtek-rtl88xxau-dkm

        echo "Building all necessary rtl8812 executable files into binary applications. This will take some time."
        cd realtek-rtl88xxau-dkm || { echo "Failed to change directory. Exiting."; exit 1; }

        echo "Cleaning builds..."
        make clean

        echo "Compiling the driver..."
        make
        if [[ $? -ne 0 ]]; then
            echo "Make command failed. Exiting."
            exit 1
        fi

        echo "Taking newly created binaries and copying them into the appropriate locations on the file system."
        sudo make install
        if [[ $? -ne 0 ]]; then
            echo "Installation of the driver binaries failed. Exiting."
            exit 1
        fi
}

check_root
check_distribution
update_system
install_git
install_kernel_headers
check_existing_driver
install_drivers

echo "Install complete!"
read -p "Do you want to reboot now? (y/n): " REBOOT_CHOICE
if [[ "$REBOOT_CHOICE" == "Y" || "$REBOOT_CHOICE" == "y" ]]; then
    echo "Rebooting!"
    reboot
else
    echo "Remember to restart"
    fi
