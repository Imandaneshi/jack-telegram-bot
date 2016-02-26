run = (msg,matches) ->
  matches[1] = matches[1]\gsub "[!/#]","" if matches[1]\match "^[!/#]"
  return matches[1]
patterns = {
  "^[#!/]echo (.*)"
}
description = "*Echo plugin !*"
usage = "
`/echo <text>`
Will return text
_Markdown is enabled_
"
return {
  :run
  :patterns
  :description
  :usage
}
