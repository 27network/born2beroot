#!/bin/sh

# This script delays the execution of the next one by calling `sleep`.
# This delay should match up to the system's uptime.
# We basically offset the crontab by the system's uptime origin. 
# (if that makes any sense)

# Define delay
DELAY=600 # 10m

# Get uptime time
UPTIME=$(date -d "$(uptime -s) seconds" +%s)

# Get current time
NOW=$(date +%s)

# Time difference
DIFF=$((NOW - UPTIME))

# Modulo DELAY
SLEEP_TIME=$((DIFF % DELAY))
SLEEP_TIME=$((DELAY - SLEEP_TIME))

# Sleep
sleep $SLEEP_TIME
