OpenRC в Debian
===============

#### Установка

Начиная с релиза `jessie` в Debian возможно использование системы инициализации [OpenRC](http://en.wikipedia.org/wiki/OpenRC). Поскольку она может использовать те же самые скрипты в `/etc/init.d/`, переход получается плавным, достаточно набрать команду `apt-get install systemd-sysv- openrc`. После установки OpenRC предложит выполнить команду для корректного завершения сервисов и перезагрузки сервера/компьютера:

    for file in /etc/rc0.d/K*; do s=`basename $(readlink "$file")` ; /etc/init.d/$s stop; done

После перезагрузки можно будет совершенно спокойно удалить директории `/etc/rc?.d/`. Симлинки на init-скрипты OpenRC хранит в `/etc/runlevels`. Чтобы посмотреть принадлежность скриптов к ранлевелам, нужно выполнить команду `rc-update show`. Для добавления и удаления своих сервисов нужно использовать команды `rc-update add <service> <runlevel>` и `rc-update delete <service>` соответственно. OpenRC готов к использованию на вашем компьютере.

#### Конфигурирование OpenRC

Work in progress. Описать параллельный запуск и взаимодействие с cgroups.

#### OpenRC-скрипты

В OpenRC реализована возможность декларативного описания сервисов. При этом формат не является строгим, вполне возможно переопределять действия для таких функций управления сервисами, как `start`, `stop` и `status`. Есть также функция `depend()`, которая описывает зависимости сервиса. В общем случае наиболее краткое описание сервиса выглядит так:

    #!/sbin/openrc-run

    command=/home/buckstabu/dev/promo/bin/www
    pidfile=/var/run/promo.pid
    command_background=true
    start_stop_daemon_args="-u buckstabu --stdout /var/log/promo.log --stderr /var/log/promo.err"
    name="promo"

    start_pre() {
        alias start-stop-daemon="openrc -a start-stop-daemon"
    }

    depend() {
        provide promo
    }

Поскольку в OpenRC существуют свои реализации команд `service` и `start-stop-daemon`, корректнее будет использовать их для манипуляций с RC-скриптами. Управление сервисами осуществляется с помощью команды `rc-service`, синтаксис тот же, что и у обычной команды, однако, `rc-service` отслеживает состояния сервисов и кэширует их описания вместе с зависимостями. Реализация `start-stop-daemon` из поставки OpenRC задействуется с помощью алиаса в функции `start_pre()`. Краткое описание реализации `start-stop-daemon`:

    openrc -a start-stop-daemon --help
    Usage: start-stop-daemon [options] 

    Options: [I:KN:PR:Sa:bc:d:e:g:ik:mn:op:s:tu:r:w:x:1:2:ChqVv]
      -I, --ionice <arg>                Установить ionice class:data при запуске
      -K, --stop                        Остановить демон
      -N, --nicelevel <arg>             Задать уровень nice при старте
      -R, --retry <arg>                 Повторные попытки запуска. Можно указать в качестве аргумента как секунды, так и СИГНАЛ/секунды(например, SIGTERM/5)
      -S, --start                       Запустить демон
      -a, --startas <arg>               устарело, используйте --exec или --name
      -b, --background                  Запустить демон в фоне
      -c, --chuid <arg>                 устарело, используйте --user
      -d, --chdir <arg>                 Перейти в директорию
      -e, --env <arg>                   Установить переменные окружения
      -k, --umask <arg>                 Задать режим umask для демона
      -g, --group <arg>                 Изменить группу процесса
      -i, --interpreted                 Определить процесс по интерпретатору
      -m, --make-pidfile                Создать pid-файл
      -n, --name <arg>                  Определить процесс по имени
      -o, --oknodo                      устарело
      -p, --pidfile <arg>               Определить pid процесса, указанный в файле
      -s, --signal <arg>                Послать сигнал
      -t, --test                        Протестировать действия без выполнения
      -u, --user <arg>                  Изменить пользователя процесса
      -r, --chroot <arg>                Изменить корневую директорию процесса на указанную
      -w, --wait <arg>                  Время в миллисекундах до запуска процесса
      -x, --exec <arg>                  Программа для запуска
      -1, --stdout <arg>                Перенаправить поток stdout в файл
      -2, --stderr <arg>                Перенаправить поток stderr в файл
      -P, --progress                    Выводить точку каждую секунду ожидания
      -h, --help                        Показать справку
      -C, --nocolor                     Отключить цветной вывод
      -V, --version                     Показать версию
      -v, --verbose                     Выводить подробную информацию
      -q, --quiet                       Выводить краткую информацию (повторить для подавления вывода ошибок)


Более подробное описание скриптов OpenRC на русском языке есть [здесь](https://www.gentoo.org/doc/ru/handbook/handbook-x86.xml?part=2&chap=4).

Раздел будет дополняться.
