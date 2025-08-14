# rental과 inventory 테이블을 join하고 film 테이블에 있는
#replace_cost가 $20 이상인 영화를 대여한 고객의 이름을 찾아주세요 고객의 이름은 소문자로 출력해주세요
SELECT * FROM rental LIMIT 1;
SELECT * FROM inventory LIMIT 1;
SELECT * FROM film LIMIT 1;
SELECT * FROM customer LIMIT 1;
SELECT * FROM payment LIMIT 1;

SELECT 
	DISTINCT LOWER(CONCAT(C.first_name, " ", C.last_name)) AS customer_name
FROM customer C
JOIN rental R ON C.customer_id = R.customer_id
JOIN inventory I ON I.inventory_id = R.inventory_id
JOIN film F ON I.film_id = F.film_id
WHERE F.replacement_cost >= 20 ;

# film 테이블에서 rating이 "PG-13"등급인 영화들에서, discription의 길이가 
# rating이 "PG-13"등급인 영화들의 평균 descroption길이보가 길이가 긴 영화의 제목을 찾아주세요
SELECT title
FROM film
WHERE rating = "PG-13" AND LENGTH(description) > (
	SELECT AVG(LENGTH(description))
    FROM film
    WHERE rating = "PG-13"
);

# customer와 rental, inventory, film 테이블을 JOIN 하여 2005년 8월에 대여된
# 모든 "R" 등급 영화의 제목과 해당 영화를 대여한 고객의 이메일을 찾아주세요 
SELECT C.email, F.title
FROM customer C
-- JOIN rental R ON R.customer_id = C.customer_id
JOIN rental R USING(customer_id)
JOIN inventory I USING(inventory_id)
JOIN film F USING(film_id)
WHERE 
	YEAR(R.rental_date) = 2005 
    AND MONTH(R.rental_date) = 8
	AND F.rating = 'R';
    
# payment 테이블에서 가장 마지막에 결제된 일시에서 30일 이전까지의 모든 결제 내역을 찾고
# 해당 결제 내역에 대해서 각 고객별 총 결제금액과 평균 결제금액을 소수점 둘째자리에서 반올림하여 출력하세요
SELECT * FROM customer LIMIT 1;
SELECT * FROM payment LIMIT 1;
	
SELECT
	customer_id, 
    ROUND(SUM(amount),1) AS customer_sum,
    ROUND(AVG(amount),1) AS customer_avg
FROM payment
WHERE payment_date >= DATE_SUB(
	(SELECT MAX(payment_date) FROM payment), INTERVAL 30 DAY
)
GROUP BY customer_id;

# actor와 film_actor 테이블을 JOIN하고 "Sci-Fi" 카테고리에 속한 영화에 출연한 배우
# 이름을 찾으세요 그리고 해당 배우의 이름은 성과 이름을 연결하여 대문자로 출력하세요
SELECT * FROM  actor LIMIT 1;
SELECT * FROM film_actor LIMIT 1;
SELECT * FROM film_category LIMIT 5;
SELECT * FROM category LIMIT 10;

SELECT 
	UPPER(CONCAT(A.first_name, A.last_name)),
    C.name
FROM actor A
JOIN film_actor FA USING(actor_id)
JOIN film_category FC USING(film_id)
JOIN category C USING(category_id)
WHERE C.name = 'Sci-Fi';

