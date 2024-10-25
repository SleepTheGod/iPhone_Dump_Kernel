iPhone Kernel Dump Project

Overview

This project automates the process of setting up the necessary environment and tools to extract and analyze kernel panic logs from an iPhone. It provides a fully automated setup script that installs dependencies, compiles the required libimobiledevice library, configures udev rules, and captures kernel logs when the iPhone is connected to a Linux system. This project supports Windows, Linux, and macOS for cross-platform compatibility and ease of use.

Repository Structure

main.sh - The main setup script which installs dependencies, configures the environment, and prepares the system for kernel log extraction
dump.sh - A script that captures and saves kernel logs and device information. Outputs are saved to kernel_panic_log.txt
iOS kernel panic and network status logs are stored in kernel_panic_log.txt and /var/log/kernel_dump.log for easy access and analysis
Features

Fully automated setup for dependency installation and library compilation (libimobiledevice)
Cross-platform support for Linux, Windows, and macOS
Automatically initiates DFU mode when the iPhone is connected, with instructions for extracting kernel logs
Logging of iOS version, device model, kernel panic information, network status, and system metrics
Consolidated logging output for efficient troubleshooting and debugging
Getting Started

Clone the repository git clone https://github.com/SleepTheGod/iPhone_Dump_Kernel.git cd iPhone_Dump_Kernel

Run the setup script ./main.sh This will install necessary dependencies, compile libimobiledevice, set up udev rules, and create the kernel log dump script

To initiate a kernel log capture, connect your iPhone and run ./dump.sh

The captured logs will be stored in

kernel_panic_log.txt in the user’s home directory for device-specific logs
/var/log/kernel_dump.log for system-wide logs
Dependencies

autoconf, automake, build-essential, git, libglib2.0-dev, libtool, pkg-config, libusb-1.0-0-dev for Linux
Windows users will need WSL or a Linux-based environment for compatibility with the main.sh script
Example Log Outputs

Kernel Panic Information - Oct 25, 2024
iOS Version - 15.0 Device Model - x86_64 Kernel Panic String - The kernel panic string (if any) will be logged here Network Status - en0 - flags=8863<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> mtu 1500 ether 01:23:45:67:89
inet 192.168.1.2 netmask 0xffffff00 broadcast 192.168.1.255
Log saved to /home/user/kernel_panic_log.txt
