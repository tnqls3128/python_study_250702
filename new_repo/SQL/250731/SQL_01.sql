/*
현재 이 공간을 통해서 SQL 언어를 작성할 예정!
해당 공간에 한 줄씩 코드를 작성 -> 쿼리(문)
하나의 쿼리가 종료되었다는 것을 정의 -> ;
*/

# 1. DB 생성 : CREATE DATABASE dbname
# 2. DB 목록확인 : SHOW DATABASES
# 3. DB 젒속 : USE dbname
# 4. Table 생성 : CREATE TABLE
# 5. Data 삽입 : DROP DATABASE IF EXISTS // DROP DATABASE

/* 
CREATE TABLE mytable(
	id INT, name VARCHAR(50), PRIMARY
);
*/

-- CREATE DATABASE david;
-- USE david;

-- CREATE TABLE mytable(
-- 	id TINYINT UNSIGNED, 
--     name VARCHAR(50), 
--     PRIMARY KEY(id)
-- );

-- CREATE TABLE mytable(
-- 	id FLOAT, 
--     name VARCHAR(50), 
--     PRIMARY KEY(id)
-- );

-- CREATE TABLE mytable(
-- 	id INT UNSIGNED, 
--     name VARCHAR(50), 
--     PRIMARY KEY(id)
-- );

-- CREATE TABLE mytable(
-- 	id INT NOT NULL AUTO_INCREMENT, 
--     name VARCHAR(50), 
--     PRIMARY KEY(id)
-- );

-- CREATE TABLE mytable(
-- 	id INT NOT NULL AUTO_INCREMENT, 
--     name CHAR(50),  # 50개의 문자열이 들어올 수 있는 공간을 항상 준비
--     city VARCHAR(50),  # 최대 50개까지 입력 -> 5개 
--     PRIMARY KEY(id)
-- );

-- CREATE TABLE mytable (
-- 	id INT NOT NULL AUTO_INCREMENT, 
--     name VARCHAR(50),  
--     PRIMARY KEY(id, name) # 하나의 레코드 안에 프라이머리 키는 복수 가능
-- );

CREATE TABLE mytable (
	id INT NOT NULL AUTO_INCREMENT, 
    name VARCHAR(50) NOT NULL,  
    modelnumber VARCHAR(15) NOT NULL,
    series VARCHAR(30) NOT NULL,
    PRIMARY KEY(id)
);
