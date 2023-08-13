#!/bin/bash

err() {
	echo -n "LINENO:$1"
	exit 1
}
trap 'err $LINENO' ERR
