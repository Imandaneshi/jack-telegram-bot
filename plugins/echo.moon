run = (msg,matches) ->
  matches[1] = matches[1]\gsub "[!/#]","" if matches[1]\match "^[ !/#]"

  if msg.chat.type == "inline"
    pic = "http://icons.iconarchive.com/icons/icons8/windows-8/128/Security-Voice-Recognition-Scan-icon.png"
    markdown_help = "*bold text*    _italic text_\n[text](URL)    ```code block```"
    html_help = "<b>bold text</b>    <i>italic text</i>\n<a href=\'\'URL\'\'>text</a>\n<pre>pre>code block</pre>"
    no_help = "without formatting..."
    block = "[#{inline_article_block "Custom Markdown", "#{matches[1]}", "Markdown", true, markdown_help, "#{pic}"}, "
    block ..= "#{inline_article_block "Custom HTML", "#{matches[1]}", "HTML", true, html_help, "#{pic}"}, "
    block ..= "#{inline_article_block "Without Formatting", "#{matches[1]}", false, true, no_help, "#{pic}"}]"
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
