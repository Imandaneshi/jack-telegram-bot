run = (msg,matches) ->
  url = "http://api-9gag.herokuapp.com/"
  jstr, res = http.request url
  jdat = JSON.decode jstr
  i = math.random #jdat
  image = jdat[i].src
  if image\sub(0,2) == '//'
    image = msg.text\sub(3,-1)

  if msg.chat.type == "inline"
    block = "[#{inline_photo_block "#{image}", "#{image}", "GAG"}]"
    telegram!\sendInline msg.id, block
    return

  GAG = download_to_file image,"9GAG.jpg"
  telegram!\sendPhoto msg.chat.id,GAG
  os.remove GAG

  return


return {
  description: "*9GAG for Telegram*"
  usage: [[
`/9gag`
Send random image from 9gag
]]
  patterns: {
  "^[/!#]9gag"
  "^###inline[/!#]9gag"
  }
  :run
}
