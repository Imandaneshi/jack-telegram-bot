redis = require "redis"
API_URL = "https://api.telegram.org/bot#{config!.telegram_api_key}"
export Redis = class Redis
  new: =>
    params =
      host: os.getenv('REDIS_HOST') or '127.0.0.1'
      port: tonumber(os.getenv('REDIS_PORT') or 6379)
      database: os.getenv('REDIS_DB')
      password: os.getenv('REDIS_PASSWORD')
    @client = redis.connect params
    @client\auth params.password if params.password
      
export telegram = class telegram
  sendRequest: (url) =>
    data, res = https.request url
    jdata = JSON.decode data

    if res ~= 200
      return false, res

    unless jdata.ok
      return false, jdat.description

    return jdata

  getMe: =>
    url = "#{API_URL}/getMe"
    return telegram!\sendRequest url

  sendMessage: (target,text,reply_to_message_id,parse_mode,disable_web_page_preview) =>
    url = "#{API_URL}/sendMessage"
    url ..= "?chat_id=#{target}&text=#{URL.escape text}"
    url ..= "&reply_to_message_id=#{reply_to_message_id}" if reply_to_message_id
    url ..= "&parse_mode=#{parse_mode}" if parse_mode
    url ..= "&disable_web_page_preview=#{disable_web_page_preview}" if disable_web_page_preview
    return telegram!\sendRequest url

  getUpdates: (offset) =>
    url = "#{API_URL}/getUpdates?timeout=20"
    url ..= "&offset=#{offset}" if offset
    return telegram!\sendRequest url
