# accounting-using-blockchain
w12 accounting using blockchain project

Формат таблицы

`
CREATE TABLE test.records(
	"id" INT(11) NOT NULL AUTO_INCREMENT,
	"record_key" INT(11) NOT NULL,
	"user_id" INT(11) NOT NULL,
	"data" CHAR(128) NOT NULL,
	"write_flag" BOOL NOT NULL,
	"blockchain" CHAR(1) NOT NULL,
	PRIMARY KEY("id")
`


##API

###getUserRecords
get запрос

параметры:  
*user_id* - id пользователя, положительное целое чило 32 бита  
*start_key* - ключ от которого будет осуществляться выдача, положительное целое число 32 бита  
*limit* - максимальное количество возвращаемых данные, минимум 1, максимум 10000, по умолчанию 10

ответ


###getRecord
get запрос


###getRecoistory
get запрос


###getRecordsBatch
get запрос




