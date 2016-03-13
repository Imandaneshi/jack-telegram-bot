run = (msg,matches) ->

  text = matches[1]

  url = "http://tts.baidu.com/text2audio?lan=en&ie=UTF-8&text=#{URL.escape text}"

  VOICE = download_to_file url,"vc.ogg"

  telegram!\sendVoice msg.chat.id,VOICE

  os.remove VOICE

  return


return {
  description: "*Return voice*"
  usage: "`/tts [text]` - Return a voice with your text\n"
  patterns: {
  "^[/!#]tts (.*)"
  "^[/!#]v (.*)"
  "^[/!#]voice (.*)"
  }
  :run
}
