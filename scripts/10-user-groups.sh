#!/bin/sh

groupadd user42
groupadd sudo
usermod -aG user42 $1
usermod -aG sudo $1
