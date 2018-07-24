### Описание

На этом занятии были даны базовые представления о протоколе HTTP, веб-серверах и веб-клиентах.

### Домашнее задание

Основная цель нижеописанных действий - "пощупать" элементарное веб-приложение на Python, работающее под uwsgi. Кроме того - научиться поднимать uwsgi-приложение под supervisor-ом.

Пусть в /root/homework у вас находится последняя версия содержимого репозитрия https://gitlab.com/tfs_s18_admin/homework.git

Прежде всего на вашей машине под root-ом нужно выполнить то, что описано в materials/class05/src/prepare.sh

Кроме того в качестве подготовки Вам следует сделать следующее. Под root-ом:

```
mkdir -p /opt/webcode/
cp -R /root/homework/materials/class05/src/former /opt/webcode
```

Теперь всё готово для проверки работы приложения под uwsgi.

#### Задание 1. Запускаем приложение "former" под uwsgi

```
uwsgi --plugins=python --http-socket=0.0.0.0:80 --wsgi-file /opt/webcode/former/process/webrunner.py --static-map /form=/opt/webcode/former/form/index.html --processes=5 --master --pidfile=/tmp/formdig.pid --vacuum --max-requests=5000
```

Убеждаемся, что приложение работает, открыв в браузере на терминальном сервере адрес http://YOURPREFIX.fintech-admin.m1.tinkoff.cloud/form (где YOURPREFIX - начало имени вашей машины, до точки), после чего заполнив и отправив форму.

Для завершения надо остановить процесс uwsgi.

В качестве отчёта по этому заданию скопируйте в форму его сдачи строку, с помощью которой вы запустили приложение под uwsgi.

#### Задание 2. Запускаем приложение "former" под uwsgi+supervisor

Пусть prepare.sh выполнен ещё на предыдущем шаге и проверка запуска uwsgi вручную прошла успешно. Теперь делаем следующее. (при выполнении данного домашнего задания по умолчанию работаем под root-ом) 

```
systemctl enable supervisord
systemctl start supervisord
mkdir -p /var/log/webapps
cp /root/homework/materials/class05/src/former.ini /etc/supervisord.d/
supervisorctl reread
supervisorctl update
```

Убеждаемся, что приложение работает, открыв в браузере на терминальном сервере всё тот же адрес http://YOURPREFIX.fintech-admin.m1.tinkoff.cloud/form, после чего заполнив и отправив форму.

Убедитесь, что вы можете управлять приложением при помощи supervisor:

```
supervisorctl status
supervisorctl stop former
supervisorctl status
supervisorctl start former
supervisorctl status
```

В качестве отчёта по этому заданию скопируйте в форму URL доступа к Вашему приложению: http://YOURPREFIX.fintech-admin.m1.tinkoff.cloud/form.

#### Задание 3. Меняем метод отправки формы

В этой части домашнего задания вам надо поменять метод отправки формы с POST на GET. Выполните соответствующее изменение в коде html-страницы с формой, выполните перезапуск приложения при помощи supervisor и в качестве отчёта по этом заданию скопируйте в форму отправки домашнего задания тот текст, который вернёт вам обработчик при отправке формы.

#### Задание 4 *

(Не обязательное, но полезное) Опишите коротко все команды, которые вы выполняли в процессе подготовки д/з. Опишите коротко все опции uwsgi, которые задавались при запуске приложения. Опишите коротко все конфигурационные опции из конфиг. файла former.ini. Опишите коротко, что делает каждая строчка кода webrunner.py.
