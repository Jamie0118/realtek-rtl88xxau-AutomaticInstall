#!/bin/bash
cat << "EOF"


       _                 _         ___  __ __  ___  
      | |               (_)       / _ \/_ /_ |/ _ \ 
      | | __ _ _ __ ___  _  ___  | | | || || | (_) |
  _   | |/ _` | '_ ` _ \| |/ _ \ | | | || || |> _ < 
 | |__| | (_| | | | | | | |  __/ | |_| || || | (_) |
  \____/ \__,_|_| |_| |_|_|\___|  \___/ |_||_|\___/ 
                                                    
                                                    

EOF
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
        echo "Unsupported Linux distribution. Bye!"
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
    sudo "$PACKAGE_MANAGER" update -y || { echo "Failed to update repositories. Exiting."; exit 1; }
    sudo "$PACKAGE_MANAGER" install -y linux-headers-$(uname -r) || { 
        echo "Failed to install kernel headers. Exiting."; 
        exit 1; 
    }
    echo "Kernel headers installed successfully."
}

update_system() {
    echo "Updating and upgrading the system..."
    sudo "$PACKAGE_MANAGER" update -y && \
    sudo "$PACKAGE_MANAGER" upgrade -y && \
    sudo "$PACKAGE_MANAGER" dist-upgrade -y
}

check_existing_driver() {
    if lsmod | grep -q "88XXau"; then
        echo "Driver already installed."
        read -p "Do you want to remove the existing installation? (y/n): " REMOVE_CHOICE

        if [[ "$REMOVE_CHOICE" == "Y" || "$REMOVE_CHOICE" == "y" ]]; then
            echo "Removing existing driver installation..."
            sudo rmmod 88XXau || { echo "Failed to remove the driver from the kernel. Exiting."; exit 1; }
            echo "Driver uninstalled successfully."
        else
            echo "Skipping driver removal."
            exit 0
        fi
    fi
}

install_drivers() {
    echo "Installing rtl8812au drivers..."

    echo "Cloning the rtl8812au repository from aircrack-ng..."
    git clone https://github.com/aircrack-ng/rtl8812au.git || { echo "Failed to clone repository. Exiting."; exit 1; }

    echo "Building the driver..."
    cd rtl8812au || { echo "Failed to change directory. Exiting."; exit 1; }
    make clean
    make || { echo "Build failed. Exiting."; exit 1; }

    echo "Installing the driver..."
    sudo make install || { echo "Driver installation failed. Exiting."; exit 1; }

    echo "Loading the driver module..."
    sudo modprobe 8812au || { echo "Failed to load driver module. Exiting."; exit 1; }
    echo "Driver installation completed successfully."
}

reboot_prompt() {
    echo "Installation complete!"
    read -p "Do you want to reboot now? (y/n): " REBOOT_CHOICE
    if [[ "$REBOOT_CHOICE" == "Y" || "$REBOOT_CHOICE" == "y" ]]; then
        echo "Rebooting!"
        reboot
    else
        echo "Remember to restart your system for the changes to take effect."
    fi
}

# Main Execution Flow
check_root
check_distribution
update_system
install_git
install_kernel_headers
check_existing_driver
install_drivers
reboot_prompt
