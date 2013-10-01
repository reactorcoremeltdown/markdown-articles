Ввод пароля путём сканирования QR-кода веб-камерой
==================================================

Я достаточно ленив и люблю всякие удобства, даже если они не всегда безопасны. Ниже я расскажу, как можно заставить веб-камеру ноутбука кушать **QR**-коды и вводить пароли самостоятельно.
 
Рецепт моих паролей всегда прост - `head -c 12 /dev/urandom | base64`
Однако, вводить его руками часто довольно мучительно: либо раскладка не та, либо промахнулся, либо Caps Lock включил случайно. Мне это надоело. Сначала я стал пользоваться баркод-сканером на работе. Всё бы хорошо, но не всегда удобно таскать вместе с ноутом довольно габаритный девайс. Совсем недавно меня натолкнули на мысль использования вебкамеры в качестве сканера. Я начал искать подходящие утилиты для осуществления желаемого. **zbarcam** и **zbarimg** с баркодами справлялись плохо, а вот **QR**-коды слопали за милую душу. Я был окрылён вдохновением и тотчас сел писать волшебные костыли.

Плясать, как говорится, принято от печки, а печкой был **Crunchbang** Linux, мой любимый дистрибутив. Перво-наперво мне необходимо было скармливать пароль всяким веб-формочкам и sudo. Как оказалось, нет ничего проще:

    #!/usr/bin/env bash
    
    fswebcam -r 1280x720 --png 0 --save /tmp/printcode.png
    text_data=`zbarimg -q /tmp/printcode.png | cut -f 2 -d ':'`
    
    if [[ $text_data == '' ]]; then
        notify-send "Error"
    else
        active_window=`xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | cut -f 5 -d ' '`
        xdotool type --window $active_window $text_data
        xdotool key --window $active_window KP_Enter
        mplayer /usr/share/sounds/KDE-Im-Sms.ogg > /dev/null 2>&1 &
    fi
    
    rm -f /tmp/printcode.png

Сохранив этот скрипт, я повесил его на хоткей **Super-Z** в **OpenBox**:

    <keybind key="W-z">
      <action name="Execute">
        <command>~/bin/printcode</command>
      </action>
    </keybind>

Далее, необходимо было протащить как-то считывание кода в **lightdm**. Поскольку запуск команд по хоткею в нём не поддерживается, мне пришлось раскуривать конфиг. И там я увидел нечто интересное:

    greeter-setup-script=/home/buckstabu/bin/printcode-greeter-launch

Запускаемый скрипт:

    #!/usr/bin/env bash
    
    /home/buckstabu/bin/printcode-greeter > /dev/null 2>&1 &

Он является обвязкой для запуска в фоне циклического сканирования до тех пор, пока не будет считан пароль(без этой обвязки greeter **lightdm**'а не хотел запускаться). Сам "сканер" выглядит так:

    #!/usr/bin/env bash
    
    while [[ $text_data == '' ]]; do
        fswebcam -r 1280x720 --png 0 --save /tmp/printcode.png
        text_data=`zbarimg -q /tmp/printcode.png | cut -f 2 -d ':'`
        if [[ $text_data != '' ]]; then
            mplayer /usr/share/sounds/KDE-Im-Sms.ogg > /dev/null 2>&1 &
            xdotool type $text_data
            xdotool key KP_Enter
        fi
    done
    
    rm /tmp/printcode.png

Стоит заметить, что **lightdm** запускает эти скрипты от имени **root**.

На закуску у нас **XScreensaver**. Он тоже не позволяет запускать команды посредством хоткея, но что мешает запустить описанный выше сканер вместе с хранителем экрана? Ничего:

![](https://dl.dropbox.com/u/19274654/pictures/screenshot/crunchbang/xscreensaver.png)

В скрипте мы описываем запуск скринсейвера:

    #!/usr/bin/env bash
    
    /home/buckstabu/bin/printcode-greeter-launch
    /usr/lib/xscreensaver/glmatrix -root -mode hex

Вот и всё, господа и дамы. Теперь можно показать веб-камере бумажку с кодом и компьютер послушно разблокируется. Да, это не так и безопасно, да и в полумраке работает чуть лучше чем никак, но, попробовав один раз, я уже не могу себе отказывать в подобном удовольствии.
 
P.S.: Да, я знаю про PAM. Мне лень было разбираться с pam-script, ибо документации с гулькин нос.

P.P.S.: /tmp/ заблаговременно переместил в RAM.

P.P.P.S.: Как оказалось, **zbarimg** довольно привередлив, поэтому изображения для него нужно подготавливать. После съёмки кадра с помощью **fswebcam** картинку нужно преобразовать:

    convert /tmp/printcode.png -colorspace Gray -normalize -equalize -depth 50 -white-threshold 20000 /tmp/printcode.png

Рецепт я подобрал почти случайно, улучшения приветствуются.
