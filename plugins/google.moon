run = (msg,matches) ->

  text = matches[1]

  url = "https://ajax.googleapis.com/ajax/services/search/web?v=1.0&rsz=6&q=#{URL.escape text}"
  jstr, res = https.request url
  if res ~= 200
     return "_No connection_"
  jdat = JSON.decode jstr
  if not jdat.responseData.results[1]
     return "_No results found_"
  text = ""
  i = 0 + 1
  for i,v in ipairs (jdat.responseData.results)
     url = "#{jdat.responseData.results[i].unescapedUrl\gsub '_', '\\_'}"
     tit = "#{jdat.responseData.results[i].titleNoFormatting\gsub '&amp;', '&'}"
     text ..= "*#{i} - *[#{tit}](#{url})\n"

  return text


return {
  description: "*Searches Google*"
  usage: "`/google [terms]`\n"
  patterns: {
  "^[/!#]g (.*)"
  "^[/!#]google (.*)"
  }
  :run
}
