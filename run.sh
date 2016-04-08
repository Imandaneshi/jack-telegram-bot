ver="1.0"
if [ "$1" = "--help" ]; then
  echo -e "
        \033[31;47mJack Telegram Bot\033[0m

              \033[5mV $ver\033[0m



--no-outpot      Bot won't print incoming msgs
--admin-mode     Only listen to admins !
--update         Sync bot with master repo
--about          About bot
--help           Prints this msg
"

elif [ "$1" = "--about" ]; then
  echo -e "

        \033[31;47mJack Telegram Bot\033[0m

         By Iman Daneshi

              \033[5mV $ver\033[0m

A multi purpose Telegram bot written in MoonScript !

Website: jack.seedteam.org

"
elif [ "$1" = "--Update" ]; then
  git pull
else
  echo -e "

        \033[31;47mJack Telegram Bot\033[0m

         By Iman Daneshi

              \033[5mV $ver\033[0m
"
  while true; do
    moon jackbot.moon "${@}"
    sleep 10s
  done
fi
