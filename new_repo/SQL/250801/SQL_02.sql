USE school;
DESC students;
SELECT * FROM students;

ALTER TABLE students MODIFY COLUMN
age VARCHAR(20);

UPDATE students SET age = "15세" WHERE id = 1;
UPDATE students SET age = "17세" WHERE id = 2;
UPDATE students SET age = "15세" WHERE id = 3;
UPDATE students SET age = "17세" WHERE id = 4;
UPDATE students SET age = "16세" WHERE id = 5;
UPDATE students SET grade = "8학년" WHERE id = 1;
UPDATE students SET grade = "10학년" WHERE id = 2;
UPDATE students SET grade = "8학년" WHERE id = 3;
UPDATE students SET grade = "10학년" WHERE id = 4;
UPDATE students SET grade = "9학년" WHERE id = 5;

SELECT name FROM students;
SELECT name, age FROM students;
SELECT * FROM students WHERE age = "16세";
SELECT * FROM students WHERE age != "16세";
SELECT * FROM students WHERE age <> "16세";
SELECT * FROM students WHERE age > "16세";
SELECT * FROM students WHERE age <= "15세";

SELECT * FROM students WHERE grade != "10학년";

SELECT * FROM students 
WHERE age >= "15세" and grade = "10학년" ;

SELECT * FROM students 
WHERE age <= "16세" or grade = "8학년" ;

SELECT * FROM students 
WHERE name LIKE "%태%";  # %는 0개여도 되고, 1개여도 됨

SELECT * FROM students 
WHERE name LIKE "_태_";  # %보다 엄격하게 일치하는 데이터를 찾아오고자 할 때

SELECT * FROM students 
WHERE name LIKE "____";  # # 이름이 4글자일때 자릿수 