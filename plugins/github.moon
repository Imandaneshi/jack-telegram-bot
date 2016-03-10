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
  elseif matches[1] == "gituser" and matches[2]
    url = "https://api.github.com/users/#{matches[2]}"
    jstr, res = https.request url
    jdat = JSON.decode jstr
    text = "#{jdat.name}
followers: #{jdat.followers}
following: #{jdat.following}
repos: #{jdat.public_repos}
blog: #{jdat.blog}
location: #{jdat.location}  
email: #{jdat.email} 
GitPage: #{jdat.html_url}"
    file = jdat.avatar_url
    file_path = download_to_file file,"av.jpg"
    telegram!\sendPhoto msg.chat.id,file_path,text
    os.remove file_path
    return

return {
  description: "*github plugin !*"
  usage: "`/gitrepo [repo]`
`/gituser [user]`"
  
  patterns: {
    "^[/!#](gitrepo) (.*)$"
    "^[/!#](gituser) (.*)$"
    }
    :run
  }
