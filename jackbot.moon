export moonscript = require "moonscript.base"
export http = require "socket.http"
export https = require "ssl.https"
export URL = require "socket.url"
export ltn12 = require "ltn12"
export serpent = require "serpent"
export socket = require "socket"
export JSON = require "cjson"
export colors = require 'ansicolors'
export config = moonscript.loadfile "config.moon",implicitly_return_root:true
utilities = moonscript.loadfile "utilities.moon",implicitly_return_root:true
utilities!
export redis = (Redis @).client
export plugins = {}

export bot_run = class bot_run
  @admins_ids: config!.admins
  print_admins: =>
    for k,v in pairs (config!.admins)
      print( colors "%{black whitebg}#{v}%{reset}%{bright green} Added as admin%{reset}")

  print_info: =>
    info = telegram!\getMe!
    print colors("%{bright red}@#{info.result.username}
#{info.result.first_name}
#{info.result.id}%{reset}
")

  plugins_load: =>
    print "\n"
    for k,v in pairs config!.plugs
      pcall(->
        t = moonscript.loadfile "plugins/#{v}.moon",implicitly_return_root:true
        plugins[v] = t
      )
      print(colors "Plugin %{blue whitebg}#{v}%{reset} loaded")
  Bot_loading: =>
    export last_update = last_update or tonumber(redis\get "bot:update_id") or 0

    export last_cron = last_cron or os.time!

    export is_running = true


  new: =>
    @print_info!
    @print_admins!
    @plugins_load!
    @Bot_loading!


export match_trigger = (trigger,text) ->
  if text
    matches = {}
    matches = { string.match text, trigger }
    if next(matches)
      return matches

export match_plugin = (plugin, plugin_name, msg) ->
  for k, patterns in pairs (plugin @).patterns
    matches = match_trigger patterns, msg.text
    print "plugin #{plugin_name} triggered: #{trigger}" if matches
    if matches
      result = (plugin @).run msg, matches
      if result
        telegram!\sendMessage msg.chat.id, result







export msg_processor = (msg) ->
  print msg.text if msg.text
  for name, plugin in pairs plugins
    match_plugin(plugin, name, msg)


bot_run!
telegram!\sendMessage 110626080, "result"
while is_running
  res = telegram!\getUpdates last_update + 1
  if res
    for i,msg in ipairs res.result
      msg_processor msg.message
      export last_update = msg.update_id
      redis\set "bot:update_id", msg.update_id
  else
    print "Connection failed"
