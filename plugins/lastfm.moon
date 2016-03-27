run = (msg, matches) ->
  username = ""
  lastfm = redis\hgetall "bot:lastfm:users"
  if msg.chat.type == "inline" and lastfm[tostring(msg.from.id)]
    username = lastfm[tostring(msg.from.id)]
    if redis\get "bot:lastfm:user:#{msg.from.id}"
      username = redis\get "bot:lastfm:user:#{msg.from.id}"

  if string.match(msg.text, '^[!/]lastfm$') and msg.reply_to_message and lastfm[tostring(msg.reply_to_message.from.id)]
    username = lastfm[tostring(msg.reply_to_message.from.id)]
    if redis\get "bot:lastfm:user:#{msg.reply_to_message.from.id}"
      username = redis\get "bot:lastfm:user:#{msg.reply_to_message.from.id}"

  if string.match(msg.text, "^[!/]lastfm$") and not msg.reply_to_message
    if lastfm[tostring(msg.from.id)]
      username = lastfm[tostring(msg.from.id)]
      if redis\get "bot:lastfm:user:#{msg.from.id}"
        username = redis\get "bot:lastfm:user:#{msg.from.id}"
    else
      return '*Please specify your last.fm username or set it with*`/lastfm set username`'

  if string.match msg.text, "^[!/]lastfm ([^%s]+)$"
    if matches[1] == "rem"
      redis\hdel "bot:lastfm:users", tostring(msg.from.id)
      return '*Your last.fm username has been forgotten.*'
    else
      username = matches[1]

  if string.match msg.text, "^[!/]lastfm (set) ([^%s]+)$"
    if matches[1] == "set"
      redis\hset "bot:lastfm:users", tostring(msg.from.id), matches[2]
      lastfm_move = redis\hgetall "bot:lastfm:users"
      for k,v in pairs lastfm_move
        redis\set "bot:lastfm:user:#{k}", v
      return "*Your last.fm username has been set to* `#{matches[2]}`"
    return
  url = "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&format=json&limit=1&api_key=#{config!.lastfm_api_key}&user="
  if username == nil or username == ""
    return '*Please specify your last.fm username or set it with*` /lastfm set username`'
  url ..= URL.escape username

  jstr, res = https.request url

  if res ~= 200
    if msg.chat.type == "inline"
      return
    return "Connection failed"

  jdat = JSON.decode jstr

  if jdat.error
    if msg.chat.type == "inline"
      return
    return '*Please specify your last.fm username or set it with*` /lastfm set username`'

  jdat = jdat.recenttracks.track[1] or jdat.recenttracks.track

  unless jdat
    if msg.chat.type == "inline"
			return
    return '_Iv\'e found nothing about this user_'
  message = "*#{username}*"

  if jdat['@attr'] and jdat['@attr'].nowplaying
    message ..= ' *is currently listening to:*\n'
  else
    message ..= ' *last listened to:*\n'

  title = jdat.name or '*Unknown*'
  artist = '*Unknown*'
  artist = jdat.artist['#text'] if jdat.artist

  if msg.chat.type == "inline"
    pic = "http://icons.iconarchive.com/icons/uiconstock/socialmedia/128/Lastfm-icon.png"
    message = "#{message}`#{string.gsub(title,"%p", "-")}` *|* `#{string.gsub(artist,"%p", "-")}`"
    block = "[#{inline_article_block "#{username} on Lastfm !", message, "Markdown" , true, "#{title} - #{artist}", "#{pic}"}]"
    telegram!\sendInline msg.id, block
    return

  message = "#{message}`#{title}` *-* `#{artist}`"
  return message

description = "*Last.fm*"
usage = [[
`/lastfm`
Returns what you are or were last listening to
`/lastfm [username]`
Returns what [username] is or was last listening to
`/lastfm set [username]`
Will set your username
`/lastfm rem`
Will remove your username
]]
patterns = {
  "^[!/#]lastfm ([^%s]+)$"
	"^[!/#]lastfm (set) ([^%s]+)$"
	"^[!/#]lastfm$"
	"###inline[!/]lastfm$"
	"^[!/#]lf$"
	"##inline[!/]lft$"
}
return {
  :description
  :usage
  :patterns
  :run
}
