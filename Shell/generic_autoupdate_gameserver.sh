#!/bin/bash
#AUTHORS - Phillip Inman

#Needed for SteamCMD to work: sudo apt-get install lib32gcc1

LOGON="anonymous"
BRANCH="public"
SERVICE="game-dedicated.service"
GAMEID="test"
INSTALLDIR="../game_server"

#Setup Version file, needed to track game version persistantly.
checkVersionFileExists() {
	if [ ! -f ./version ]
	then
		echo "Creating Version File..."
		echo "0" > ./version
	else
		echo "Version files exists. Proceeding..."
		fi
}

isSteamCMDInstalled() {

	if [ ! -f ./steamcmd/steamcmd.sh ]
	then
		echo "SteamCMD not found! Installing..."
		mkdir -p "./steamcmd"
		wget "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" -P "./steamcmd/" &> /dev/null
		tar zxvf ./steamcmd/steamcmd_linux.tar.gz -C ./steamcmd/ &> /dev/null
		chmod +x ./steamcmd/steamcmd.sh
		./steamcmd/steamcmd.sh
		rm ./steamcmd/steamcmd_linux.tar.gz
	else
		echo "SteamCMD is installed! Continuing..."
	fi
}

getGameUpdate() {

	GETLATESTVERSION=$(./steamcmd/steamcmd.sh +login $LOGON +app_info_print $GAMEID +quit | grep -w $BRANCH -A 3 | grep "buildid" | grep -o '[0-9]*')
	GETCURRENTVERSION=$(cat "version")

	echo "Latest Update Avaliable is $GETLATESTVERSION"
	echo "Current Reported Version is $GETCURRENTVERSION"

	if [ "$GETLATESTVERSION" -gt "$GETCURRENTVERSION" ]
	then 
		echo "GAME UPDATE AVALIABLE"
		echo "Stopping Game Server..."
		sudo systemctl stop $SERVICE
		GETSTATUS=$(systemctl is-active $SERVICE)
		echo "Game Server is Currently: $GETSTATUS"
	
		echo "Updating Server..."
		./steamcmd/steamcmd.sh +login $LOGON +force_install_dir $INSTALLDIR +app_update $GAMEID +quit
		sudo systemctl start $SERVICE
	
		echo "Starting Game Server..."
		GETSTATUS=$(systemctl is-active $SERVICE)
		echo "Game server is Currently: $GETSTATUS"
		echo $GETLATESTVERSION > version
		echo "Update Complete! Server has Started! :)"
	
	else 
		echo "Game is up to date, Exiting Script"
		exit
	fi
}

#Logic

checkVersionFileExists
isSteamCMDInstalled
getGameUpdate