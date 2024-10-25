#!/bin/bash

# Define log file for installation process
INSTALL_LOG="$HOME/ios_setup_install.log"
exec > >(tee -a "$INSTALL_LOG") 2>&1

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Function to install packages
install_packages() {
    echo "Updating package list..."
    apt update || { echo "Failed to update package list"; exit 1; }

    echo "Installing necessary packages..."
    apt install -y usbutils udev ios-tools dmesg || { echo "Package installation failed!"; exit 1; }
    echo "All necessary packages installed."
}

# Function to create udev rule for iPhone
create_udev_rule() {
    UDEV_RULE="/etc/udev/rules.d/99-ios-dfu.rules"
    echo "Creating udev rule..."

    cat <<EOL > $UDEV_RULE
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="05ac", RUN+="/usr/local/bin/dfu_instructions.sh"
EOL

    chmod 644 $UDEV_RULE || { echo "Failed to set permissions for udev rule"; exit 1; }
    echo "Udev rule created successfully."
}

# Function to create DFU instructions script
create_instructions_script() {
    INSTRUCTIONS_SCRIPT="/usr/local/bin/dfu_instructions.sh"
    echo "Creating DFU instructions script..."

    cat <<EOL > $INSTRUCTIONS_SCRIPT
#!/bin/bash
echo "Your iPhone has been connected."
echo "Please follow these steps to enter DFU mode:"
echo "1. Connect your iPhone to your computer."
echo "2. Turn off your iPhone."
echo "3. Press and hold the Power button for 3 seconds."
echo "4. While holding the Power button, press and hold the Volume Down button for 10 seconds."
echo "5. Release the Power button but continue holding the Volume Down button for another 5 seconds."
echo "If done correctly, your iPhone screen will be black, and it will be recognized in recovery mode."
EOL

    chmod +x $INSTRUCTIONS_SCRIPT || { echo "Failed to make instructions script executable"; exit 1; }
    echo "DFU instructions script created successfully."
}

# Function to create kernel log dump script
create_log_dump_script() {
    LOG_DUMP_SCRIPT="/usr/local/bin/dump_kernel_logs.sh"
    echo "Creating kernel log dump script..."

    cat <<EOL > $LOG_DUMP_SCRIPT
#!/bin/bash

LOGFILE="\$HOME/kernel_panic_log.txt"
echo "Kernel Panic Information - \$(date)" >> \$LOGFILE
echo "-------------------------------------" >> \$LOGFILE
echo "iOS Version: \$(sw_vers -productVersion 2>/dev/null || echo "Not on macOS")" >> \$LOGFILE
echo "Device Model: \$(uname -m)" >> \$LOGFILE

if [ -n "\$1" ]; then
    echo "Kernel Panic String:" >> \$LOGFILE
    echo "\$1" >> \$LOGFILE
fi

echo "Network Status:" >> \$LOGFILE
ifconfig >> \$LOGFILE

echo "-------------------------------------" >> \$LOGFILE
echo "Log saved to \$LOGFILE"

dmesg > /var/log/kernel_dump.log
echo "Kernel logs dumped to /var/log/kernel_dump.log."
EOL

    chmod +x $LOG_DUMP_SCRIPT || { echo "Failed to make log dump script executable"; exit 1; }
    echo "Kernel log dump script created successfully."
}

# Function to reload udev rules
reload_udev_rules() {
    echo "Reloading udev rules..."
    udevadm control --reload-rules || { echo "Failed to reload udev rules"; exit 1; }
    echo "Udev rules reloaded."
}

# Main script execution
install_packages
create_udev_rule
create_instructions_script
create_log_dump_script
reload_udev_rules

echo "Setup complete! Please connect your iPhone to see the instructions."
echo "Installation log saved to $INSTALL_LOG"
