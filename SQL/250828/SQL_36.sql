#8. rental 테이블에서 각 직원들의 대여 날짜에 따른 대여횟수와 각 직원별 누적 대여 횟수
# 대여ID, 직원 ID, 대여날짜, 대여횟수, 누적대여횟수
USE sakila;
SELECT 
	rental_id, staff_id, rental_date,
    COUNT(*) OVER (PARTITION BY staff_id, DATE(rental_date) ORDER BY DATE(rental_date)
					ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS rental_count,
    COUNT(*) OVER (PARTITION BY staff_id ORDER BY DATE(rental_date)
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS cumulative_amount
FROM rental;

#9. customer테이블과 payment테이블을 사용해서 각 도시별 고객의 총 결제금액 순위를 출력
# 고객 ID, 도시, 총 결제금액, 도시순위
SELECT
	C.customer_id,
    CI.city,
    SUM(P.amount) AS total_amount,
    RANK() OVER (PARTITION BY CI.city ORDER BY SUM(P.amount) DESC) AS city_rank
FROM customer C
JOIN address A USING(address_id)
JOIN city CI USING(city_id)
JOIN payment P USING(customer_id)
GROUP BY C.customer_id, CI.city;

#10.  customer테이블에서 고객의 대여 횟수에 따라 4개의 그룹으로 나눠주세요
# 고객 ID, 대여횟수, 그룹
SELECT
	C.customer_id,
    COUNT(*) AS rental_count,
    NTILE(4) OVER (ORDER BY COUNT(*) DESC)
FROM customer C
JOIN rental R USING(customer_id)
GROUP BY C.customer_id;

#11. film테이블에서 영화를 대여기간에 따라서 5개 그룹으로 나눠주세요
# 영화ID, 대여기간, 그룹
SELECT 
	film_id,
    rental_duration,
    NTILE(5) OVER (ORDER BY rental_duration DESC)
FROM film ;

# 12.payment 테이블에서 각 고객별로 지불 내역에 행 번호를 부여해주세요
# 고객별 지불 내역의 행 번호는 payment_date가 낮은 순으로 부여해주세요
# 지불ID, 고객ID, 지불날짜, 지불금액, 행 번호
SELECT 
	payment_id, customer_id, payment_date, amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date) AS row_numbers
FROM payment;

# 13. film테이블에서 각 등급별로 영화에 행 번호를 부여하세요
# 영화는 대여기간에 따라 정렬될 수 있도록 해주세요
# 영화ID, 등급, 대여기간, 행번호
SELECT
	film_id, rating, rental_duration,
    ROW_NUMBER() OVER(PARTITION BY rating ORDER BY rental_duration) AS row_numbers
FROM film;

#14. customer테이블과 payment테이블을 사용해서 고객을 총 결제금액에 따라 10개의 그룹으로 나누고
#각 그룹 내에서 고객별 총 결제금액에 따라 번호를 부여하세요
# 고객ID, 총 결제금액, 그룹, 그룹 내 행번호
WITH CustomerPayments AS (
	SELECT 
		C.customer_id,
		SUM(P.amount) AS total_amount
	FROM customer C
	JOIN payment P USING(customer_id)
	GROUP BY C.customer_id
),
CustomerGroup AS (
	SELECT
		customer_id, total_amount,
        NTILE(10) OVER (ORDER BY total_amount) AS ten
    FROM CustomerPayments
)
SELECT
	customer_id, total_amount, ten,
    ROW_NUMBER() OVER(PARTITION BY ten ORDER BY total_amount) AS row_numbers
FROM CustomerGroup;
