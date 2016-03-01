run = (msg,matches) ->
  
  link = matches[1]
  
  url = "https://api-ssl.bitly.com/v3/shorten?access_token=#{config!.linkshorter_api_key}&longUrl=#{URL.escape link}"
  
  jstr, res = https.request url
  
  jdat = JSON.decode jstr
  
  return "#{jdat.data.url}"
 
  

return {
  description: "*link shortener plugin*"
  usage: "`/shorten [url]`
Will shorten that link 
Example :
/shorten _https://google.com_
\n"
  patterns: {
  "^[/!#]shorten (https?://[%w-_%.%?%.:/%+=&]+)$"
  }
  :run
}
