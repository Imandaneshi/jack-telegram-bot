get_variables_hash = (msg) ->
  if msg.chat.type == "group" or msg.chat.type == "supergroup" or msg.chat.type == "channel"
    return "bot:chat:#{msg.chat.id}:variables"

  if msg.chat.type == "private"
    return "bot:user:#{msg.from.id}:variables"

list_variables = (msg) ->
  hash = get_variables_hash msg

  if hash
    names = redis\hkeys hash
    text = ""
    for i=1, #names do
      text = "#{text}*#{i}* - `#{names[i]}`\n"

    return text

get_value = (msg, var_name) ->
  hash = get_variables_hash msg
  if hash
    value = redis\hget hash, var_name
    unless value
      return '_Not found, use "!return" to list variables_'
    else
      return "*#{var_name}*

#{value}"


run = (msg, matches) ->
  if matches[2]
      text = get_value msg, matches[2]
      return text
  else
    return list_variables msg


return {
description: "*Retrieves variables saved with /set*"
  usage: "`/return (value_name)`\n"
  patterns: {
  "^([#!/]return) (.+)$"
  "^([#!/]r) (.+)$"
  "^[#!/]return$"
  }
  :run
}
