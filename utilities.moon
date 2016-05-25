redis = require "redis"
API_URL = "https://api.telegram.org/bot#{config!.telegram_api_key}"--Telegram Bot Api
export Redis = class Redis--Redis configuration
  new: =>
    params =
      host: os.getenv('REDIS_HOST') or '127.0.0.1'
      port: tonumber(os.getenv('REDIS_PORT') or 6379)
      database: os.getenv('REDIS_DB')
      password: os.getenv('REDIS_PASSWORD')
    @client = redis.connect params
    @client\auth params.password if params.password

export telegram = class telegram--Telegram api methods
  sendRequest: (url) =>
    data, res = https.request url

    if res ~= 200
      return false, res

    jdata = JSON.decode data
    unless jdata.ok
      return false, jdat.description

    return jdata

  curl: (data) =>--You should have curl installed
    req = io.popen(data)\read '*all'
    jdata = JSON.decode req

    unless jdata.ok
      return false,jdata.description

    return jdata


--https://core.telegram.org/bots/api#getme
  getMe: =>
    url = "#{API_URL}/getMe"
    return telegram!\sendRequest url

--https://core.telegram.org/bots/api#sendmessage
  sendMessage: (chat_id, text, reply_to_message_id, parse_mode, disable_web_page_preview, disable_notification, reply_markup) =>
    url = "#{API_URL}/sendMessage"
    url ..= "?chat_id=#{chat_id}&text=#{URL.escape text}"
    url ..= "&reply_to_message_id=#{reply_to_message_id}" if reply_to_message_id
    url ..= "&parse_mode=#{parse_mode}" if parse_mode
    url ..= "&disable_web_page_preview=#{disable_web_page_preview}" if disable_web_page_preview
    url ..= "&disable_notification=#{disable_notification}" if disable_notification
    url ..= "&reply_markup=#{URL.escape reply_markup}" if reply_markup
    return telegram!\sendRequest url

--https://core.telegram.org/bots/api#getupdates
  getUpdates: (offset) =>
    url = "#{API_URL}/getUpdates?timeout=20"
    url ..= "&offset=#{offset}" if offset
    return telegram!\sendRequest url

--https://core.telegram.org/bots/api#forwardmessage
  forwardMessage: (chat_id,from_chat_id,message_id,disable_notification) =>
    url = "#{API_URL}/forwardMessage"
    url ..= "?chat_id=#{chat_id}&from_chat_id=#{from_chat_id}&message_id=#{message_id}"
    url ..= "&disable_notification=#{disable_notification}" if disable_notification
    return telegram!\sendRequest url

--https://core.telegram.org/bots/api#sendphoto
  sendPhoto: (chat_id,photo,caption,reply_to_message_id,disable_notification,reply_markup) =>
    url = "#{API_URL}/sendPhoto"
    command = "curl #{url}?chat_id=#{chat_id} -F \"photo=@#{photo}\""
    command ..= " -F \"caption=#{caption}\"" if caption
    command ..= " -F \"reply_to_message_id=#{reply_to_message_id}\"" if reply_to_message_id
    command ..= " -F \"disable_notification=#{disable_notification}\"" if disable_notification
    return telegram!\curl command

