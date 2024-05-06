## Описание файлов репозитория:
* Папка source-files содержит исходные CSV и TXT файлы
* Папка output-files необходима для архивации обработанных данных
* Папка sql-scripts содержит скрипт для создания исходных таблиц и код задач обработки данных внутри пакета
	
## Описание объектов БД:
* Temporary area (именуется как "tmp" в sql-коде) - схема для загрузки необработанных данных. Таблицы в этой схеме не содержит первичных ключей
* Target area (именуется как "ta" в sql-коде) - схема для загрузки обработанных данных
	
## Глоссарий:

* Control Flow - Поток управления
* Data Flow - Поток данных
	
## Подготовка решения к запуску:

1. Cоздать БД, схемы и таблицы скриптом "set_database" из папки "sql-scripts"
2. Открыть "test-ssis-solution.sln" файл и настроить локальную переменную "outFolder" в соответствии с расположением папки "output-files" проекта. Каталоги отделены двойным слешем, так как в дальнейшем будут переданы в C# скрипт.
3. Поменять настройки соединения к СУБД (имя локальной СУБД) и CSV файлам (поменять имеющиеся пути к файлам на локальные пути к файлам в папке source-files)
	
# Описание решения:

1. На первом шаге производится удаление данных из "tmp" схемы, чтобы при перезапуске пакета и повторном импорте данных из CSV в "tmp" слой не было дубликатов данных.
2. Объекты БД создаются скриптом "set_database" из папки "sql-scripts". Объекты БД создаются отдельно, а не внутри SSIS-пакета, так как не имеют непосредственного отношения к процедуре загрузки данных.
3. Данные из CSV файлов загружаются в соответствующие таблицы БД в Temporaty схему. Загрузка данных разбита на два потока управления, чтобы их можно было перезапускать независимо друг от друга (при наличии точки сохранения). Если бы задачи загрузки данных находились в одном потоке управления, но в разных потоках данных, то перезапуск по отдельности был бы невозможен.
4. Производится слияние данных соответствующих таблиц "Temporary" и "Target" схем. Это позволяет избежать ошибок в случае, когда в таблицах есть записи с одинаковыми значениями первичного ключа ID. Отсутствующие данные будут добавлены в "Target" таблицы, а совпадающие значения заменены (обновлены).
5. В папке "output-files" создаётся архивная папка с именем в формате "YYYYMMDD_HHMMSS". Задача выполняется при помощи скрипта на языке C#.
6. Файлы перемещаются в архив для хранения. Процесс выполняется на завершающем этапе, чтобы при перезапуске пакета исходные файлы были доступны в начальном каталоге.