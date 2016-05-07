get_msgs_user_chat = (user_id, chat_id) ->
  user = redis\hgetall("bot:users:#{user_id}")
  user_msg_s = "bot:total_users_msgs_in_chat:#{chat_id}:#{user_id}"
  user_info = {
    msgs: tonumber redis\get(user_msg_s) or 0
    name: "#{user.first_name} {#{user_id}}"
  }
  return user_info

get_group_name = (chat_id) ->
  chat = redis\hgetall "bot:chats:#{chat_id}"
  return chat.title or "uknown"

all_groups_stats = (target) ->
  group_stats = {}
  text = ""
  list = redis\smembers "bot:chats"
  for k,v in pairs list
    if tonumber(v) < 0
      group_stat = {
        name: get_group_name v
        msgs: tonumber redis\get("bot:total_chat_msgs:#{v}")
        id: v
      }
      table.insert group_stats, group_stat
  sorting = (a, b) ->
    if a.msgs and b.msgs
      return a.msgs > b.msgs
  table.sort(group_stats, sorting)
  i = 1
  for k,v in pairs group_stats
    text ..= "#{i} - #{v.name} [#{v.id}] = #{v.msgs}\n"
    i += 1
  file = io.open ".tmp/groups.txt", "w"
  file\write text
  file\flush!
  file\close!
  telegram!\sendDocument target, ".tmp/groups.txt"
  os.remove ".tmp/groups.txt"

chat_stats = (chat_id, target) ->

  users = redis\smembers("bot:chat#{chat_id}")
  users_info = {}
  for i = 1, #users
    user_id = users[i]
    user_info = get_msgs_user_chat user_id, chat_id
    table.insert(users_info, user_info)

  table.sort(users_info,(a, b) ->
    if a.msgs and b.msgs then
      return a.msgs > b.msgs)

  text = ""
  i = 1
  if tonumber(redis\scard "bot:chat#{chat_id}") < 30
    for k,user in pairs users_info
      text ..= "#{i} - #{user.name} = #{user.msgs}\n"
      i += 1
  else
    for k,user in pairs users_info
      text ..= "#{i} - #{user.name} = #{user.msgs}\n"
      i += 1

    file = io.open "#{chat_id}_chat_stats.txt", "w"
    file\write text
    file\flush!
    file\close!
    telegram!\sendDocument target, "#{chat_id}_chat_stats.txt"
    os.remove "#{chat_id}_chat_stats.txt"
    return ""

  return text

run = (msg, matches) ->
  if matches[1] == 'groupstats' and is_admin msg
    all_groups_stats(msg.from.id)
    return
  if matches[1] == "chatstats"
    unless matches[2]
      if msg.chat.type ~= 'private'
        return chat_stats msg.chat.id, msg.chat.id
    else
      if not is_admin msg
        return

      return chat_stats matches[2], msg.from.id

patterns = {
  "^[#!/](chatstats) (.*)$"
  "^[#!/](chatstats)$"
  "^[#!/](groupstats)$"
}
description = "*Chat stats.*"
usage = [[
`/chatstats`
Returns a list of members with their msg statistics
]]
return {
  :run
  :patterns
  :description
  :usage
}
