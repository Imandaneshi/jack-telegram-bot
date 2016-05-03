run = (msg,matches) ->
  text = matches[1]
  if text\match "^%p+$"
    text = "hi"
  message = io.popen("python chatter.py \"#{text}\"")\read('*all')

  return message

description = "*chatter plugin !*"
usage = "`#{bot_first_name}, [text]`
`#{bot_first_name}, How are you ?`
You can also trigger chatter plugin by talking to me in private or replying on of my messages
"
patterns = {
  "#{bot_first_name}, +(.+)$"
  "^@#{bot_username}, +(.+)$"
}
return {
  :description
  :usage
  :patterns
  :run
}
