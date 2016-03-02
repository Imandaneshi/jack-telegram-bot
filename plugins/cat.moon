run = (msg,matches) ->

    url = "http://thecatapi.com/api/images/get?format=src&type=jpg"
   
    file = download_to_file url,"cat.jpg"
   
    telegram!\sendPhoto msg.chat.id,file
    os.remove file
    
    return
 
return {
  description: "*Return a Cat*"
  usage: "`/cat`\n"
  patterns: {
  "^[/!#]cat"
  }
  :run
}
