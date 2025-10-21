# 1. category 테이블에서 Comedy, Sports, Family 카테고리의 category_id와 카테고리명을 출력해주세요
SELECT * FROM category LIMIT 10;

SELECT category_id, name
FROM category
WHERE 
	name = "Comedy" OR
    name = "Sports" OR
    name = "Family";
    
SELECT category_id, name
FROM category
WHERE 
	name IN ("Comedy","Sports","Famliy");

# 2. film_category 테이블에서 카테고리 ID별 영화 갯수 확인 및 출력
SELECT * FROM film_category ;

SELECT category_id, COUNT(*)
FROM film_category
GROUP BY category_id;

#3. 카테고리가 Comedy인 영화 갯수 확인 및 출력 (*JOIN으로 작성)
SELECT * FROM category ;
SELECT * FROM film_category ;

SELECT C.name, COUNT(*)
FROM category C
JOIN film_category F USING (category_id)
WHERE C.name = "Comedy";

#4. 카테고리가 Comedy인 영화 갯수 확인 및 출력 (*서브쿼리로 작성)
SELECT COUNT(*) FROM film_category
WHERE category_id IN (
	SELECT category_id FROM category
    WHERE name = "Comedy"
);

#5. Comedy, Sports, Family 각각의 카테고리별 영화 수 확인하기 (JOIN사용)
SELECT C.name, COUNT(*)
FROM category C
JOIN film_category F USING (category_id)
WHERE C.name IN ("Comedy","Sports","Family")
GROUP BY C.category_id;

#6. 각 카테고리를 기준으로 영화 갯수가 70이상인 카테고리명을 출력해주세요
SELECT 
    name, COUNT(*) AS category_count
FROM
    category C
        JOIN
    film_category F USING (category_id)
GROUP BY C.category_id
HAVING COUNT(*) >= 70;

#7. 각 카테고리에 포함된 영화들의 렌탈 횟수 구하기
# 렌탈횟수 => 현재 우리가 가지고 있는 DVD 전체 총 아이템을 기준으로 각 아이템들이 몇번씩 렌탈이 되었는가
# 렌탈정보 => rental => inventory_id, film_id
# inventory => inventory_id, film_id
# film_category => film_category
# category => category_id

SELECT C.name, COUNT(*)
FROM category C
JOIN film_category F USING(category_id)
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY C.category_id;

#8. Comedy, Sports, Family 카테고리에 포함되는 영화들의 렌탈 횟수 구하기
SELECT C.name, COUNT(*)
FROM category C
JOIN film_category F USING(category_id)
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
WHERE C.name IN ("Comedy","Sports","Family")
GROUP BY C.category_id;

#9. 카테고리가 Comedy인 데이터의 렌탈 횟수 출력 (*서브쿼리문법으로 작성)
SELECT COUNT(*)
FROM rental
WHERE inventory_id IN (
	SELECT inventory_id FROM inventory WHERE film_id IN (
		SELECT film_id FROM film_category WHERE category_id IN(
        SELECT category_id FROM category
        WHERE name = "comedy"
        ) 
    )
);




