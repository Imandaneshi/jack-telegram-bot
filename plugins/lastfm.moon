recents = (msg,username) ->
  if username == null
      return "LastFM not linked\nUse `/me lastfm [username]` to set"
  url = "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{username}&api_key=#{config!.lastfm_api_key}&format=json"
  response, code, headers = http.request url
  if code ~= 200
    return "There seems to be an error :(\nCode: #{code}"
  if #response > 0
    jdat = JSON.decode response
    if jdat.error
      return "Username not found :("
    if jdat.recenttracks['@attr'].total == "0"
      return "No recent tracks found :("
    message = "[#{username}](http://www.last.fm/user/#{username}) "
    if jdat.recenttracks.track[1]['@attr']
        message ..= "is currently listening to: \n[#{jdat.recenttracks.track[1].name}\t-\t#{jdat.recenttracks.track[1].artist['#text']}](#{jdat.recenttracks.track[1].url})"
    else
        message ..= "last listened to:\n[#{jdat.recenttracks.track[1].name}\t-\t#{jdat.recenttracks.track[1].artist['#text']}](#{jdat.recenttracks.track[1].url})\n"
    if msg.chat.type == "inline"
        block = "[#{inline_article_block "What #{username} is listening to!", message, "Markdown" , true, "#{jdat.recenttracks.track[1].name} - #{jdat.recenttracks.track[1].artist['#text']}", "#{jdat.recenttracks.track[1].image[3]['#text']}"}]"
        telegram!\sendInline msg.id, block
        return
    return message

run = (msg,matches) ->
  if matches[1] == "lastfm" and matches[2]
    return recents msg,matches[2]
  elseif msg.reply_to_message
    return recents msg,redis\get "bot:lastfm:user:#{msg.reply_to_message.from.id}"
  else
    return recents msg,redis\get "bot:lastfm:user:#{msg.from.id}"

return {
  description: "Grab info from a LastFM profile"
  usage: "See what you're currently listening to or your last played song. This can also be used by replying to another user:
`/lastfm`
Allows you to specify a username for #{bot_first_name} to use:
`/lastfm [username]`

You can set your username with `/me lastfm [username]`."
  patterns: {
  "^[!/](lastfm) (.+)",
  "^[!/]lastfm$",
  "###inline[!/](lastfm) (.+)",
  "###inline[!/]lastfm$"
  }
  :run
}
