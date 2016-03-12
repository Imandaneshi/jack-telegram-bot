run = (msg,matches) ->
  
  text = matches[1]
  
  url = "http://latex.codecogs.com/png.download?#{URL.escape text}"
  
  photo = download_to_file url,"stick.jpg"
  
  telegram!\sendPhoto msg.chat.id,photo
  
  os.remove photo

  return
 
 
return {
  description: "*Tex To PHOTO*"
  usage: "`/tophoto [text]`\n"
  patterns: {
  "^[/!#]tophoto (.*)"
  }
  :run
}
