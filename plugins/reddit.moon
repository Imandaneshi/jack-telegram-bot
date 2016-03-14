run = (msg,matches) ->
	message = ""
	limit = 6
	if msg.chat.type == "private"
	   limit = 8
	url = "http://www.reddit.com/.json?limit=10"
	if not matches[1]
		url = "http://www.reddit.com/.json?limit=10"

    if matches[1]
		if matches[1] == "/r"
			url = "http://www.reddit.com/r/#{matches[2]}/.json?limit=#{limit}"
		elseif matches[1] ~= "/r"
			url = "http://www.reddit.com/search.json?q=#{URL.escape matches[1]}&limit=#{limit}"

	jstr, res = http.request url
	if res ~= 200
		return "_Connection error_"

	jdat = JSON.decode jstr
	if #jdat.data.children == 0
		return "_No results_"

	for i,v in ipairs (jdat.data.children)
		if v.data.over_18
			message ..= "*[NSFW]* "

	    long_url = ""
		if not v.data.is_self
			long_url = "[Extra link](#{v.data.url})\n\n"


		short_url = "redd.it/#{v.data.id}"
		title = "#{v.data.title\gsub '%[.+%]', ''}"
		message ..= "*#{i}* - [#{title}](#{short_url})

#{long_url}"

    return message


return {
  description: "*Return top result of Reddit*"
  usage: [[
`/reddit`
Will return reddit top results
`/reddit /r [subreddit]`
Will return top result of /rsubreddit
`/reddit search [text]`
Will search text on Reddit and return result
]]
  patterns: {
      "^[!/#]reddit (/r) ([^%s]+)$",
      "^[!/#]reddit search +(.+)$",
      "^[!/#]reddit$"
  }
  :run
}
