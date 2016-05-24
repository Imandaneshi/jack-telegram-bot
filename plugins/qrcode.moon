run = (msg,matches) ->
  url = "https://api.qrserver.com/v1/create-qr-code/?size=500x500&data=#{URL.escape matches[1]}"
  caption = matches[1]
  file_path = download_to_file url,"qrcode.jpg"

  telegram!\sendPhoto msg.chat.id,file_path,caption
  os.remove file_path
  return

return {
  description: "*QR code plugin for telegram, given a text it returns the qr code*"
  usage: "`/qr [text]` - Generates a QR code\n"
  patterns: {
  "^[/!#]qr (.*)"
  }
  :run
}
