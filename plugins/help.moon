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
    if plugins[v]
      if (plugins[v] @).is_listed == nil or (plugins[v] @).is_listed == true
        text ..= "`#{i}` *- #{v}*\n"
        i += 1

  text ..= "
Send `/help [plugin name]` for more info."
  text ..= "
Or Send `/help all` to my private for all info."
  return text

help_all = (target) ->--Returns all plugins info
  text = ""
  help_plugins = {}
  i = 1
  p = 0
  for k,v in pairs config!.plugs
    if plugins[v]
      if (plugins[v] @).is_listed == nil or (plugins[v] @).is_listed == true
        table.insert help_plugins, v

  for i=1,#help_plugins
    text ..= "*#{i}* - #{plugin_help help_plugins[i]}"
    if i > 14
      p += 1
      if i == 15
        p = 0
        res = telegram!\sendMessage target,text,false,"Markdown"
        unless res
          return false
        text = ""
      elseif p > 14
        p = 0
        res = telegram!\sendMessage target,text,false,"Markdown"
        unless res
          return false
        text = ""
    i += 1
    p = p

  res = telegram!\sendMessage target,text,false,"Markdown"
  unless res
    return false

run = (msg,matches) ->
  if matches[1] == "help" and matches[2] == "all"
    if msg.chat.type == 'inline'
      return
    elseif msg.chat.type ~= "private"
      res = help_all(msg.from.id)
      unless res
        return "_Message me first so i can message you !_"

      return "*I have sent you the plugins list with their full information in a private message*"
    else
      help_all(msg.from.id)
      return

  elseif matches[1] == "help" and matches[2]
    if msg.chat.type == 'inline'
      pic = "http://icons.iconarchive.com/icons/custom-icon-design/pretty-office-2/128/help-desk-icon.png"
      help_inline = plugin_help matches[2]
      if help_inline
        block = "[#{inline_article_block "#{matches[2]}", "#{help_inline}", "Markdown", true, "Help for #{matches[2]}", "#{pic}"}]"
        telegram!\sendInline msg.id, block
        return
    else
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
usage = "
`/help`
Will return a short list of plugins
`/help all`
Will return full list of plugins with their commands
`/help [plugin_name]`
Will return info about that plugin
"
patterns = {
  "^[/!#](help) (.*)$"
  "^[/!#](help)$"
  "^[/!#](start)$"
  "^###inline[/!#](help) (.*)"
}
is_listed = false
return {
  :run
  :patterns
  :usage
  :description
  :is_listed
}
