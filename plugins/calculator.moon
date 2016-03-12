mathjs = (exp) ->
    url = "http://api.mathjs.org/v1/?expr=#{URL.escape exp}"
    b,c = http.request url
    if c ~= 200
      return "Error"
    if c == 200
      text = "*Result:* `#{b}`"

      return text

run = (msg,matches) ->
    calc = matches[1]

    if msg.chat.type == "inline"
      block = "[#{inline_article_block "Result", mathjs("#{calc}"), "Markdown", true}]"
      telegram!\sendInline msg.id,block
      return

    return mathjs "#{calc}"


return {
  description: "*Calculator !*"
  usage: "`/calc [expression]`\n"
  patterns: {
  "^[!/#]calc (.*)"
  "###inline[!/#]calc (.*)"
  }
  :run
}
