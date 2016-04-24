run = (msg,matches) ->
	uid = URL.escape matches[1]
	url = "https://api.instagram.com/v1/users/search?q=#{uid}&access_token=#{config!.insta_api_key}"
	jstr, res = https.request url
	if res ~= 200
		return "_No connection_"
	jdat = JSON.decode jstr
	id = ''
	for k, v in pairs jdat.data
		if v.username == uid\lower!
			id = v.id
	if id == ''
		random = math.random #{jdat.data}
		id = "#{jdat.data[random].id}"
	gurl = "https://api.instagram.com/v1/users/#{id}/?access_token=#{config!.insta_api_key}"
	jstr, res = https.request gurl
	if res ~= 200
		return "_No connection_"
	user = JSON.decode jstr
	text = "[#{user.data.username}](https://www.instagram.com/#{user.data.username})

`#{user.data.bio}`

*Name:* #{user.data.full_name}
*Media Count:* #{user.data.counts.media}
*Following:* #{user.data.counts.follows}
*Followers:* #{user.data.counts.followed_by}
[WebSite](#{user.data.website})"

	if msg.chat.type == "inline"
		pic = "http://icons.iconarchive.com/icons/uiconstock/socialmedia/128/Instagram-icon.png"
		block = "[#{inline_article_block "#{user.data.full_name}", "#{text}", "Markdown", true, "#{user.data.bio}", "#{pic}"}]"
		telegram!\sendInline msg.id,block
		return

	file_path = download_to_file user.data.profile_picture,"insta.jpg"
	telegram!\sendPhoto msg.chat.id,file_path
	os.remove file_path
	return text


return {
	description: "Search users on instagram"
	usage: "`/insta <username>` - Return user info\n"
	patterns: {
	"^[/!#]insta (.*)"
	"^[/!#]instagram (.*)"
	"^###inline[/!#]insta (.*)"
	"^###inline[/!#]instagram (.*)"
	}
	:run
}
