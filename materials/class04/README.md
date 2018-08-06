### Описание

На этом занятии мы познакомились с основными принципами функционирования системы DNS.

### Домашнее задание

Поднять на своей машине DNS-сервер bind, который был бы мастером для зоны "fintechtestzone". При помощи systemctl сделать его автоматически поднимающимся при старте системы. Сделать его способным отвечать на запросы извне (чтобы слушал не только на 127.0.0.1, но и н внешнем интерфейсе). Обеспечить прохождение следующих тестов (способность отвечать на запросы с localhost-а вы можете проверить сами, а извне проверим мы):

 nslookup fintechtestzone. localhost  
Name:	fintechtestzone  
Address: 127.0.0.1

 nslookup -type=txt fintechtestzone. localhost  
fintechtestzone	text = "Any text"

 nslookup -type=ns fintechtestzone. localhost  
fintechtestzone	nameserver = s-XX.fintech-admin.m1.tinkoff.cloud.

Описать последовательность ваших действий (набор команд и правок в конфигах с краткими комментариями). Описание сдать через форму выполнения домашнего задания на сайте https://fintech.tinkoff.ru.

Подсказка: начинаете с команды:

 yum install -y bind bind-utils