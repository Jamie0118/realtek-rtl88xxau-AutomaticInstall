
# realtek-rtl88xxau-AutomaticDriverInstall

A shell script to automate the installation of Realtek RTL88xxAU wireless network drivers on Linux systems. This script supports installing the drivers via package managers or from source and handles kernel header updates, existing driver removal, and system updates.

## Supported Network Adapters

The following Realtek chipsets are supported by this script (based on the RTL88xxAU driver from Aircrack-ng):

- **RTL8812AU**  
- **RTL8821AU**  
- **RTL8814AU**

These chipsets are commonly used in USB Wi-Fi adapters such as:

- TP-Link Archer T4U
- TP-Link Archer T2U Plus
- Alfa AWUS036AC
- Alfa AWUS036ACH
- Edimax EW-7822UAC
- ASUS USB-AC56
- Netgear A6210

Make sure to confirm your adapter is using one of the supported chipsets before running the script.

## Features

- Checks for root privileges before execution.
- Detects the Linux distribution and adjusts commands accordingly (`apt-get` or `dnf`).
- Updates and installs necessary kernel headers.
- Removes any existing driver installations.
- Installs Realtek RTL88xxAU drivers via:
  - **Package Manager**: For distributions offering the driver as a package.
  - **Source Code**: Builds and installs the driver from the Aircrack-ng repository.
- Optionally reboots the system after installation.

## Requirements

- A Linux distribution based on **Debian/Ubuntu** or **RedHat/Fedora**.
- Package manager support for `apt-get` or `dnf`.
- Git installed for source installation.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/realtek-rtl88xxau-AutomaticDriverInstall.git
   cd realtek-rtl88xxau-AutomaticDriverInstall
   ```

2. Make the script executable:
   ```bash
   chmod +x install.sh
   ```

3. Run the script with root privileges:
   ```bash
   sudo ./install.sh
   ```

4. Follow the on-screen instructions to complete the installation.

## Usage

The script offers the following functionality:
- Installs or updates the kernel headers for your system.
- Checks if a Realtek RTL88xxAU driver is already installed.
- Removes existing driver installations if requested.
- Allows you to choose between installing drivers using the package manager or from source.

Example interaction:

```text
Driver already installed.
Do you want to remove the existing installation? (y/n): y
Removing existing driver installation...
Do you want to install Realtek drivers using the package manager (1) or from the source (2)? Enter 1 or 2: 2
Cloning the rtl8812au repository from Aircrack-ng...
Compiling the driver...
Installing the driver binaries...
Install complete!
Do you want to reboot now? (y/n): y
```

## Troubleshooting

- **Kernel Headers Missing**: Ensure that your system has the correct kernel headers installed. The script attempts to detect and install them automatically.
- **Driver Compilation Fails**: Check if your system has `build-essential` or equivalent tools installed.
- **Unsupported Adapter**: Ensure your Wi-Fi adapter uses one of the supported chipsets listed above.

## Contributing

Feel free to fork the repository and submit pull requests to enhance the functionality or add support for more distributions and drivers.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
