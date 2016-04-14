run = (msg,matches) ->
  telegram!\sendChatAction(msg.chat.id, "find_location")
  url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{URL.escape(matches[1])}"
  jstr, res = http.request url
  if res ~= 200
    return "_Connection error_"
  jdat = JSON.decode jstr
  if jdat.status ~= 'OK'
    return "_No results found_"
  lat = jdat.results[1].geometry.location.lat
  lng = jdat.results[1].geometry.location.lng
  address = jdat.results[1].formatted_address

  telegram!\sendVenue msg.chat.id, lat, lng, "Location", address, false, msg.message_id
  return

description = "*Google maps*"
usage = [[
`/loc <query>`
Sends location data for query
]]
patterns = {
  "^[/!#]loc +(.+)$"
  "^[/!#]location +(.+)$"
}
return {
  :description
  :usage
  :patterns
  :run
}