--https://core.telegram.org/bots/api#sendaudio
  sendAudio: (chat_id,audio,duration,performer,title,reply_to_message_id,disable_notification) =>
    url = "#{API_URL}/sendAudio"
    command = "curl #{url}?chat_id=#{chat_id} -F \"audio=@#{audio}\""
    command ..= " -F \"duration=#{duration}\"" if duration
    command ..= " -F \"performer=#{performer}\"" if performer
    command ..= " -F \"title=#{title}\"" if title
    command ..= " -F \"reply_to_message_id=#{reply_to_message_id}\"" if reply_to_message_id
    command ..= " -F \"disable_notification=#{disable_notification}\"" if disable_notification
    return telegram!\curl command

  --https://core.telegram.org/bots/api#senddocument
  --Bots can currently send files of any type of up to 50 MB in size
  sendDocument: (chat_id,document,reply_to_message_id,disable_notification) =>
    url = "#{API_URL}/sendDocument"
    command = "curl #{url}?chat_id=#{chat_id} -F \"document=@#{document}\""
    command ..= " -F \"reply_to_message_id=#{reply_to_message_id}\"" if reply_to_message_id
    command ..= " -F \"disable_notification=#{disable_notification}\"" if disable_notification
    return telegram!\curl command

  --https://core.telegram.org/bots/api#sendsticker
  sendSticker: (chat_id,sticker,reply_to_message_id,disable_notification) =>
    url = "#{API_URL}/sendSticker"
    command = "curl #{url}?chat_id=#{chat_id} -F \"sticker=@#{sticker}\""
    command ..= " -F \"reply_to_message_id=#{reply_to_message_id}\"" if reply_to_message_id
    command ..= " -F \"disable_notification=#{disable_notification}\"" if disable_notification
    return telegram!\curl command

  --https://core.telegram.org/bots/api#sendvideo
  sendVideo: (chat_id,video,duration,caption,reply_to_message_id,disable_notification) =>
    url = "#{API_URL}/sendVideo"
    command = "curl #{url}?chat_id=#{chat_id} -F \"video=@#{video}\""
    command ..= " -F \"duration=#{duration}\"" if duration
    command ..= " -F \"caption=#{caption}\"" if caption
    command ..= " -F \"reply_to_message_id=#{reply_to_message_id}\"" if reply_to_message_id
    command ..= " -F \"disable_notification=#{disable_notification}\"" if disable_notification
    return telegram!\curl command

  --https://core.telegram.org/bots/api#sendvoice
  sendVoice: (chat_id,voice,duration,reply_to_message_id,disable_notification) =>
    url = "#{API_URL}/sendVoice"
    command = "curl #{url}?chat_id=#{chat_id} -F \"voice=@#{voice}\""
    command ..= " -F \"duration=#{duration}\"" if duration
    command ..= " -F \"reply_to_message_id=#{reply_to_message_id}\"" if reply_to_message_id
    command ..= " -F \"disable_notification=#{disable_notification}\"" if disable_notification
    return telegram!\curl command

  --https://core.telegram.org/bots/api#sendlocation
  sendLocation: (chat_id,latitude,longitude,reply_to_message_id,disable_notification) =>
    url = "#{API_URL}/sendLocation"
    if latitude == "0" and longitude == "0"
       return false
    url ..= "?chat_id=#{chat_id}&latitude=#{latitude}&longitude=#{longitude}"
    url ..= "&reply_to_message_id=#{reply_to_message_id}" if reply_to_message_id
    url ..= "&disable_notification=#{disable_notification}" if disable_notification
    return telegram!\sendRequest url

--https://core.telegram.org/bots/api#sendvenue
  sendVenue: (chat_id,latitude,longitude,title,address,foursquare_id,reply_to_message_id,disable_notification) =>
    url = "#{API_URL}/sendVenue"
    if latitude == "0" and longitude == "0"
      return false
    url ..= "?chat_id=#{chat_id}&latitude=#{latitude}&longitude=#{longitude}&title=#{title}&address=#{address}"
    url ..= "&foursquare_id=#{foursquare_id}" if foursquare_id
    url ..= "&reply_to_message_id=#{reply_to_message_id}" if reply_to_message_id
    url ..= "&disable_notification=#{disable_notification}" if disable_notification
    return telegram!\sendRequest url

--https://core.telegram.org/bots/api#sendcontact
  sendContact: (chat_id,phone_number,first_name,last_name,reply_to_message_id,disable_notification) =>
    url = "#{API_URL}/sendContact"
    url ..= "?chat_id=#{chat_id}&phone_number=#{phone_number}&first_name=#{first_name}"
    url ..= "&last_name=#{last_name}" if last_name
    url ..= "&reply_to_message_id=#{reply_to_message_id}" if reply_to_message_id
    url ..= "&disable_notification=#{disable_notification}" if disable_notification
    return telegram!\sendRequest url

  --https://core.telegram.org/bots/api#sendchataction
  sendChatAction: (chat_id,action) =>
    url = "#{API_URL}/sendChatAction"
    url ..= "?chat_id=#{chat_id}&action=#{action}"
    return telegram!\sendRequest url

  --https://core.telegram.org/bots/api#inlinequeryresultarticle
  sendInline: (inline_id, result) =>
    url = "#{API_URL}/answerInlineQuery"
    url ..= "?inline_query_id=#{inline_id}&results=#{URL.escape result}&is_personal=true&cache_time=1"
    return telegram!\sendRequest url

  --https://core.telegram.org/bots/api#getfile
  getFile: (file_id) =>
    url = "#{API_URL}/getFile"
    url ..= "?file_id=#{file_id}"
    return telegram!\sendRequest url

  --https://core.telegram.org/bots/api#getuserprofilephotos
  getUserProfilePhotos: (user_id,limit) =>
    url = "#{API_URL}/getUserProfilePhotos"
    url ..= "?user_id=#{user_id}"
    url ..= "&limit=#{limit}" if limit
    return telegram!\sendRequest url

