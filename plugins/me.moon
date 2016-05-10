parameters = {
	["location"]: "%s\n"
	["spotify"]: "[%s](https://play.spotify.com/user/%s)\n"
	["twitter"]: "[%s](https://twitter.com/%s)\n"
	["phone"]: "`%s`\n"
	["email"]: "%s\n"
	["github"]: "[%s](https://github.com/%s)\n"
	["steam"]: "[%s](http://steamcommunity.com/id/%s)\n"
	["facebook"]: "[%s](https://www.facebook.com/%s)\n"
	["reddit"]: "[%s](https://reddit.com/u/%s)\n"
	["instagram"]: "[%s](https://www.instagram.com/%s)\n"
	["lastfm"]: "[%s](http://www.lastfm.com/user/%s)\n"
}
patterns = {
	"^[#!/](me)$"
	"^###inline[!/#](me)"
}
is_parameter = (q) ->
	var = false
	for k,v in pairs(parameters)
		if q == k
			var = true
	return var

for k,v in pairs parameters
	pattern = "^[#!/](me) (#{k}) +(.+)$"
	table.insert patterns, pattern

run = (msg,matches) ->
	if matches[1] == "me"
		msg = msg.reply_to_message if msg.reply_to_message and matches[2] == nil
		if matches[2] and matches[2] and matches[3] ~= "del"
			if is_parameter matches[2]
				if string.len(matches[3]) < 35
					redis\set "bot:#{matches[2]}:user:#{msg.from.id}", matches[3]
					return "Your `#{matches[2]}` has been set to `#{matches[3]}`"
				else
					return "_Too much character_"
			else
				return "Unknown parameter"
		elseif matches[3] == "del"
			if is_parameter matches[2]
				redis\del "bot:#{matches[2]}:user:#{msg.from.id}"
				return "Your `#{matches[2]}` has been forgotten"
		else
			text = "`#{msg.from.first_name}`"
			text ..= " `#{msg.from.last_name}`" if msg.from.last_name
			text ..= "\n"

			for k,v in pairs parameters
				if redis\get "bot:#{k}:user:#{msg.from.id}"
					v = v\format redis\get("bot:#{k}:user:#{msg.from.id}"),redis\get("bot:#{k}:user:#{msg.from.id}")
					text ..= "*#{up_the_first k}:* #{v}"
			if msg.chat.type == "inline"
				pic = "http://icons.iconarchive.com/icons/designcontest/ecommerce-business/128/contact-info-icon.png"
				block = "[#{inline_article_block "ME !", text, "Markdown", true, text, pic}]"
				telegram!\sendInline msg.id,block
				return
			if msg.chat.type ~= "private"
				user_msg = redis\get "bot:total_users_msgs_in_chat:#{msg.chat.id}:#{msg.from.id}"
				group_msg = redis\get "bot:total_chat_msgs:#{msg.chat.id}"
				percent = math.floor((user_msg * 100) / group_msg)
				text ..= "\nYou've sent `#{user_msg}` (#{percent}%) messages and this group has `#{group_msg}` messages."
			if msg.chat.type == "private"
				user_msg = redis\get "bot:total_user_msgs_in_private:#{msg.from.id}"
				text ..= "\nYou've sent #{user_msg} messages to me."

			return text
usage = "`/me [parameter] [query]`
parameters are "
i = 1
for k,v in pairs(parameters)
	if i = 1
 		usage ..= "#{k},"
	else
		usage ..= ",#{k}"
		i += 1
usage ..= "
_/me facebook imandabot_
`/me [parameter] del`
Will delete [parameter]
`/me`
Will return your profile and msg Statistics
_Can also be triggered by reply_
"
return {
	:run
	:patterns
	description: "*Your profile !*"
	:usage
}
