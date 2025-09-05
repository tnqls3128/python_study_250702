# Sakila DB를 참고해서, 가장 많은 영화를 대여한 고객
# (*단,가장 많은 영화의 기준 -> 동일한 영화를 반복해서 대여한 경우의 수는 제외, 
# 오직 서로 다른 영화를 대여했다는 기준으로만) 을 찾아내고, 해당 고객이 대여한 영화 갯수를 찾아주세요. 
# 또한 해당 고객이 대여한 영화가 가장 많이 속한 카테고리
# (*단, 이때에는 동일한 영화를 반복해서 대여한 경우의 수도 포함)도 찾아주세요.
WITH customer_unique_film AS (
	SELECT
		C.customer_id,
		COUNT(DISTINCT I.film_id) AS unique_film
	FROM rental R
	JOIN inventory I USING(inventory_id)
	JOIN customer C USING(customer_id)
	GROUP BY C.customer_id
),
top_customer AS (
	SELECT *
    FROM customer_unique_film
    ORDER BY unique_film DESC
    LIMIT 1
),
customer_category AS (
	SELECT 
		C.name AS name,
		COUNT(*) AS rental_count
	FROM rental R
	JOIN inventory I USING(inventory_id)
	JOIN film F USING(film_id)
	JOIN film_category FC USING(film_id)
	JOIN category C USING(category_id)
	WHERE R.customer_id = 148
	GROUP BY C.name
	ORDER BY rental_count DESC
	LIMIT 1
)
SELECT 
	TC.customer_id,
    TC.unique_film,
    CC.name,
    CC.rental_count
FROM top_customer TC
JOIN customer_category CC ;


