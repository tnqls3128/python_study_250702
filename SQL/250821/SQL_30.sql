#10. address테이블에는 address_id가 있지만 customer 테이블에는 없는 데이터 갯수 출력
# (*INNER JOIN)
USE sakila;
SELECT * FROM address; #603
SELECT * FROM customer; # 599

SELECT
	COUNT(A.address_id)
FROM address A
JOIN customer C USING(address_id);

SELECT
	(SELECT COUNT(*) FROM address) -
	(SELECT
		COUNT(A.address_id)
	FROM address A
	JOIN customer C USING(address_id)) AS no_customer_address;

# 1 + 2 = 3
# RIGHT OUTER JOIN

SELECT COUNT(*) AS no_customer_address
FROM customer C
RIGHT JOIN address A
ON A.address_id = C.address_id
WHERE customer_id IS NULL;

#11. 캐나다 고객에게 이메일 마케팅 캠페인을 진행하고자 합니다.
#캐나다 고객의 이름과 이메일 주소 리스트를 출력해주세요
SELECT CONCAT(CU.first_name," ", CU.last_name) AS name, CU.email
FROM customer CU
JOIN address A  USING(address_id)
JOIN city CI USING(city_id)
JOIN country CO USING(country_id)
WHERE CO.country = "Canada";

#12. 신혼부부 타겟고객들의 매출이 최근 저조해져서 가족 영화를 홍보대상으로 삼고자합니다.
#가족 영화로 분류된 모든 영화 리스트를 출력해주세요
SELECT C.name, F.title
FROM category C
JOIN film_category FC USING (category_id)
JOIN film F USING (film_id)
WHERE name = "Family";

#13. 가장 자주 대여하는 영화리스트를 참고로 보고 싶습니다 가장 자주 대여하는 영화순으로 100개만 뽑아주세요
# 뽑아달른 것의 의미는 "영화제목"과 "렌탈횟수"
SELECT F.title, COUNT(*) AS rental_count
FROM rental R
JOIN inventory I USING(inventory_id)
JOIN film F USING(film_id)
GROUP BY F.film_id
ORDER BY rental_count DESC
LIMIT 100;

#14. 각 스토어별로 매출을 확인하고 싶습니다 관련 데이터를 출력해주세요
#도시, 국가 // 스토어ID // 스토어별 총 매출
SELECT 
	CONCAT(CI.city, " ", CO.country) AS store,
    STO.store_id AS Store_ID,
    SUM(P.amount) AS total_sales
FROM payment P
JOIN staff STA ON P.staff_id = STA.staff_id
JOIN store STO ON STA.store_id = STO.store_id
JOIN address A ON A.address_id = STO.address_id
JOIN city CI ON A.city_id = CI.city_id
JOIN country CO ON CI.country_id = CO.country_id
GROUP BY STO.store_id;

#15. 가장 렌탈비용을 많이 지불한 상위 10명의 VIP고객에게 선물을 배송하고자 합니다
# 해당 VIP고객들의 이름, 주소와 이메일, 그리고 각 고객별 그동안 총 지불 비용을 출력해주세요
SELECT
	CONCAT(CU.first_name, " ", CU.last_name) AS Name,
    A.address,
    CU.email,
	SUM(P.amount) AS Total_Amount
FROM payment P
JOIN customer CU ON P.customer_id = CU.customer_id
JOIN address A ON A.address_id = CU.address_id
GROUP BY CU.customer_id
ORDER BY Total_Amount DESC
LIMIT 10;

#16. actor 테이블의 배우 이름을 fist_name과 last_name의 조합으로 출력 단, 소문자로
# Actor_Name이라는 필드명으로 출력
SELECT 
	LOWER(CONCAT(first_name, " ", last_name)) AS Actor_Name
FROM actor;

SELECT 
	CONCAT(
		UPPER(LEFT(first_name, 1)), 
        LOWER(SUBSTRING(first_name, 2)),
        " ",
        UPPER(LEFT(last_name, 1)), 
        LOWER(SUBSTRING(last_name, 2))
        ) AS Actor_Name
FROM actor;

#17. 언어가 영화인 영화 중 영화 타이틀이 K와 Q로 시작하는 영화의 타이틀만 출력 (*서브쿼리로)
SELECT title
FROM film 
WHERE language_id = (
	SELECT language_id 
    FROM language
    WHERE name = 'English'
) 
AND (title LIKE "K%" OR title LIKE "Q%");

#18. Alone Trip에 나오는 배우 이름을 하나의 문장으로 모두 출력해주세요
# 단 배우이름은 actor_name이라는 필드명으로 출력해주세요 (*서브쿼리로)
SELECT CONCAT(first_name, " ", last_name) AS actor_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
    FROM film_actor
    WHERE film_id = (
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
    )
);

#19. 2005년 8월에 각 스태프 멤버가 올린 매출을 출력해주세요
# 스태프 멤버 필드명은 Staff_Member로 매출 필드명은 Total_Amount로 출력
SELECT 
    CONCAT(first_name, " ", last_name) AS Staff_Member,
    SUM(amount) AS Total_Amount
FROM payment 
JOIN staff USING(staff_id)
WHERE payment_date LIKE "2005-08%"
GROUP BY staff_id;

SELECT 
	CONCAT(first_name, " ", last_name) AS Staff_Member,
    SUM(amount) AS Total_Amount
FROM payment 
JOIN staff USING(staff_id)
WHERE
	EXTRACT(YEAR FROM payment_date) = 2005 AND
    EXTRACT(MONTH FROM payment_date) = 8
GROUP BY staff_id ;

