
# realtek-rtl88xxau-AutomaticDriverInstall

A shell script to automate the installation of Realtek RTL88xxAU wireless network drivers on Linux systems. This script supports installing the drivers via package managers or from source and handles kernel header updates, existing driver removal, and system updates.

## Supported Network Adapters

The following Realtek chipsets are supported by this script (based on the RTL88xxAU driver from Aircrack-ng):

- **RTL8812AU**  
- **RTL8821AU**  
- **RTL8814AU**

These chipsets are commonly used in USB Wi-Fi adapters such as:

- TP-Link Archer T4U
- TP-Link Archer T2U
- TP-Link Archer T2UH
- TP-Link Archer T4UH
- TP-Link Archer T2U Plus
- Alfa AWUS036AC
- Alfa AWUS036ACH
- Alfa AWUS036EAC
- Edimax EW-7822UAC
- ASUS USB-AC51
- ASUS USB-AC56
- Netgear A6210

Make sure to confirm your adapter is using one of the supported chipsets before running the script.

## Requirements

- A Linux distribution based on **Debian/Ubuntu** or **RedHat/Fedora**.
- Package manager support for `apt-get` or `dnf`.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Jamie0118/realtek-rtl88xxau-AutomaticInstall
   cd realtek-rtl88xxau-AutomaticDriverInstall
   ```

2. Make the script executable:
   ```bash
   chmod +x realtek-rtl88xxau-AutomaticDriverInstall.sh
   ```

3. Run the script with root privileges:
   ```bash
   sudo ./realtek-rtl88xxau-AutomaticDriverInstall.sh
   ```

4. Follow the on-screen instructions to complete the installation.

## Usage

The script offers the following functionality:
- Installs or updates the kernel headers for your system.
- Checks if a Realtek RTL88xxAU driver is already installed.
- Removes existing driver installations if requested.
- Allows you to choose between installing drivers using the package manager or from source.

## Troubleshooting

- **Kernel Headers Missing**: Ensure that your system has the correct kernel headers installed. The script attempts to detect and install them automatically.
- **Driver Compilation Fails**: Check if your system has `build-essential` or equivalent tools installed.
- **Unsupported Adapter**: Ensure your Wi-Fi adapter uses one of the supported chipsets listed above.

## Contributing

Feel free to fork the repository and submit pull requests to enhance the functionality or add support for more distributions and drivers.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
