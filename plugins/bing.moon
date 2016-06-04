get_api = (URL) ->
	data = {}
	_, code = https.request{
		url: URL
		method: 'GET'
		headers:{
			["Ocp-Apim-Subscription-Key"]:	"#{config!.bing_api_key}"
		}
		sink: ltn12.sink.table data
	}
	if not code or code ~= 200
		return false
	return table.concat data

run = (msg,matches) ->
	text = matches[1]
	url = "https://bingapis.azure-api.net/api/v5/search/?q=#{text}&count=6"
	jstr = get_api(url)
	if not jstr
		return "_No connection_"
	jdat = JSON.decode jstr
	if not jdat.webPages or not jdat.webPages.value
		return "_No results found_"
	text = ""
	pic = "http://icons.iconarchive.com/icons/dakirby309/simply-styled/128/Bing-icon.png"
	block = "["
	i = 0 + 1
	for i,v in ipairs jdat.webPages.value
		if i <= 6
			url = "#{v.displayUrl\gsub '_', '\\_'}"
			tit = "#{v.name\gsub '&amp;', '&'}"
			block ..= "#{inline_article_block "#{tit\gsub '%[.+%]', ''\gsub '%(.+%)', ''}", "[#{tit}](#{url})", "Markdown", true, "#{v.snippet}", "#{pic}"}, "
			text ..= "*#{i} - *[#{tit}](#{url})\n"

	if msg.chat.type == "inline"
		block ..= "#{inline_article_block "End", "End results", "Markdown", true, "End results", "#{pic}"}]"
		telegram!\sendInline msg.id,block
		return

	return text


return {
	description: "*Searches Bing*"
	usage: "`/bing [terms]` - Search on Bing!\n"
	patterns: {
	"^[/!#]bing (.*)"
	--inline
	"^###inline[/!#]bing (.*)"
	}
	:run
}
