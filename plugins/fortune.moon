fortunes = (msg) ->
  MSG = io.popen("fortune")\read("*all")

  if string.match(MSG, 'not found$')
    print("Plugin Fortune: Requirement Fortune")
    print("sudo apt-get install fortune")

  if msg.chat.type == "inline"
    pic = "http://icons.iconarchive.com/icons/icons8/ios7/128/Astrology-Fortune-Teller-icon.png"
    block = "[#{inline_article_block "Fortune", "#{MSG}", "Markdown", true, "#{MSG}", "#{pic}"}]"
    telegram!\sendInline msg.id,block
    return

  return MSG

run = (msg, matches) ->
   if matches[1] == "fortunes"
     return fortunes msg


return {
  description: "*Fortunes*"
  usage: "`/fortunes`\n"
  patterns: {
  "^[/!#](fortunes)"
  "^###inline[/!#](fortunes)"
  }
  :run
}
