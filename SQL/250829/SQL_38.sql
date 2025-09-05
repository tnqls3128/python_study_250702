#18. 각 고객을 활동 상태가 높은 순으로 정렬하고 이를 기준으로 3개의 그룹으로 나누세요
# 그룹 내 고객의 순서를 customer_id가 낮은 순으로 출력, 정렬 후 행번호
# 고객ID, 이름, active, active_group, group_row_number

USE sakila;
WITH RankedCustomers AS (
	SELECT
		customer_id, first_name, last_name, active,
		NTILE(3) OVER (ORDER BY active DESC) AS active_group
	FROM customer
)
SELECT 
	customer_id, first_name, last_name, active, active_group,
    ROW_NUMBER() OVER(PARTITION BY active_group ORDER BY customer_id)
						AS group_row_number
FROM RankedCustomers;

#19. 영화 대여 내역에서 고객별 대여순서 출력, 이전 대여와의 간격 (Day단위 간격 기준) 정보출력, 
# 첫번째 대여일시 출력 , 위 3가지를 포함한 내용을 출력해주세요 
# customer_id, rental_id, rental_date, prev_rental_gap, first_rental_date
SELECT 
	customer_id, rental_id, rental_date,
    ROW_number() OVER (PARTITION BY customer_id ORDER BY rental_date) AS rental_order,
    DATEDIFF (
		rental_date,
        LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date)
    ) AS prev_rental_gap,
	FIRST_VALUE(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date)
									AS first_rental_date
FROM rental;

#20. 각 고객의 결제 금액에 따른 순위(결제금액이 높은 순으로 정렬, 만약 동일한 값이 존재하는 경우,
# 같은 순위를 부여하지만 다음 순위는 건너뛰지 않는다) 를 출력해주시고 백분위 순위 (결제금액이 높은 순으로 정렬) 2개 출력
WITH Payment_info AS(
	SELECT
		customer_id, SUM(amount) AS total_amount
	FROM payment
	GROUP BY customer_id
)
SELECT 
	customer_id, total_amount,
    DENSE_RANK() OVER (ORDER BY total_amount DESC) AS total_amount_rank,
    PERCENT_RANK() OVER (ORDER BY total_amount DESC) AS total_amount_pct_rank
FROM Payment_info;

#21. 각 등급별로 영화를 대여기간에 따라 4개의 그룹으로 나누고 각 그룹 내에서
# rental_duration이 낮은 순으로 번호를 매겨서 영화를 출력
# film_id, title, rating, rental_duration, rental_duraion_group, group_row_number
SELECT
	film_id, title, rating, rental_duration,
    NTILE(4) OVER (PARTITION BY rating ORDER BY rental_duration) AS rental_duraion_group,
	ROW_number() OVER (
		PARTITION BY rating ORDER BY rental_duration) AS group_row_number
FROM film;

#22. 각 배우의 출연 영화수에 따른 누적 분포를 다음정보와 함께 출력해주세요
#actor_id, first_name, last_name, film_count, film_count_cume_dist
WITH FilmCount AS (
	SELECT
		A.actor_id, A.first_name, A.last_name, COUNT(*) AS film_count
	FROM actor A
	JOIN film_actor FA USING(actor_id)
	JOIN film F USING(film_id)
	GROUP BY A.actor_id
)
SELECT 
	actor_id, first_name, last_name, film_count,
    CUME_DIST() OVER (ORDER BY film_count) AS film_count_cume_dist
FROM FilmCount;
