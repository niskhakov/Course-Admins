# Admins: HW → БД2

## Задание 1: Установка  и работа с Peewee
	
	1. Выполним команду для установки Peewee:
	```bash
	pip install peewee
	```

	2. Далее напишем небольшой скрипт на Python для работы с Peewee (идем по презентации)

	Файл: orm.py
	```python
	#!/bin/python

	from peewee import *
	db = PostgresqlDatabase("shop_data", user="py_user", password="py_pass", port=6789, host="localhost")

	class Person(Model):
			name = CharField()
			birthday = DateField()
			is_relative = BooleanField()

			class Meta:
					database = db

	class Pet(Model):
			owner = ForeignKeyField(Person, related_name='pets')
			name = CharField()
			animal_type = CharField()

			class Meta:
					database = db
	```
	
	3. Выполним в оболочке python:
	```python
	from orm.py import *
	Person.create_table() 
	Pet.create_table()
	uncle_bob = Person(name='Bob', birthday=date(1960, 1, 15), is_relative=True)
	uncle_bob.save() # Output: 1

	grandma = Person.create(name='Grandma', birthday=date(1935, 3, 1), is_relative=True)
	herb = Person.create(name='Herb', birthday=date(1950, 5, 5), is_relative=False)
	grandma.name = 'Grandma L.'
	grandma.save() # Output: 1
	```
	