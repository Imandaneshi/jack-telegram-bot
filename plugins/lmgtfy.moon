run = (msg,matches) ->
  message = "[#{matches[1]}](http://lmgtfy.com/?q=#{URL.escape matches[1]})"
  if msg.chat.type == "inline"
    pic = "http://s6.picofile.com/file/8244044400/lmgtfy.jpeg"
    block = "[#{inline_article_block "lmgtfy", "#{message}", "Markdown", true, "#{matches[1]}", "#{pic}"}]"
    telegram!\sendInline msg.id,block
    return
  telegram!\sendMessage msg.chat.id,message,nil,"Markdown",true

return {
  description: "Return url from lmgtfy"
  usage: "`/lmgtfy <query>` - Return url from lmgtfy :v\n"
  patterns: {
  "^[/!#]lmgtfy (.*)"
  "###inline[/!#]lmgtfy (.*)"
  }
  :run
}
