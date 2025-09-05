# Sakila 데이터베이스의 결제 내역을 활용하여 다음 조건을 만족하는 SQL 쿼리를 작성하세요.
# 고객별 결제 내역을 날짜순으로 정렬하여 누적 결제 금액을 계산하고, 
# 각 결제 건마다 이전 결제 금액 차이와 다음 결제 금액 차이를 구하세요. 
# 고객별 첫 번째 결제일과 마지막 결제일을 찾으며, 전체 고객의 총 결제 금액을 기준으로 5개의 그룹으로 나누어 
# 각 결제가 속한 그룹을 표시하세요. 또한 고객별 총 결제 금액을 기준으로 내림차순 순위를 매기되, 
# 동일 금액은 같은 순위를 부여하고 이후 순위는 연속되게 이어지도록 하세요. 
# 고객별 총 결제 금액에 대해 백분위 순위와 누적 분포를 계산하고, 
# 마지막으로 고객별 결제 내역을 날짜순으로 정렬했을 때 각 결제가 몇 번째 결제인지 순서를 부여하세요.
# 위 내용들을 다음 항목으로 출력해주세요. 
# customer_id, payment_date, cumulative_amount, prev_payment_diff, .
# next_payment_diff, first_payment_date, last_payment_date, total_amount_rank,
# payment_amount_pct_rank, payment_amount_cume_dist, total_amount_group, 
# group_row_number
USE sakila;

WITH Total AS (
	SELECT
		customer_id,
		SUM(amount) AS total_amount,
		DENSE_RANK() OVER (ORDER BY SUM(amount) DESC) AS total_amount_rank,
		PERCENT_RANK() OVER (ORDER BY SUM(amount)) AS payment_amount_pct_rank,
		CUME_DIST() OVER (ORDER BY SUM(amount)) AS payment_amount_cume_dist,
		NTILE(5) OVER (ORDER BY SUM(amount)) AS total_amount_group
	FROM payment
	GROUP BY customer_id
),
PaymentInfo AS (
	SELECT
		customer_id, payment_date, amount,
		SUM(amount) OVER (PARTITION BY customer_id ORDER BY payment_date
							ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_amount,
		LAG(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS prev_amount,
		LEAD(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS last_amount,
		amount - LAG(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS prev_payment_diff,
		amount - LEAD(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS next_payment_diff,
		FIRST_VALUE(payment_date) OVER (PARTITION BY customer_id ORDER BY payment_date) AS first_payment_date,
		LAST_VALUE(payment_date) OVER (PARTITION BY customer_id ORDER BY payment_date
										ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_payment_date,
		ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY paymant_date) AS group_row_number
	FROM payment
)
SELECT
	P.customer_id,
    P.payment_date,
    P.cumulative_amount,
    P.prev_payment_diff,
    P.next_payment_diff,
    P.first_payment_date,
    P.last_payment_date,
    T.total_amount_rank,
    T.payment_amount_pct_rank,
    T.payment_amount_cume_dist,
    T.total_amount_group,
    P.group_row_number
FROM PaymentInfo P
JOIN Total T ON P.customer_id = T.customer_id
ORDER BY T.total_amount_rank, P.customer_id, P.payment_date;
