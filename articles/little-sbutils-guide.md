Небольшое руководство по набору утилит sbutils
==============================================

После jailbreak iPhone превращается в карманный unix-компьютер. В репозиториях Cydia есть много полезных command-line утилит. В этом руководстве не будет манула по джейлбрейку и установке софта, только обзор некоторых утилит.

#### sbalert
Умеет посылать на springboard разнообразные уведомения

    Usage: sbalert [arguments...]
      -t: title/header text
      -m: message text
      -d: default button text
      -a: alternate button text
      -o: other button text
      -q: timeout in seconds
      -p: prompt for text input
      -v: default value for text input

Введённые в prompt данные выводятся в stdout, что может быть поезным для взаимодействия с другими программами.

#### sbbundleids

Программа ничего не умеет кроме как выводить на экран bundle id установленных приложений и не принимает никаких опций. Пригодится для запуска приложений через `sblaunch`.

#### sbdevice

Отображение разнообразной информации об устройстве

    Usage: sbdevice [option]
      -n: device name
      -N: system name
      -V: system version
      -m: localized model
      -u: udid
      -o: orientation
      -l: battery level
      -s: battery state
      -p: proximity sensor
      -e: multitasking support
      -h: This help message

#### sblaunch

Позволяет запускать приложения-бандлы, как системные, так и установленные из appstore. Опционально можно передать URL

    Usage: sblaunch [-p] [-d] [-b] [-u url] <bundle> [arguments...]
      -p: print pid
      -d: launch for debugging
      -b: launch in background

В качестве примера использования можно взять передачу URL из vimperator на десктопе в смартфон: `command -nargs=0 sendtoiphone :execute "!ssh -p 8022 mobile@iphone sblaunch -u '" + content.location.href + "' com.apple.mobilesafari"`
