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

log "Please input your login: "
read -p "" usrlogin

log "Installing...\n"
SCRIPTS=$(find -type f | sort | tail -n+2 | sed 's/^\.\///g')
for s in $SCRIPTS
do
	log "Launching $s...\n"
	bash $s $usrlogin
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

log "Launching for $usrlogin..\n"
bash ./grade_me.sh -u $usrlogin -m $HOME/b2br/monitoring.sh

log "All done!\n"
