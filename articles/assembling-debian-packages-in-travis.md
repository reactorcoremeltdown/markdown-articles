Сборка пакетов для Debian в Travis CI
=====================================

*Материал является адаптированной доработкой [этого](http://travis.debian.net/) гайдлайна.*

### Введение

С конца августа 2015 года в [Travis CI](https://travis-ci.org) стало возможным использование платформы Docker для сборки проектов. Это означает, что в Travis CI таким образом можно использовать практически любое окружение для сборки чего угодно. Этот документ поможет вам настроить окружение для сборки пакетов для Debian и Ubuntu(чего не можен оригинальный скрипт travis.debian.net).

### Подготовка

Для начала нам потребуются образы, из которых мы будем разворачивать наши контейнеры. Можно взять официальные образы, но при их использовании возникает ряд проблем:

  + Нет поддержки архитектуры i386. Для большинства пользователей компьютеров в 2016 году это не будет являться проблемой, однако я решил для себя, что пока конденсаторы на материнских платах не попересохли, сборку стоит поддерживать.
  + Неудобная итерация по релизам. Скрипт в процессе сборки будет итерироваться по именам релизов. У официальных образов Debian и Ubuntu именование различается, что может привнести некоторые проблемы в процессе именования образов и пакетов.
  + Отсутствие в базовой поставке официальных образов Debian и Ubuntu пакетов `devscripts` и `build-essential`. Эти пакеты в любом случае будут нужны, без них сборка пакетов неосуществима. Наличие этих пакетов увеличивает размер контейнеров, но сокращает время сборки, поскольку Travis CI кэширует скачиваемые образы.

Пример создания собственного базового образа есть в [документации Docker](https://docs.docker.com/engine/userguide/eng-image/baseimages/). Готовые образы LTS-релизов Debian и Ubuntu для архитектур amd64 и i386 есть в [моём репозитории](https://hub.docker.com/u/likeall/) DockerHub.

### Скрипт

Я использую скрипт, который предварительно настроен на загрузку пакетов в мой [Debian-репозиторий](http://crapcannon.tk/debian). В будущем планируется адаптировать этот скрипт для более широкого использования, что, впрочем, потребует дополнительных опций настройки в переменных окружения. Рассмотрим работу скрипта в деталях:

#### Подключаем метаданные

Ранее я использовал сборку на отдельной машине путём вызова хука `post-receive` на Git-сервере. Для корректного определения целей сборки использовались переменные из подключаемого скрипта. Какая-то часть этого формата осталась и в нынешней реализации системы сборки. Метаданные располагаются в файле `debian/package.sh`([пример](https://raw.githubusercontent.com/Like-all/dumbfuck/master/debian/package.sh)). Подключение метаданных осуществляется просто:

```bash
source ./debian/package.sh
```

#### Ping loop

У Travis CI есть две неприятные особенности: ограничение на объём данных, выводимых в лог сборки(не более 5 мегабайт), и ограничение времени простоя, в течение которого данные не поступают в лог(5 минут; в таком случае Travis считает, что сборка зависла, поэтому требуется убить воркер). Всё это не было бы проблемой, если бы не требовалась сборка крупных проектов, например [systemd](https://github.com/systemd/systemd). Впрочем, доблестными воинами клавиатуры и терминала на StackExchange было найдено решение: увести вывод лога в файл, а в STDOUT время от времени посылать какую-нибудь информацию, например таймстемпы. В случае ошибки во время сборки в скрипте выводится 500 последних строк лога. Этого, обычно, достаточно для выявления проблемы.

Здесь происходит установка значений необходимых переменных и создание файлов:

```bash
export PING_SLEEP=30s
export WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export BUILD_OUTPUT=$WORKDIR/build.out

touch $BUILD_OUTPUT
```

Пара необходимых функций(вывод лога при ошибке сборки и вызов вебхука для отправки уведомления в Telegram):

```bash
dump_output() {
   echo -e "\e[0;31mTailing the last 500 lines of output:\e[0m"
   tail -500 $BUILD_OUTPUT
}

function die() {
    NAME=$1
    DISTRO=$2
    ARCHITECTURE=$3

    dump_output
    test -z $TELEGRAM_TOKEN || curl -XPOST -d "message=Building $NAME on $DISTRO-$ARCHITECTURE failed&token=$TELEGRAM_TOKEN" http://api.it-the-drote.tk/telegram
    exit 1
}
```

Сам ping loop запускается непосредственно перед сборкой.

#### Определение параметров сборки

На этом этапе осуществляется настройка параметров сборки, в частности списка поддерживаемых репозиториев, типа сборки(testing, stable), и так далее. Последний параметр управляется посредством установки тегов в Git.

```bash
echo -e "\e[0;32mSetting up variables...\e[0m"

DEBREW_SUPPORTED_DISTRIBUTIONS="jessie
wheezy
trusty
xenial"
DEBREW_SUPPORTED_ARCHITECTURES="amd64
i386"

DEBREW_CWD=`pwd`
DEBREW_REPO_OWNER=`echo $DEBREW_CWD | cut -f 5 -d '/'`
DEBREW_SOURCE_NAME=`dpkg-parsechangelog | grep Source | cut -f 2 -d ' '`
DEBREW_REVISION_PREFIX=`dpkg-parsechangelog | grep Version | cut -f 2 -d ' '`
DEBREW_VERSION_PREFIX=`echo $DEBREW_REVISION_PREFIX | cut -f 1 -d '-'`
stable_hash=`git rev-list stable | head -n 1`
current_hash=`git rev-parse HEAD`
changelog_modified=`git show --name-only HEAD | grep -c 'debian/changelog'`

if [[ $stable_hash == $current_hash ]]; then
    if [[ $TRAVIS_BRANCH == 'stable' ]]; then
        if [[ $PRODUCTION_FLAVOURS == 'any' ]]; then
            DEBREW_DISTRIBUTIONS=$DEBREW_SUPPORTED_DISTRIBUTIONS
        else
            DEBREW_DISTRIBUTIONS=$PRODUCTION_FLAVOURS
        fi
        if [[ $PRODUCTION_ARCHITECTURES == 'any' ]]; then
            DEBREW_ARCHITECTURES=$DEBREW_SUPPORTED_ARCHITECTURES
        else
            DEBREW_ARCHITECTURES=$PRODUCTION_ARCHITECTURES
        fi
        DEBREW_ENVIRONMENT='stable'
    else
        echo -e "\e[0;32mThis branch is not "stable", exiting gracefully.\e[0m"
        exit 0
    fi
else
    DEBREW_DISTRIBUTIONS=$TESTING_FLAVOURS
    DEBREW_ARCHITECTURES=$TESTING_ARCHITECTURES
    DEBREW_ENVIRONMENT='testing'
fi
```

#### Итерированная сборка Dockerfile и, собственно, сборка пакетов

Кульминационная часть процесса. Все ранее заданные переменные теперь используются для генерации докерфайлов и запуска в созданных с помощью них контейнеров процессов сборки. Готовые артефакты затем выгружаются из контейнеров в хост-систему и загружаются по FTP в директорию incoming на удалённом сервере. Здесь я не стал использовать `dupload`, поскольку это несколько усложнило бы процесс, а подпись пакетов и так осуществляется на сервере с репозиторием. Пароль к FTP-серверу пробрасывается через переменную окружения, которая задаётся в настройках проекта в интерфейсе Travis CI.

Сборка докерфайла:

```bash
for DISTRO in $DEBREW_DISTRIBUTIONS; do
    for ARCH in $DEBREW_ARCHITECTURES; do
        echo -e "\e[0;32mAssembling Dockerfile...\e[0m"
        echo -e "\e[0;32mDistribution: "$DISTRO"-"$ARCH"\e[0m"
        cat >Dockerfile <<EOF
FROM likeall/$DISTRO-$ARCH
WORKDIR $DEBREW_CWD
COPY . .
ENV DEBFULLNAME "Travis CI"
ENV DEBEMAIL repo@crapcannon.tk
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
EOF

        test -z $SECRET1 || echo "ENV SECRET1 $SECRET1" >> Dockerfile
        test -z $SECRET2 || echo "ENV SECRET2 $SECRET2" >> Dockerfile
        test -z $SECRET3 || echo "ENV SECRET3 $SECRET3" >> Dockerfile
        cat >> Dockerfile <<EOF
RUN apt-get update
RUN mk-build-deps --install --remove --tool 'apt-get --no-install-recommends --yes' debian/control
RUN dch --preserve --newversion $DEBREW_REVISION_PREFIX"+"$DISTRO ""
RUN dch --preserve -D $DISTRO --force-distribution ""
RUN dh_make --createorig -s -y -p $DEBREW_SOURCE_NAME"_"$DEBREW_VERSION_PREFIX || true
RUN debuild -e SECRET1 -e SECRET2 -e SECRET3 --no-tgz-check -us -uc
CMD /bin/true
EOF
```

Также в процессе сборки задействуются переменные окружения `SECRET1`, `SECRET2` и `SECRET3`, которые пробрасываются внутрь окружения для сборки и могут быть использованы для подстановки секретов в макросы.

Далее следует сам процесс сборки, в котором и происходит запуск ping loop:

```bash
    bash -c "while true; do echo \$(date) - building ...; sleep $PING_SLEEP; done" & PING_LOOP_PID=$!
    echo -e "\e[0;32mBuilding Docker container...\e[0m"
    docker build --tag="debrew/"$DEBREW_SOURCE_NAME"_"$DISTRO . >> $BUILD_OUTPUT 2>&1 || die $DEBREW_SOURCE_NAME $DISTRO $ARCH
    rm -f Dockerfile
    DEBREW_CIDFILE=`mktemp`
    rm -f $DEBREW_CIDFILE
    echo -e "\e[0;32mRunning Docker container...\e[0m"
    docker run --cidfile=$DEBREW_CIDFILE "debrew/"$DEBREW_SOURCE_NAME"_"$DISTRO >> $BUILD_OUTPUT 2>&1 || die $DEBREW_SOURCE_NAME $DISTRO $ARCH
    mkdir ext-build
    echo -e "\e[0;32mExtracting files from Docker container...\e[0m"
    docker cp `cat $DEBREW_CIDFILE`":"$DEBREW_CWD"/../" ./ext-build || die $DEBREW_SOURCE_NAME $DISTRO $ARCH
    cd ./ext-build/$DEBREW_REPO_OWNER/
    echo -e "\e[0;32mPushing build artifacts to the repo...\e[0m"
    for i in `ls *.deb`; do
        if [[ $DEBREW_HIDDEN_REPO == 'true' ]]; then
            DEBREW_FTP_URL="ftp://it-the-drote.tk/hidden/"
        else
            DEBREW_FTP_URL="ftp://it-the-drote.tk/$DEBREW_ENVIRONMENT/$DISTRO/$ARCH/"
        fi
        echo -e "\e[0;31m Uploading $i to $DEBREW_FTP_URL\e[0m"
        curl -s -T "$i" "$DEBREW_FTP_URL" --user travis:$DEBREW_FTP_PASSWORD || die $DEBREW_SOURCE_NAME $DISTRO $ARCH
    done
    cd $DEBREW_CWD
    echo -e "\e[0;32mRemoving Docker container...\e[0m"
    docker rm `cat $DEBREW_CIDFILE`
    rm -f $DEBREW_CIDFILE
    rm -fr ext-build
    kill $PING_LOOP_PID
    rm $BUILD_OUTPUT
  done
done
```

Полностью скрипт доступен [здесь](http://dev.crapcannon.tk/scripts/travis-debian.sh).

### Подключение проекта

Для сборки проекта в Github с помощью Travis CI достаточно простого конфига `.travis.yml` в пять строчек:

```
sudo: required

services:
  - docker

script:
  - wget -O- http://dev.crapcannon.tk/scripts/travis-debian.sh | bash -
```

После этого в настройках проекта в Travis CI требуется указать необходимые настройки в переменных окружения(токены, пароли).

### Заключение

Код, предоставленный в этом материале, не является готовым решением для сборки Debian-пакетов в Travis CI, Это всего лишь набор скриптов, заточенных под мою личную инфраструктуру, однако материал поможет вам сделать ваш сборочный конвейер значительно проще и быстрее.

Рекомендую также ознакомиться с [руководством разработчика Debian](https://www.debian.org/doc/manuals/maint-guide/). Литература хоть и нудная, но полезная.
