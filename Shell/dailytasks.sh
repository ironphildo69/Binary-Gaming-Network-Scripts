#!/bin/bash
#0 5 * * * /home/gameserver/dailytasks.sh

sudo systemctl stop gameserver-dedicated.service
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
./update_gameserver.sh
sudo reboot