#!/bin/bash

echo "------------------------------------------"
echo "SERVER PERFORMANCE STATISTICS"
echo "------------------------------------------"

# System Information
echo ""
echo "System Information:"
echo "OS Version        : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '\"')"
echo "Kernel Version    : $(uname -r)"
echo "Uptime            : $(uptime -p)"
echo "Load Average      : $(uptime | awk -F'load average: ' '{ print $2 }')"
echo "Logged In Users   : $(who | wc -l)"

# CPU Usage
echo ""
echo "CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage        : " 100 - $8 "%"}'

# Memory Usage
echo ""
echo "Memory Usage:"
free -h | awk '/Mem:/ {
    printf "Total Memory     : %s\nUsed Memory      : %s\nFree Memory      : %s\nMemory Usage     : %.2f%%\n", $2, $3, $4, $3/$2 * 100
}'

# Disk Usage
echo ""
echo "Disk Usage:"
df -h / | awk 'NR==2 {
    printf "Total Disk       : %s\nUsed Disk        : %s\nAvailable Disk   : %s\nDisk Usage       : %s\n", $2, $3, $4, $5
}'

# Top 5 Processes by CPU Usage
echo ""
echo "Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | awk 'NR==1{print "PID     COMMAND     CPU%"} NR>1{printf "%-7s %-12s %s\n", $1, $2, $3}'

# Top 5 Processes by Memory Usage
echo ""
echo "Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | awk 'NR==1{print "PID     COMMAND     MEM%"} NR>1{printf "%-7s %-12s %s\n", $1, $2, $3}'

# Failed Login Attempts
echo ""
echo "Failed Login Attempts:"
if [ -f /var/log/auth.log ]; then
    echo "From /var/log/auth.log : $(grep -c "Failed password" /var/log/auth.log)"
elif [ -f /var/log/secure ]; then
    echo "From /var/log/secure    : $(grep -c "Failed password" /var/log/secure)"
else
    echo "Log file not found for failed login attempts."
fi

echo "------------------------------------------"