--https://core.telegram.org/bots/api#kickchatmember *Correct is ban*
  banChatMember: (chat_id,user_id) =>
    url = "#{API_URL}/kickChatMember"
    url ..= "?chat_id=#{chat_id}&user_id=#{user_id}"
    return telegram!\sendRequest url

  --https://core.telegram.org/bots/api#unbanchatmember
  unbanChatMember: (chat_id,user_id) =>
    url = "#{API_URL}/unbanChatMember"
    url ..= "?chat_id=#{chat_id}&user_id=#{user_id}"
    return telegram!\sendRequest url

  --Kick Member ...
  kickChatMember: (chat_id,user_id) =>
    res = telegram!\banChatMember chat_id,user_id
    unless res
      return false
    res = telegram!\unbanChatMember chat_id,user_id
    unless res
      return false
    return true

  --https://core.telegram.org/bots/api#editmessagetext
  editMessageText: (chat_id,message_id,text,disable_web_page_preview,parse_mode,reply_markup) =>
    url =  "#{API_URL}/editMessageText"
    url ..= "?chat_id=#{chat_id}&message_id=#{message_id}" if chat_id ~= "callback_inline"
    url ..= "?inline_message_id=#{message_id}" if chat_id == "callback_inline"
    url ..= "&text=#{URL.escape text}"
    url ..= "&parse_mode=#{parse_mode}" if parse_mode
    url ..= "&disable_web_page_preview=#{disable_web_page_preview}" if disable_web_page_preview
    url ..= "&reply_markup=#{URL.escape reply_markup}" if reply_markup
    return telegram!\sendRequest url

  --https://core.telegram.org/bots/api#editmessagecaption
  editMessageCaption: (chat_id,message_id,caption) =>
    url =  "#{API_URL}/editMessageCaption"
    url ..= "?chat_id=#{chat_id}&message_id=#{message_id}" if chat_id ~= "callback_inline"
    url ..= "?inline_message_id=#{message_id}" if chat_id == "callback_inline"
    url ..= "&caption=#{URL.escape caption}"
    return telegram!\sendRequest url

  --https://core.telegram.org/bots/api#answercallbackquery
  answerCallbackQuery: (callback_query_id, text, show_alert) =>
    url = "#{API_URL}/answerCallbackQuery?callback_query_id=#{callback_query_id}&text=#{URL.escape text}"
    url ..= "&show_alert=#{show_alert}" if show_alert
    return telegram!\sendRequest url

  --https://core.telegram.org/bots/api#getchat
  getChat: (chat_id,action) =>
    url = "#{API_URL}/getChat"
    url ..= "?chat_id=#{chat_id}"
    return telegram!\sendRequest url

  --https://core.telegram.org/bots/api#getchatadministrators
  getChatAdministrators: (chat_id) =>
    url = "#{API_URL}/getChatAdministrators"
    url ..= "?chat_id=#{chat_id}"
    return telegram!\sendRequest url

  --https://core.telegram.org/bots/api#getchatmemberscount
  getChatMembersCount: (chat_id) =>
    url = "#{API_URL}/getChatMembersCount"
    url ..= "?chat_id=#{chat_id}"
    return telegram!\sendRequest url

  --https://core.telegram.org/bots/api#getchatmember
  getChatMember: (chat_id,user_id) =>
    url = "#{API_URL}/getChatMember"
    url ..= "?chat_id=#{chat_id}"
    url ..= "&user_id=#{user_id}"
    return telegram!\sendRequest url

  --https://core.telegram.org/bots/api#leavechat
  leaveChat: (chat_id) =>
    url = "#{API_URL}/leaveChat"
    url ..= "?chat_id=#{chat_id}"
    return telegram!\sendRequest url

