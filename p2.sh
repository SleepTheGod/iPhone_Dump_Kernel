#!/bin/bash

LOGFILE="$HOME/kernel_panic_log.txt"
echo "Kernel Panic Information - $(date)" >> $LOGFILE
echo "-------------------------------------" >> $LOGFILE
echo "iOS Version: $(sw_vers -productVersion 2>/dev/null || echo "Not on macOS")" >> $LOGFILE
echo "Device Model: $(uname -m)" >> $LOGFILE

if [ -n "$1" ]; then
    echo "Kernel Panic String:" >> $LOGFILE
    echo "$1" >> $LOGFILE
fi

echo "Network Status:" >> $LOGFILE
ifconfig >> $LOGFILE

echo "-------------------------------------" >> $LOGFILE
echo "Log saved to $LOGFILE"

dmesg > /var/log/kernel_dump.log
echo "Kernel logs dumped to /var/log/kernel_dump.log."
