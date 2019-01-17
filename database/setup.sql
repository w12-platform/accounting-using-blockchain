CREATE TABLE records(
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`record_key` INT UNSIGNED NOT NULL,
	`user_id` MEDIUMINT UNSIGNED NOT NULL,
	`data` VARCHAR(255) NOT NULL,
	`write_state` TINYINT UNSIGNED ZEROFILL NOT NULL,
	`blockchain` TINYINT UNSIGNED ZEROFILL NOT NULL,
	PRIMARY KEY(`id`)
);
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123';