--Returns users full info as string
-- first_name last_name username [id]
export user_info = (user) ->
  text = user.first_name
  text ..= " #{user.last_name}" if user.last_name
  text ..= " @#{user.username}" if user.username
  text ..= " [#{user.id}]"
  return text

--Checks if user is admin or not
export is_admin = (msg) ->
  var = false
  for v,admin in pairs config!.admins
    if admin == msg.from.id
      var = true

  return var

-- Reply markup
export ReplyKeyboardMarkup = (keyboard, resize_keyboard, one_time_keyboard,	selective) ->
  unless keyboard
    print "keyboard not specified"
    return nil
  if #keyboard < 1
    print "keyboard is empty"
    return nil
  res = {}
  res.keyboard = {keyboard}
  res.resize_keyboard = resize_keyboard or false
  res.one_time_keyboard = one_time_keyboard or true
  res.selective = selective or true
  return JSON.encode(res)

export InlineKeyboardMarkup = (buttons) ->
  res = {}
  res.inline_keyboard = buttons
  return JSON.encode(res)

export ForceReply = (selective) ->
  res = {}
  res.force_reply = true
  res.selective = selective or false
  return JSON.encode(res)

export ReplyKeyboardHide = (selective) ->
  res = {}
  res.force_reply = true
  res.selective = selective or false
  return JSON.encode(res)

-- Inline Block
export inline_article_block = (title, text, parse_mode, disable_web_page_preview, description, thumb_url, reply_markup) ->
  ran = math.random 1 ,100
  inline = "{\"type\":\"article\", \"id\":\"#{ran}\", \"title\":\"#{title}\", \"message_text\": \"#{text}\""
  inline ..= ",\"parse_mode\": \"#{parse_mode}\"" if parse_mode
  inline ..= ",\"disable_web_page_preview\": #{disable_web_page_preview}" if disable_web_page_preview
  inline ..= ",\"description\": \"#{description}\"" if description
  inline ..= ",\"thumb_url\": \"#{thumb_url}\"" if thumb_url
  inline ..= ",\"reply_markup\": #{reply_markup}" if reply_markup
  inline ..= "}"
  return inline

export inline_photo_block = (photo_url, thumb_url, title, description, caption, message_text, parse_mode, disable_web_page_preview, reply_markup) ->
  ran = math.random 1 ,100
  inline = "{\"type\":\"photo\", \"id\":\"#{ran}\", \"photo_url\":\"#{photo_url}\""
  inline ..= ",\"thumb_url\": \"#{thumb_url}\"" if thumb_url
  inline ..= ",\"title\": \"#{title}\"" if title
  inline ..= ",\"description\": \"#{description}\"" if description
  inline ..= ",\"caption\": #{caption}" if caption
  inline ..= ",\"message_text\": \"#{message_text}\"" if message_text
  inline ..= ",\"parse_mode\": \"#{parse_mode}\"" if parse_mode
  inline ..= ",\"disable_web_page_preview\": #{disable_web_page_preview}" if disable_web_page_preview
  inline ..= ",\"reply_markup\": #{reply_markup}" if reply_markup
  inline ..= "}"
  return inline

export inline_gif_block = (gif_url, thumb_url, title, caption, message_text, parse_mode, disable_web_page_preview, reply_markup) ->
  ran = math.random 1 ,100
  inline = "{\"type\":\"gif\", \"id\":\"#{ran}\", \"gif_url\":\"#{gif_url}\""
  inline ..= ",\"thumb_url\": \"#{thumb_url}\"" if thumb_url
  inline ..= ",\"title\": \"#{title}\"" if title
  inline ..= ",\"caption\": #{caption}" if caption
  inline ..= ",\"message_text\": \"#{message_text}\"" if message_text
  inline ..= ",\"parse_mode\": \"#{parse_mode}\"" if parse_mode
  inline ..= ",\"disable_web_page_preview\": #{disable_web_page_preview}" if disable_web_page_preview
  inline ..= ",\"reply_markup\": #{reply_markup}" if reply_markup
  inline ..= "}"
  return inline

