#Jack

Multi purpose telegram bot written in MoonScript/lua and licenced under the GNU General Public License.

[Public bot](https://telegram.me/imandabot)

[Website](http://jack.seedteam.org)

Table of Contents

* [Setup](#setup)
* [Telegram Cli](#telegram-cli)
* [Database](#database)
* [Plugins](#plugins)
* [Support and development](#support-and-development)
* [Special thanks to](#special-thanks-to)
* [Collaborators](#collaborators)
* [Other projects](#other-projects)

#Setup

Clone Jack !

```bash
cd $HOME
git clone https://github.com/Imandaneshi/jack-telegram-bot.git
cd jack-telegram-bot
```
install it!

```
chmod +x install.sh
./install.sh
```
[Manual installation](https://github.com/SEEDTEAM/jack-telegram-bot/wiki/Manual-installation)

Add your bot token in config.moon

```MoonScript
telegram_api_key: "Your bot token here"
```

Add your telegram id to admins table in config.moon

```MoonScript
admins: {
    110626080
    123456789
    --your id
  }
```

Run it !
```
chmod +x run.sh
./run.sh
```

# Telegram cli

*If it's first time you are installing telegram-cli*

You should have `libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libpython-dev make` installed

You can install them by

```
 sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libpython-dev make
```

Install telegram-cli using `./install.sh`

Run it
```
./tg.sh
```
Enter your phone number and conformation code

And uncomment plugin `telegramCli` in config.moon

_You can change port in tg.sh_

You can send commands to telegram-cli using your api bot

Few examples
```
#tg msg user#id123456789 <text>
#tg msg channel#id123456789 <text>
#tg msg chat#id123456789 <text>
#tg resolve_username @username
#tg chat_del_user chat#id123456789 user#id12345678
```

[Telegram CLI Commands](https://github.com/vysheng/tg/wiki/Telegram-CLI-Commands)

#Database

Jack uses redis as database

Here are the datas

**Chats**

`bot:chats` > List of all chats(groups,supergroups,privates)

`bot:privates` > List of all private chats

`bot:groups` > List of all groups

`bot:supergroups` > List of all supergroups

`bot:inline_users` > List of all inline users

**chat_id info**

`bot:chats:chat_id`

1. title
2. type

**user_id info**

`bot:users:user_id`

1. first_name
2. last_name
3. username

These info will be updated on each msg

`bot:total_inline_from_user:msg.from.id` >  

**bot statistics**

`bot:total_messages` > Number of total msgs bot received

`bot:total_inlines` > Number of total inline requests

**chat_id msg statistics**

`bot:total_chat_msgs:chat_id` > Number of total msgs bot received in chat_id

`"bot:total_users_msgs_in_chat:chat_id:user_id"` > Number of total msgs bot received in chat_id from user_id

**chat_id members**

`bot:chatchat_id` > list of chat_id members


[How to backup,restore,secure,stablize redis DB](https://github.com/SEEDTEAM/TeleSeed/wiki/Redis)

# Plugins

Plugins list
* [9gag](#9gag)
* [Admin](#admin)
* [Anime](#anime)
* [Calculator](#calculator)
* [Cat](#cat)
* [Chatter](#chatter)
* [Code](#code)
* [Dogify](#dogify)
* [Echo](#echo)
* [Giphy](#giphy)
* [Github](#github)
* [Google](#google-search)
* [Help](#help)
* [Imdb](#imdb)
* [Ipinfo](#ip-info)
* [Lastfm](#lastfm)
* [Linkshortener](#link-shortener)
* [Location](#location)
* [Meme](#meme)
* [Moon](#moon)
* [Qrcode](#qrcode)
* [Reddit](#reddit)
* [Remind](#remind)
* [Spotify](#spotify)
* [Stats](#stats)
* [Sticker](#sticker)
* [Talk](#talk)
* [Telegram-Cli](#telegramcli)
* [Time](#time)
* [Translate](#Translate)
* [Urbandictionary](#urban-dictionary)
* [Weather](#weather)
* [Webshot](#webshot)
* [Who](#who)
* [Wikipedia](#wikipedia)
* [youtube](#youtube)



### Admin

Plugin for admins

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  N    |        N         |         Y          |    N

**Commands**

`/bot`

>Returns Bot status

`/admin reload`

>Reloads bot

`/plugins <Plugin_name> <chat_id> <true|false>`

>True will disable plugin `<Plugin_name>` on chat `<chat_id>`

`/blacklist <user_id>`

>This command will blacklist <user_id>
>>Can also be used by reply

`/bc <chat_id> <text>`

>this command will send `<text>` to `<chat_id>`
>>Markdown is enabled

>>use @channel_username for sending msgs to channels

`/broadcast <msg>`
>This command will send msg to all chats

### Calculator

Returns solutions to math expressions


Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N

**Commands**

`/calc <expression>`

### Cat

Returns a cat

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        O         |         Y          |    N

**Commands**

`/cat`

### Chatter

Talk to bot in English !

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N

**Commands**

`bot_first_name, <text>`
`bot_username, <text>`
>jack, How are you ?
>@imandabot, How are you ?
>>you can also trigger chatter plugin by talking to bot in private or replying on of its messages in groups

### Code

Send the code in image format with support for highlighter.

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        Y         |         N          |    N


**Commands**

`/code [language] [code]`


### Dogify

Create a doge image with you words


Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N

**Commands**

`/dogify <your/words/with/slashes>`

### Echo

Returns text

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    Y

**Commands**

`/echo <text>`

>Markdown is enabled

**Inline**

`@bot_username /echo <text>`


### Giphy

Returns a GIF from giphycom!

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        Y         |         Y          |    N

**Commands**

`/giphy`

>Returns a random GIF

`/giphy [query]`

>Returns a GIF about [query]

### Github

Returns info about GitHub repo

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |       N          |         Y          |    N


**Commands**

`/github <repo>`

>/gitrepo SEEDTEAM/TeleSeed

### Google search

Google search

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N


**Commands**

`/google <terms>`

`/g <terms>`

### 10 - Help

Returns info about other plugins

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  N    |        N         |         Y          |    N


**Commands**

`/help`

>Will return a short list of plugins

`/help all`

>Will return full list of plugins with their commands

`/help [plugin_name]`

>Will return info about that plugin



### IMDB

Returns Info about movie from IMDB and its poster

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N


**Commands**



### IP info

Returns Given IP or domain info

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        Y         |         Y          |    N


**Commands**

`/ip <IP|domain>`


### Link shortener

Returns Shorten link

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        Y         |         Y          |    N


**Commands**

`/shorten <url>`

>/shorten https://github.com/SEEDTEAM


### Location

Sends location data

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N


**Commands**

`/loc <query>`

`/location <query>`


### Remind

Reminder

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N


**Commands**

`/remind <delay (value|mh)>  <text>`

>/remind 1h test

>/remind 1m test

>/remind 1h30m test

>>This plugin will save data in Redis(database) So It even works after Bot crashed or anything happen


### Spotify

Spotify plugin

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        O         |         Y          |    Y


**Commands**

`/spotify get [track name(for search)]`

Returns preview of that song (only 30 sec)

`/spotify track [track name(for search)]`

Returns track info and picture

`/spotify album [album name(for search)]`

Returns album info and picture

`/spotify artist [artist name(for search)]`

Returns artist info and picture

`/spotify playlist [playlist name(for search)]`

Returns playlist info and picture

**Inline**

`@bot_username /spotify album [album name(for search)]`

`@bot_username /spotify album [album name(for search)]`

`@bot_username /spotify artist [artist name(for search)]`

`@bot_username /spotify playlist [playlist name(for search)]`


### Stats

Chat msg statistics

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N


**Commands**


### Talk

Returns voice

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N


**Commands**

`/tts <text>`


### Time

Returns the time, date, and timezone for the given location

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N


**Commands**

`/time <location>`



### Urban dictionary

Returns the top definition from Urban Dictionary.

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N


**Commands**

`/ud <query>`


### Webshot

Returns screen shot from given website

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        Y         |         Y          |    N


**Commands**

`/webshot <url>`


### Who

Returns info about user and chat

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N


**Commands**

`/who`

### Wikipedia

Returns results from wikipedia.com

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N


**Commands**

`/wiki <query>`
`/wikipedia <query>`


### Youtube

Returns results from youtube.com

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        Y         |         N          |    Y


**Commands**

`/youtube get [video name(for search)]`
`/youtube dl [video name(for download)]`

**Inline**

`/youtube dl [video name(for download)]`



#Support and development

Join our bot development group by sending /join 1047524697 to @TeleSeed
# Special thanks to

[Alphonse](https://github.com/hmon)

[Vamptacus](https://telegram.me/Vamptacus)

[topkecleon](https://github.com/topkecleon)

[Yago](https://github.com/yagop)



# Collaborators

[Unfriendly](https://github.com/pAyDaAr)

[Tiago Danin](https://github.com/TiagoDanin)

# Other projects

[TeleSeed](https://github.com/SEEDTEAM/TeleSeed)

>An advance Administration bot

[TelegramLoggingBot](https://github.com/SEEDTEAM/TelegramLoggingBot)

>Connects 2 groups or can be used to create a logging group

[file-manager-bot](https://github.com/SEEDTEAM/file-manager-bot)

>A Linux file manager telegram bot
