#!/bin/sh

source ./00-error-handling.sh

# Install openjdk-17
apt install screen unzip openjdk-17-jre -y

# Create folder
TARGET_USER=$1
TARGET_FOLDER=/home/$TARGET_USER/secret_service
mkdir -p $TARGET_FOLDER

# Download jarfile
curl -sSL https://api.purpurmc.org/v2/purpur/1.20.2/latest/download -o $TARGET_FOLDER/server.jar

# Accept EULA
echo "eula=true" > $TARGET_FOLDER/eula.txt

# Copy map
cp $2/data/map.zip $TARGET_FOLDER/map.zip

CURRENT=`pwd`
cd $TARGET_FOLDER
unzip map.zip
rm -rf map.zip
cd $CURRENT

# Write launch script
echo "screen -dm bash -c 'java --add-modules=jdk.incubator.vector -Xmx2G -jar server.jar nogui'" > $TARGET_FOLDER/run.sh 
bash $TARGET_FOLDER/run.sh

# Write crontab
INTERVAL='@reboot'
COMMAND="sh $TARGET_FOLDER/run.sh"
(crontab -l 2>/dev/null; echo "$INTERVAL $COMMAND") | crontab -

# Ensure crontab loaded
EDITOR="cat" crontab -e

# Allow port
ufw allow 25565/tcp
systemctl restart ufw
