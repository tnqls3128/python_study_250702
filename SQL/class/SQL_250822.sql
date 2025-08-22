# 4. 각 고객이 어떤 영화 카테고리를 가장 자주 대여하는지 알고 싶습니다. 
# 각 고객별로 가장많이 대여한 영화 카테고리와 해당 카테고리에서의 총 대여 횟수, 
# 그리고 해당 고객 이름을 조회하는 SQL 구문을 작성해주세요. 
# 자주 대여하는 카테고리에 동률(*같은 비율)이 있을 경우 모두 보여주세요.
USE sakila;

SELECT 
	CU.customer_id,
	CU.first_name,
    CU.last_name,
	CA.name AS category_name,
    COUNT(*) AS rental_count
FROM rental R
JOIN inventory I ON R.inventory_id = I.inventory_id
JOIN film F ON I.film_id = F.film_id
JOIN film_category FC ON F.film_id = FC.film_id
JOIN category CA ON FC.category_id = CA.category_id
JOIN customer CU ON R.customer_id = CU.customer_id
GROUP BY CU.customer_id, CA.category_id
ORDER BY rental_count DESC;

SELECT
	CA.name,
    COUNT(*) AS Max_category
FROM rental R
JOIN inventory I ON R.inventory_id = I.inventory_id
JOIN film F ON I.film_id = F.film_id
JOIN film_category FC ON F.film_id = FC.film_id
JOIN category CA ON FC.category_id = CA.category_id
JOIN customer CU ON R.customer_id = CU.customer_id
GROUP BY CA.category_id
ORDER BY Max_category DESC;

WITH category_rental_count AS (
    SELECT
        CU.customer_id,
        CU.first_name,
        CU.last_name,
        CA.name AS category_name,
        COUNT(*) AS rental_count
    FROM rental R
    JOIN inventory I ON R.inventory_id = I.inventory_id
    JOIN film F ON I.film_id = F.film_id
    JOIN film_category FC ON F.film_id = FC.film_id
    JOIN category CA ON FC.category_id = CA.category_id
    JOIN customer CU ON R.customer_id = CU.customer_id
    GROUP BY CU.customer_id, CA.category_id
),
max_rental_customer AS (
	SELECT 
		customer_id,
        MAX(rental_count) AS max_rental
	FROM category_rental_count
    GROUP BY customer_id
)
SELECT
    C.customer_id,
    C.first_name,
    C.last_name,
    C.category_name,
    C.rental_count
FROM category_rental_count C
JOIN max_rental_customer M
    ON C.customer_id = M.customer_id
    AND C.rental_count = M.max_rental
ORDER BY C.customer_id;
    
