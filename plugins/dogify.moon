run = (msg,matches) ->

  text = string.gsub matches[1], " ", "%%20"
  url = "http://dogr.io/#{text}.png?split=false&.png"
  file_path = download_to_file url,"dog.png"
  telegram!\sendPhoto msg.chat.id,file_path
  os.remove file_path
  return



return {
  description: "*Create a doge image with you words*"
  usage: "`/dogify (your/words/with/slashes) [words]` - Create a doge image with you words\n"
  patterns: {
  "^[/!#]dogify (.*)"
  "^[/!#]dog (.*)"
  }
  :run
}
