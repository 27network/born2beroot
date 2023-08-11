#!/bin/bash

ARCH=$(uname -srm)
CPUS=$(cat /proc/cpuinfo | grep "physical id" | uniq | wc -l)
VCPUS=$(cat /proc/cpuinfo | grep "processor" | uniq | wc -l)
MEM_TOTAL_DISPLAY="$(free -m | grep "Mem" | xargs echo | cut -d' ' -f2)MB"
MEM_USED_DISPLAY="$(free -m | grep "Mem" | xargs echo | cut -d' ' -f3)"
MEM_TOTAL=$(free | grep "Mem" | xargs echo | cut -d' ' -f2)
MEM_USED=$(free | grep "Mem" | xargs echo | cut -d' ' -f3)
MEM_USED_PERCENTAGE=$(awk "BEGIN {printf \"%.2f\",${MEM_USED}/${MEM_TOTAL}*100}")

USER_LOG=$(who | wc -l)
IP=$(hostname -I)
MAC=$(ip link show | awk '/ether/ {print $2}')
SUDO_CMD=$(cat /var/log/sudo/sudo.log | grep COMMAND | wc -l)

echo $MEM_USED_PERCENTAGE

wall "	#Architecture $ARCH
	#CPU Physical : $CPUS
	#vCPU : $VCPUS
	#Memory Usage: $MEM_USED_DISPLAY/$MEM_TOTAL_DISPLAY ($MEM_USED_PERCENTAGE%)
	#Disk Usage: / (%)
	#CPU load: %
	#Last boot:
	#LVM use:
	#Connections TCP : 
	#User log: $USER_LOG
	#Network: IP $IP ($MAC)
	#Sudo: $SUDO_CMD cmd";
