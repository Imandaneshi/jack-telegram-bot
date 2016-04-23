--Also if you foward a msg to bot it will send the info about the fowarded from user
run = (msg, matches) ->
  text = ""
  chat_user = ""
  name = msg.from.first_name
  name ..= " #{msg.from.last_name}" if msg.from.last_name
  name ..= " @#{msg.from.username}" if msg.from.username
  chat_user = "@#{msg.chat.username}" if msg.chat.username

  if msg.chat.type == "inline"
    pic = "http://icons.iconarchive.com/icons/custom-icon-design/pretty-office-9/128/file-info-icon.png"
    text ..= "<b>Info User:</b> #{name} <code>[#{msg.from.id}]</code>"
    block = "[#{inline_article_block "User Info", text, "HTML", true, "#{name} - #{msg.from.id}", pic}]"
    telegram!\sendInline msg.id,block
    return

  text ..= "<b>You are</b> #{name} <code>[#{msg.from.id}]</code>\n<b>And you are messaging Me !</b>" if msg.chat.type == "private"
  text = "<b>You are</b> #{name} <code>[#{msg.from.id}]</code>\n<b>And you are messaging</b> #{msg.chat.title} #{chat_user} <code>[#{msg.chat.id}]</code>" if msg.chat.type ~= "private"

  telegram!\sendMessage msg.chat.id, text, msg.message_id, "HTML" if msg.chat.type ~= "private"
  telegram!\sendMessage msg.chat.id, text, false, "HTML" if msg.chat.type == "private"
  return

description = "*User&chat info*"
usage = [[
`/who`
Returns info about user and chat
]]
patterns = {
  "^[/!#]who$"
  "^###inline[/!#]who"
}
return {
  :description
  :usage
  :lower
  :patterns
  :run
}
