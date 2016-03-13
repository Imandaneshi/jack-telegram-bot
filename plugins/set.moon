save_value = (msg, name, value) ->
  if (not name or not value)
    return ""

  hash = nil
  if msg.chat.type == 'group' or msg.chat.type == "supergroup" or msg.chat.type == "channel"
    hash = "bot:chat:#{msg.chat.id}:variables"

  if msg.chat.type == 'private'
    hash = "bot:user:#{msg.from.id}:variables"

  if hash
    redis\hset hash, name, value
    return "*Saved* `#{name}`"

run = (msg,matches) ->
  name = string.sub matches[1], 1, 50
  value = string.sub matches[2], 1, 1000

  text = save_value msg, name, value
  return text

return {
  description: "*Plugin for saving values*"
  usage: "`/set [value_name] [data]`\n"
  patterns: {
  "^[#!/]set ([^%s]+) (.+)$"
  }
  :run
}
