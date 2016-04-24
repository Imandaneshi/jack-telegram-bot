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

*Language:* `#{jdat.language}`
*Forks:* `#{jdat.forks_count}`
*Stars:* `#{jdat.stargazers_count}`
*Issues:* `#{jdat.open_issues_count}`"

    text ..= "
*Created at:* `#{jdat.created_at\match '(%d+%-%d+%-%d+)'}`
*Last updated:* `#{jdat.pushed_at\match '(%d+%-%d+%-%d+)'}`
*Git clone:* `#{jdat.ssh_url}`
" if msg.chat.type == "private"

    if msg.chat.type == "inline"
      pic = "http://icons.iconarchive.com/icons/icons8/windows-8/128/Programming-Github-icon.png"
      block = "[#{inline_article_block "#{jdat.name} on Github !", "#{text}", "Markdown", true, "#{jdat.description}", "#{pic}"}]"
      telegram!\sendInline msg.id,block
      return

    return text


run = (msg, matches) ->
  if matches[1] == "gitrepo" and matches[2]
    return repo msg, matches[2]
  elseif matches[1] == "gituser" and matches[2]
    url = "https://api.github.com/users/#{matches[2]}"
    jstr, res = https.request url
    jdat = JSON.decode jstr
    text = "#{jdat.name}
Followers: #{jdat.followers}
Following: #{jdat.following}
Repos: #{jdat.public_repos}\n"
    text ..= "Blog: #{jdat.blog}\n" if jdat.blog and type(jdat.blog) ~= "userdata"
    text ..= "Location: #{jdat.location}\n" if jdat.location and type(jdat.location) ~= "userdata"
    text ..= "Email: #{jdat.email}\n" if jdat.email and type(jdat.email) ~= "userdata"
    text ..= "GitPage: #{jdat.html_url}\n"
    file = jdat.avatar_url

    if msg.chat.type == "inline"
      pic = "http://icons.iconarchive.com/icons/icons8/windows-8/128/Programming-Github-icon.png"
      block = "[#{inline_article_block "#{jdat.name} on Github !", "#{text}", "Markdown", true, "Repos: #{jdat.public_repos} - Followers: #{jdat.followers}", "#{pic}"}]"
      telegram!\sendInline msg.id,block
      return

    file_path = download_to_file file,"av.jpg"
    telegram!\sendPhoto msg.chat.id,file_path,text
    os.remove file_path
    return

return {
  description: "*github plugin !*"
  usage: [[
`/gitrepo [repo]` - Return about the repo
`/gituser [user]` - Return about the user
]]
  patterns: {
    "^[/!#](gitrepo) (.*)$"
    "^[/!#](gituser) (.*)$"
    -- inline
    "^###inline[/!#](gitrepo) (.*)$"
    "^###inline[/!#](gituser) (.*)$"
    }
    :run
  }
