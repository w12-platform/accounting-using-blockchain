CREATE TABLE records(
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`record_key` INT UNSIGNED NOT NULL,
	`user_id` MEDIUMINT UNSIGNED NOT NULL,
	`data` VARCHAR(255) NOT NULL,
	`write_state` TINYINT UNSIGNED ZEROFILL NOT NULL,
	`blockchain` TINYINT UNSIGNED ZEROFILL NOT NULL,
	`trx_id` VARCHAR(255) NOT NULL,
	`bc_key` VARCHAR(255) NOT NULL,
	PRIMARY KEY(`id`)
);
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '78DnW946U9r726oBuga6';
GRANT ALL ON *.* to 'root'@'%' IDENTIFIED BY '78DnW946U9r726oBuga6';