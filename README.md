# Jack

Multi purpose telegram bot written in MoonScript/lua and licenced under the GNU General Public License.

[Public bot](https://telegram.me/imandabot)

[Website](http://jack.seedteam.org)

Table of Contents

* [Setup](#setup)
* [Ranks](#ranks)
* [Telegram Cli](#telegram-cli)
* [Database](#database)
* [Plugins](#plugins)
* [Support and development](#support-and-development)
* [Special thanks to](#special-thanks-to)
* [Collaborators](#collaborators)
* [Other projects](#other-projects)

# Setup

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

### options

Use `./run.sh --help` for available options


# Ranks

 Ranks | Permissions      |
------ | ---------------- |
 Admin | Has access to everything
 Premium | Has access to premium feature
 Normal user | Has access to public feature
 Blacklisted | Bot will ignore blacklisted users

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
#tg resolve_username username
#tg chat_del_user chat#id123456789 user#id12345678
```

[Telegram CLI Commands](https://github.com/vysheng/tg/wiki/Telegram-CLI-Commands)

# Database

Jack uses redis as database

Here are the datas

**Chats**

`bot:chats` > List of all chats(groups,supergroups,privates)

`bot:privates` > List of all private chats

`bot:groups` > List of all groups

`bot:supergroups` > List of all supergroups

`bot:inline_users` > List of all inline users

`bot:callback_users` > List of all callback users

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

`bot:total_callbacks` > Number of total callback requests

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
* [Commit](#commit)
* [Currency](#currency)
* [Dogify](#dogify)
* [DuckGo](#duckgo)
* [Echo](#echo)
* [Giphy](#giphy)
* [Github](#github)
* [Google](#google-search)
* [Help](#help)
* [Imdb](#imdb)
* [Instagram](#instagram)
* [Ipinfo](#ip-info)
* [Lastfm](#lastfm)
* [Linkshortener](#link-shortener)
* [lmgtfy](#lmgtfy)
* [Location](#location)
* [Me](#me)
* [Meme](#meme)
* [Moon](#moon)
* [Poll](#poll)
* [Qrcode](#qrcode)
* [Reactions](#reactions)
* [Reddit](#reddit)
* [Remind](#remind)
* [Set](#set)
* [Shell](#shell)
* [Slap](#slap)
* [Spotify](#spotify)
* [Stats](#stats)
* [Sticker](#sticker)
* [Talk](#talk)
* [Telegram-Cli](#telegramcli)
* [Time](#time)
* [Translate](#translate)
* [Time](#time)
* [Translate](#Translate)
* [Urban dictionary](#urban-dictionary)
* [Weather](#weather)
* [Webshot](#webshot)
* [Who](#who)
* [Wikipedia](#wikipedia)
* [Youtube](#youtube)


### 9gag

Send random image from 9gag

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    Y

**Commands**

`/9gag`

### Admin

Plugin for admins

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  N    |        N         |         Y          |    Y

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

`/editmsg <new msg>`

> Edit message
>> Use in reply

### Anime

Anime plugin (hummingbird.me)

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    Y


**Commands**

`/anime search <anime name>`

> For searching

`/anime pic <query>`

> Will search for query

`/anime pic`

> Will send random anime pic

### Calculator

Returns solutions to math expressions


Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    Y

**Commands**

`/calc <expression>`

### Cat

Returns a cat

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        O         |         Y          |    Y

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

`/code <language> <code>`


### Commit

Send the a commit.

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         N          |    Y


**Commands**

`/commit`


### Currency

Currency rate converter

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    Y

**Commands**

`/cash <amount> <from> to <to>`

> Returns exchange rates for various currencies.

### Dogify

Create a doge image with you words


Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N

**Commands**

`/dogify <your/words/with/slashes>`

### DuckGo

DuckDuckGo search

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         N          |    Y


**Commands**

`/duckduckgo <terms>`

`/duckgo <terms>`

### Echo

Returns text

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    Y

**Commands**

`/echo <text>`

>Markdown is enabled


### Fortune

Linux Fortunes

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         N          |    Y

**Commands**

`/fortunes`

## Get

Retrieves variables saved with /set

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N

**Commands**

`/return (value_name)`

### Giphy

Returns a GIF from giphycom!

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        Y         |         Y          |    N

**Commands**

`/giphy`

>Returns a random GIF

`/giphy <query>`

>Returns a GIF about <query>

### Github

Returns info about GitHub repo

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |       N          |         Y          |    Y


**Commands**

`/github <repo>`

>/gitrepo SEEDTEAM/TeleSeed

### Google search

Google search

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        Y         |         Y          |    Y


**Commands**

`/google <terms>`

`/g <terms>`

### Greeting

About and greeting

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N

**Commands**

`/about`

>Info about your bot

`Hi bot_first_name`

`Bye bot_first_name`

### Help

Returns info about other plugins

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  N    |        N         |         Y          |    Y


**Commands**

`/help`

>Will return a short list of plugins

`/help all`

>Will return full list of plugins with their commands

`/help <plugin_name>`

>Will return info about that plugin



### IMDB

Returns Info about movie from IMDB and its poster

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    Y


**Commands**

`/imdb`

### Instagram

Search users on instagram

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        Y         |         N          |    Y

**Commands**

`/insta <username>`

> Return user info

### IP info

Returns Given IP or domain info

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        Y         |         Y          |    Y


**Commands**

`/ip <IP|domain>`

### lastfm

[Lastfm](https://last.fm)

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        Y         |         Y          |    Y

**Commands**

`/lastfm`

Returns what you are or were last listening to

`/lastfm <username>`

Returns what <username> is or was last listening to

`/lastfm set <username>`

Will set your username

`/lastfm rem`

Will remove your username

### Link shortener

Returns Shorten link

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        Y         |         Y          |    Y


**Commands**

`/shorten <url>`

>/shorten https://github.com/SEEDTEAM

### Lmgtfy

Let me google that for you !

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    Y

### Location

Sends location data

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N


**Commands**

`/loc <query>`

`/location <query>`

### Me

Your profile in telegram !

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    Y


**Commands**

`/me <parameter> <query>`

>/me facebook imandabot

`/me <parameter> del`

>Will delete <parameter>

`/me`

>Will return your profile and msg Statistics

_Can also be triggered by reply_

### Poll

Create a poll

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         N          |    N


**Commands**

`/poll new <question>`

>Create a new poll

`/poll add <option>`

>Added a answer option

`/poll del`

>Delete or terminate the Poll

`/poll`

>Shows the poll

### QRcode

Send a QRcore

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         N          |    N


**Commands**

`/qr <text>`

>Generates a QR code

### Reactions

Reactions

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    Y

**Commands**

`/reactions`

> Returns list of reactions

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

### set

Plugin for saving values

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N

**Commands**

`/set <value_name> <data>`

### Shell

Run terminal commands

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  N    |        N         |         N          |    N

**Commands**

`/shell <Command>`

>/shell date

### Slap

Slap someone

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N

**Commands**

`/slap`

>By reply

`/slap <name>`

### Spotify

Spotify plugin

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        O         |         Y          |    Y


**Commands**

`/spotify get <track name(for search)>`

>Returns preview of that song (only 30 sec)

`/spotify track <track name(for search)>`

>Returns track info and picture

`/spotify album <album name(for search)>`

>Returns album info and picture

`/spotify artist <artist name(for search)>`

>Returns artist info and picture

`/spotify playlist <playlist name(for search)>`

>Returns playlist info and picture


### Stats

Chat msg statistics

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N


**Commands**

`/chatstats`

>Returns a list of members with their msg statistics

### Sticker

Return a sticker with your text

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N

**Commands**

`/sticker <text>`

### Talk

Returns voice

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N


**Commands**

`/tts <text>`

### TelegramCli

Control a real telegram account

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  N    |        N         |         N          |    N

**Commands**

`/tg <Telegram-cli command`

[More info](#telegram-cli)

### Time

Returns the time, date, and timezone for the given location

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    Y


**Commands**

`/time <location>`

### Translate

Yandex translate

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        Y         |         Y          |    Y

`/translate <language> <text>`

>Will translate text to language

`/translate <language>`

<language> examples:

>en for translating text to english

>ar-en for translating text from arabic to english

>You can use both

>Can be used by replying to a msg

### Urban dictionary

Returns the top definition from Urban Dictionary.

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    N


**Commands**

`/ud <query>`


### weather

Returns the current weather

Listed | Requires API KEY | Enabled by default | inline
------ | ---------------- | ------------------ | ------
  Y    |        N         |         Y          |    Y

**Commands**

`/weather <city>`


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
  Y    |        N         |         Y          |    Y


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

`/youtube get <video name(for search)>`

`/youtube dl <video name(for download)>`


# Support and development

Join our development group by sending /join 1047524697 to [@TeleSeed](https://telegram.me/teleseed)

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
