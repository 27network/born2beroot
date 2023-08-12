#!/bin/sh

# Move scripts
ROOT_DIR="$HOME/b2br-scripts"
mkdir -p $ROOT_DIR
cp $HOME/b2br/monitoring.sh $ROOT_DIR/monitoring.sh
chmod 755 $HOME/b2br/monitoring.sh

# Enable cron
systemctl enable --now cron

# Write crontab
INTERVAL='*/10 * * * *'
COMMAND="sh $ROOT_DIR/monitoring.sh 2>/dev/null"
(crontab -l 2>/dev/null; echo "$INTERVAL $COMMAND") | crontab -

# Ensure crontab loaded
EDITOR="cat" crontab -e
