# sakila DB의 “영화 대여 내역”을 바탕으로 다음 항목을 모두 출력하는 SQL 쿼리문을 작성해주세요. 
# 고객별 대여 순위, 이전 대여와의 간격, 다음 대여와의 간격,고객별 첫 번째 및 마지막 대여 일자, 
# 고객별 대여 건의 백분위 순위 및 누적분포, 고객별 대여 내역의 3개 그룹 분할, 
# 분할된 그룹 내 대여날짜 기준 오름차순 정렬
# 위 항목들을 customer_id, rental_date와 함께 “모두 포함하여 출력”하는 SQL 쿼리를 작성해주세요.
WITH Rental AS (
	SELECT 
		customer_id,
        rental_id,
        rental_date,
        LAG(rental_date, 1, 0) OVER (PARTITION BY customer_id ORDER BY rental_date) AS prev_rental,
		DATEDIFF(rental_date, LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date)) AS prev_gap,
		LEAD(rental_date, 1, 0) OVER (PARTITION BY customer_id ORDER BY rental_date) AS next_rental,
		DATEDIFF(LEAD(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date),rental_date) AS next_gap,
		ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY rental_date) AS rental_rank,
        PERCENT_RANK() OVER (PARTITION BY customer_id ORDER BY rental_date DESC) AS percentile_rank,
		CUME_DIST() OVER (PARTITION BY customer_id ORDER BY rental_date DESC) AS cumulative_distribution,
		NTILE(3) OVER (PARTITION BY customer_id ORDER BY rental_date DESC) AS rental_group,
        FIRST_VALUE(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS first_rental_date,
        MAX(rental_date) OVER (PARTITION BY customer_id) AS last_rental_date
	FROM rental
),
CustomerRank AS (
	SELECT 
		customer_id, 
		COUNT(*) AS rental_count,
		DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS customer_rank
	FROM rental
	GROUP BY customer_id
)
SELECT 
	R.customer_id,
    R.rental_id,
    R.rental_date,
    R.prev_rental,
    R.prev_gap,
    R.next_rental,
    R.next_gap,
    R.rental_rank,
    R.first_rental_date,
    R.last_rental_date,
    R.percentile_rank,
    R.cumulative_distribution,
    R.rental_group,
    C.customer_rank,
    C.rental_count
FROM Rental R
JOIN CustomerRank C ON R.customer_id = C.customer_id
ORDER BY R.customer_id, R.rental_date;

# --------------------------------------------------------------------

SELECT 
	customer_id, 
	COUNT(*) AS rental_count,
	DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS customer_rank
FROM rental
GROUP BY customer_id;

SELECT 
	customer_id, rental_id, rental_date,
    LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS prev_rental,
    DATEDIFF(rental_date, LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date)) AS prev_gap,
    LEAD(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS next_rental,
    DATEDIFF(LEAD(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date),rental_date) AS next_gap
FROM rental;

SELECT 
    customer_id,
    MIN(rental_date) AS first_rental_date,
    MAX(rental_date) AS last_rental_date,
    COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id;

SELECT 
	customer_id, rental_date,
    PERCENT_RANK() OVER (PARTITION BY customer_id ORDER BY rental_date DESC) AS percentile_rank,
    CUME_DIST() OVER (PARTITION BY customer_id ORDER BY rental_date DESC) AS cumulative_distribution,
    NTILE(3) OVER (PARTITION BY customer_id ORDER BY rental_date DESC) AS rental_group
FROM rental;


