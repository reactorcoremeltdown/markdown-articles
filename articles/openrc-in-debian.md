OpenRC в Debian
===============

####Установка

Начиная с релиза `jessie` в Debian возможно использование системы инициализации [OpenRC](http://en.wikipedia.org/wiki/OpenRC). Поскольку она может использовать те же самые скрипты в `/etc/init.d/`, переход получается плавным, достаточно набрать команду `apt-get install systemd- openrc`. После установки OpenRC предложит выполнить команду для корректного завершения сервисови перезагрузки сервера/компьютера:

    for file in /etc/rc0.d/K*; do s=`basename $(readlink "$file")` ; /etc/init.d/$s stop; done

После перезагрузки можно будет совершенно спокойно удалить директории `/etc/rc?.d/`. Симлинки на init-скрипты OpenRC хранит в `/etc/runlevels`. Чтобы посмотреть принадлежность скриптов к ранлевелам, нужно выполнить команду `rc-update show`. Для добавления и удаления своих сервисов нужно использовать команды `rc-update add <service> <runlevel>` и `rc-update delete <service>` соответственно. OpenRC готов к использованию на вашем компьютере.

*Примечание: для корректной работы OpenRC-скриптов необходимо будет сделать следующее: `mount --bind /sbin/openrc /sbin/start-stop-daemon`, `mount --bind /sbin/openrc /usr/sbin/service`*

####Конфигурирование OpenRC

Work in progress. Описать параллельный запуск и взаимодействие с cgroups.

####OpenRC-скрипты

В OpenRC реализована возможность декларативного описания сервисов. При этом формат не является строгим, вполне возможно переопределять действия для таких функций управления сервисами, как `start`, `stop`, `restart` и `status`. Есть также функция `depend()`, которая описывает зависимости сервиса. В общем случае наиболее краткое описание сервиса выглядит так:

    #!/sbin/openrc-run

    command=/home/buckstabu/dev/promo/bin/www
    pidfile=/var/run/promo.pid
    command_background=true
    start_stop_daemon_args="-u buckstabu --stdout /var/log/promo.log --stderr /var/log/promo.err"
    name="promo"

    depend() {
            provide promo
    }

Более подробное описание скриптов OpenRC на русском языке есть [здесь](https://www.gentoo.org/doc/ru/handbook/handbook-x86.xml?part=2&chap=4).

Раздел будет дополняться.
