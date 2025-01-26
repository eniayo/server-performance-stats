#!/bin/bash

# Display total CPU usage
echo "===== CPU Usage ====="
cpu_usage=$(ps -A -o %cpu | awk '{sum+=$1} END {print "CPU Usage: " sum "%"}')
echo "$cpu_usage"

# Display total memory usage
echo "===== Memory Usage ====="
memory_usage=$(vm_stat | awk '
BEGIN {
    printf "Memory Usage: "
}
{
    if ($1 == "Pages") {
        total += $2
        if ($1 == "Pages free:") free = $2
    }
}
END {
    used = total - free
    total_mb = total * 4096 / 1024 / 1024
    used_mb = used * 4096 / 1024 / 1024
    free_mb = free * 4096 / 1024 / 1024
    printf "Used: %.2fMB / Total: %.2fMB (%.2f%%)\n", used_mb, total_mb, used_mb / total_mb * 100
}')

echo "$memory_usage"

# Display total disk usage
echo "===== Disk Usage ====="
disk_usage=$(df -h / | awk 'NR==2 {printf "Used: %s / Total: %s (%s)\n", $3, $2, $5}')
echo "$disk_usage"

# Display top 5 processes by CPU usage
echo "===== Top 5 Processes by CPU Usage ====="
ps -A -o pid,comm,%cpu --sort=-%cpu | head -n 6 | awk '{printf "PID: %s | Process: %s | CPU: %s%%\n", $1, $2, $3}'

# Display top 5 processes by memory usage
echo "===== Top 5 Processes by Memory Usage ====="
ps -A -o pid,comm,%mem --sort=-%mem | head -n 6 | awk '{printf "PID: %s | Process: %s | Memory: %s%%\n", $1, $2, $3}'

# Optional Stretch Features
echo "===== Additional System Info ====="
# OS version
os_version=$(sw_vers -productName && sw_vers -productVersion)
echo "OS Version: $os_version"

# Uptime
uptime_info=$(uptime | awk -F'( |,|:)+' '{print $6, "hours,", $7, "minutes"}')
echo "Uptime: $uptime_info"

# Load average
load_avg=$(uptime | awk -F'load averages:' '{print $2}')
echo "Load Average: $load_avg"

# Logged in users
logged_in_users=$(who | wc -l)
echo "Logged-in Users: $logged_in_users"

