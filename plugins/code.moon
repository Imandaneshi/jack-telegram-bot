run = (msg, matches) ->
	if matches[1] and matches[2] then
		lang = URL.escape matches[1]
		code = URL.escape matches[2]
		code = string.gsub(code, '—', '--')

		highlighter = "http://markup.su/api/highlighter?language=#{lang}&theme=Sunburst&source=#{code}"
		jstr, res = http.request highlighter
		if res ~= 200
			return
		if string.match(jstr, "^Couldn't load")
			return "[List of language supported](http://pastebin.com/HiRrhzUm)"
		highlighter = URL.escape highlighter
		screenshotmachine = "http://api.screenshotmachine.com/?key=#{config!.screenshotmachine_api_key}&size=X&url=#{highlighter}"

		i = math.random(10, 1000)
		file_path = download_to_file screenshotmachine, "#{i}code.jpg"
		telegram!\sendPhoto msg.chat.id, file_path
		os.remove file_path
		return
	return

return {
	description: "*Send the code in image format*"
	usage: [[
	`/code [language] [code]`
	Send the code in image format with support for highlighter.
	[List of language supported](http://pastebin.com/HiRrhzUm)
	]]
	patterns: {
		"^[!/#]code ([^%s]+) (.*)$"
	}
	:run
}
