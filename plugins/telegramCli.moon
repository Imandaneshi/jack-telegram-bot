run = (msg,matches) ->
	unless is_admin msg
		return
	text = tg!\send "#{matches[1]} \n",true
	text = JSON.decode text
	if type text == "table"
		text = serpent.block(text,{comment:false})
		text = text\gsub ",", ""
		text = text\gsub " =", ":"

	text = text\gsub "phone: [^%s]+", "phone: *******"
	text = "`#{text}`"
	return text

return {
	is_listed: false
	description: "*Telegram cli plugin*"
	usage: "/tg [command] - Run command on Telegram cli"
	patterns: {
		"^[/!#]tg (.*)$"
	}
	:run
}
