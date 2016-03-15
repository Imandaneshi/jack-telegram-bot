imdb = (msg, movie) ->
  movie = movie\gsub ' ', '+'
  url = "http://www.omdbapi.com/?t=#{movie}"
  response, code, headers = http.request url

  if code ~= 200
    return "Error: #{code}"

  if #response > 0
    jdat = JSON.decode response
    if jdat.Error
      return jdat.Error

    if jdat.Poster and jdat.Poster ~= "" and msg.chat.type ~= 'inline'
      file_path = download_to_file jdat.Poster,"imdb_poster.jpg"
      telegram!\sendPhoto msg.chat.id,file_path
      os.remove file_path

    message = "[#{jdat.Title}](http://imdb.com/title/#{jdat.imdbID}) *#{jdat.Year} *
*#{jdat.imdbRating}* | *#{jdat.Runtime}* | *#{jdat.Genre}*

#{jdat.Director}

_#{jdat.Actors}_

*#{jdat.Awards}*

`#{jdat.Plot}`"

    if msg.chat.type == "inline"
      pic = "http://icons.iconarchive.com/icons/uiconstock/socialmedia/128/IMDb-icon.png"
      block = "[#{inline_article_block "#{jdat.Title}", "#{message}", "Markdown", true, "#{jdat.Plot}", "#{pic}"}]"
      telegram!\sendInline msg.id,block
      return
    return message
  return

run = (msg, matches) ->
  return imdb msg, matches[1]

return {
  description: "*IMDB for telegram !*"
  usage: "`/imdb [movie]` - Search on IMDB!\n"
  patterns: {
    "^[!/#]imdb (.+)"
    "^###inline[!/#]imdb (.+)"
  }
  :run
}
