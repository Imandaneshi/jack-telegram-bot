run = (msg,matches) ->
	input = matches[1]
	url = "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20in%20%28select%20woeid%20from%20geo.places%281%29%20where%20text%3D%22#{URL.escape input}%22%29&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
	jstr, res = http.request url
	if res ~= 200
		  return "_No connection_"

	jdat = JSON.decode jstr

	unless jdat.query.results
		return "_no results_"

	data = jdat.query.results.channel.item.condition
	text = data.text

	fahrenheit = data.temp
	celsius = string.format("%.0f", (fahrenheit - 32) * 5/9)
	message = "*#{celsius}*°C | * #{fahrenheit} *°F, _ #{text} _."

	if msg.chat.type == "inline"
		pic = "http://icons.iconarchive.com/icons/pixelkit/flat-jewels/128/Weather-icon.png"
		block = "[#{inline_article_block "#{matches[1]} weather", "*#{matches[1]} weather* \n#{message}","Markdown", true, "#{celsius}°C | #{fahrenheit}°F", "#{pic}"}]"
		telegram!\sendInline msg.id, block
		return
	return message

return {
  description: "*Weather*"
  usage: "`/weather <city>` - Returns the current weather\n"
  patterns: {
  "^[/!#]w (.*)"
  "^[/!#]weather (.*)"
  "^###inline[/!#]weather (.*)"
  }
  :run
}
