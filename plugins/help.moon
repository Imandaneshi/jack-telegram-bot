plugin_help = (plugin_name) ->--Returns plugin info
  plugin = plugins[plugin_name]
  unless plugin
    return nil
  text = " *#{plugin_name}* - #{(plugin @).description}
#{(plugin @).usage or " "}
"
  return text

plugins_list = ->--Returns plugin list
  text = "*Plugins list*:

"
  i = 1
  for k,v in pairs config!.plugs
    if v ~= "admin"
      text ..= "`#{i}` *- #{v}*\n"
      i += 1

  text ..= "
Send `/help [plugin name]` for more info."
  text ..= "
Or Send `/help all` to my private for all info."
  return text

help_all = (target) ->--Returns all plugins info
  text_1 = ""
  --text_2 = ""
  --help_plugins = {}
  i = 1
  for v in pairs(plugins)
    text_1 ..= "*#{i}* - #{plugin_help(v)}"
    i += 1

  res = telegram!\sendMessage target,text_1,false,"Markdown"
  if res
    return true
  else
    return false

run = (msg,matches) ->
  if matches[1] == "help" and matches[2] == "all"
    if msg.chat.type ~= "private"
      res = help_all(msg.from.id)
      unless res
        return "_Message me first so i can message you !_"

      return "*I have sent you the plugins list with their full information in a private message*"
    else
      help_all(msg.from.id)
      return

  elseif matches[1] == "help" and matches[2]
    return plugin_help(matches[2])
  else
    if msg.chat.type ~= "private"
      res = telegram!\sendMessage msg.from.id,plugins_list!,false,"Markdown"
      unless res
        return "_Message me first so i can message you !_"

      return "*I have sent you the plugins list in a private message*"
    else
      return plugins_list()

description = "*Get info about plugins !*"
usage = [[
`/help`
Will return a short list of plugins
`/help all`
Will return full list of plugins with their commands
`/help [plugin_name]`
Will return info about that plugin
]]
patterns = {
  "^[/!#](help) (.*)$"
  "^[/!#](help)$"
  "^[/!#](start)$"
}
return {
  :run
  :patterns
  :usage
  :description
}
