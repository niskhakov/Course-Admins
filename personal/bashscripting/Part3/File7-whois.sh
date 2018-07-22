#!/bin/bash

# Команда 'whois domain-name' выясняет имя домена на одном из 3 серверов:
#                    ripe.net, cw.net, radb.net

# Разместите этот скрипт под именем 'wh' в каталоге /usr/local/bin

# Требуемые символические ссылки:
# ln -s /usr/local/bin/wh /usr/local/bin/wh-ripe
# ln -s /usr/local/bin/wh /usr/local/bin/wh-cw
# ln -s /usr/local/bin/wh /usr/local/bin/wh-radb

if [ -z "$1" ]
then
  echo "Порядок использования: `basename $0` [domain-name]"
  exit 65
fi

case `basename $0` in
# Проверка имени скрипта и, соответственно, имени сервера
	"wh"	) whois $1@whois.ripe.net;;
	"wh-ripe"	) whois $1@whois.ripe.net;;
	"wh-radb"	) whois $1@whois.radb.net;;
	"wh-cw"		) whois $1@whois.cw.net;;
	*			) echo "Порядок использования: `basename $0` [domain-name]";;
esac

exit 0