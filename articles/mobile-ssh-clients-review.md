Обзор мобильных SSH-клиентов
============================

Довольно часто я пользуюсь мобильными SSH-клиентами, да ещё и перепробовал их всяких на разных платформах. Полагаю, что о динозаврах типа Windows Mobile или Symbian писать не стоит, а вот на SSH-клиенты на живых платформах посмотреть будет интересно. Платные клиенты при хороших и годных бесплатных аналогах рассматривать не буду.

### Android
Их там всяких разных просто уйма, хоть на зиму соли. Начну, пожалуй, с первенца на этой платформе.

#### ConnectBot
Самый древний из клиентов. Настолько древний, что до сих пор содержит в себе поддержку девайсов с трекболами, хотя, их, с появлением 4.x, в девайсы ставить перестали. А жаль, штуковина, порой, удобная, пригодилась бы для стрелочек. Клиент свободный, посему породил несколько форков. По данным Google Play, с 7 октября 2010 года разработчики на своё детище забили, что не мешает приложению иметь свои заслуженные 4,7 звёзд.

С первого запуска программы видно, что она создавалась ещё под первые девайсы, с аппаратной клавиатурой и другими многочисленными клавишами. Ну и Android 1.x-2.x, да, что, впрочем не мешает приложению работать на 4.x:

![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:30:47.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:30:55.png)

Самое приятное в клиенте - возможность быстро создать подключение: достаточно лишь выбрать протокол(ssh, telnet или local), а затем вписать в текстбокс `<имя пользователя>@<имя хоста>` и нажать Return:

![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:31:03.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:32:55.png)

Настроек у приложения не очень много, в основном привязки действий к аппаратным клавишам и screen/wifi lock:

![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:33:08.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:41:04.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:41:14.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:41:18.png)

Также имеются отдельные настройки для каждого хоста: 

![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:39:38.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:40:00.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:40:04.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:40:10.png)

Есть возможность сгенерировать пару ключей RSA или DSA. Passphrase обязательна, вводится один раз при запуске приложения:

![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:33:22.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:33:51.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:34:00.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:34:16.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:34:36.png)

По умолчанию будет предложено ввести пароль, однако в свойствах хоста можно предварительно указать ключ, а публичную его часть скопировать в буфер обмена и послать, например, самому себе по почте, чтобы потом закинуть в `authorized_keys` на сервере.

![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:35:15.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:35:26.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:38:36.png)

Итак, после подключения в приложении появляется, собственно, терминал, небольшая панелька с тремя программными клавишами внизу него(`Ctrl`, `Esc` и вызов экранной клавиатуры) и контекстное меню. Свайп по левой половине экрана забит на клавиши `PgUp` и `PgDn`, свайп по правой - на скроллинг буфера:

![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:36:50.png)

Есть одна неприятная особенность: в zsh почему-то текст введённых команд дублируется на новую строку. В bash, при этом, всё хорошо:

![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:36:14.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:36:34.png)

Я до сих пор не придумал, как в этом клиенте нажимать клавишу `Alt` и мне без неё очень грустно. Впрочем, нажатие стрелочек я тоже не знаю как сымитировать. Всё это было возможно на старых добрых клавиатурных девайсах, но их времена, кажется, безвозвратно ушли. Получается, что и время этой программы ушло, однако, форки исправили положение дел.

#### VX ConnectBot
Очень добротный форк, почти идеальный ssh-клиент. Но почти, поскольку в нём пока ещё нет поддержки [mosh](http://mosh.mit.edu). 

На Android 4.x не выглядит анахронизмом, используется "родная" тема Holo:

![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:43:12.png)
![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:43:45.png)

Добавлена возможность передавать файлы по протоколу sftp:

![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:51:35.png)

Имеется поддержка раскладок аппаратных клавиатур последних из живых qwerty-смартфонов и планшетов:

![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:46:31.png)

Добавлена возмонжность привязывать нужные хоткеи к существующим клавишам(например, я привязываю `Tab` к `Volume Up`, `Ctrl+A Space` к `Volume Down` и список URL к `Search`):

![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:45:46.png)

Есть настраиваемое окошко с быстрым выбором символов: забавная функция, хотя, ни разу ей не пользовался:

![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:51:00.png)

Также имеется куча других полезных всплывающих окон:

В настройках хоста есть форвардинг X11. Подозреваю, что для этого нужно где-то отдельно держать X-сервер, что на Android-смартфоне проделывать мало кому захочется, поэтому я эту функцию обозревать не буду:

![](http://wasteland.it-the-drote.tk/shot/Android/sshreview/raw/cropped/2013-12-01-17:44:58.png)

Привязки свайпа по левой и правой половине экрана никуда не делись, всё привычно, однако в целом клиент во много раз удобнее своего прародителя. Осталось лишь дождаться поддержки mosh.