export inline_mpeg4_block = (mpeg4_url, thumb_url, title, caption, message_text, parse_mode, disable_web_page_preview, reply_markup) ->
  ran = math.random 1 ,100
  inline = "{\"type\":\"mpeg4_gif\", \"id\":\"#{ran}\", \"mpeg4_url\":\"#{mpeg4_url}\""
  inline ..= ",\"thumb_url\": \"#{thumb_url}\"" if thumb_url
  inline ..= ",\"title\": \"#{title}\"" if title
  inline ..= ",\"caption\": #{caption}" if caption
  inline ..= ",\"message_text\": \"#{message_text}\"" if message_text
  inline ..= ",\"parse_mode\": \"#{parse_mode}\"" if parse_mode
  inline ..= ",\"disable_web_page_preview\": #{disable_web_page_preview}" if disable_web_page_preview
  inline ..= ",\"reply_markup\": #{reply_markup}" if reply_markup
  inline ..= "}"
  return inline

export inline_video_block = (video_url, mime_type, thumb_url, title, caption, message_text, parse_mode, disable_web_page_preview, reply_markup) ->
  ran = math.random 1 ,100
  inline = "{\"type\":\"video\", \"id\":\"#{ran}\", \"video_url\":\"#{video_url}\", \"mime_type\": \"#{mime_type}\""
  inline ..= ",\"thumb_url\": \"#{thumb_url}\"" if thumb_url
  inline ..= ",\"title\": \"#{title}\"" if title
  inline ..= ",\"caption\": #{caption}" if caption
  inline ..= ",\"message_text\": \"#{message_text}\"" if message_text
  inline ..= ",\"parse_mode\": \"#{parse_mode}\"" if parse_mode
  inline ..= ",\"disable_web_page_preview\": #{disable_web_page_preview}" if disable_web_page_preview
  inline ..= ",\"reply_markup\": #{reply_markup}" if reply_markup
  inline ..= "}"
  return inline

export inline_audio_block = (audio_url, title, performer, audio_duration, reply_markup) ->
  ran = math.random 1 ,100
  inline = "{\"type\":\"audio\", \"id\":\"#{ran}\", \"audio_url\":\"#{audio_url}\", \"mime_type\": \"#{mime_type}\""
  inline ..= ",\"title\": \"#{title}\""
  inline ..= ",\"performer\": #{performer}" if performer
  inline ..= ",\"audio_duration\": \"#{audio_duration}\"" if audio_duration
  inline ..= ",\"reply_markup\": #{reply_markup}" if reply_markup
  inline ..= "}"
  return inline

export inline_voice_block = (voice_url, title, performer, voice_duration, reply_markup) ->
  ran = math.random 1 ,100
  inline = "{\"type\":\"voice\", \"id\":\"#{ran}\", \"voice_url\":\"#{voice_url}\", \"mime_type\": \"#{mime_type}\""
  inline ..= ",\"title\": \"#{title}\"" if title
  inline ..= ",\"voice_duration\": \"#{audio_duration}\"" if voice_duration
  inline ..= ",\"reply_markup\": #{reply_markup}" if reply_markup
  inline ..= "}"
  return inline

export inline_document_block = (document_url, title, caption, mime_type, description, disable_web_page_preview, reply_markup) ->
  ran = math.random 1 ,100
  inline = "{\"type\":\"document\", \"id\":\"#{ran}\""
  inline ..= ",\"title\": \"#{title}\"" if title
  inline ..= ",\"caption\": #{caption}" if caption
  inline ..= ",\"document_url\": \"#{document_url}\""
  inline ..= ",\"message_text\": \"#{mime_type}\"" if mime_type
  inline ..= ",\"parse_mode\": \"#{description}\"" if description
  inline ..= ",\"thumb_url\": #{thumb_url}" if thumb_url
  inline ..= ",\"reply_markup\": #{reply_markup}" if reply_markup
  inline ..= "}"
  return inline

