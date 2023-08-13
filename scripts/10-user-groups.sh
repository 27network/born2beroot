#!/bin/sh

# Add the groups 
groupadd -f user42
groupadd -f sudo

# Add the user to the groups if they're not already in them
TARGET_USER=$1
if ! groups $TARGET_USER | grep -q '\buser42\b'; then
	usermod -aG user42 $TARGET_USER
fi
if ! groups $TARGET_USER | grep -q '\bsudo\b'; then
	usermod -aG sudo $TARGET_USER
fi
