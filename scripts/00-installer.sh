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
echo -e "\x1b[31;1m     _    ____  _          \x1b[0m"
echo -e "\x1b[33;1m    | |__|___ \| |__  _ __ \x1b[0m"
echo -e "\x1b[32;1m    | '_ \ __) | '_ \| '__|\x1b[0m"
echo -e "\x1b[34;1m    | |_) / __/| |_) | |   \x1b[0m"
echo -e "\x1b[36;1m    |_.__/_____|_.__/|_|   \x1b[0m"
echo ""

echo ""
log "Born2BeRoot installer v0.2.5 by kiroussa\n"
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

LOG_DIR="$1/logs"
if [ -d "$LOG_DIR" ]
then
	rm -rf $LOG_DIR
fi
mkdir -p $LOG_DIR

echo ""
log "Outputs (and errors) will be saved in $LOG_DIR\n"
echo ""

SCRIPTS=$(find -type f | sort | tail -n+2 | sed 's/^\.\///g')
MAX_SCRIPT_LENGTH=$(echo $SCRIPTS | /bin/wc -L)
for s in $SCRIPTS
do
	log "Executing $s...\n"
	SPACING=$(printf "%*s" $((MAX_SCRIPT_LENGTH - ${#s})) "")
	echo -n "$SPACING"
	bash $s $usrlogin $1 > $LOG_DIR/$s.log 2>$LOG_DIR/$s.err
	if [ -s $LOG_DIR/$s.err ]
	then
		echo -en "\x1b[41;1m"
		echo -n " FAILURE "
	else
		echo -en "\x1b[42;1m"
		echo -n " SUCCESS "
	fi
	echo -e "\x1b[0m"
done

log "Finished install!"

echo -n " Do you want to launch 27network/Born2BeRootTester? (y/N) " 
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
touch $HOME/b2br-scripts/.enable_monitoring
bash ./grade_me.sh -u $usrlogin -m $HOME/b2br-scripts/monitoring.sh

log "All done!\n"
