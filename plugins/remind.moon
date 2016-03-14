save_cron = (msg, text, date, name) ->
  hash = "bot:reminder:#{msg.chat.id}:#{msg.from.id}"
  redis\hset hash, 'date', date
  redis\hset hash, 'text', text
  redis\hset hash, 'name', name
  hash = "bot:reminds"
  redis\sadd hash, "#{msg.chat.id}:#{msg.from.id}"
  return 'Saved!'

delete_cron = (cron) ->
  redis\del "bot:reminder:#{cron}"
  redis\srem "bot:reminds", cron

cron = ->
  for k, v in pairs redis\smembers("bot:reminds")
    reminds = redis\hgetall("bot:reminder:#{v}")
    if reminds
      if tonumber(reminds.date) < tonumber(os.time!)--times up !
        telegram!\sendMessage v,"*Reminder:*
#{reminds.name}

#{reminds.text}", false, "Markdown"

        delete_cron v--Delete the cron

run = (msg,matches) ->
  time = 0
  text = ""
  delay = 0
  if matches[2]\match("[Hh]") and matches[4]
    if matches[4]\match("[Mm]") and matches[5]
      if matches[1]\len! > 4
        return "_ERROR!_"
      if matches[3]\len! > 4
        return "_ERROR!_"
      matches[1] = tonumber(matches[1])
      matches[3] = tonumber(matches[3])
      text = matches[5]
      delay = (matches[1] * 3600)+(matches[3]* 60)

  if matches[2]\match("[Hh]") and matches[3] and matches[5] == nil
    if matches[1]\len! > 4
      return "_ERROR!_"

    time = tonumber(matches[1])
    text = tostring(matches[3])
    delay = time * 3600

  if matches[2]\match("m") and matches[3] and matches[5] == nil
    if matches[1]\len! > 4
      return "_ERROR!_"
    time = tonumber matches[1]
    text = tostring matches[3]
    delay = time * 60

  delay += os.time!
  name = msg.from.first_name
  name ..= "\n@#{msg.from.username}" if msg.from.username
  save_cron msg, text, delay, name
  return "I'll remind you on `#{os.date("%x at %H:%M:%S",delay)}` about *#{text}*"

description = "*Remind plugin*"
usage = [[
`/remind [delay] [value (in mh)] [text]`
Save a reminder
Examples:
/remind _1h test_
/remind _1m test_
/remind _1h30m test_
]]
patterns = {
  "^[!/#]remind (%d+)([Hh]) (.+)$"
  "^[!/#]remind (%d+)([Mm]) (.+)$"
  "^[!/#]remind (%d+)([Hh])(%d+)([Mm]) (.+)$"
  }
return {
  :description
  :usage
  :patterns
  :run
  :cron
}
