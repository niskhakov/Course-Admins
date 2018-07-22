#!/bin/bash

# Присваивание значения переменным и подстановка

a=375
hello=$a


#-------------------------------------------------------------------------
# Использование пробельных символов
# с обеих сторон символа "=" присваивания недопустимо.

#  Если записать "VARIABLE =value",
#+ то интерпретатор попытается выполнить команду "VARIABLE" с параметром "=value".

#  Если записать "VARIABLE= value",
#+ то интерпретатор попытается установить переменную окружения "VARIABLE" в ""
#+ и выполнить команду "value".
#-------------------------------------------------------------------------

echo hello 	# Не ссылка на переменную
echo $hello
echo ${hello} 	# Идентично предыдущей строке

echo "$hello"
echo "${hello}"

echo

hello="A B  C   D"
echo $hello		# A B C D
echo "$hello"	# A B  C   D
# Здесь вы сможете наблюдать различия в выводе echo $hello и echo "$hello".
# Заключение ссылки на переменную в кавычки сохраняет пробельные символы.

echo

echo '$hello'

hello=
echo "\$hello (пустое значение) = $hello"

# --------------------------------------------------------------

#  Допускается присваивание нескольких переменных в одной строке,
#+ если они отделены пробельными символами.
#  Внимание! Это может снизить читабельность сценария и оказаться непереносимым.

var1=variable1 var2=variable2 var3=variable3
echo
echo "var1=$var1 var2=$var2 var3=$var3"

echo; echo

numbers="один два три"
other_numbers="1 2 3"
# Если в значениях переменных встречаются пробелы,
# то использование кавычек обязательно.
echo "number = $numbers"
echo "other_numbers = $other_numbers"
echo 

echo "uninitialized_variable = $uninitialized_variable"
uninitialized_variable=   #  Объявление неинициализированной переменной
                          #+ (то же, что и присваивание пустого значения, см. выше).
echo "uninitialized_variable = $uninitialized_variable"
                          # Переменная содержит "пустое" значение.

uninitialized_variable=23       # Присваивание.
unset uninitialized_variable    # Сброс.
echo "uninitialized_variable = $uninitialized_variable"
                                # Переменная содержит "пустое" значение.

echo

exit 0