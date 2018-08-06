# Admins: HW → БД
```
    Домашнее задание
    
    Цель - научиться устанавливать, запускать postgres и научиться выполнять базовые команды SQL из python.
    
    Задание 1. Установить postgres server из репозитория CentOS
    
    yum install postgresql-server
    
    Далее необходимо запустить сервер postgres, установив в конфиге размер разделяемой памяти сервера 512мб, work_mem 32mb и настроив конфиг так, чтобы сервер слушал подключения по порту 6789 со всех ip.
    
    Задание 2. Создать БД и наполнить ее данными
    
    Создать базу данных shop_data через psql.
    (проверить можно \l+ в psql)
    
    Далее нужно написать небольшой python-скрипт, делающий следующее:
    
    
    Подключиться к созданной БД из python, используя любую подходящую библиотеку. параметры подключения лучше убрать в отдельный конфиг. Подключение к БД password или md5, никаких trust
    
    Создать три таблицы: 
    
    
    customers (cust_id serial, first_nm varchar(100), last_nm varchar(100)), Primary key - cust_id
    orders (order_id serial, cust_id, order_dttm timestamp, status varchar(20)), Primary key - order_id, foreign key - customers.cust_id
    goods (good_id serial, vendor varchar(100), name varchar(100), description varchar(300)), Primary key - good_id
    order_items (order_item_id serial, order_id, good_id, quantity int), Primary key - order_item_id, foreign key - order_id, foreign key - good_id
    
    
    Наполнить их данными (данные можно придумать на ходу - по паре строк в каждую таблицу).
    
    Написать функции добавления товара в заказ, удаления товара из заказа, изменения количества заказанного товара.
    сделать выгрузку всех товаров всех заказов с указанием имени заказчика и наименования товара + его производителя в текстовый файл
```

# Ход работы: 
## Задание 1 : Установка Postgres server


1. Выполнили команду `yum install postresql-server` 


2. Также установили `postgresql-contrib` 


3. `postgresql-setup initb` 


4. В файле /var/lib/pgsql/data/postgresql.conf

    * Добавили строчку: listen_adresss=’*’ для прослушки со всех ip 
    * shared_buffers=512MB
    * work_mem=32MB


5. Также изменим файл pg_hba.conf. Заменим ident на md5 - вход по паролю

    ```
    # "local" is for Unix domain socket connections only
    local   all             all                                     peer
    # IPv4 local connections:
    host    all             all             127.0.0.1/32            md5
    # IPv6 local connections:
    host    all             all             ::1/128                 md5
    ```


6. Порт изменяется не в файле  postgresql.conf, а задается файлом systemd

    Создадим файл /etc/systemd/system/postgresql.service

    ```
    .include /lib/systemd/system/postgresql.service
    [Service]
    Environment=PGPORT=6789
    ```

7. Дали права на исполнение файлу, и перезапустили сервис: 

    ```
    chmod +x postgresql.service
    systemctl restart postgresql
    ```


## Задание 2 : Работа с БД
1. Запускаем программу psql и работаем уже в ней: 

    `sudo -i -u postgres psql -p 6789`

    Примечание: запускаем программу от пользователя postgres (он был создан при установке postgres-server), и говорим программе, что сервер работает на порту 6789.


2. Создаем базу данных shop_data в psql (не забыли ; - это важно)
    ```
    postgres=# CREATE DATABASE shop_data;
    postgres=# \l+
    ** получили список баз данных **
    ```

3. Чуть не забыли: создадим нового пользователя БД и дадим все разрешения на работу с базой этому пользователю
    ```
    postgres=# CREATE USER py_user WITH ENCRYPTED PASSWORD 'py_pass';
    postgres=# GRANT ALL PRIVILEGES ON DATABASE shop_data TO py_user;
    ```

4. Теперь для работы с базой данных из Python, нам нужно установить модуль psycopg, но перед этим установим pip (пакетный менеджер для python)  и обновим его
    ```
    yum install python-pip
    pip install --upgrade pip
    pip install psycopg2-binary
    ```


5. Питоновское окружение готово для решения наших задач. Теперь пишем скрипт для работы с базой данных через драйвер psycopg2. 

    Скрипт находится в папке personal/homework/lesson6/

