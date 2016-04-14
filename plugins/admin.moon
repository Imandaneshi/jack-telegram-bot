obtain_user_info = (user_id) ->
  first_name = false
  last_name = false
  username = false
  info = redis\hgetall "bot:users:#{user_id}"
  if info
    if info.first_name
      first_name = info.first_name
    if info.last_name
      last_name = info.last_name
    if info.username
      username = info.username
  text = ""
  if first_name
    text ..= "#{first_name} "
  if last_name
    text ..= "#{last_name} "
  text ..= "#{user_id} "
  if username
    text ..= "@#{username}"
  text ..= "\n"
  return text

premium_list = (msg) ->
  text = ""
  users = redis\smembers "bot:premium:users"
  for k,v in pairs(users)
    text ..= "#{obtain_user_info v}"
  return text

spairs = (t, order) ->
    -- collect the keys
    keys = {}
    for k in pairs(t)
      keys[#keys+1] = k

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order
        table.sort(keys,(a,b) ->
          return order t, a, b
          )
    else
        table.sort keys

    -- return the iterator function
    i = 0
    return () ->
        i += 1
        if keys[i] then
            return keys[i], t[keys[i]]

run = (msg,matches) ->
  unless is_admin(msg)
    return "For admins only"

  if matches[1] == "admin"
    if matches[2] == "reload"--Reloads the bot(plugins not config!)
      bot_run!
      return "*Reloaded !*"

  if matches[1] == "bc"--send a msg to chat/user
    telegram!\sendMessage matches[2],matches[3],false,"Markdown",true

  if matches[1] == "blacklist"--blacklist/baned ppl
    user_id = ""
    if msg.reply_to_message
      user_id = msg.reply_to_message.from.id
    elseif matches[2]
      user_id = matches[2]

    is_blacklisted = redis\sismember("bot:blacklist", user_id)
    if is_blacklisted
      redis\srem("bot:blacklist", user_id)
      return "`User #{user_id} removed from blacklist`"
    else
      redis\sadd("bot:blacklist", user_id)
      return "`User #{user_id} Added to blacklist`"

  if matches[1] == "broadcast"
    list = redis\smembers("bot:chats")
    for k,v in pairs list
			telegram!\sendMessage v, matches[2], false, "Markdown", true
			print matches[2]

  if matches[1] == "bot"--Bot status
    t_msgs = redis\get "bot:total_messages" or 0
    chats = redis\scard "bot:chats" or 0
    groups = redis\scard "bot:groups" or 0
    supergroups = redis\scard "bot:supergroups" or 0
    privates = redis\scard "bot:privates" or 0
    text = "*Chats:* #{chats}
*Groups:* #{groups}
*Supergroups:* #{supergroups}
*Users:* #{privates}
*Total messages:* #{t_msgs}

"
    if msg.chat.type == "inline"
      block = "[#{inline_article_block "Bot stats", text, "Markdown", true}]"
      telegram!\sendInline msg.id,block

    text ..= "*Plugins usage*
"
    plugin_usage = {}
    for k, v in pairs config!.plugs
      plugin_usage[v] = tonumber(redis\get("bot:plugin_usage:#{v}")) or 0

    total_plugins_usage = tonumber(redis\get("bot:plugins_usage")) or 0

    i = 1
    for k, v in spairs(plugin_usage,(t,a,b) ->
      return t[b] < t[a]
      )
      if redis\get("bot:plugin_usage:#{k}") and k ~= "admin"
        percent = math.floor((tonumber(v) * 100) / tonumber(total_plugins_usage))
        text ..= "#{i} - *#{k}:* #{v} (#{percent}%)\n"
      i = i + 1
    return text

  if matches[1] == "plugins"--Plugin disable/enable
    if matches[2]\lower! == "admin"
      return "_ERROR_"

    if matches[4] == "false"
      redis\del "bot:plugin_disabled_on_chat:#{matches[2]}:#{matches[3]}"
      return "*Plugin* `#{matches[2]} `enabled on `#{matches[3]}`"
    elseif matches[4] == "true" then
      redis\set "bot:plugin_disabled_on_chat:#{matches[2]}:#{matches[3]}", true
      return "*Plugin* `#{matches[2]} `disabled on `#{matches[3]}`"
  if matches[1] == "premium"
    if matches[2]
      if matches[2] == "list"
        return premium_list!
    user_id = ""
    if msg.reply_to_message
      user_id = msg.reply_to_message.from.id
    elseif matches[2]
      user_id = matches[2]

    is_premium = redis\sismember("bot:premium:users", user_id)
    if is_premium
      redis\srem("bot:premium:users", user_id)
      return "`User #{user_id} removed from premium list`"
    else
      redis\sadd("bot:premium:users", user_id)
      return "`User #{user_id} Added to premium list`"

  if matches[1] == "editmsg" and matches[2] then
    unless is_admin(msg)
      return "For admins only"

    id_reply = ""
    if msg.reply_to_message and msg.reply_to_message.message_id
      id_reply = msg.reply_to_message.message_id

    id_chat = msg.chat.id
    telegram!\editMessageText id_chat,id_reply,matches[2],false,"Markdown"
    return



patterns = {
  "^[!#/](admin) (reload)$"
  "^[!#/](plugins) ([^%s]+) (.+) (true)$"
  "^[!#/](plugins) ([^%s]+) (.+) (false)$"
  "^[!#/](blacklist)$"
  "^[!#/](blacklist) (%d+)$"
  "^[!#/](premium) (%d+)$"
  "^[!#/](premium) (list)$"
  "^[!#/](premium)$"
  "^[!#/](editmsg) (.*)$"
  "^[!#/](bc) ([^%s]+) (.*)$"
  "^[!#/](broadcast) +(.+)$"
  "^[!#/](bot)$"
  "###inline[!#/](bot)$"
}
description = ""
usage = ""
is_listed = false
return {
  :run
  :patterns
  :description
  :usage
  :is_listed
}
