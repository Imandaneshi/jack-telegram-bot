prefix = 'sp'
photo_download = true
id_spotify = true

id = (msg, matches) ->
	query = URL.escape matches
	url = "https://api.spotify.com/v1/tracks/#{query}"
	jstr, res, headers = https.request url

	if res ~= 200
		return
	jdat = JSON.decode jstr

	file_name = jdat.id
	duration = jdat.duration_ms
	time_song = math.floor duration / ( 10 ^ 3 )
	pic = jdat.album.images[2].url
	song_name = jdat.name
	artist = jdat.artists[1].name
	artist_link = jdat.artists[1].external_urls.spotify
	link = jdat.external_urls.spotify
	album = jdat.album.name
	album_link = jdat.album.external_urls.spotify
	tracknumber = jdat.track_number

	output = "["..song_name.."]("..link..") *-* ["..artist.."]("..artist_link..")\n"
	output ..= "*Duration:* "..time_song.."\n*Album:* "..album.."\n*Track number:* "..tracknumber

	telegram!\sendMessage msg.chat.id, output, msg.message_id, "Markdown"

	return

track = (msg, matches, music) ->
	query = URL.escape matches
	url = "https://api.spotify.com/v1/search?limit=1&type=track&q=#{query}"
	jstr, res, headers = https.request url

	if res ~= 200
		return "_NO tracks found_"
	jdat = JSON.decode jstr
	if jdat.tracks.total == 0
		return "_NO tracks found_"

	v = jdat.tracks.items[1]
	file_name = v.id
	duration = v.duration_ms
	time_song = math.floor(duration / ( 10 ^ 3 ))
	pic = v.album.images[2].url
	song_name = v.name
	artist = v.artists[1].name
	artist_link = v.artists[1].external_urls.spotify
	link = v.external_urls.spotify
	album = v.album.name
	album_link = v.album.external_urls.spotify
	tracknumber = v.track_number

	output = "["..artist.."]("..artist_link..") *-* ["..song_name.."]("..link..") \n"
	output ..= "*Duration:* "..time_song.."\n*Album:* "..album.."\n*Track number:* "..tracknumber

	if music
		file_music = download_to_file v.preview_url, prefix..file_name..".mp3"
		telegram!\sendAudio msg.chat.id, file_music, 30, artist, song_name
		return

	if msg.chat.type == "inline"
		block = "[#{inline_article_block "#{song_name} on Spotify !", "#{output}", "Markdown", true, "#{artist} - #{song_name}", "#{pic}"}]"
		telegram!\sendInline msg.id, block
		return

	if photo_download
		file_path = download_to_file pic, prefix..file_name..".jpg"
		telegram!\sendPhoto msg.chat.id, file_path
		os.remove file_path
	else
		if msg.chat.type ~= "private"
			telegram!\sendMessage msg.chat.id, "[​]("..pic..") "..output, msg.message_id, "Markdown"
			return
		else
			telegram!\sendMessage msg.chat.id, "[​]("..pic..") "..output, false, "Markdown"
			return

	return output

artist = (msg, matches) ->
	query = URL.escape matches
	url = "https://api.spotify.com/v1/search?limit=1&type=artist&q=#{query}"
	jstr, res, headers = https.request url

	if res ~= 200
		return "_NO artists found_"
	jdat = JSON.decode jstr
	if jdat.artists.total == 0
		return "_NO artists found_"

	v = jdat.artists.items[1]
	file_name = v.id
	follow = v.followers.total
	pic = v.images[2].url
	name = v.name
	popularity = v.popularity
	artist_link = v.external_urls.spotify

	output = "*Name:* ["..name.."]("..artist_link..")\n*Followers:* "..follow.." \n*Popularity:* "..popularity

	if msg.chat.type == "inline"
		block = "[#{inline_article_block "#{name} on Spotify !", "#{output}", "Markdown", true, "#{name} - Followers: #{follow}", "#{pic}"}]"
		telegram!\sendInline msg.id, block
		return

	if photo_download
		file_path = download_to_file pic, prefix..file_name..".jpg"
		telegram!\sendPhoto msg.chat.id, file_path
		os.remove file_path
	else
		if msg.chat.type ~= "private"
			telegram!\sendMessage msg.chat.id, "[​]("..pic..") "..output, msg.message_id, "Markdown"
			return
		else
			telegram!\sendMessage msg.chat.id, "[​]("..pic..") "..output, false, "Markdown"
			return

	return output

