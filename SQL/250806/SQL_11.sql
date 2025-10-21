SELECT rating FROM film
GROUP BY rating; 

SELECT rating, COUNT(*) FROM film
GROUP BY rating;

SELECT rating, COUNT(*) FROM film
WHERE rating = "PG" OR rating = "G"
GROUP BY rating;

# 필름 테이블에서 영화등급이 G등급인 영화 제목을 모두 출력해주세요 
SELECT rating FROM film 
WHERE rating = "G" OR rating ="PG"
GROUP BY rating;

# 필름 테이블에서 영화개봉 년도가 2006년 또는 2007년이고 영화등급이 PG 또는 G등급인 영화 제목만 출력 
SELECT * FROM film LIMIT 1;

SELECT title FROM film
WHERE
	(release_year = 2006 OR release_year = 2007) AND
    (rating = "G" OR rating = "PG");

# film테이블에서 rating으로 그룹을 묶어서 각 등급별 영화갯수와 등급, 각 그룹별 평균 rental_rate를 출력
SELECT * FROM film LIMIT 1;

SELECT 
	rating, COUNT(*), AVG(rental_rate) 
FROM film
GROUP BY rating
ORDER BY AVG(rental_rate) DESC;

SELECT 
	rating, 
    COUNT(*) AS total_fimls,
    AVG(rental_rate) AS avg_rental_rate 
FROM film
GROUP BY rating
ORDER BY avg_rental_rate DESC;

# GROUP BY -> 집계함수를 사용해서 들어오면 해당 컬럼값이 실제 그룹핑과 관계가 없더라고
# 출력 값으로 허용 (*예외조항)

/*
각 등급별 영화 길이가 130분 이상인 영화의 갯수와 등급을 출력 
*/
SELECT rating, COUNT(*) filmcount
FROM film
WHERE length >= 130
GROUP BY rating
ORDER BY filmcount DESC;


