CREATE DATABASE IF NOT EXISTS school;
USE school;

-- CREATE TABLE students (
-- 	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
--     PRIMARY KEY(id) 
-- );

CREATE TABLE students (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT UNSIGNED,
    grade VARCHAR(10)
);

DESC students;

INSERT INTO studentS VALUES(3, "강백호", 15, "8");

INSERT INTO students (name, age, grade)
VALUE("서태웅",15,"8");

INSERT INTO students (grade, name, age)
VALUE("10", "채치수",17);

SELECT * FROM students;

INSERT INTO students (grade, name, age)
VALUE("9", "정대만",16);

INSERT INTO students (grade, name, age)
VALUE("9", "송태섭",16);

SELECT * FROM students;
SELECT name FROM students;
SELECT grade FROM students;
SELECT name, grade FROM students;

SELECT * FROM students WHERE age=16 AND name="정대만";  # 대입연산자
SELECT * FROM students WHERE age!=15;  # 부정연산자 -1
SELECT * FROM students WHERE age <> 15;  # 부정연산자 -2