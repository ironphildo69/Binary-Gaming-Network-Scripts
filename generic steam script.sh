#Binary Gaming Network - Phillip Inman

#Run the below command if needed
#sudo apt-get install lib32gcc1

#Begin main script - piping on tar doesnt work for some reason :'(
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -zxvf steamcmd_linux.tar.gz ./steamcmd
cd ./steamcmd && /steamcmd.sh +login anonymous +force_install_dir ../starbound_server +app_update app_id validate +quit