# 영화 길이에 대한 백분위 순위와 누적 분포 계산
# 백분위 순위 : 전체률 100% -> 0 ~ 1 => PERCENT_RANK()
# 누적분포 : 전체를 기준으로 각 그룹의 비율이 몇 프로대까지인지를 누적해서 보는 것 => CUME_DIST()
USE sakila;
SELECT
	title, length,
    PERCENT_RANK() OVER (ORDER BY length) AS percent,
    CUME_DIST() OVER (ORDER BY length) AS cume
FROM film;

SELECT 
	customer_id,
    CONCAT(first_name, ",", last_name) AS customer_name,
    NTILE(4) OVER (ORDER BY customer_id) AS customer_group
FROM customer;

#1. payment테이블에서 각 고객들의 결제금액을 출력하세요 (단, 출력내용은 다음과 같아야합니다)
# 고객ID, 고객 결제금액, 해당 행의 결제금액의 이전 결제금액, 해당 행의 결제금액의 다음 결제금액 (*고객 결제흐름)
SELECT 
	customer_id,
    amount,
    LAG(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) prev_amount,
    LEAD(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) next_amount
FROM payment P;

#2. rental 테이블에서 각 고객별로 첫번째 대여일자와 마지막 대여일자를 출력하세요
# 출력 결과물에는 고객 ID, 첫번째 대여일자, 마지막 대여일자가 포함되어있으면 됩니다
SELECT 
	customer_id,
    FIRST_VALUE(rental_date) OVER 
		(PARTITION BY customer_id ORDER BY rental_date) AS first_rental_date,
    LAST_VALUE(rental_date) OVER 
		(PARTITION BY customer_id ORDER BY rental_date
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS last_rental_date
FROM rental;

#3. payment 테이블에서 각 직원이 처리한 첫번째 결제와 마지막 결제금액을 출력해주세요
# 직원ID, 첫번째 결제금액, 마지막 결제금액
SELECT 
	DISTINCT staff_id,
    FIRST_VALUE(amount) OVER 
		(PARTITION BY staff_id ORDER BY payment_date) AS first_payment_amount,
    LAST_VALUE(amount) OVER 
		(PARTITION BY staff_id ORDER BY payment_date
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS last_payment_amount
FROM payment;

#4. film 테이블에서 각 영화의 대여기간에 대한 백분위 순위, 누적분포를 계산해주세요
# 영화제목, 대여기간, 백분위 순위, 누적분포
SELECT
	title, 
    rental_duration,
    PERCENT_RANK() OVER (ORDER BY rental_duration) AS percentile_rank,
    CUME_DIST() OVER (ORDER BY rental_duration) AS cumulative_distribution
FROM film ;

#5. customer 테이블에서 각 고객의 결제 금액에 대한 백분위 순위와 누적분포를 계산해주세요
# 고객ID, 총 결제금액, 백분위 순위, 누적분포
SELECT
	customer_id,
    SUM(P.amount) AS total_amount,
    PERCENT_RANK() OVER (ORDER BY SUM(P.amount) DESC) AS percentile_rank,   # 같은 값이 여러개 있을 때는 같은 순위
    CUME_DIST() OVER (ORDER BY SUM(P.amount) DESC) AS cumulative_distribution   # 누적결제비율
FROM customer
JOIN payment P USING(customer_id)
GROUP BY customer_id
ORDER BY total_amount;

#6. rental 테이블에서 각 고객별로 대여순서에 따른 누적 대여 횟수륵 출력해주세요
# 대여ID, 고객ID, 대여날짜, 누적 대여 횟수 
SELECT
	rental_id, customer_id, rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_amount
FROM rental;

#7. payment테이블에서 각 고객별로 결제일자에 따른 누적 결제금액을 출력
SELECT 
	payment_id, customer_id, amount,
    SUM(amount) OVER (PARTITION BY customer_id ORDER BY payment_date
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_amount
FROM payment;
