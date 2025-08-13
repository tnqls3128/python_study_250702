-- CREATE DATABASE IF NOT EXISTS Dave;
-- USE Dave;

CREATE TABLE mytable (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
    modelnumber VARCHAR(15) NOT NULL,
    series VARCHAR(30) NOT NULL,
    PRIMARY KEY(id)
);

-- DESC mytable;

-- ALTER TABLE mytable MODIFY COLUMN 
-- name VARCHAR(20) NOT NULL;
-- ALTER TABLE mytable CHANGE COLUMN 
-- modelnumber model_number VARCHAR(10) NOT NULL;
-- ALTER TABLE mytable CHANGE COLUMN
-- series model_type VARCHAR(10);
-- ALTER TABLE mytable MODIFY
-- model_type VARCHAR(10) NOT NULL;

-- DROP TABLE IF EXISTS mytable;
CREATE TABLE model_info (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    model_num VARCHAR(10) NOT NULL,
    model_type VARCHAR(10) NOT NULL,
    PRIMARY KEY(id)
);

