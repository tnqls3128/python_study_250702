USE sakila;
SHOW TABLES;

SELECT * FROM customer LIMIT 3;
SELECT * FROM payment LIMIT 3;

SELECT
	first_name,
    last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
    FROM payment
    WHERE amount > (SELECT AVG(amount) FROM payment)
);

SELECT
	first_name,
    last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
    FROM payment
    WHERE amount > 3
);

SELECT
	first_name,
    last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
    FROM payment
    GROUP BY customer_id
    HAVING COUNT(*) > (
		SELECT AVG(payment_count)
        FROM (
			SELECT COUNT(*) AS payment_count
            FROM payment
            GROUP BY customer_id
		) AS payment_count
    )
);

SELECT
	first_name,
    last_name
FROM customer
WHERE customer_id = (
	SELECT customer_id
    FROM (
		SELECT customer_id, COUNT(*) AS payment_count
		FROM payment
		GROUP BY customer_id
	) AS payment_counts
    ORDER BY payment_count DESC
    LIMIT 1
);

# 상관 서브쿼리
SELECT
	P.customer_id,
    P.amount,
    P.payment_date
FROM payment P
WHERE P.amount > (
	SELECT 
		AVG(amount)
    FROM payment
    WHERE customer_id = P.customer_id
);

# film 테이블에서 평균 영화길이보다 긴 영화들의 제목을 찾아주세요
SELECT * FROM film;

SELECT title, length
FROM film F
WHERE F.length > (SELECT AVG(length) FROM film);

# rental 테이블에서 고객별 평균 대여 횟수보다 많은 대여를 한 고객들의 이름(firts, lsat)찾아주세요
SELECT * FROM rental LIMIT 1;
SELECT * FROM customer LIMIT 1;

SELECT first_name, last_name 
FROM customer
WHERE customer_id IN (
	SELECT customer_id
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(*) > (
		SELECT AVG(retal_count)
		FROM(
			SELECT COUNT(*) AS retal_count
			FROM rental
			GROUP BY customer_id 
		) AS retal_counts
    )
);
 # SQL에서 서브쿼리 구문이 등장하는 경우가 거의 WHERE절에서 나옴
 # 단일값 VS 여러개 값
 #  = VS IN 
 
 # 가장 많은 영화를 대여한 고객의 이름 (first, last)찾아주세요
 SELECT first_name, last_name 
 FROM customer
 WHERE customer_id = (
	SELECT customer_id
    FROM (
		SELECT customer_id, COUNT(*) AS rental_count
        FROM rental
        GROUP BY customer_id
    ) AS rental_counts
    ORDER BY rental_count DESC
    LIMIT 1
);

# 각 고객에 대해 자신이 대여한 평균 영화 길이보다 긴 영화들의 제목을 찾아주세요
SELECT * FROM film LIMIT 1;
SELECT * FROM rental LIMIT 1;
SELECT * FROM customer LIMIT 1;
SELECT * FROM inventory LIMIT 1;

SELECT 
	C.first_name, C.last_name, F.title
FROM customer C
JOIN rental R ON R.customer_id = C.customer_id
JOIN inventory I ON I.inventory_id = R.inventory_id
JOIN film F ON F.film_id = I.film_id
WHERE F.length > (
	SELECT AVG(FIL.length)
    FROM film FIL
    JOIN inventory INV ON INV.film_id = FIL.film_id
    JOIN rental REN ON REN.inventory_id = INV.inventory_id
    WHERE REN.customer_id = C.customer_id
);

