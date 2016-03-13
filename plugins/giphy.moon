gif = (msg,q) ->
  q = q
  url = "http://api.giphy.com/v1/gifs/search?q=#{q}&api_key=dc6zaTOxFJmzC"

  jstr, res = http.request url

  if res ~= 200
     return "not found"

  jdat = JSON.decode jstr

  random = math.random #{jdat.data}

  file = "#{jdat.data[random].images.original.url}"

  file_path = download_to_file file,"giphy.gif"

  gif = telegram!\sendDocument msg.chat.id,file_path

  remove = os.remove file_path

run = (msg,matches) ->
  if matches[1] == "giphy" and matches[2]
      return gif msg,matches[2]
  elseif matches[1] == "giphy"
      url = "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=american+psycho"

      jstr, res = http.request url
      jdat = JSON.decode jstr

      file = "#{jdat.data.image_url}"

      file_path = download_to_file file,"giphy.gif"

      gif = telegram!\sendDocument msg.chat.id,file_path
      remove = os.remove file_path

return {
  description: "*Returns a GIF from giphy.com!*"
  usage: [[
`/giphy`
Returns a random GIF
`/giphy [query]`
Returns a GIF about query
]]
  patterns: {
  "^[/!#](giphy) (.*)"
  "^[/!#](giphy)$"
  }
  :run
}
