#!/bin/bash

LOGFILE="/var/log/videocard_check.log"

# Check if a video card is detected
if ! lspci | grep -iq vga; then
    echo "$(date) - Video card not detected! Restarting system..." | tee -a "$LOGFILE"
    sudo reboot
else
    echo "$(date) - Video card detected, system is OK." >> "$LOGFILE"
fi
