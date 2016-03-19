run = (msg, matches) ->
   to = matches[3]\upper()
   amount = matches[1]\upper()
   result = 1
   frm = matches[2]\upper()
   url = "https://www.google.com/finance/converter"

   if frm ~= to

    url ..= "?from=#{frm}&to=#{to}&a=#{amount}"
    str, res = https.request url
    if res ~= 200
      return

    str = str\match "<span class=bld>(.*) %u+</span>"

    unless str
      return "_No results_"

    result = str\format "%.2f"
    message = "*#{amount}* _#{frm}_ = *#{result}* _#{to}_"

    if msg.chat.type == "inline"
      pic = "http://icons.iconarchive.com/icons/custom-icon-design/flatastic-11/128/Cash-icon.png"
      block = "[#{inline_article_block "Currency rate converter", "#{message}", "Markdown", true, "#{result} #{to}", "#{pic}"}]"
      telegram!\sendInline msg.id,block
      return

    return message

return {
  description: "*Currency rate converter*"
  usage: "`/cash [amount] [from] to [to]`
Returns exchange rates for various currencies.\n"
  patterns: {
  "^[/!]cash (%d+) ([^%s]+) to ([^%s]+)"
  "^###inline[/!]cash (%d+) ([^%s]+) to ([^%s]+)"
  }
  :run
}