export inline_location_block = (latitude, longitude, title, thumb_url, reply_markup) ->
  ran = math.random 1 ,100
  inline = "{\"type\":\"location\", \"id\":\"#{ran}\", \"latitude\": \"#{latitude}\", \"longitude\": \"#{longitude}\""
  inline ..= ",\"title\": #{title}" if title
  inline ..= ",\"thumb_url\": #{thumb_url}" if thumb_url
  inline ..= ",\"reply_markup\": #{reply_markup}" if reply_markup
  inline ..= "}"
  return inline

export inline_venue_block = (latitude, longitude, title, address, foursquare_id, thumb_url, reply_markup) ->
  ran = math.random 1 ,100
  inline = "{\"type\":\"venue\", \"id\":\"#{ran}\", \"latitude\": \"#{latitude}\", \"longitude\": \"#{longitude}\""
  inline ..= ",\"title\": #{title}" if title
  inline ..= ",\"address\": \"#{address}\"" if address
  inline ..= ",\"foursquare_id\": \"#{foursquare_id}\"" if foursquare_id
  inline ..= ",\"thumb_url\": #{thumb_url}" if thumb_url
  inline ..= ",\"reply_markup\": #{reply_markup}" if reply_markup
  inline ..= "}"
  return inline

export inline_contact_block = (phone_number, first_name, last_name, thumb_url, reply_markup) ->
  ran = math.random 1 ,100
  inline = "{\"type\":\"contact\", \"id\":\"#{ran}\", \"phone_number\": \"#{phone_number}\", \"first_name\": \"#{first_name}\""
  inline ..= ",\"last_name\": #{last_name}" if last_name
  inline ..= ",\"thumb_url\": #{thumb_url}" if thumb_url
  inline ..= ",\"reply_markup\": #{reply_markup}" if reply_markup
  inline ..= "}"
  return inline

export inline_keyboard_block = (block) ->
  inline_keyboard = "{\"inline_keyboard\":#{block}}"
  return inline_keyboard

export inline_keyboard_button = (text, url, callback_data, switch_inline_query) ->
  inline = "{\"text\": \"#{text}\""
  inline ..= ",\"url\":\"#{url}\"" if url
  inline ..= ",\"callback_data\":\"#{callback_data}\"" if callback_data
  inline ..= ",\"switch_inline_query\":\"#{switch_inline_query}\"" if switch_inline_query
  inline ..= "}"
  return inline

--cheks whatever text matches or not
export match_trigger = (trigger,text) ->
  matches = {}
  if text
    matches = { string.match text, trigger }
    if next(matches)
      return matches

