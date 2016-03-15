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
  pic = "http://icons.iconarchive.com/icons/iconsmind/outline/128/Google-icon.png"
  block = "["
  i = 0 + 1
  for i,v in ipairs (jdat.responseData.results)
     url = "#{jdat.responseData.results[i].unescapedUrl\gsub '_', '\\_'}"
     tit = "#{jdat.responseData.results[i].titleNoFormatting\gsub '&amp;', '&'}"
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
