CREATE DATABASE IF NOT EXISTS interparkmkt;
USE interparkmkt;

CREATE TABLE IF NOT EXISTS performances (
	id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    data_range VARCHAR(100),
    place VARCHAR(100)
);

DESC performances;
SELECT * FROM performances;