#!/bin/sh

B2BR_INSTALLER_VERSION="0.4.0"

# if the first argument isnt set
if [ -z "$1" ]
then
	echo "Usage: ./$0 <b2br repo/directory>"
	exit -1
fi

function log() {
	PREFIX="\x1b[32;1mBorn2BeRoot\x1b[0m>"
	printf "$PREFIX $@"
}

LOG_DIR="$1/logs"
if [ -d "$LOG_DIR" ]
then
	rm -rf $LOG_DIR
fi
mkdir -p $LOG_DIR

# Obligatory project header
clear
echo ""
echo -e "\x1b[31;1m     _    ____  _          \x1b[0m"
echo -e "\x1b[33;1m    | |__|___ \| |__  _ __ \x1b[0m"
echo -e "\x1b[32;1m    | '_ \ __) | '_ \| '__|\x1b[0m\tBorn2BeRoot installer v$B2BR_INSTALLER_VERSION by kiroussa"
echo -e "\x1b[34;1m    | |_) / __/| |_) | |   \x1b[0m\tRunning in '$1'"
echo -e "\x1b[36;1m    |_.__/_____|_.__/|_|   \x1b[0m\tLogs will be saved in $LOG_DIR"
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

SCRIPTS=$(find -type f -name "??-*.sh" | sort | sed 's/^\.\///g' | grep -v '00-')
MAX_SCRIPT_LENGTH=$(echo $SCRIPTS | tr ' ' '\n' | wc -L)
MAX_SCRIPT_LENGTH=$(expr $MAX_SCRIPT_LENGTH + 4)
for s in $SCRIPTS
do
	log "Executing $s..."
	NB_SPACES=$(expr $MAX_SCRIPT_LENGTH - $(echo $s | wc -c))
	printf "%${NB_SPACES}s" " "
	bash $s $usrlogin $1 > $LOG_DIR/$s.log 2>$LOG_DIR/$s.err
	RETURN_CODE=$?

	if [ $(cat $LOG_DIR/$s.err | wc -l) -eq 0 ]
	then 
		rm $LOG_DIR/$s.err
	fi

	if [ $RETURN_CODE -eq 0 ]
	then
		printf "\x1b[42;1m"
		printf " SUCCESS "
	else
		LINENB=$(cat $LOG_DIR/$s.log | grep -o 'LINENO:[0-9]*' | tail -n 1 | cut -d ':' -f 2) 
		cat $LOG_DIR/$s.log | head -n -1 > $LOG_DIR/$s.log.tmp
		mv $LOG_DIR/$s.log.tmp $LOG_DIR/$s.log

		printf "\x1b[41;1m"
		printf " FAILURE \x1b[0m"
		printf "\x1b[31;1m (line $LINENB)"
	fi
	printf "\x1b[0m\n"
done

touch $HOME/b2br-scripts/.enable_monitoring
log "Finished install!\n"

echo ""
log "Do you want to launch 27network/Born2BeRootTester? (y/N) " 
read -p "" yn2

case $yn2 in
	[yY] )
		;;
	[nN] )
		exit 0;;
	* )
		exit -1;;
esac

# Disable monitoring for the tester
rm -f $HOME/b2br-scripts/.enable_monitoring

log "Launching for $usrlogin..\n"
git clone https://github.com/27network/Born2BeRootTester $1/tester
cd $1/tester
bash ./grade_me.sh -u $usrlogin -m $HOME/b2br-scripts/monitoring.sh

# Re-enable monitoring
touch $HOME/b2br-scripts/.enable_monitoring

log "All done!\n"
