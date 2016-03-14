--Also if you foward a msg to bot it will send the info about the fowarded from user
run = (msg, matches) ->
  text = ""
  name = msg.from.first_name
  name ..= " #{msg.from.last_name}" if msg.from.last_name
  name ..= " @#{msg.from.username}" if msg.from.username
  text ..= "You are #{name} [#{msg.from.id}] And you are messaging Me !" if msg.chat.type == "private"
  text = "You are #{name} [#{msg.from.id}] And you are messaging #{msg.chat.title}  [#{msg.chat.id}]" if msg.chat.type ~= "private"

  telegram!\sendMessage msg.chat.id, text, msg.message_id, false if msg.chat.type ~= "private"
  telegram!\sendMessage msg.chat.id, text, false, false if msg.chat.type == "private"
  return

description = "*User&chat info*"
usage = [[
`/who`
Returns info about user and chat
]]
patterns = {
  "^[/!#]who$"
}
return {
  :description
  :usage
  :patterns
  :run
}
