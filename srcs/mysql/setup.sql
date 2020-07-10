GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON *.* TO 'wp'@'%' IDENTIFIED BY 'wp';
GRANT ALL PRIVILEGES ON *.* TO 'pma'@'%' IDENTIFIED BY 'pma';
FLUSH PRIVILEGES;
FLUSH HOSTS;
CREATE DATABASE wp;
USE wp;
CREATE TABLE example ( id smallint unsigned not null auto_increment, name varchar(20) not null, constraint pk_example primary key (id) );
INSERT INTO example ( id, name ) VALUES ( 1, 'Sample data' );