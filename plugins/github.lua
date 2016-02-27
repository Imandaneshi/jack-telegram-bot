repo = (msg, git) ->
  git = git
  url = "https://api.github.com/repos/#{git}"
  response, code, headers = https.request url

  if code ~= 200
    return "Error: #{code}"

  if #response > 0
    jdat = JSON.decode response
    if jdat.Error
      return jdat.Error
    
    text = "[#{jdat.owner.login}](#{jdat.owner.html_url}) *|* [#{jdat.name}](#{jdat.html_url})

`#{jdat.description}`

*language:* `#{jdat.language}`
*forks:* `#{jdat.forks_count}`
*stars:* `#{jdat.stargazers_count}`
*issues:* `#{jdat.open_issues_count}`"
    return text
    

run = (msg, matches) ->
  if matches[1] == "gitrepo" and matches[2]
    return repo msg, matches[2]
 

return {
  description: "*github plugin !*"
  usage: "`/gitrepo [repo]`"
  patterns: {
    "^[/!#](gitrepo) (.*)$"
    }
    :run
  }
