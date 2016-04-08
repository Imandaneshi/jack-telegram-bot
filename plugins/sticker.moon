run = (msg,matches) ->

  text = matches[2]
  size = matches[1]

  url = "http://latex.codecogs.com/png.download?".."\\dpi{"..size.."}%20\\LARGE%20#{URL.escape text}"

  STICKER = download_to_file url,"stick.webp"

  telegram!\sendSticker msg.chat.id,STICKER

  os.remove STICKER

  return


return {
  description: "*Return sticker*"
  usage: "`/sticker [text]` - Return a sticker with your text\n"
  patterns: {
  "^[/!#]sticker (.*) (.*)"
  }
  :run
}
