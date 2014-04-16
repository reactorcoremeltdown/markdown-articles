Кросспостинг из Instagram для гиков
===================================

Бывает и так, что кросспостить из Instagram хочется в малоизвестные сервисы, а счастья хочется. Также может хотеться встраивать фоточки из инстаграма в твиттер, но по какому-то недоразумению, эмбеддинг фотогафий в твиттере оторвали с мясом. К счастью, это ограничение можно успешно обойти.

Для начала потребуется [зарегистрироваться](http://flickr.com/signup) в сервисе Flickr. Это не займёт много времени. После регистрации необходимо авторизовать flickr в клиенте instagram, это тоже просто

[ ![](http://wasteland.it-the-drote.tk/shot/iOS/IMG_0343.PNG) ](http://wasteland.it-the-drote.tk/shot/iOS/IMG_0343.PNG)
[ ![](http://wasteland.it-the-drote.tk/shot/iOS/IMG_0344.PNG) ](http://wasteland.it-the-drote.tk/shot/iOS/IMG_0344.PNG)

Далее необходимо выяснить api key, api secret и user id. Взять их можно на [этой](http://www.flickr.com/services/apps/create/apply/) странице. User ID можно взять из URL после перехода по [этой](http://www.flickr.com/services/apps/by/me) ссылке, он будет последним значением после слэша. Теперь создаём директорию, в которой всё это будет крутиться, и пишем конфиг:

    api_key="your api key"
    secret="your api secret"
    user_id="your user id"
    interval="20"
    plugins="./plugins"

Сохраняем конфиг в файл `flickrpostrc`. В нём дополнительно указываем интервал поллинга api и директорию с плагинами. Теперь же дело за самим скриптом. Создадим директории `extdata` и `plugins` для начала, а после и сам файл `flickrpost`. В него пишем:

    #!/usr/bin/env bash

    . ./flickrpostrc #подключаем конфиг

    prev_id="" #обнуляем id

    api_url="http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key="$api_key"&user_id="$user_id"&per_page=1"

    while true; do
            curl $api_url | grep "photo id" | sed 's/<photo //;s/ \/>//' > ./variables      #грязный хак с иксемелями: очищаем строфу от скобочек...
             . ./variables                                                                  #...и подключаем получившийся файл как bash-скрипт с переменными
            if [[ $id != $prev_id ]]; then                                                  #если фотография изменилась, то начинаем представление
                    pic_url="http://farm"$farm".staticflickr.com/"$server"/"$id"_"$secret".jpg"
                    for i in $( ls $plugins ); do                                           #вызываем каждый плагин из директории и скармливаем ему тайтл и линк на фоточку
                            $plugins$i $pic_url "$title"
                    done
            fi
            prev_id=$id
            sleep $interval                                                                 #ждём следующей итерации
    done

Теперь настало время плагинов. Для примера отправим данные в twitpic. Этот сервис поддерживает отправку постов на секретный email. Идём в директорию `plugins`, создаём файлик `twitpic`, в него пишем:

    #!/usr/bin/env bash

    pic_url=$1
    text=`echo $2 | sed 's/&quot;/"/g'`                     #убираем подлянку с кавычками в иксемелях

    target="your.secret.mail@twitpic.com"                   #очень секретный почтовый адрес сервиса twitpic
    pic_file="/path/to/extdata/photo.jpg"                   #в этот файл скачиваем фото

    rm -f $pic_file                                         #убираем старый файл
    wget -c $pic_url -O $pic_file                           #замещаем новым

    echo "photo" | mutt -a $pic_file -s $text -- $target    #и отправляем его вложением с текстом

Не забываем делать `chmod +x twitpic`. Вот и всё. Далее можно писать плагины по вкусу.
