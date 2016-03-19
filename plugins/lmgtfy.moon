run = (msg,matches) ->
  message = "http://lmgtfy.com/?q=#{URL.escape matches[1]}"
  if msg.chat.type == "inline"
    pic = "http://s6.picofile.com/file/8244044400/lmgtfy.jpeg"
    block = "[#{inline_article_block "lmgtfy", "#{message}", "Markdown", true, "#{matches[1]}", "#{pic}"}]"
    telegram!\sendInline msg.id,block
    return
  return message 

return {
  description: ""
  usage: ""
  patterns: {
  "^[/!#]lmgtfy (.*)"
  "###inline[/!#]lmgtfy (.*)"
  }
  :run
}
