### Описание

На этом занятии были рассмотрены основы СУБД PostgreSQL, установка, первичная настройка и работа с БД из python.


### Домашнее задание

Цель - научиться устанавливать, запускать postgres и научиться выполнять базовые команды SQL из python.

Задание 1. Установить postgres server из репозитория CentOS

yum install postgresql-server

Далее необходимо запустить сервер postgres, установив в конфиге размер разделяемой памяти сервера 512мб, work_mem 32mb и настроив конфиг так, чтобы сервер слушал подключения по порту 6789 со всех ip.

Задание 2. Создать БД и наполнить ее данными

Создать базу данных shop_data через psql.
(проверить можно \l+ в psql)

Далее нужно написать небольшой python-скрипт, делающий следующее:
1. Подключиться к созданной БД из python, используя любую подходящую библиотеку. параметры подключения лучше убрать в отдельный конфиг. Подключение к БД password или md5, никаких trust
2. Создать три таблицы: 
    - customers (cust_id serial, first_nm varchar(100), last_nm varchar(100)), Primary key - cust_id
    - orders (order_id serial, cust_id, order_dttm timestamp, status varchar(20)), Primary key - order_id, foreign key - customers.cust_id
    - goods (good_id serial, vendor varchar(100), name varchar(100), description varchar(300)), Primary key - good_id
    - order_items (order_item_id serial, order_id, good_id, quantity int), Primary key - order_item_id, foreign key - order_id, foreign key - good_id

    Наполнить их данными (данные можно придумать на ходу - по паре строк в каждую таблицу).

3. Написать функции добавления товара в заказ, удаления товара из заказа, изменения количества заказанного товара.
4. сделать выгрузку всех товаров всех заказов с указанием имени заказчика и наименования товара + его производителя в текстовый файл
