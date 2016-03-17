#!/bin/bash

read -p "This program install some modules manually in case you are experiencing LuaRocks errors. Please only execute this when in the root directory of the bot (it should contain config.moon, jackbot.moon, etc). yes/no:"
if [ "$REPLY" != "yes" ]; then
   exit
fi
sudo apt-get install lua5.1 luarocks lua-socket lua-sec redis-server curl
sudo luarocks install moonscript
sudo luarocks install oauth
sudo apt-get install lua-redis
sudo apt-get install lua-cjson
sudo wget https://raw.githubusercontent.com/kikito/ansicolors.lua/master/ansicolors.lua
sudo apt-get install lua-serpent
