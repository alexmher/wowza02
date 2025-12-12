# Set the threshold for memory usage in megabytes
threshold=20

# Function to check memory usage
check_memory() {
    used_memory=$(free -g | awk 'NR==2{print $4}')
    date >> /var/log/bufmemcheck
    echo "Used Memory: ${used_memory}GB" >> /var/log/bufmemcheck

    if [ "$used_memory" -lt "$threshold" ]; then
        restart_service
    else
        echo "Memory usage is below the threshold. No action required." >> /var/log/bufmemcheck
    fi
}

# Function to restart the service
restart_service() {
    echo "Memory usage exceeds the threshold. Clearing caches..." >> /var/log/bufmemcheck
    sh -c 'echo 3 >  /proc/sys/vm/drop_caches'

    echo "Caches cleared." >> /var/log/bufmemcheck
}

# Check memory and take action
check_memory
