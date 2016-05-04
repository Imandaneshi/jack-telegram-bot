run = (msg,matches) ->
	text = matches[1]
	url = "http://api.duckduckgo.com/?q=#{URL.escape text}&format=json&pretty=1&no_html=1&skip_disambig=1"
	jstr, res = https.request url
	if res ~= 200
		return "_No connection_"
	jdat = JSON.decode jstr
	if not jdat.RelatedTopics[1]
		return "_No results found_"
	text = ""
	pic = "http://icons.iconarchive.com/icons/ampeross/qetto-2/128/search-icon.png"
	block = "["
	i = 0 + 1
	for i,v in ipairs (jdat.RelatedTopics)
		if jdat.RelatedTopics[i].Result and i <= 6
			url = "#{jdat.RelatedTopics[i].FirstURL\gsub '_', '\\_'}"
			tit = "#{jdat.RelatedTopics[i].Text}"
			text ..= "*#{i} - *[#{tit}](#{url})\n"
			block ..= "#{inline_article_block "#{tit\gsub '%[.+%]', ''\gsub '%(.+%)', ''\sub 1, 23}", "[#{tit}](#{url})", "Markdown", true, "#{url}", "#{pic}"}, "

	if msg.chat.type == "inline"
		block ..= "#{inline_article_block "End", "End results", "Markdown", true, "End results", "#{pic}"}]"
		telegram!\sendInline msg.id,block
		return

	return text


return {
	description: "*Searches DuckDuckGo*"
	usage: "`/google [terms]` - Search on DuckDuckGo!\n"
	patterns: {
	"^[/!#]duckgo (.*)"
	"^[/!#]duckduckgo (.*)"
	--inline
	"^###inline[/!#]duckgo (.*)"
	"^###inline[/!#]duckduckgo (.*)"
	}
	:run
}
