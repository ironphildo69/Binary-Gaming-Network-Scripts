#!/bin/bash
#AUTHORS - Phillip Inman

BRANCH="public"
SERVICE="starbound-dedicated.service"

#BE SURE TO CHANGE THE STEAM ID BELOW TO YOUR GAME

GETLATESTVERSION=$(./steamcmd/steamcmd.sh +login anonymous +app_info_print 211820 +quit | grep -w $BRANCH -A 3 | grep "buildid" | grep -o '[0-9]*')
GETCURRENTVERSION=$(cat "version")

echo "Latest Update Avaliable is $GETLATESTVERSION"
echo "Current Reported Version is $GETCURRENTVERSION"

if [ "$GETLATESTVERSION" -gt "$GETCURRENTVERSION" ]
then 
	echo "GAME UPDATE AVALIABLE"
	echo "Stopping Game Server..."
	sudo systemctl stop $SERVICE #Change this to your service file. For more info read about systemd units. This can also be a script.
	GETSTATUS=$(systemctl is-active $SERVICE)
	echo "Game Server is Currently: $GETSTATUS"
	
	echo "Updating Server..."
	./steamcmd/steamcmd.sh +login anonymous +force_install_dir ../starbound_server +app_update 211820 +quit # CHANGE THIS ID TO YOUR GAME AS WELL
	sudo systemctl start $SERVICE # Same as the the above, put your startup script here or systemd unit file.
	
	echo "Starting Game Server..."
	GETSTATUS=$(systemctl is-active $SERVICE)
	echo "Game server is Currently: $GETSTATUS"
	echo $GETLATESTVERSION > version
	echo "Update Complete! Server has Started! :)"
	
else 
	echo "Game is up to date, Exiting Script"
	exit
	fi
