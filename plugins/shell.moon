run = (msg,matches) ->
	if matches[1] == "shell" and is_admin msg
		command = matches[2]\gsub('—', '--')
		text = "`#{io.popen(command)\read("*all")}`"
		print text
		return text


patterns = {
  "^[#!/](shell) (.*)$"
}
description = "*Command line*"
usage = [[
`/shell <command>`
Will run that command and return results
]]
is_listed: false
return {
  :run
  :patterns
  :description
	:is_listed
  :usage
}
