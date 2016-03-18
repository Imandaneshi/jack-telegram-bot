fortunes = (msg) ->
  MSG = io.popen("fortune")\read("*all")
  return MSG
  
run = (msg, matches) ->
   if matches[1] == "fortunes"
     return fortunes msg


return {
  description: "*Fortunes*"
  usage: "`/fortunes`"
  patterns: {
  "^[/!#](fortunes)"
  }
  :run
}
