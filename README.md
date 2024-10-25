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




Example of output

Kernel Panic Diagnostic Log - Oct 25, 2024
===========================================
Timestamp: 2024-10-25 14:35:22 UTC
Device Information:
-------------------------------------------
  iOS Version           : 15.0
  Device Model          : iPhone12,1 (iPhone 11)
  Kernel Version        : Darwin Kernel Version 20.3.0: Mon Jan 18 23:14:12 PST 2024; root:xnu-7195.81.3~1/RELEASE_ARM64_T8101
  CPU Architecture      : ARM64

Kernel Panic Summary:
-------------------------------------------
  Panic Location        : cpu 0 caller 0xfffffff00abcdef0
  Panic Type            : Kernel data abort
  Exception Class       : Data Abort (TLB - Kernel Virtual Memory)
  Faulting Address      : 0x0000000000000042
  Affected Process      : backboardd
  ESR (Exception Syndrome Register) : 0x96000045

Backtrace of Faulty Thread:
-------------------------------------------
0xffffff8012345678 : panic+0x158
0xffffff8012345678 : vm_fault+0x124
0xffffff8012345678 : translation_fault+0xf8
0xffffff8012345678 : page_fault+0x32
0xffffff8012345678 : kernel_pmap_enter+0x220
0xffffff8012345678 : vfs_context_proc+0x2f4
0xffffff8012345678 : kern_return_t mach_msg_receive+0x104
0xffffff8012345678 : 0xfffffff00f1ab3d1 - Kernel function

System Metrics at Time of Panic:
-------------------------------------------
  CPU Load (1 min)      : 27%
  CPU Load (5 min)      : 24%
  Total RAM             : 4 GB
  Used RAM              : 2.1 GB
  Free RAM              : 1.9 GB
  Disk Usage            : 8.7 GB used / 64 GB total
  Swap Usage            : 512 MB / 1 GB

Network Diagnostics:
-------------------------------------------
en0: flags=8863<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> mtu 1500
    ether a1:b2:c3:d4:e5:f6 
    inet 192.168.1.20 netmask 0xffffff00 broadcast 192.168.1.255
    inet6 fe80::a1b2:c3ff:fe4d:e5f6%en0 prefixlen 64 scopeid 0x4
    media: autoselect (1000baseT <full-duplex>)
    status: active
lo0: flags=8049<UP,LOOPBACK,RUNNING,MULTICAST> mtu 16384
    inet 127.0.0.1 netmask 0xff000000

Memory Dump Snapshot:
-------------------------------------------
  Physical Memory:
    Page size          : 4096 bytes
    Pages in use       : 544,257
    Free pages         : 121,743
    Pages wired        : 101,205
    Compressed pages   : 4,872
    Active pages       : 342,000
    Inactive pages     : 80,300
    Pageouts           : 812

  Virtual Memory:
    Swap used          : 512 MB / 1 GB
    Swap file count    : 1
    VM objects         : 108,743
    Kernel Memory      : 96 MB

Detailed Kernel Status:
-------------------------------------------
  Kernel Zone Allocation:
    Zone name         : Kernel_map
    Zone usage        : 22,345 pages
    Zone size         : 4096 KB
    Allocations       : 56,230 objects

  Mutex Information:
    Mutexes in use    : 18
    Mutex contention  : 3 (last 10 seconds)

  I/O Status:
    I/O Threads       : 12
    I/O operations    : 184/s
    Read operations   : 92/s
    Write operations  : 45/s

Application State:
-------------------------------------------
  Affected Process     : backboardd
  Process ID           : 234
  Process Memory       : 54 MB
  Thread Count         : 12
  Open File Descriptors: 67

System Messages Leading to Panic:
-------------------------------------------
  - [INFO] Starting panic log process at 2024-10-25 14:35:21
  - [WARN] Memory allocation at threshold; paging high
  - [ERROR] TLB exception at 0x0000000000000042
  - [INFO] Panic triggered by CPU fault at 0xfffffff00abcdef0
  - [INFO] Dumping backtrace information

-------------------------------------------
Log saved to /home/user/kernel_panic_diagnostic_log.txt
