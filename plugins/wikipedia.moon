run = (msg,matches) ->

  text = matches[1]
  gurl = "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&rsz=1&q=site:wikipedia.org%20"
  wurl = "http://en.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exchars=4000&exsectionformat=plain&titles="
  jstr, res = http.request(gurl..URL.escape text)
  if res ~= 200
       return "_No connection_"
  jdat = JSON.decode jstr
  if not jdat.responseData.results[1]
      return "_No results_"
  url = "#{jdat.responseData.results[1].url}"
  title = "#{jdat.responseData.results[1].titleNoFormatting\gsub '%- Wikipedia, the free encyclopedia', ''}"
  jstr, res = https.request(wurl..URL.escape title)
  if res ~= 200
       return "_No connection_"
  jdat = JSON.decode(jstr).query.pages
  for k,v in pairs jdat
      jdat = v.extract
  if not jdat
      return "_No results_"
  jdat = jdat\gsub '</?.->', ''
  l = jdat\find '\n'
  if l
      jdat = jdat\sub 1, l-1
  jdat ..= "\n<a href=\"#{url}\">#{title} on wikipedia</a>"

  if msg.chat.type ~= "private"
    telegram!\sendMessage msg.chat.id, jdat, msg.message_id, "HTML", true
  else
    telegram!\sendMessage msg.chat.id, jdat, false, "HTML", true

  return



return {
  description: "*Wikipedia.com*"
  usage: "`/wiki [query]` - Search on Wikipedia\n"
  patterns: {
  "^[/!#]wikipedia (.*)"
  "^[/!#]wiki (.*)"
  }
  :run
}
