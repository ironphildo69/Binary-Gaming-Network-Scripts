#!/bin/sh
wget -N https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O ./buildtools/BuildTools.jar
cd ./buildtools/
java -jar ./BuildTools.jar
cd ..
cp ./buildtools/spigot* ./mcs0_lobby/spigot.jar
cp ./buildtools/spigot* ./mcs1_survival/spigot.jar
cp ./buildtools/spigot* ./mcs2_creative/spigot.jar

systemctl start bungee.service
systemctl start mcs0.service