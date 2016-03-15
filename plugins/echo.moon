run = (msg,matches) ->
  matches[1] = matches[1]\gsub "[!/#]","" if matches[1]\match "^[!/#]"

  if msg.chat.type == "inline"
    pic = "http://icons.iconarchive.com/icons/icons8/windows-8/128/Security-Voice-Recognition-Scan-icon.png"
    markdown = "*bold text*    _italic text_\n[text](URL)    ```code block```"
    block = "[#{inline_article_block "Custom markdown", "#{matches[1]}", "Markdown", true, "#{markdown}", "#{pic}"}]"
    telegram!\sendInline msg.id,block
    return

  return matches[1]
patterns = {
  "^[#!/]echo (.*)"
  "^###inline[#!/]echo (.*)"--inline
}
description = "*Echo plugin !*"
usage = [[
`/echo <text>`
Will return text
_Markdown is enabled_
]]
return {
  :run
  :patterns
  :description
  :usage
}
