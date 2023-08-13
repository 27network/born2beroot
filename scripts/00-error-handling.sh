#!/bin/bash

err() {
	echo -en "\x1b[41;1m"
	echo -n " FAILURE (line $1) "
	exit -1
}
trap 'err $LINENO' ERR
