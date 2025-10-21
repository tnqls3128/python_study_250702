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
		SELECT
			AVG(payment_count)
        FROM (
			SELECT COUNT(*) AS payment_count
            FROM payment
            GROUP BY customer_id
    )
);

