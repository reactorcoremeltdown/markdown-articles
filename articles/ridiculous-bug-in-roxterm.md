Очень смешной баг в ROXTerm
===========================

С недавнего времени мне очень захотелось перейти на эмулятор терминала в котором имеется возможность добавлять новые темы оформления отдельными файлами. Желательно, чтобы формат тем был прост(т.е. не XML, а ini или хотя бы JSON). Под руку попался [ROXTerm](http://roxterm.sourceforge.net/), в котором и темы оформления, и сочетания клавиш, и настройки профилей лежат отдельно, что вполне удобно. Настало время настройки хоткеев. После генерации конфига для сочетаний клавиш по умолчанию заработало всё кроме `copy` и `paste`. После часа размышлений было обнаружено, что в конфиге шорткатов вписаны пункты и подпункты контекстного меню в том виде, в котором их читает пользователь. ROXTerm в моём случае был переведён частично на русский язык, поэтому сгенерированный по умолчанию конфиг для этих пунктов попросту не работал. Рабочая версия конфига сейчас выглядит так:

    [roxterm shortcuts scheme]
    File/New Window=<Shift><Control>n
    File/New Tab=<Shift><Control>t
    File/Close Window=<Shift><Control>q
    File/Close Tab=<Shift><Control>w
    Tabs/Previous Tab=<Control>Page_Up
    Tabs/Next Tab=<Control>Page_Down

    Edit/Копировать=<Control><Shift>c
    Edit/Вставить=<Control><Shift>v

    View/Zoom In=<Control>plus
    View/Zoom Out=<Control>minus
    View/Normal Size=<Control>0
    View/Full Screen=F11
    View/Scroll Up One Line=<Shift>Up
    View/Scroll Down One Line=<Shift>Down
    Help/Help=F1
    Edit/Copy & Paste=<Shift><Control>y
    Search/Find...=<Shift><Control>f
    Search/Find Next=<Shift><Control>n
    Search/Find Previous=<Shift><Control>p
    File/New Window With Profile/Default=
    File/New Tab With Profile/Default=

То есть действия в конфиге наглухо прибиты к названиям пунктов меню. Багрепорт уже [оформлен](http://sourceforge.net/p/roxterm/bugs/103/).
