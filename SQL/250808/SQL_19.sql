CREATE DATABASE IF NOT EXISTS index_demo_v1;
USE index_demo_v1;

SHOW VARIABLES LIKE 'default_storage_engine';

CREATE TABLE customers (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    age INT,
    city VARCHAR(100)
);

DESC customers;

# 클러스터형 인덱스, 보조형 인덱스가 다른 필드값에 있는 요소들을 사용할 때보다 연산처리 속도가 빠르다는 것을 확인
# 우선 여러분들의 MySQL안에 설정 및 설치되어있다는 스토리지 엔진(Storage = Engine)
# ENGINE=InnoDB
# MySQL 8.0 이상 버전 부터는 기본 값
# MyISAM 엔진이면 x

INSERT INTO customers (name, email, age, city) values ();

INSERT INTO customers (name, email, age, city)
SELECT
	CONCAT('User', LPAD(FLOOR(RAND() * 100000),5,'0')),
    CONCAT('user', FLOOR(RAND() * 100000), '@test.com'),
    FLOOR(18 + (RAND() * 50)),
    ELT(FLOOR(1 + (RAND() * 5)) ,'Seoul', 'Busan', 'Inchon', 'Daegu', 'Daejeon')
FROM information_schema.tables LIMIT 1000;

SELECT COUNT(*) FROM customers;
SELECT * FROM customers;

# information_schema.tables
# 현재 내가 사용하고 있는 MySQL 워크벤치 안에 있는 전체 테이블 정보 값을 가지고 있는 시스템 테일 = 메타테이블
# MySQL워크벤치 -> 대략적인 테이블 수의 정보를 기준으로 

SHOW INDEX FROM customers;
CREATE INDEX idx_email ON customers(email);
CREATE INDEX idx_age ON customers(age);

SELECT * FROM customers;
EXPLAIN SELECT * FROM customers;   # ALL 377

EXPLAIN SELECT * FROM customers WHERE id = 300;  # const 1

EXPLAIN SELECT * FROM customers WHERE email = 'user95976@test.com';  # const 1

EXPLAIN SELECT * FROM customers WHERE city = 'Busan';  # ALL 377
