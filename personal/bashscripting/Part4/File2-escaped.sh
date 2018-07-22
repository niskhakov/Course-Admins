#!/bin/bash
# экранированные символы

echo; echo

echo "\v\v\v\v"      # Вывод последовательности символов \v\v\v\v.
# Для вывода экранированных символов следует использовать ключ -e.
echo "============="
echo "ВЕРТИКАЛЬНАЯ ТАБУЛЯЦИЯ"
echo -e "\v\v\v\v"   # Вывод 4-х вертикальных табуляций.
echo "=============="

echo "КАВЫЧКИ"
echo -e "\042"       # Выводит символ " (кавычки с восьмеричным кодом ASCII 42).
echo "=============="

# Конструкция $'\X' делает использование ключа -e необязательным.
echo; echo "НОВАЯ СТРОКА И ЗВОНОК"
echo $'\n'           # Перевод строки.
echo $'\a'           # Звонок (сигнал).

echo "==============="
echo "КАВЫЧКИ"
# Bash версии 2 и выше допускает использование конструкции $'\nnn'.
# Обратите внимание: здесь под '\nnn' подразумевается восьмеричное значение.
echo $'\t \042 \t'   # Кавычки (") окруженные табуляцией.

# В конструкции $'\xhhh' допускается использовать и шестнадцатеричные значения.
echo $'\t \x22 \t'  # Кавычки (") окруженные табуляцией.
# Спасибо Greg Keraunen, за это примечание.
# Ранние версии Bash допускали употребление конструкции в виде '\x022'.
echo "==============="
echo


# Запись ASCII-символов в переменную.
# ----------------------------------------
quote=$'\042'        # запись символа " в переменную.
echo "$quote Эта часть строки ограничена кавычками, $quote а эта -- нет."

echo

# Конкатенация ASCII-символов в переменную.
triple_underline=$'\137\137\137'  # 137 -- это восьмеричный код символа '_'.
echo "$triple_underline ПОДЧЕРКИВАНИЕ $triple_underline"

echo

ABC=$'\101\102\103\010'           # 101, 102, 103 это  A, B и C соответственно.
echo $ABC

echo; echo

escape=$'\033'                    # 033 -- восьмеричный код экранирующего символа.
echo "\"escape\" выводится как $escape"
#                                   вывод отсутствует.

echo; echo

exit 0