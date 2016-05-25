redis_poll = (chat_id, matches) ->
	hash = "bot:poll:#{chat_id}"
	redis\set "#{hash}:name", "#{matches}" if matches
	redis\set "#{hash}:id", math.random 100,900 if matches
	name = redis\get "#{hash}:name"
	id = redis\get "#{hash}:id"
	return name, id

redis_poll_del = (chat_id) ->
	hash = "bot:poll:#{chat_id}"
	redis\del "#{hash}:users"
	redis\del "#{hash}:name"
	redis\del "#{hash}:id"
	redis\del "#{hash}:votes"
	redis\del "#{hash}"
	return true

redis_save = (chat_id, vote, nvotes) ->
	hash = "bot:poll:#{chat_id}"
	redis\hset "#{hash}:votes", "#{vote}", "#{nvotes}"
	return true

redis_check = (chat_id, vote) ->
	hash = "bot:poll:#{chat_id}"
	get = redis\hget "#{hash}:votes", "#{vote}"
	return get

redis_get = (chat_id) ->
	hash = "bot:poll:#{chat_id}"
	get = redis\hgetall "#{hash}:votes"
	return get

redis_save_user = (chat_id, from_id, vote) ->
	hash = "bot:poll:#{chat_id}"
	redis\hset "#{hash}:users", "#{from_id}", "#{vote}"
	return

redis_get_user = (chat_id, from_id) ->
	hash = "bot:poll:#{chat_id}"
	get = redis\hget "#{hash}:users", "#{from_id}"
	return get

vote_fun = (chat_id, from_id, vote) ->
	hash = "bot:poll:#{chat_id}"
	get = redis_get_user chat_id, from_id

	if not get
		n_votes = redis_check chat_id, vote
		n_votes = math.floor(n_votes+1)
		redis_save chat_id, vote, n_votes
		redis_save_user chat_id, from_id, vote
		return vote
	elseif get
		get_nvotes = redis_check chat_id, get
		get_nvotes = math.floor(get_nvotes-1)
		redis_save chat_id, get, get_nvotes

		n_votes = redis_check chat_id, vote
		n_votes = math.floor(n_votes+1)
		redis_save chat_id, vote, n_votes
		redis_save_user chat_id, from_id, vote
		return vote
	return

new_poll = (chat_id, matches) ->
	message = "
	*Poll Created!*
	Now added answer option.
	Example:
	`/poll add Minecraft`
	`/poll add Clash of clan`
	"

	redis_poll_del chat_id
	name = redis_poll chat_id, matches
	return message

del_poll = (chat_id) ->
	message = "*Poll Deleted!*"
	unless redis_poll chat_id
		return "_No has poll!_"
	redis_poll_del chat_id
	return message

add_poll = (chat_id, matches) ->
	redis_save chat_id, matches, 0
	return "*Added!*"

poll_poll = (msg, chat_id, get) ->
	name, id = redis_poll chat_id
	unless name
		return "_No has poll!_"

	message = "*Votes for* `#{name}`*:*\n"
	win_v = false
	win_i = 0
	for v, i in pairs redis_get chat_id
		message ..= "*-* #{v}: `#{i}`\n"
		if math.floor(i) > math.floor(win_i)
			win_i = "#{i}"
			win_v = "#{v}"

	message ..= "\n*Win: #{win_v}*: `#{win_i}`" if win_v
	if get
		return message
	url = "https://telegram.me/#{bot_username}?start=pollid#{id}CHAT#{chat_id}"
	call = "[[#{inline_keyboard_button "Vote Here", url}]]"
	telegram!\sendMessage msg.chat.id, message, false, "Markdown", true, true, "#{inline_keyboard_block call}"
	return

vote_poll = (msg, matches) ->
	chat_id = matches[3]
	name, id = redis_poll chat_id
	unless "#{id}" == "#{matches[2]}"
		return "_ERROR_"

	call = "["
	for v, i in pairs redis_get chat_id
		call ..= "[#{inline_keyboard_button "#{v}", false, "poll:pollid#{id}:chat#{chat_id}:vote:#{v}"}],"
	call ..= "[#{inline_keyboard_button "View Total",  false, "poll:pollid#{id}:chat#{chat_id}:view"}]]"

	if msg.chat.type == "private"
		telegram!\sendMessage msg.from.id, "*Poll: #{name}*", false, "Markdown", true, true, "#{inline_keyboard_block call}"
		return

	if matches[4] and matches[4] == "view" and msg.chat.type == "callback"
		telegram!\editMessageText msg.chat.id, msg.message_id, "#{poll_poll msg, chat_id, true}", true, "Markdown", "#{inline_keyboard_button call}"
		return
	elseif matches[4] == "vote" and msg.chat.type == "callback"
		if matches[5]
			vote = matches[5]
			svote = vote_fun chat_id, msg.from.id, vote
			telegram!\answerCallbackQuery msg.id, "Your vote was saved!"
			telegram!\editMessageText msg.chat.id, msg.message_id, "#{poll_poll msg, chat_id, true}\nYou voted in #{svote}", true, "Markdown", "#{inline_keyboard_block call}"
			return
	return

run = (msg, matches) ->
	chat_id = msg.chat.id
	if matches[1] == "new" and matches[2] and msg.chat.type ~= "private"
		return new_poll chat_id, matches[2]
	elseif matches[1] == "del" and not matches[2] and msg.chat.type ~= "private"
		return del_poll chat_id
	elseif matches[1] == "add" and matches[2] and msg.chat.type ~= "private"
		return add_poll chat_id, matches[2]
	elseif matches[1] == "poll" and not matches[2] and msg.chat.type ~= "private"
		return poll_poll msg, chat_id, false
	elseif matches[1] == "pollid" and matches[2] and matches[3]
		return vote_poll msg, matches
	elseif msg.chat.type == "private"
		return "*Only in Group!*"
	return

return {
	description: "*Poll Plugin!*"
	usage: [[
`/poll new [question]` - Create a new poll
`/poll add [option]` - Added a answer option
`/poll del` - Delete or terminate the Poll
`/poll` - Shows the poll
]]
	patterns: {
	"^[!/#]poll (new) (.*)"
	"^[!/#]poll (del)"
	"^[!/#]poll (add) (.*)"
	"^[!/#](poll)$"
	"^/(pollid)(.*)CHAT(.*)"
	"^###callback:poll:(pollid)(.*):chat(.*):(view)"
	"^###callback:poll:(pollid)(.*):chat(.*):(vote):(.*)"
	}
	:run
}
