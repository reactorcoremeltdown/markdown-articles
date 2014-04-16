Btce-mobile - легковесный мобильный веб-клиент для криптовалютной биржи BTCe
============================================================================


###Обзор

BTCe-mobile - простой мобильный веб-клиент для криптовалютной биржи BTCe. Он подходит для быстрого размещения и снятия ордеров на покупку/продажу криптовалюты с помощью мобильного устройства.

[ ![](http://wasteland.it-the-drote.tk/shot/iOS/BTCe-mobile/IMG_1034.PNG) ](http://wasteland.it-the-drote.tk/shot/iOS/BTCe-mobile/IMG_1034.PNG)
[ ![](http://wasteland.it-the-drote.tk/shot/iOS/BTCe-mobile/IMG_0289.PNG) ](http://wasteland.it-the-drote.tk/shot/iOS/BTCe-mobile/IMG_0289.PNG)
[ ![](http://wasteland.it-the-drote.tk/shot/iOS/BTCe-mobile/IMG_0960.PNG) ](http://wasteland.it-the-drote.tk/shot/iOS/BTCe-mobile/IMG_0960.PNG)

###Установка

_Описанный процесс установки подходит для дистрибутивов Debian Wheezy и Ubuntu 12.04 LTS. На дистрибутивах с Systemd вместо системы инициализации, а также на операционных системах FreeBSD, OpenBSD, NetBSD, прочих BSD, Mac OS X и Microsoft Windows работа клиента не проверялась. Если имеется желание это исправить - добро пожаловать в [репозиторий](https://github.com/Like-all/btce-mobile) на GitHub._

Сперва необходимо убедиться, что на сервере установлена самая свежая версия [Node.js](http://nodejs.org/download/) и [git](http://git-scm.com/downloads). Далее необходимо из под учётной записи `root` выполнить следующую команду:

    bash <(curl -s https://raw.githubusercontent.com/Like-all/btce-mobile/master/util/install.sh)

Во время выполнения команды будет предложено ввести имя пользователя в клиенте, пароль, а так же API key и API secret из вашего профиля в BTCe. Убедитесь, что ключу выданы необходимые права:

![](http://wasteland.it-the-drote.tk/shot/debian/btce-api-permissions.png)

После установки клиента необходимо настроить http-сервер и спроксировать его на порт клиента. [Здесь](https://github.com/Like-all/btce-mobile/tree/master/util/nginx) есть примеры конфигурационных файлов для сервера nginx(рекомендуется использовать https, если сервер не находится за NAT).

###Решение проблем

Если после установки клиента он не заработал, то нужно остановить его командой `service btce-mobile stop` и посмотреть в файл `/var/log/btce-mobile.log`.

Примеры ошибок:

    Error: listen EADDRINUSE

В этом случае необходимо сменить порт в файле `/opt/btce-mobile/settings.js`.

    TypeError: Cannot read property 'funds' of undefined

Ошибка означает, что клиент не может получить данные от сервера BTCe. Проверьте права, выданные ключу, а также правильность API key и API secret в файле `/opt/btce-mobile/settings.js`.

###Пожертвования

Если вам понравился клиент btce-mobile, то вы можете поблагодарить меня небольшим денежным вознаграждением на следующие кошельки:

+ **Bitcoin**: [196mWnvQze7UX16SUwzBy4ppUMcPbgUTPH](bitcoin:196mWnvQze7UX16SUwzBy4ppUMcPbgUTPH?label=btcpocket)
+ **Litecoin**: [LaW4vgsVn9Vghu3SSwWTMhz6PWbusH3HaH](litecoin:LaW4vgsVn9Vghu3SSwWTMhz6PWbusH3HaH?label=ltcpocket)
