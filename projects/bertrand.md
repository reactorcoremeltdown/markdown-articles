Bertrand
========

Bertrand - это простая программа для учёта финансов для тех, кто не хочет изучать ledger.

# Сборка и установка

    git clone https://github.com/Like-all/bertrand.git
    cd bertrand
    go get github.com/droundy/goopt
    go build
    cp bertrand /somewhere/in/the/$PATH/

Также необходимо создать файл config.json в директории `~/.bertrand` со следующим содержанием:

    {
        "bertrandFile": "/path/to/accounting/file.csv"
    }

Существуют также бинарные сборки: [Linux amd64](http://wasteland.it-the-drote.tk/appstore/bertrand/linux/amd64/bertrand), [Windows amd64](http://wasteland.it-the-drote.tk/appstore/bertrand/windows/amd64/bertrand.exe)(экспериментальная сборка, работоспособность не проверялась).

В текущей версии есть агрумент `--init`, позволяющий инициировать конфигурационный файл и файл для записи транзакций.

# Использование

Bertrand хранит данные в файлах csv, которые содержат 4 колонки: **DATE**;**ACCOUNT**;**AMOUNT**;**COMMENT**(optional)

Вызов bertrand без аргументов позволяет вывести все счета, подсчета и их текущие значения с самого начала ведения счетов.

Bertrand имеет два режима: режим проводок для записи расходов и режим вывода отчётов.

## Режим проводок
В режиме проводок осуществляется перевод расходов с одного счёта на другой. Опционально можно указать дату записи:

    bertrand --checkout --from salary.work --to cash.pocket --date 2014-01-01 --amount 40000.00 --comment "WOOT!"

Или ещё короче:

    bertrand -c -f salary.work -t cash.pocket -d 2014-01-01 -a 40000.00 -C "WOOT!"

В результате в csv-файле появляется две записи:

    2014-01-01;salary.work;-40000.00;WOOT!
    2014-01-01;cash.pocket;40000.00;WOOT!

Теперь можно посмотреть, что происходит на счету pocket:

    $ bertrand | grep pocket
    cash.pocket: 40000.00
    $

## Режим вывода отчётов

Bertrand позволяет выводить отчёты не только за всё время ведения счетов, но и за определённый срок. Также можно задать необходимую глубину отображения для субсчетов:

    bertrand --since-date 2013-10-01 --to 2013-10-30 --depth 2 | grep food

Этот отчёт выведет расходы на еду в октябре 2013 года с подкатегориями.
