donwload = true
mb = "50m"
total = "1"

youtube = (msg, matches, dl) ->
	query = URL.escape matches
	url = "https://www.googleapis.com/youtube/v3/search?key=#{config!.google_api_key}&type=video&part=snippet&maxResults=#{total}&q=#{query}"
	jstr, res, headers = https.request url

	if res ~= 200
		return
	jdat = JSON.decode jstr

	if jdat.pageInfo.totalResults == 0
		return "_NO video found_"

	i = math.random(jdat.pageInfo.resultsPerPage)
	title = jdat.items[i].snippet.title
	title = string.gsub(title, '%(.+%)', '')
	id = jdat.items[i].id.videoId
	by = jdat.items[i].snippet.channelTitle
	pic = jdat.items[i].snippet.thumbnails.high.url
	url = "https://www.youtube.com/watch?v=#{id}"
	text = "Youtube: #{title}\n#{url}"

	if dl and donwload
		cmd = io.popen("youtube-dl -o '.tmp/%(id)s.%(ext)s' #{id} -f 'bestvideo[filesize<#{mb}]' --print-json")\read('*all')
		if string.match(cmd, 'not found$')
			print("Plugin Youtube: Requirement donwload youtube-dl")
			print("https://github.com/rg3/youtube-dl#installation")
			return
		if string.match(cmd, '(.*)*ERROR:(.*)*$')
			return "_NO video found_"

		jdat = JSON.decode cmd
		telegram!\sendVideo msg.chat.id, jdat._filename, jdat.duration, "Youtube: #{title} by #{by}", msg.message_id
		os.remove jdat._filename
		return

	unless dl
		if msg.chat.type == "inline"
			block = "[#{inline_article_block "#{title} on Youtube !", "*Youtube:* [#{title}](#{url})", "Markdown", true}]"
			telegram!\sendInline msg.id, block
			return

		file_path = download_to_file pic, "#{id}.jpg"
		telegram!\sendPhoto msg.chat.id, file_path, text
		os.remove file_path
		return
	return

run = (msg, matches) ->
	if matches[1] == "youtube" and matches[2] == "dl" and matches[3]
		return youtube msg, matches[3], true
	elseif matches[1] == "youtube" and matches[2] == "get" and matches[3]
		return youtube msg, matches[3], false

return {
	description: "*Search on Youtube*"
	usage: [[
	`/youtube get [video name(for search)]`
	Search video on Youtube
	`/youtube dl [video name(for download)]`
	Donwload of video
	]]
	patterns: {
		"^[!/#](youtube) (get) (.*)$"
		"^[!/#](youtube) (dl) (.*)$"
		"^###inline[!/#](youtube) (get) (.*)$"
	}
	:run
}
