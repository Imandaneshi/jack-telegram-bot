run = (msg,matches) ->
	unless is_admin msg
		return
	matches[1] = matches[1]\gsub "return msg", "return msg_global" if matches[1]\match "msg"
	text = moonscript.loadstring matches[1]
	text = text!
	if type text == "table"
		text = serpent.block(text,{comment:false})--sudo luarocks install serpent , also uncomment export serpent in jackbot.moon
		text = text\gsub ",", ""
		text = text\gsub " =", ":"

	return "`#{text}`"

return {
	is_listed: false
	description: "*moonscript load string*"
	usage: "`/moon [code]` - Load string in moonscript\n"
	patterns: {
		"^[/!#]moon (.*)"
	}
	:run
}
