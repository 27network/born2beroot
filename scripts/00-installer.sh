#!/bin/sh

function log() {
	PREFIX="\x1b[32;1mBorn2BeRoot\x1b[0m>"
	printf "$PREFIX $@"
}

# Ask if we want to automate the install process
log "Do you want to start the automatic install? (y/N) "
read -p "" yn

case $yn in
	[yY] )
		;;
	[nN] )
		exit 0;;
	* )
		exit -1;;
esac

log "Installing...\n"
SCRIPTS=$(find -type f | sort | tail -n+2 | sed 's/^\.\///g')
for s in $SCRIPTS
do
	log "Launching $s...\n"
	bash $s
done

log "Finished install!\n"
