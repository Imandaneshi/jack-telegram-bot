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
	output = "*Language:* `#{jdat.lang}
`#{jdat.text[1]}"

    return output

return {
       description: "*Google translate*"
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
               "^[/!]translate ([^%s]+) (.*)$"
               "^[/!]translate (.*)$"
               "^[/!]tr ([^%s]+) (.*)$"
               "^[/!]tr ([^%s]+)$"
}
             :run
       }
