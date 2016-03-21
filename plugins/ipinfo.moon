run = (msg,matches) ->
  IP = matches[1]
  url = "http://api.ipinfodb.com/v3/ip-city/?key=#{config!.ipinfo_api_key}&ip=#{IP}&format=json"
  jstr, res = http.request url
  jdat = JSON.decode jstr
  if jdat.statusCode ~= "OK"
    return jdat.statusMessage
  if res ~= 200 then
     return "Invalid IP Address."
  ACTION = telegram!\sendChatAction msg.chat.id,"find_location"
  LOC = telegram!\sendLocation msg.chat.id,jdat.latitude,jdat.longitude
  MSG = "*Ip Address:* `#{jdat.ipAddress}`
*Country:* `#{jdat.countryName}` *#{jdat.countryCode}*
*Region name:* `#{jdat.regionName}`
*City name:* `#{jdat.cityName}`
*Zip code:* `#{jdat.zipCode}`"

  if msg.chat.type == "inline"
    pic = "http://icons.iconarchive.com/icons/iconsmind/outline/128/URL-Window-icon.png"
    block = "[#{inline_article_block "Ip|Domain info!", "#{MSG}", "Markdown", true, "Ip Address: #{jdat.ipAddress}", "#{pic}"}]"
    telegram!\sendInline msg.id,block
    return

  return MSG

return {
  description: "*Returns Given ip or domain info*"
  usage: "`/ip [ip|domain]` - Return info\n"
  patterns: {
    "^[/!#]ip (.*)$"
    "^###inline[/!#]ip (.*)$"
    }
    :run
  }
