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

log "Finished install! Do you want to launch Pixailz's tester? (y/N) "
read -p "" yn2

case $yn2 in
	[yY] )
		;;
	[nN] )
		exit 0;;
	* )
		exit -1;;
esac

log "Fetching & launching tester...\n"
git clone https://github.com/27network/Born2BeRootTester $HOME/b2br/tester
cd $HOME/b2br/tester

log "Please input your login (will be used for checks): "
read -r "" usrlogin

log "Welcome $usrlogin, launching tester...\n"
bash ./grade_me.sh -u $usrlogin

log "All done!"