SELECT 
	CONCAT(first_name, " ", last_name) AS Staff_Member,
    SUM(amount) AS Total_Amount
FROM payment 
JOIN staff USING(staff_id)
WHERE
	YEAR(payment_date) = 2005 AND
    MONTH(payment_date) = 8
GROUP BY staff_id ;

#20. 각 카테고리의 평균 영화 러닝타임이 전체 평균 러닝타임보다 큰 카테고리들의 
# 카테고리명과 해당 카테고리의 평균 러닝 타임을 출력하세요
SELECT C.name, AVG(F.length) film_length
FROM category C
JOIN film_category FC USING(category_id)
JOIN film F USING(film_id)
GROUP BY category_id
HAVING AVG(F.length) > (
	SELECT AVG(length) FROM film
);

#21. 각 카테고리별 평균 영화 대여 시간과 해당 카테고리명을 출력
# 영화대여시간 => 영화 대여 및 반납 시간의 차이, hour를 단위로 사용하세요
/* 대여시간 : rental => inventory
inventory : inventory_id & film_id
film_category : category_id & film_id 
categoty : category_id */ 

SELECT 
	C.name,
    AVG(TIMESTAMPDIFF(HOUR, R.rental_date, R.return_date)) AS diff_time
FROM rental R
JOIN inventory I USING (inventory_id)
JOIN film_category F USING(film_id)
JOIN category C USING(category_id)
GROUP BY C.name;

#22. 새로운 임원이 부임했습니다. 총 매출액 상위 5개 장르의 매출액을 수시로 확인하고자 합니다
#각 장르별 총 매출액(*Total Sales), 각 장르이름(*Genre)로 해당 데이터를 수시로 확인할 수 있는 VIEW를 생성해주세요
#VIEW의 이름은 top5_genres로 만들어주시고 총 매출액 상위 5개 장르의 매출액이 출력될 수 있도록

CREATE OR REPLACE VIEW top5_genres AS 
	SELECT 
		C.name AS Genre, 
        SUM(P.amount) AS Total_Sales
	FROM payment P
	JOIN rental R USING(rental_id)
	JOIN inventory I USING(inventory_id)
	JOIN film_category FC USING(film_id)
	JOIN category C USING(category_id)
	GROUP BY C.name
    ORDER BY Total_Sales DESC
    LIMIT 5;
    
SELECT * FROM top5_genres;
DROP VIEW top5_genres;

#23. 2005년 5월에 가장 많이 대여된 영화 3개를 찾아주세요 영화 제목과 대여횟수 출력
SELECT 
	F.title,
	COUNT(*) AS rental_count
FROM rental R 
JOIN inventory I USING(inventory_id)
JOIN film F USING(film_id)
WHERE 
	YEAR(R.rental_date) = 2005 AND
    MONTH(R.rental_date) = 5
GROUP BY F.film_id
ORDER BY rental_count DESC
LIMIT 3;

#24. 대여된 적이 없는 영화를 찾으세요
SELECT title
FROM film 
WHERE film_id NOT IN (
	SELECT film_id FROM inventory I
    JOIN rental R USING(inventory_id)
);

#25. 각 고객의 총 지출 금액의 평균 보다 총 지출 금액이 더 큰 고객 리스트를 찾으세요
#그들의 이름과 그들이 지출한 총 금액을 보여주세요
# 고객 A 5번 렌트, 총 100달러
# 고객 B 3번 렌트, 총 80달러
# 고객당 평균 지출금액 90달러 
SELECT 
	C.first_name, C.last_name,
    SUM(P.amount)
FROM payment P
JOIN customer C USING(customer_id)
GROUP BY C.customer_id
HAVING SUM(P.amount) > (
	SELECT
		AVG(sum_amount)
	FROM (
	SELECT SUM(amount) AS sum_amount
	FROM payment
	GROUP BY customer_id
	) AS sub_query
);

#26. 가장 많은 결제건을 처리한 직원이 누구인지 찾아주세요
SELECT 
	S.staff_id, S.first_name, S.last_name, 
    COUNT(*) AS count_many
FROM staff S
JOIN payment USING(staff_id)
GROUP BY S.staff_id
ORDER BY count_many DESC
LIMIT 1;

#27. "액션" 카테고리에서 높은 영화 영상 등급을 받은 순으로 상위 5개의 영화를 보여주세요
# (*높은 영화 영상 등급 순으로의 정렬은 ORDER BY rating DESC)
SELECT F.title, F.rating
FROM film F
JOIN film_category FC USING(film_id)
JOIN category C USING(category_id)
WHERE C.name = 'Action'
ORDER BY F.rating DESC
LIMIT 5;

SELECT
	DISTINCT rating
FROM film;

DESC film;

#28. 각 영화영상등급을 기준으로 영화별 대여기간의 평균을 찾아주세요
SELECT rating, AVG(rental_duration)
FROM film
GROUP BY rating;

#29. 매장 ID별 총 매출을 보여주는 VIEW를 생성하세요
CREATE OR REPLACE VIEW ID_Amount AS 
	SELECT S.store_id, SUM(P.amount)
	FROM payment P
	JOIN staff S USING(staff_id)
	JOIN store ST USING(store_id)  
	GROUP BY S.store_id;
    
SELECT * FROM ID_Amount;
DROP VIEW ID_Amount;

#30.가장 많은 고객이 있는 상위 5개 국가를 보여주세요
SELECT CO.country, COUNT(*) customer_count
FROM country CO
JOIN city CI USING(country_id)
JOIN address A USING(city_id)
JOIN customer CU USING(address_id)
GROUP BY CO.country
ORDER BY customer_count DESC
LIMIT 5;