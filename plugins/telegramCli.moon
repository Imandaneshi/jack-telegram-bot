socket = require "socket"
export tg = class tg
	sender: socket.connect "localhost", config!.cli_port
	send: (command, output) =>
		vardump command
		if output
			s = socket.connect "localhost", config!.cli_port
			s\send command
			data = s\receive(tonumber(string.match(s\receive("*l"), "ANSWER (%d+)")))
			print data
			s\receive "*l"
			s\close()
			return data\gsub '\n$',''
		else
			(tg @).sender\send(command)







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
	description: "*Telegram cli plugin*"
	usage: "/tg <command>"
	patterns: {
		"^[/!#]tg (.*)$"
	}
	:run
}
