SELECT 
	title, length,
    RANK() OVER (ORDER BY length DESC) AS ranking,
    DENSE_RANK() OVER (ORDER BY length DESC) AS dense_ranking,
    ROW_NUMBER() OVER (ORDER BY length DESC) AS row_ranking
FROM film 
ORDER BY length DESC;

SELECT
	C.customer_id,
    CONCAT(C.first_name, " ", C.last_name) AS customer_name,
    SUM(P.amount) AS total_amount,
    RANK() OVER (ORDER BY SUM(P.amount) DESC) AS ranking,
	DENSE_RANK() OVER (ORDER BY SUM(P.amount) DESC) AS dense_ranking,
    ROW_NUMBER() OVER (ORDER BY SUM(P.amount) DESC) AS row_ranking
FROM customer C
JOIN payment P USING(customer_id)
GROUP BY C.customer_id;   # 중복되지않음

SELECT 
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date) AS cumulative_rentals   # 각 고객의 대여 내역별로 총 대여 건수 
FROM rental;

SELECT 
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date  # 고객 아이디별로 데이터 묶어서 따로 계산, 날짜 순서로 정렬
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_rentals  # 맨 처음 대여일부터 현재 대여일까지 누적
FROM rental;

SELECT
	R.customer_id,
    R.rental_date,
    P.amount,
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY DATE(R.rental_date))
FROM rental R
JOIN payment P USING(rental_id);

# customer 테이블에서 고객의 총 지출 금액을 계산하고 총 지출 금액에 따라 고객의 순위를 매겨주세요
# 출력되어질 결과값은 고객ID, 고객이름, 총 지출금액, 순위
SELECT
	C.customer_id, CONCAT(C.first_name, " ", C.last_name) customer_name,
    SUM(P.amount),
    RANK() OVER (ORDER BY SUM(P.amount) DESC) AS ranking
FROM payment P
JOIN customer C USING(customer_id)
GROUP BY C.customer_id;

# film테이블에서 각 영화의 대여횟수를 계산하고 대여횟수에 따라 영화의 순위를 매겨주세요
# 만약 같은 대여횟수가 발생했을 때는 다음번째 순위를 건너뛰지 않고 출력해주세요
# 출력해야할 값은 영화제목, 대여횟수, 순위가 포함될 수 있도록 해주세요
SELECT 
	F.title,
    COUNT(*) rental_count,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) ranking
FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY F.film_id;

SELECT
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date) count  # customer_id 기준으로 부분집합
FROM rental;

# 고객별 대여날짜 누적 대여 횟수 계산
SELECT 
	customer_id,
	rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date 
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) counts
FROM rental;

SELECT   # 맨처음부터 현재날짜까지 누적해서 몇번 대여했는지 계산
	customer_id,
	rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date 
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) counts
FROM rental;

SELECT   # 고객별로 대여날짜 순서대로 정렬해서 자기앞 1개+자기자신+뒤 1개 총 3줄 안에 몇개있는지 계산 (잎뒤 1칸씩만 포함한 카운트)
	customer_id,
	rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date 
					ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) counts
FROM rental;  

SELECT 
	R.customer_id,
	R.rental_date,
	P.amount,
    DATE(R.rental_date),
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY rental_date
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sample
FROM payment P
JOIN rental R USING(rental_id);

SELECT 
	R.customer_id,
	R.rental_date,
	P.amount,
    DATE(R.rental_date),
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY DATE(rental_date)
						RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sample
FROM payment P
JOIN rental R USING(rental_id);

SELECT 
	R.customer_id,
	R.rental_date,
	P.amount,
    AVG(P.amount) OVER (PARTITION BY R.customer_id ORDER BY rental_date
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sample
FROM payment P
JOIN rental R USING(rental_id);

# 누적 매출 수입
SELECT
	I.film_id,
	P.amount,
    P.payment_date,
    SUM(P.amount) OVER (PARTITION BY I.film_id ORDER BY P.payment_date
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) revenue
FROM payment P
JOIN rental R USING(rental_id)
JOIN inventory I USING(inventory_id);

# 장르별 영화 대여 수익
# 영화 장르와 수익성 분석이 필요합니다 영화 장르별 대여 수익의 누적합계와 전체 대여 수익대비 비율을 출력
# WITH => 장르당 총 합계 매출 금액
WITH genre_revenue AS (
	SELECT 
		C.name genre,
		SUM(P.amount) revenue
	FROM payment P
	JOIN rental R USING(rental_id)
	JOIN inventory I USING(inventory_id)
	JOIN film_category FC USING(film_id)
	JOIN category C USING(category_id)
	GROUP BY C.name
)
SELECT
	genre, revenue,
    SUM(revenue) OVER (ORDER BY revenue DESC
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) revenue2,
	revenue / SUM(revenue) OVER() revenue_ratio
FROM genre_revenue;

SELECT 
	rental_id,
    rental_date,
    LAG(rental_id, 1, 0) OVER (ORDER BY rental_date) prev_rental,
    LEAD(rental_id, 1, 0) OVER (ORDER BY rental_date) next_rental
FROM rental;

SELECT 
	I.film_id,
    R.rental_date,
    FIRST_VALUE(R.rental_date) OVER (PARTITION BY I.film_id ORDER BY R.rental_date),
    LAST_VALUE(R.rental_date) OVER (PARTITION BY I.film_id ORDER BY R.rental_date
									ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM rental R
JOIN inventory I USING(inventory_id);

SELECT 
	I.film_id,
    R.rental_date,
    FIRST_VALUE(R.rental_date) OVER (PARTITION BY I.film_id ORDER BY R.rental_date),
    LAST_VALUE(R.rental_date) OVER (PARTITION BY I.film_id ORDER BY R.rental_date)
FROM rental R
JOIN inventory I USING(inventory_id);