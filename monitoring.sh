#!/bin/bash

ENABLE_FILE="$HOME/b2br-scripts/.enable_monitoring"
if [ ! -f "$ENABLE_FILE" ]
then
	exit 0
fi

ARCH=$(uname -srm)
CPUS=$(cat /proc/cpuinfo | grep "physical id" | uniq | wc -l)
VCPUS=$(cat /proc/cpuinfo | grep "processor" | uniq | wc -l)
MEM_TOTAL_H=$(free -m | grep "Mem" | xargs echo | cut -d' ' -f2)
MEM_USED_H=$(free -m | grep "Mem" | xargs echo | cut -d' ' -f3)
MEM_TOTAL=$(free | grep "Mem" | xargs echo | cut -d' ' -f2)
MEM_USED=$(free | grep "Mem" | xargs echo | cut -d' ' -f3)
MEM_USED_PERCENTAGE=$(awk "BEGIN {printf \"%.2f\",${MEM_USED}/${MEM_TOTAL}*100}")

CPU_LOAD=$(top -bn1 | grep Cpu | xargs echo | cut -d' ' -f2 | cut -d'%' -f1)

DISK_TOTAL_H=$(df -Bg | grep "^/dev" | grep -v "/boot$" | awk '{total += $2} END {print total}')
DISK_USED_H=$(df -Bg | grep "^/dev" | grep -v "/boot$" | awk '{used += $3} END {print used}')
DISK_USED_PERCENTAGE=$(df -Bm | grep "^/dev" | grep -v "/boot$" | awk '{used += $3} {total += $2} END {printf("%d"), used / total * 100}')

LAST_BOOT=$(who -b | xargs echo | cut -d' ' -f3-)

LVM_USE="no"
NB_LVM=$(lvm pvdisplay | grep "PV Name" | wc -l)
if [ $NB_LVM -gt 0 ] 
then
	LVM_USE="yes"
fi

TCP_CONNECT=$(cat /proc/net/sockstat | grep "TCP" | cut -d' ' -f3)
USER_LOG=$(who | wc -l)
IP=$(hostname -I | xargs echo)
MAC=$(ip link show | grep ether | xargs echo | cut -d' ' -f2)
SUDO_CMD=$(cat /var/log/sudo/sudo.log | grep COMMAND | wc -l)

BROADCASTER=${BROADCASTER:-wall}
$BROADCASTER \
"	#Architecture: $ARCH
	#CPU Physical : $CPUS
	#vCPU : $VCPUS
	#Memory Usage: $MEM_USED_H/${MEM_TOTAL_H}MB ($MEM_USED_PERCENTAGE%)
	#Disk Usage: $DISK_USED_H/${DISK_TOTAL_H}GB ($DISK_USED_PERCENTAGE%)
	#CPU load: $CPU_LOAD%
	#Last boot: $LAST_BOOT
	#LVM use: $LVM_USE
	#Connections TCP : $TCP_CONNECT 
	#User log: $USER_LOG
	#Network: IP $IP ($MAC)
	#Sudo : $SUDO_CMD cmd";
