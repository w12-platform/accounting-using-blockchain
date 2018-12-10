# accounting-using-blockchain

###Формат БД

CREATE DATABASE accounting;

CREATE TABLE accounting.records(  
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,  
	`record_key` INT UNSIGNED NOT NULL,  
	`user_id` MEDIUMINT UNSIGNED NOT NULL,  
	`data` VARCHAR(255) NOT NULL,  
	`write_state` TINYINT UNSIGNED ZEROFILL NOT NULL,  
	`blockchain` TINYINT UNSIGNED ZEROFILL NOT NULL,  
	PRIMARY KEY(`id`)  
);

###API

	Сервер шлет ответы в формате JSON. При возникновении ошибки сервер отвечает объектом {"error": "текст ошибки"} 


###get запросы:

#####getUserRecords

Возвращает несколько записей пользователя по порядку возрастания ключей.


#####параметры:
*user_id* - id пользователя, положительное целое чило 24 бита  
*start_key* - ключ от которого будет осуществляться выдача, положительное целое число 32 бита  
*limit* - максимальное количество возвращаемых данные, минимум 1, максимум 10000, по умолчанию 10

#####поля ответа:
*more* - флаг указывающий что переданы не все данные и следует запросить следующую страницу  
*rows* - массив строк данных - одна строка - запись по ключу   
*key* - ключ данных  
*data* - данные  
*history* - количество записей по ключу - более одного - были исправления  

#####пример ответа:
*{"more":false,"rows":[{"key":"0","data":"user0 0","history":3}]}*



#####getRecord

Возвращает одну запись пользователя.

#####параметры:
*user_id* - id пользователя, положительное целое чило 24 бита  
*key* - ключ, положительное целое число 32 бита  

#####поля ответа:
*key* - ключ данных  
*data* - данные  
*history* - количество записей по ключу - более одного - были исправления


#####пример ответа:
{"key":0,"data":"user0 0 2","history":3}






#####getRecordHistory

Возвращает историю изменений записи.

#####параметры:
*user_id* - id пользователя, положительное целое чило 24 бита  
*key* - ключ, положительное целое число 32 бита  

#####поля ответа:
*rows* - массив строк данных - одна строка - одна запись истории

#####пример ответа:
{"rows":["user0 0","user0 0 1","user0 0 2"]}






#####getRecordsBatch

Возвращает несколько записей по массиву ключей. Если по одному из ключей нет данных возвращает
ошибку *no data*.

#####параметры:
*user_id* - id пользователя, положительное целое чило 32 бита  
*keys* - строка ключей разделенная запятыми, максимальная длинна 128  


#####поля ответа:
*rows* - массив строк данных - одна строка - запись по ключу
*key* - ключ данных  
*data* - данные  
*history* - количество записей по ключу - более одного - были исправления  


#####пример ответа:
{"rows":[{"key":0,"data":"user1 0","history":1},{"key":1,"data":"user1 1 1","history":2}]}