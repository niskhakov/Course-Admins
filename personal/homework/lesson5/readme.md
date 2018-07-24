# Admins: HW → WEB

Актуальная версия находится по адресу: [+Dropbox Paper: Admins: HW → WEB](https://paper.dropbox.com/doc/Admins-HW-WEB-Avoss3tD1CtyfWYir1v7S) 

Также ссылка на репозиторий: [+GitHub: Admins: HW → WEB](https://github.com/niskhakov/Admins/tree/Homework5/personal/homework/lesson5)

# Ход работы:
## 1 Часть: Запуск “former” под uWSGI


1. Забрали данные из сервера gitlab: `git pull origin`


2. Добавили исполнение файлу prepare.sh и выполнили его


3. Выполнили :
	```
    mkdir -p /opt/webcode/
    cp -R /root/homework/materials/class05/src/former /opt/webcode
    ```


4. Запускаем:
    
    ```uwsgi --plugins=python --http-socket=0.0.0.0:80 --wsgi-file /opt/webcode/former/process/webrunner.py --static-map /form=/opt/webcode/former/form/index.html --processes=5 --master --pidfile=/tmp/formdig.pid --vacuum --max-requests=5000```


5. Получаем ошибку, приложение не смогло получить порт 80; посмотрели список использованных портов `netstat -natp`, нашли старого друга: tinyhttpd, убили его) `kill <id>`


6. Запустил еще раз: все окей.
  Немного не понял как оформить отчет по первому заданию (Строку запуска uwsgi приложения????). Пусть будет так:
    
    ```uwsgi --plugins=python --http-socket=0.0.0.0:80 --wsgi-file /opt/webcode/former/process/webrunner.py --static-map /form=/opt/webcode/former/form/index.html --processes=5 --master --pidfile=/tmp/formdig.pid --vacuum --max-requests=5000```


![](https://d2mxuefqeaa7sj.cloudfront.net/s_92671068C3A0202807075FDEF0E7A127E23C1E94D764E55E74F0CD78CD383F8C_1532461500585_Form.png)

![](https://d2mxuefqeaa7sj.cloudfront.net/s_92671068C3A0202807075FDEF0E7A127E23C1E94D764E55E74F0CD78CD383F8C_1532461528658_Form2.png)



7. Останавлиаем uwsgi → Ctrl+C


## 2 Часть: Запуск “former” под supervisor+uWSGI


8. Выполняем команды:
    ```
    systemctl enable supervisord
    systemctl start supervisord
    mkdir -p /var/log/webapps
    cp /root/homework/materials/class05/src/former.ini /etc/supervisord.d/
    supervisorctl reread
    supervisorctl update
    ```


9. Понимаем, что супервизор нормально работает
    ```[root@s-7 ~]# supervisorctl status
    former                           RUNNING   pid 28048, uptime 0:02:54
    [root@s-7 ~]# supervisorctl stop former
    former: stopped
    [root@s-7 ~]# supervisorctl status
    former                           STOPPED   Jul 24 10:51 PM
    [root@s-7 ~]# supervisorctl start former
    former: started
    [root@s-7 ~]# supervisorctl status
    former                           RUNNING   pid 28058, uptime 0:00:07
	```

10. URL доступа к приложению ????
  Ну окей: http://s-7.fintech-admin.m1.tinkoff.cloud/form



## 3 Часть: Изменение метода отправки формы
11. Запускаем: 
    `vim /opt/webcode/former/form/index.html`


12. Заменяем метод с POST на GET или просто убираем ключ method (по умолчанию будет использоваться GET)
    ```
    <html>
      <head>
        <title>Test Page</title>
      </head>
      <body>
        <h2>Test form</h2>
        <p>
          <form action="/process" method="get">
            Name:
            <br>
            <input type="text" name="Name"/>
            <br>
            Age:
            <br>
            <input type="text" name="Age"/>
            <br>
            <input type="submit"/>
          </form>
      </p>
      </body>
    </html>
    ```
    


13. Сервер не перезапускал, и так съел)


14. Получил в ответ текст: (что соответствует GET запросу)
	```
    Method: GET
    Get content: /process?Name=Nail&Age=21
    Post content: 
    ```


## 4 часть: Доп. задания

**4.1.** 

- **mkdir -p** - создание директории и недостающие родительские каталоги
- **cp -R -** рекурсивное перемещение
- **netstat -natp** - показывает все сетевые соединения  по TCP и соотв. программы
****- **uwsgi** - в следующем пункте
- **kill** - отправляет сигнал в приложение
- **systemctl enable <serv>** - создает симлинк, для того чтобы сервис был запущен во после старта системы
- **systemctl start <serv>** - стартует сервис
- **supervisorctl reread** - перезагружает конфиги сервиса без рестарта
- **supervisorctl update** - перезагружает конфиги сервиса и делает рестарт
- **supervisorctl status** - информация о процессах
- **supervisotctl start** - запускает процесс
- **supervisorctl stop** - останавливает процесс

**4.2.**

    uwsgi --plugins=python --http-socket=0.0.0.0:80 --wsgi-file /opt/webcode/former/process/webrunner.py --static-map /form=/opt/webcode/former/form/index.html --processes=5 --master --pidfile=/tmp/formdig.pid --vacuum --max-requests=5000
    
- --plugins - загрузить Питоновский uWSGI плагин
- --http-socket - прибиндить к определенному  tcp сокету используя http протокол
- --wsgi-file - файл будет исполняться 
- --static-map - словарь (путь=файл)
- --processes - количество воркеров
- --master - запускает мастер процесс, который будет перезапускать воркеров, когда те будут падать
- -pidfile - создает pidfile
- --vacuum - пытается удалить все сгенерированные файлы\сокеты
- --max-requests - перезагружает воркеров, после указанного количества обработанных запросов

**4.3.**

В начале повторяется всё то, что было описано в предыдущем пункте.
- stopsignal=quit - сигнал используемый для остановки приложения, когда вызвана команда stop
- autostart=true - программа будет запущена автоматически, когда будет запущен супервизор
- startretries=10 - количество попыток запустить приложения, до тех пор пока супервизор не сдастся
- startsecs=0 - программа не обязана оставаться запущенной в течение какого-то промежутка времени
- stopwaitsecs=10 - если программа не завершится stop-ом до истчения 10 сек, то супервизор  отправит сигнал sigkill
- stopasgroup=true - отправляет сигнал на завершение всей группе процессов (и к воркерам тоже)

- stdout_logfile - путь к файлу стандартного вывода
- stdout_logfile_maxbytes - макс размер файла логов, после будет ротация
- stdout_logfile_backups - количество бэкап файлов, который будет держать супервизор
- stdout_capture_maxbytes - макс размер буфера в capture-mode

- stderr_logfile - путь к файлу ст. выводу ошибок
- stderr_logfile_maxbytes - аналогично выше

**4.4.**


    #!/usr/bin/python 
    # Вызов интерпретатора Python
    
    from cgi import parse_qs # импортирование библиотеки parse query string
    
    def application(env, start_response): # Определение функции, принимает окружение и обработчик запросв
        start_response('200 OK', [('Content-Type','text/plain')]) # Записываем в о.запросов хэдеры
    
        wsgi_content = env["wsgi.input"].read(0) # Прочитать всё тело запроса 
        request_uri_content = env["REQUEST_URI"] # Получение URI из запроса 
        request_method_content = env["REQUEST_METHOD"] # Получение HTTP метода из запроса
        d = parse_qs(wsgi_content) # Парсит строку запроса (query string) и записывает все данные в словарь с соответствующими ключами (не используется)
        return ["Method: " + request_method_content + "\n" +
            "Get content: " + request_uri_content + "\n" +
            "Post content: " + wsgi_content + "\n"] # Формирует тело страницы и возвращает вызвавшей её функции
    

