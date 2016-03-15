run = (msg,matches) ->
	input = ""
	if matches[2]
		input = matches[2]

	if not matches[2]
		if msg.reply_to_message
			input = msg.reply_to_message.text
		else
			input = ""

	tl = matches[1]
	url = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{config!.translate_api_key}&format=plain&lang=#{tl}&text=#{URL.escape input}"
	str, res = https.request url
	if res ~= 200
		return "_No connection_"
	jdat = JSON.decode str
	output = "*Language:* `#{jdat.lang}`\n#{jdat.text[1]}"

	if msg.chat.type == "inline"
		pic = "http://icons.iconarchive.com/icons/custom-icon-design/flatastic-5/128/Select-language-icon.png"
		block = "[#{inline_article_block "Translator! #{jdat.lang}", "#{output}", "Markdown", true, "#{jdat.text[1]}", "#{pic}"}]"
		telegram!\sendInline msg.id, block
		return

    return output

return {
	description: "*Yandex translate*"
	usage: [[
`/translate [language] [text]`
Will translate text to language
`/translate [language]`
[language] examples:
en for translating text to english
ar-en for translating text from arabic to english
You can use both
Use it by reply
]]
	patterns: {
		"^[/!#]translate ([^%s]+) (.*)$"
		"^[/!#]translate (.*)$"
		"^[/!#]tr ([^%s]+) (.*)$"
		"^[/!#]tr ([^%s]+)$"
		-- Inline
		"^###inline[/!#]translate ([^%s]+) (.*)$"
		"^###inline[/!#]translate (.*)$"
		"^###inline[/!#]tr ([^%s]+) (.*)$"
		"^###inline[/!#]tr ([^%s]+)$"
	}
:run
}
