instagrm = (msg,q) ->
  url = "https://api.instagram.com/v1/users/search?q=#{q}&access_token=#{config!.insta_api_key}"
  jstr, res = https.request url
  jdat = JSON.decode jstr
  random = math.random #{jdat.data}
  id = "#{jdat.data[random].id}"
  gurl = "https://api.instagram.com/v1/users/#{id}/?access_token=#{config!.insta_api_key}"
  jstr, res = https.request gurl
  user = JSON.decode jstr
  text = "[#{user.data.username}](https://www.instagram.com/#{user.data.username})

`#{user.data.bio}`

*Name:* #{user.data.full_name}
*Media Count:* #{user.data.counts.media}
*Following:* #{user.data.counts.follows}
*Followers:* #{user.data.counts.followed_by}
[WebSite](#{user.data.website})"


  file_path = download_to_file user.data.profile_picture,"insta.jpg"
  telegram!\sendPhoto msg.chat.id,file_path
  os.remove file_path
  return text


run = (msg,matches) ->
  if matches[1] == "insta" and matches[2]
      return instagrm msg,matches[2]


return {
  description: "Search users on instagram"
  usage: "`/insta <username>` - Return user info\n"
  patterns: {
  "^[/!#](insta) (.*)"
  }
  :run
}
