#!/bin/bash

ARCH=$(uname -srm)
CPUS=$(cat /proc/cpuinfo | grep "physical id" | uniq | wc -l)
VCPUS=$(cat /proc/cpuinfo | grep "processor" | uniq | wc -l)
MEM_TOTAL_DISPLAY=$(free -h | grep "Mem" | xargs echo | cut -d' ' -f2)
MEM_USED_DISPLAY=$(free -h | grep "Mem" | xargs echo | cut -d' ' -f3)
MEM_FREE=$(free | grep "Mem" | xargs echo | cut -d' ' -f4)

wall "#Architecture $ARCH
#CPU Physical : $CPUS
#vCPU : $VCPUS";
