#!/bin/bash

a=24
b=47

if [ "$a" -eq 24 ] && [ "$b" -eq 47 ]
then
  echo "Первая проверка прошла успешно."
else
  echo "Первая проверка не прошла."
fi

# ОКА:  if [ "$a" -eq 24 && "$b" -eq 47 ]
#          пытается выполнить  ' [ "$a" -eq 24 '
#          и терпит неудачу наткнувшись на ']'.
#
#    if [[ $a -eq 24 && $b -eq 24 ]]   это правильный вариант
#    (в строке 17 оператор "&&" имеет иной смысл, нежели в строке 6.)
#    Спасибо Stephane Chazelas.


if [ "$a" -eq 98 ] || [ "$b" -eq 47 ]
then
  echo "Вторая проверка прошла успешно."
else
  echo "Вторая проверка не прошла."
fi


#  Опции -a и -o предоставляют
#+ альтернативный механизм проверки условий.
#  Спасибо Patrick Callahan.


if [ "$a" -eq 24 -a "$b" -eq 47 ]
then
  echo "Третья проверка прошла успешно."
else
  echo "Третья проверка не прошла."
fi


if [ "$a" -eq 98 -o "$b" -eq 47 ]
then
  echo "Четвертая проверка прошла успешно."
else
  echo "Четвертая проверка не прошла."
fi


a=rhino
b=crocodile
if [ "$a" = rhino ] && [ "$b" = crocodile ]
then
  echo "Пятая проверка прошла успешно."
else
  echo "Пятая проверка не прошла."
fi

exit 0