run = (msg,matches) ->
  matches[1] = matches[1]\gsub "[!/#]",""
  return matches[1]
patterns = {
  "^/echo (.*)"
}
return {
  :run
  :patterns
}
