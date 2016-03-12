run = (msg,matches) ->
  
  text = matches[1]
  
  url = "http://latex.codecogs.com/png.download?#{URL.escape text}"
  
  STICKER = download_to_file url,"stick.webp"
  
  telegram!\sendSticker msg.chat.id,STICKER
  
  os.remove STICKER

  return
 
 
return {
  description: "*Return sticker*"
  usage: "`/sticker [text]`\n"
  patterns: {
  "^[/!#]sticker (.*)"
  }
  :run
}
