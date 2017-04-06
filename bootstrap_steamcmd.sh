#Binary Gaming Network - Phillip Inman

#Run the below command if needed
#sudo apt-get install lib32gcc1

#Begin main script
mkdir steamcmd && cd ./steamcmd
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar zxvf steamcmd_linux.tar.gz
./steamcmd.sh +login anonymous +force_install_dir ../starbound_server +app_update app_id validate +quit
rm steamcmd_linux.tar.gz