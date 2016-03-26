#!/bin/bash

read -p "Do you want me to install lua,luarocks,redis-server,moonscript,lua-socket,lua-sec,oauth,redis-lua,lua-cjson and ansicolors ? (yes/no):"

if [ "$REPLY" != "yes" ]; then
	echo "
"
else
	echo "Updating apt-get"
	sudo apt-get update
	echo "Installing lua5.1 luarocks lua-socket lua-sec redis-server curl"
	sudo apt-get install lua5.1 luarocks lua-socket lua-sec redis-server curl
	echo "Installing MoonScript"
	sudo luarocks install moonscript
	echo "Installing rocks"
	sudo luarocks install oauth
	sudo luarocks install redis-lua
	sudo luarocks install lua-cjson
	sudo luarocks install ansicolors
	sudo luarocks install serpent
	echo " "
fi

read -p "Do you want me to remove lua 5.2 to prevent moon script from crashing ? (yes/no):"
if [ "$REPLY" != "yes" ]; then
	echo "
"
else
	echo "Removing lua 5.2"
	sudo apt-get remove lua5.2
	echo " "
fi

read -p "Do you want me to install telegram-CLI ? (yes/no):"

if [ "$REPLY" != "yes" ]; then
	exit
else
	echo "Installing Telegram-CLI"
	git clone https://github.com/Rondoozle/tg.git
	cd tg
	git submodule update --init --recursive
	./configure
	make
	echo "./bin/telegram-cli -k ./tg/tg-server.pub -P 7731 --json" > tg.sh
	chmod +x tg.sh
	echo "Use \"./tg.sh\" to run telegram-CLI"
	echo "Enjoy !"
fi
