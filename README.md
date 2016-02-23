#WARNING
**This is under development, use at your own risk**

#Setup

You should have lua,luarocks,redis-server,moonscript,serpent,lua-socket,lua-sec,oauth,redis-lua,lua-cjson and ansicolors installed

You can install them by:

```bash
sudo apt-get install lua5.1 luarocks lua-socket lua-sec redis-server ; sudo luarocks install moonscript ; sudo luarocks install oauth ; sudo luarocks install redis-lua ; sudo luarocks install lua-cjson ; sudo luarocks install ansicolors ;sudo luarocks install serpent
```

Clone the bot

```bash
cd $HOME
git clone https://github.com/Imandaneshi/jack-telegram-bot.git
cd jack-telegram-bot
```
Set telegram_api_key in config.moon file to the token you received from the Botfather.

```moonscript
telegram_api_key: ""--Your telegram bot api key
```

Run it!

```
sh run.sh
```

#Support and development

Join our bot development group by sending /join 1047524697 to @TeleSeed or just search username [@seed_dev](https://telegram.me/seed_dev) and join
