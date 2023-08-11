#!/bin/sh

# Move scripts
ROOT_DIR="/root/b2br-scripts"
mkdir -p $ROOT_DIR
cp $HOME/b2br/monitoring.sh $ROOT_DIR/monitoring.sh
cp $HOME/b2br/delay.sh $ROOT_DIR/delay.sh
chmod 755 $HOME/b2br/monitoring.sh
chmod 755 $HOME/b2br/delay.sh

# Enable cron
systemctl enable --now cron

# Write crontab
INTERVAL='*/10 * * * *'
COMMAND="sh $ROOT_DIR/delay.sh; sh $ROOT_DIR/monitoring.sh"
(crontab -l 2>/dev/null; echo "$INTERVAL $COMMAND") | crontab -

