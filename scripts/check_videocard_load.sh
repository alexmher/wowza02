#!/bin/bash

# Define the service name and log file
SERVICE_NAME="WowzaStreamingEngine"
LOG_FILE="/var/log/videocard_load_check.log"

# Get the current timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "$TIMESTAMP - Starting GPU load check..." >> $LOG_FILE

# Initialize counter for low load occurrences
LOW_LOAD_COUNT=0

# Loop 3 times with 15-second intervals
for i in {1..3}; do
    CURRENT_TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    GPU_LOAD=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n 1)

    echo "$CURRENT_TIMESTAMP - Check $i: GPU Load: $GPU_LOAD%" >> $LOG_FILE

    if [ "$GPU_LOAD" -lt 1 ]; then
        ((LOW_LOAD_COUNT++))
    fi

    # Sleep for 15 seconds unless it's the last iteration
    if [ "$i" -lt 3 ]; then
        sleep 15
    fi
done

# Final decision
FINAL_TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
if [ "$LOW_LOAD_COUNT" -eq 3 ]; then
    echo "$FINAL_TIMESTAMP - GPU load was below 1% in all 3 checks, restarting $SERVICE_NAME..." >> $LOG_FILE
    systemctl restart $SERVICE_NAME
    echo "$FINAL_TIMESTAMP - Service $SERVICE_NAME restarted." >> $LOG_FILE
else
    echo "$FINAL_TIMESTAMP - GPU load not consistently low (only $LOW_LOAD_COUNT/3), no action taken." >> $LOG_FILE
fi