--Get file name
--Taken from https://github.com/yagop/telegram-bot
export get_http_file_name = (url, headers) ->
  file_name = url\match "[^%w]+([%.%w]+)$"
  file_name = file_name or url\match "[^%w]+(%w+)[^%w]+$"
  file_name = file_name or str\random 5
  content_type = headers["content-type"]
  types = {
  ["text/html"]: "html"
  ["text/css"]: "css"
  ["text/xml"]: "xml"
  ["image/gif"]: "gif"
  ["image/jpeg"]: "jpg"
  ["application/x-javascript"]: "js"
  ["application/atom+xml"]: "atom"
  ["application/rss+xml"]: "rss"
  ["text/mathml"]: "mml"
  ["text/plain"]: "txt"
  ["text/vnd.sun.j2me.app-descriptor"]: "jad"
  ["text/vnd.wap.wml"]: "wml"
  ["text/x-component"]: "htc"
  ["image/png"]: "png"
  ["image/tiff"]: "tiff"
  ["image/vnd.wap.wbmp"]: "wbmp"
  ["image/x-icon"]: "ico"
  ["image/x-jng"]: "jng"
  ["image/x-ms-bmp"]: "bmp"
  ["image/svg+xml"]: "svg"
  ["image/webp"]: "webp"
  ["application/java-archive"]: "jar"
  ["application/mac-binhex40"]: "hqx"
  ["application/msword"]: "doc"
  ["application/pdf"]: "pdf"
  ["application/postscript"]: "ps"
  ["application/rtf"]: "rtf"
  ["application/vnd.ms-excel"]: "xls"
  ["application/vnd.ms-powerpoint"]: "ppt"
  ["application/vnd.wap.wmlc"]: "wmlc"
  ["application/vnd.google-earth.kml+xml"]: "kml"
  ["application/vnd.google-earth.kmz"]: "kmz"
  ["application/x-7z-compressed"]: "7z"
  ["application/x-cocoa"]: "cco"
  ["application/x-java-archive-diff"]: "jardiff"
  ["application/x-java-jnlp-file"]: "jnlp"
  ["application/x-makeself"]: "run"
  ["application/x-perl"]: "pl"
  ["application/x-pilot"]: "prc"
  ["application/x-rar-compressed"]: "rar"
  ["application/x-redhat-package-manager"]: "rpm"
  ["application/x-sea"]: "sea"
  ["application/x-shockwave-flash"]: "swf"
  ["application/x-stuffit"]: "sit"
  ["application/x-tcl"]: "tcl"
  ["application/x-x509-ca-cert"]: "crt"
  ["application/x-xpinstall"]: "xpi"
  ["application/xhtml+xml"]: "xhtml"
  ["application/zip"]: "zip"
  ["application/octet-stream"]: "bin"
  ["audio/midi"]: "mid"
  ["audio/mpeg"]: "mp3"
  ["audio/ogg"]: "ogg"
  ["audio/x-m4a"]: "m4a"
  ["audio/x-realaudio"]: "ra"
  ["video/3gpp"]: "3gpp"
  ["video/mp4"]: "mp4"
  ["video/mpeg"]: "mpeg"
  ["video/quicktime"]: "mov"
  ["video/webm"]: "webm"
  ["video/x-flv"]: "flv"
  ["video/x-m4v"]: "m4v"
  ["video/x-mng"]: "mng"
  ["video/x-ms-asf"]: "asf"
  ["video/x-ms-wmv"]: "wmv"
  ["video/x-msvideo"]: "avi"
}

  extension = nil
  if content_type
    extension = types[content_type]
    if extension
      file_name = "#{file_name}.#{extension}"
      disposition = headers["content-disposition"]
      if disposition
        file_name = disposition\match 'filename=([^;]+)' or file_name
        return file_name

--Download and save file in .tmp folder
--Taken from https://github.com/yagop/telegram-bot
export download_to_file = (url, file_name) ->
  print "url to download: #{url}"

  respbody = {}
  options = {
    :url
    sink: ltn12.sink.table(respbody),
    redirect: true
  }
  response = nil

  if url\match '^https'
    options.redirect = false
    response = {https.request options}
  else
    response = {http.request options}

  code = response[2]
  headers = response[3]
  status = response[4]

  if code ~= 200
    return nil

  file_name = file_name or get_http_file_name url,headers
  file_path = ".tmp/#{file_name}"
  print "Saved to: #{file_path}"
  file = io.open file_path,"w+"
  file\write(table.concat respbody)
  file\close!

  return file_path

export getFileDownload = (file_id) ->
  get_file = telegram!\getFile file_id
  if get_file
    file = "https://api.telegram.org/file/bot#{config!.telegram_api_key}/#{get_file.result.file_path}"
    return download_to_file file, file_id
  return false

export vardump = (data) ->
  print serpent.block(data,{comment:false})

socket = require "socket"
export tg = class tg--https://github.com/JuanPotato/Lua-tg
  sender: socket.connect "localhost", config!.cli_port
  send: (command, output) =>
    if output
      s = socket.connect "localhost", config!.cli_port
      s\send command
      data = s\receive(tonumber(string.match(s\receive("*l"), "ANSWER (%d+)")))
      s\receive "*l"
      s\close()
      return data\gsub '\n$',''
    else
      (tg @).sender\send(command)

export up_the_first = (word) ->
	a = string.upper string.sub(word,1,1)
	b = string.lower string.sub(word,2,string.len(word))
	return "#{a}#{b}"

export no_output =  ->
  if #arg >= 1
    for k,v in pairs arg
      if v\lower! == "--no-output"
        return true
  return false

export admin_only = ->
  if #arg >= 1
    for k,v in pairs arg
      if v\lower! == "--admin-mode"
        return true
  return false

export is_premium = (msg) ->
  if is_admin(msg)
    return true
  redis = (Redis @).client
  users = redis\smembers "bot:premium:users"
  for k,v in pairs(users)
    if msg.from.id == tonumber(v)
      return true
    if msg.chat.id == tonumber(v)
      return true
  return false
