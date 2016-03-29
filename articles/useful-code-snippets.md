Полезные куски кода и конфигов
==============================

### Bash и прочий скриптинг

Замена *первого* вхождения регулярного выражения в файле

    sed -i '0,/RE/ { s|RE|ANOTER_RE| }' file

Вывод на stdout диапазона *символов* из переменной

    foo="<1234"; echo ${foo:0:1}

Multipattern grep

    egrep "pattern1|pattern2|pattern3"

Перейти в корневую директорию git-репозитория

    cd $(git rev-parse --show-cdup)

Использование массивов в bash

    declare -A foo
    foo[bar] = 'baz'

### NGINX

Правильная подстановка переменной в путь к файлу

    access_log /var/log/nginx/${variable}-access.log;
                              ^
_Запись в директорию должна быть возможна от пользователя, под которым запущен воркер_

### PostgreSQL

Переместить все таблицы из одной схемы в другую

    DO
    $$
    DECLARE
        row record;
    BEGIN
        FOR row IN SELECT tablename FROM pg_tables WHERE schemaname = 'public' -- and other conditions, if needed
        LOOP
            EXECUTE 'ALTER TABLE public.' || quote_ident(row.tablename) || ' SET SCHEMA [new_schema];';
        END LOOP;
    END;
    $$;

### MySQL

Пропустить запрос для устранения ошибки дублирования

    SET GLOBAL SQL_SLAVE_SKIP_COUNTER=1; START SLAVE;
