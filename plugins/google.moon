run = (msg,matches) ->
  text = matches[1]
  url = "https://www.googleapis.com/customsearch/v1?q=#{URL.escape text}&cx=#{config!.google_cx_key}&key=#{config!.google_api_key}"
  jstr, res = https.request url
  if res ~= 200
     return "_No connection_"
  jdat = JSON.decode jstr
  if jdat.queries.request[1].totalResults == "0"
     return "_No results found_"
  text = ""
  pic = "http://icons.iconarchive.com/icons/iconsmind/outline/128/Google-icon.png"
  block = "["
  i = 0 + 1
  for i,v in ipairs (jdat.items)
    if i <= 6
      url = "#{v.formattedUrl\gsub '_', '\\_'}"
      tit = "#{v.title\gsub '&amp;', '&'}"
      block ..= "#{inline_article_block "#{tit\gsub '%[.+%]', ''\gsub '%(.+%)', ''}", "[#{tit}](#{url})", "Markdown", true, "#{url}", "#{pic}"}, "
      text ..= "*#{i} - *[#{tit}](#{url})\n"

  if msg.chat.type == "inline"
    block ..= "#{inline_article_block "End", "End results", "Markdown", true, "End results", "#{pic}"}]"
    telegram!\sendInline msg.id,block
    return

  return text


return {
  description: "*Searches Google*"
  usage: "`/google [terms]` - Search on Google!\n"
  patterns: {
  "^[/!#]g (.*)"
  "^[/!#]google (.*)"
  --inline
  "^###inline[/!#]g (.*)"
  "^###inline[/!#]google (.*)"
  }
  :run
}
