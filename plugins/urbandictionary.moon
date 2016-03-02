run = (msg,matches) ->
  
  text = matches[1]
  
  url = "http://api.urbandictionary.com/v0/define?term=#{URL.escape text}"
  jstr, res = http.request url
  if res ~= 200 then
	 return "_No connection_"
  jdat = JSON.decode jstr
  if jdat.result_type == "no_results"
     return "_No results_"
  message = "*#{jdat.list[1].word}*
#{jdat.list[1].definition\gsub '^%s*(.-)%s*$', '%1'}

*Example:*
_#{jdat.list[1].example\gsub '^%s*(.-)%s*$', '%1'}_"
  return message
 
 
return {
  description: "*Urban dictionary*"
  usage: "`/ud [query]`\n"
  patterns: {
  "^[/!#]ud (.*)"
  "^[/!#]dic (.*)"
  }
  :run
}
