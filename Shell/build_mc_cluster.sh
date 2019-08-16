#!/bin/sh

sudo systemctl stop bungeecord.service
sudo systemctl stop lobby.service
sudo systemctl stop survival.service
sudo systemctl stop creative.service

wget -N https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O ./buildtools/BuildTools.jar
cd ./buildtools/
java -jar ./BuildTools.jar
cd ..
cp ./buildtools/spigot* ../template/spigot.jar

chmod +x ./template/start.sh

cp -R ./template/* ./servers/lobby/
cp -R ./template/* ./servers/survival/
cp -R ./template/* ./servers/creative/

sudo systemctl start bungeecord.service
sudo systemctl start lobby.service
sudo systemctl start survival.service
sudo systemctl start creative.service

