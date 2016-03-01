#WARNING
**This is under development, use at your own risk**

#Setup

You should have lua,luarocks,redis-server,moonscript,lua-socket,lua-sec,oauth,redis-lua,lua-cjson and ansicolors installed

You can install them by:

```bash
sudo apt-get install lua5.1 luarocks lua-socket lua-sec redis-server ; sudo luarocks install moonscript ; sudo luarocks install oauth ; sudo luarocks install redis-lua ; sudo luarocks install lua-cjson ; sudo luarocks install ansicolors
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


If you get this error from moonscript
```
/usr/bin/lua: /usr/share/lua/5.1//luarocks/loader.lua:113: error loading module 'lfs' from file '/usr/local/lib/lua/5.1/lfs.so':
    /usr/local/lib/lua/5.1/lfs.so: undefined symbol: luaL_register
```



Make sure you are using the lua5.1 package instead of the lua5.2 package. Try:

```
sudo apt-get install lua5.1
sudo apt-get remove lua5.2
```

#Support and development

Join our bot development group by sending /join 1047524697 to @TeleSeed or just search username [@seed_dev](https://telegram.me/seed_dev) and join

# Special thanks to

[Alphonse](https://github.com/hmon)

[topkecleon](https://github.com/topkecleon)

[Yago](https://github.com/yagop)

[Tiago Danin](https://github.com/TiagoDanin)

[Unfriendly](https://github.com/pAyDaAr)
