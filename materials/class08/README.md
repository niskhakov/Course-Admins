### Описание

На этом занятии мы поговорим о мониторинге на примере сервиса Prometheus.

### Домашнее задание

В рамках домашнего задания - вы познакомитесь с установкой и настройкой Prometheus,
а также поставите стандартный экспортер - node_exporter.

Теперь всё готово для проверки работы приложения под uwsgi.

#### Задание 1. Настраиваем Prometheus и Node Exporter

* Скачайте prometheus - https://github.com/prometheus/prometheus/releases/download/v2.3.2/prometheus-2.3.2.linux-amd64.tar.gz 
* Скачайте node_exporter - https://github.com/prometheus/node_exporter/releases/download/v0.16.0/node_exporter-0.16.0.linux-amd64.tar.gz 
* Откройте prometheus.yml в распакованном архиве prometheus и добавьте в targets node_exporter. Должно выглядить:
```yaml
    static_configs:
    - targets: ['localhost:9100','localhost:80']
```
* Запустите node_exporter на стандартном порту.
```bash
./node_exporter &
```
* Запустите prometheus на порту 80. Пока у нас нет доступов по порту 9090 (default). Предварительно остановите приложение former, седланное на предыдущих занятиях. 
Или поменяйте порт, на которому будет слушать приложение.
```bash
./prometheus --web.listen-address="0.0.0.0:80" &
```
* Заходим на http://grafana.fintech-admin.m1.tinkoff.cloud. Учетные данные совпадают с используемыми на ВМ.
* Переключаемся в свою организацию (в левом нижнем углу -> switch). Организация будет называться также как и имя вашего пользователя.
В организации у вас привилегии Admin.
* Заходите в Configuration организации (значок шестеренки слева). Data Sources -> Add data source.
* Name: prometheus. Type: Prometheus. URL: http://your-hostname.fintech-admin.m1.tinkoff.cloud:80. Access: Browser (из-за отсутствия доступов). Жмем "Save & Test". 
Убеждаемся, что "Data source is working"
* Переходим во вкладку Dashboards сверху. Жмем Prometheus 2.0 Stats -> Import.
* Теперь вы можете увидеть этот dashboard во влкадке Dashboards (четыре квадрата слева)
* Скачиваем шаблон dashboard-а для node_exporter: https://grafana.com/dashboards/1860 Справа кнопка "Download JSON" 
* Наводим стрелку на значок "плюс" слева и нажимаем Import. Прикрепляем этот JSON файл. 
* В конечном итоге у вас должно остаться два дашборда: "Prometheus 2.0 Stats" и "Node Exporter Full"

Проверьте, что ваши таргеты описаны в WEB GUI prometheus: http://your-hostname.fintech-admin.m1.tinkoff.cloud/targets

#### Задание 2. Запускаем prometheus и node_exporter в supervisord

Остановите или "убейте" сервисы, запущенные на предыдущих шагах.

Вам необходимо создать ini скрипты для prometheus и node_exporter самостоятельно и убедится, что сервисы prometheus и node_exporter работают.
По аналогии с http-сервисом former.
```
systemctl enable supervisord
systemctl start supervisord
mkdir -p /var/log/prometheus /var/log/node_exporter
```

В результе у вас должны автономно работать сервисы prometheus и node_exporter. И продолжать работать, даже когда вы отключились от консоли.

#### Задание 3. Меняем метод отправки формы

(Не обязательное, но полезное) 

В этом задании мы поставим uwsgi_exporter для сбора метрик с uwsgi приложения.

По умолчанию, uwsgi умеет отдавать метрики. Добавляем в параметры запуска uwsgi-приложения:
```ini
    --stats "127.0.0.1:1717"
    --stats-http
```

Скачиваем экспортер: https://github.com/timonwong/uwsgi_exporter/releases/download/v0.7.0/uwsgi_exporter-0.7.0.linux-amd64.tar.gz

Запускать его надо будет с флагом указания stats.
```bash
--stats.uri="http://127.0.0.1:1717"
```

Этот экспортер также требуется обернуть в supervisord

Также правим конфигурацию prometheus.yml, добавляя новый таргет 'localhost:9117', на котором по-умолчанию слушает uwsgi_exporter.