album = (msg, matches, id) ->
	unless id
		query = URL.escape matches
		url = "https://api.spotify.com/v1/search?limit=1&type=album&q=#{query}"
		jstr, res, headers = https.request url

		if res ~= 200
			return "_NO albums found_"
		jdat = JSON.decode jstr
		if jdat.albums.total == 0
			return "_NO albums found_"
		id = jdat.albums.items[1].id

	--Album
	query = URL.escape id
	url = "https://api.spotify.com/v1/albums/#{query}"
	jstr, res, headers = https.request url

	if res ~= 200
		return
	jdat = JSON.decode jstr

	file_name = jdat.id
	pic = jdat.images[2].url
	artists = '*Artists:* \n'
	unless jdat.artists[2]
		artists = '*Artist:* '
	for i,v in ipairs jdat.artists
		artists ..= jdat.artists[i].name..'\n'
	name = jdat.name
	url = jdat.external_urls.spotify
	date = jdat.release_date
	popularity = jdat.popularity
	tracks = '*Tracks:* \n'
	unless jdat.tracks.items[2]
		tracks = '*Track:* '
	for i,v in ipairs jdat.tracks.items
		tracks ..= '*'..i..'-* '..jdat.tracks.items[i].name..'\n'
	total = jdat.tracks.total

	output = "*Name:* ["..name.."]("..url..")\n*Date:* "..date.." \n*Popularity:* "..popularity..'\n'..artists
	if msg.chat.type ~= "private"
		output ..= '*Total Tracks:* '..total
	else
		output ..= '\n'..tracks

	if msg.chat.type == "inline"
		block = "[#{inline_article_block "#{name} on Spotify !", "#{output}", "Markdown", true, "#{name} - #{total} Tracks", "#{pic}"}]"
		telegram!\sendInline msg.id, block
		return

	if photo_download
		file_path = download_to_file pic, prefix..file_name..".jpg"
		telegram!\sendPhoto msg.chat.id, file_path
		os.remove file_path
	else
		if msg.chat.type ~= "private"
			telegram!\sendMessage msg.chat.id, "[​]("..pic..") "..output, msg.message_id, "Markdown"
			return
		else
			telegram!\sendMessage msg.chat.id, "[​]("..pic..") "..output, false, "Markdown"
			return

	return output

playlist = (msg, matches) ->
	query = URL.escape matches
	url = "https://api.spotify.com/v1/search?limit=1&type=playlist&q=#{query}"
	jstr, res, headers = https.request url

	if res ~= 200
		return "_NO playlists found_"
	jdat = JSON.decode jstr
	if jdat.playlists.total == 0
		return "_NO playlists found_"

	v = jdat.playlists.items[1]
	file_name = v.id
	pic = v.images[2].url
	name = v.name
	playlist_link = v.external_urls.spotify
	total = v.tracks.total

	output = "*Name:* ["..name.."]("..playlist_link..")\n*Total:* "..total

	if msg.chat.type == "inline"
		block = "[#{inline_article_block "#{name} on Spotify !", "#{output}", "Markdown", true, "#{name} - #{total} Tracks", "#{pic}"}]"
		telegram!\sendInline msg.id, block
		return

	if photo_download
		file_path = download_to_file pic, prefix..file_name..".jpg"
		telegram!\sendPhoto msg.chat.id, file_path
		os.remove file_path
	else
		if msg.chat.type ~= "private"
			telegram!\sendMessage msg.chat.id, "[​]("..pic..") "..output, msg.message_id, "Markdown"
			return
		else
			telegram!\sendMessage msg.chat.id, "[​]("..pic..") "..output, false, "Markdown"
			return

	return output

run = (msg, matches) ->
	if matches[1] == 'spotify' and matches[2] == 'track' and matches[3]
		return track msg, matches[3]
	elseif matches[1] == 'spotify' and matches[2] == 'get' and matches[3]
		return track msg, matches[3], true
	elseif matches[1] == 'spotify' and matches[2] == 'artist' and matches[3]
		return artist msg, matches[3]
	elseif matches[1] == 'spotify' and matches[2] == 'album' and matches[3]
		return album msg, matches[3]
	elseif matches[1] == 'spotify' and matches[2] == 'playlist' and matches[3]
		return playlist msg, matches[3]
	elseif matches[1] == "spotify"
		return "Use `/help spotify` to view the commands"
	elseif matches[1] == 'spotify:track:' and matches[2] and id_spotify
		return id msg, matches[2]
	elseif matches[1] == 'spotify:album:' and matches[2] and id_spotify
		return album msg, false, matches[2]

return {
	description: "*Spotify plugin !*"
	usage: [[
`/spotify get [track name(for search)]`
will send you preview of that song (only 30 sec)

`/spotify track [track name(for search)]`
`/spotify album [album name(for search)]`
`/spotify artist [artist name(for search)]`
`/spotify playlist [playlist name(for search)]`
Will send info and picture
]]
	patterns: {
		"^[!/#](spotify) (playlist) (.*)$"
		"^[!/#](spotify) (artist) (.*)$"
		"^[!/#](spotify) (track) (.*)$"
		"^[!/#](spotify) (album) (.*)$"
		"^[!/#](spotify) (get) (.*)$"
		"^[!/#](spotify)$"
		"^(spotify:track:)(.*)$"
		"^(spotify:album:)(.*)$"
		--Inline
		"^###inline[!/#](spotify) (playlist) (.*)$"
		"^###inline[!/#](spotify) (artist) (.*)$"
		"^###inline[!/#](spotify) (track) (.*)$"
		"^###inline[!/#](spotify) (album) (.*)$"
	}
	:run
}
