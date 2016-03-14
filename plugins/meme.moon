run = (msg,matches) ->
  meme = matches[1]
  top = matches[2]
  bot = matches[3]
  url = "http://apimeme.com/meme?meme=#{URL.escape meme}&top=#{URL.escape top}&bottom=#{URL.escape bot}"
  file_path = download_to_file url, "meme.jpg"
  telegram!\sendPhoto msg.chat.id,file_path
  os.remove file_path
  return

return {
  description: "*Generate a meme image with up and bottom texts.*"
  usage: [[
`/meme [name] "[text top]" "[text buttom]"`
Generate a meme image
Example:
/meme _Derb "Love" "JackBot"_
]]
    patterns: {
    '^[!/#]meme (.+) "(.+)" "(.+)"$'
    }
    :run
  }
