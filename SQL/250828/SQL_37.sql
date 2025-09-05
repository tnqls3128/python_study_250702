#15. 각 고객별 결제 금액에 따른 순위를 출력해주세요
# 고객ID, 렌탈ID, 고객의 결제 금액에 따른 순위
# 순위를 출력할 때 동일한 값이 있을 경우 순위를 부여하고 다음 순위는 건너뛰지 않습니다
SELECT 
	customer_id, rental_id, amount,
    DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY amount DESC) AS amount_rank
FROM payment;

#16. 고객별 대여날짜 시간 순으로 정렬 후 아래 내용을 출력해주세요
# 고객ID, 렌탈ID, 대여날짜시간, 해당 대여날짜 시간을 기준으로 다음 대여 날짜 시간
SELECT 
	customer_id, rental_id, rental_date, 
    LEAD(rental_date) OVER(PARTITION BY customer_id ORDER BY rental_date) AS next_rental_date
FROM rental;

#17. 각 등급별로 대여기간이 가장 긴 영화의 제목을 출력하세요
SELECT 
	DISTINCT rating, 
    FIRST_VALUE(title) OVER
		(PARTITION BY rating ORDER BY rental_duration DESC) AS longest_rental_movie
FROM film;

