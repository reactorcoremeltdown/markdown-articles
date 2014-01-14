Правильная синхронизация фотографий на iOS-девайсах
===================================================

Директория с картинками в iOS представляет собой ужасную свалку, в которую попадают фотографии, скриншоты, картинки сохранённые из браузеров и прочая ерунда. Это неприятно. Но также вдвойне неприятно то, что мобильные приложения для синхронизации фотобарахла не делают различий между скриншотами, пикрандомом и, собственно, фотографиями. Ниже описан способ, которым я поборол этот недостаток.

**ВНИМАНИЕ, JAILBREAK**

Все нижеописанные действия можно воспроизвести только на телефоне с Jailbreak. Если Вы опасаетесь потери гарантии, то делать Jailbreak не рекомендуется.

Из необходимого софта на смартфон/планшет надо установить `sbutils`, `openssh-server` и `rsync`. На десктопе нам также потребуется `rsync` и кроме него `exiftags` и `imagemagick`. Далее кладём скрипт куда-нибудь в `$PATH`:

    #!/usr/bin/env bash

    backup_path="/Volumes/MacHD/Backup/photodump/"
    photos_path="/Volumes/MacHD/Яндекс.Диск/pictures/photos/"
    picrandom_path="/Volumes/MacHD/Яндекс.Диск/pictures/picdump/"
    screenshot_path="/Volumes/MacHD/Яндекс.Диск/shot/iOS"

    if ! [[ -z $(ping -c 1 -t 1 iphone | grep "1 packets received") ]];then
        rsync -rue "ssh -p 8022" mobile@iphone:/var/mobile/Media/DCIM/ $backup_path
        ssh -p 8022 mobile@iphone "sbalert -t 'Синхронизация прошла успешно'"
        for f in `find ${backup_path}*`;do
            if ! [[ -d $f ]]; then
                if [[ $(exiftags -c $f | grep "Camera Model" | cut -f 3 -d ' ') == "iPhone" && ! -f $photos_path$(basename $f) ]]; then
                        cp $f $photos_path
                elif [[ $(basename $f | cut -f 2 -d '.') == "PNG" && $(identify -format "%wx%h" $f) == "640x960" && ! -f $screenshot_path$(basename $f) ]]; then
                        cp $f $screenshot_path
                elif ! [[ -f $picrandom_path$(basename $f) ]]; then
                        cp $f $picrandom_path
                fi
            fi
        done
    fi

В скрипте указаны четыре директории:

+ `backup_path` для общего бэкапа
+ `photos_path` для свалки фотографий
+ `picrandom_path` для свалки пикрандома из интернета
+ `screenshot_path` для свалки скриншотов

Обратите особое внмание на 8, 9 и 10 строки скрипта: `ping` в Mac OS X и в Linux выводит на stdout разные описания происходящего, поэтому для Linux используйте `grep "1 received"`; в 9 и 10 строках используйте свои номер порта и имя хоста смартфона.

Далее можно добавить синхронизацию в `crontab` и перестать беспокоиться о плохо отсортированных картинках.
