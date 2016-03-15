run = (msg,matches) ->
  link = matches[1]
  url = "https://api-ssl.bitly.com/v3/shorten?access_token=#{config!.linkshorter_api_key}&longUrl=#{URL.escape link}"
  jstr, res = https.request url

  jdat = JSON.decode jstr
  if msg.chat.type == "inline"
    pic = "http://icons.iconarchive.com/icons/custom-icon-design/pretty-office-8/128/Link-icon.png"
    block = "[#{inline_article_block "Linkshorter !", "#{jdat.data.url}", "Markdown", true, "#{jdat.data.url}", "#{pic}"}]"
    telegram!\sendInline msg.id,block
    return

  return "#{jdat.data.url}"


return {
  description: "*link shortener plugin*"
  usage: [[
`/shorten [url]`
Will shorten that link
Example:
/shorten _https://google.com_
]]
  patterns: {
  "^[/!#]shorten (https?://[%w-_%.%?%.:/%+=&]+)$"
  "^###inline[/!#]shorten (https?://[%w-_%.%?%.:/%+=&]+)$"
  }
  :run
}
