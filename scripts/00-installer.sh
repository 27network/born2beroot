#!/bin/sh

# if the first argument isnt set
if [ -z "$1" ]
then
	echo "Usage: ./00-installer.sh <directory>"
	exit -1
fi

function log() {
	PREFIX="\x1b[32;1mBorn2BeRoot\x1b[0m>"
	printf "$PREFIX $@"
}

# Obligatory project header
clear
echo ""
echo "     _    ____  _          "
echo "    | |__|___ \\| |__  _ __ "
echo "    | '_ \\ __) | '_ \\| '__|"
echo "    | |_) / __/| |_) | |   "
echo "    |_.__/_____|_.__/|_|   "
echo ""
echo ""
log "Born2BeRoot installer v0.2.1 by kiroussa\n"
log "Running in '$1'\n"
echo ""
echo ""

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
	bash $s $usrlogin $1
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
git clone https://github.com/27network/Born2BeRootTester $1/tester
cd $1/tester

log "Launching for $usrlogin..\n"
bash ./grade_me.sh -u $usrlogin -m $HOME/b2br-scripts/monitoring.sh

log "All done!\n"
