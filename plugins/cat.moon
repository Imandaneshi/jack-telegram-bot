run = (msg,matches) ->
    url = "http://thecatapi.com/api/images/get?format=src&type=jpg"

    if msg.chat.type == "inline"
        block = "[#{inline_photo_block "#{url}", "#{url}", "CAT"}]"
        telegram!\sendInline msg.id, block
        return

    file = download_to_file url,"cat.jpg"
    telegram!\sendPhoto msg.chat.id,file
    os.remove file

    return

return {
  description: "*Return a Cat*"
  usage: "`/cat` - Return a Cat\n"
  patterns: {
  "^[/!#]cat"
  "^###inline[/!#]cat"
  }
  :run
}
