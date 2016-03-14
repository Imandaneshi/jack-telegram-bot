export get_coords = (input) ->
  url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{URL.escape(input)}"
  jstr, res = http.request url
  if res ~= 200
    return "_No results_"

  jdat = JSON.decode jstr

  if jdat.status == 'ZERO_RESULTS'
    return "_No results_"
  lat = jdat.results[1].geometry.location.lat
  lng = jdat.results[1].geometry.location.lng


  return {
    :lat
  	:lng
  }

run = (msg, matches) ->
  coords = get_coords matches[1]
  if type(coords) == 'string'
    return "_No connection_"
  vardump coords
  url = "https://maps.googleapis.com/maps/api/timezone/json?location=#{coords.lat},#{coords.lng}&timestamp=#{os.time!}"
  jstr, res = https.request url
  if res ~= 200
    return "_No connection_"

  jdat = JSON.decode jstr
  timestamp = os.time! + (jdat.rawOffset or 0) + jdat.dstOffset
  utcoff = (jdat.rawOffset or 0 + jdat.dstOffset) / 3600
  if utcoff == math.abs(utcoff)
    utcoff = "+#{utcoff}"


  message = "#{os.date('*%I:%M %p*\n', timestamp)}#{os.date('%A, %B %d, %Y\n_', timestamp)}#{jdat.timeZoneName}_
`UTC #{utcoff}`"
  if msg.chat.type == "inline"
    block = "[#{inline_article_block "#{matches[1]} local time", message, "Markdown", true}]"
    telegram!\sendInline msg.id,block
    return
  return message


description = "*Time !*"
usage = [[
`/time [location]`
Returns the time, date, and timezone for the given location
]]
patterns = {
  "^[/!#]time +(.+)$"
  "###inline[/!#]time +(.+)$"
}

return {
  :description
  :usage
  :patterns
  :run
}
