USE bestproducts;

# 1. 메인카테고리와 서브카테고리별 평균할인가격과 평균할인률 출력
SELECT * FROM items LIMIT 10;
SELECT * FROM ranking LIMIT 10;

SELECT R.main_category, R.sub_category, AVG(dis_price), AVG(discount_percent)
FROM items I
JOIN ranking R
ON R.item_code = I.item_code
GROUP BY R.main_category, R.sub_category
ORDER BY AVG(discount_percent) DESC;

# 2, 판매자별 베스트상품 갯수, 평균할인가격, 평균할인률을 출력
# - 상품갯수 순으로 내림차순 정렬
SELECT 
	provider,
    COUNT(*) AS count,
    AVG(dis_price) dis_price,
    AVG(discount_percent) dis_percent
FROM items 
GROUP BY provider
ORDER BY count DESC;

#3. 메인카테고리별 베스트 상품 갯수가 20개 이상인 판매자의 판매자별 평균할인 가격, 평균할인률, 베스트 상품 갯수 출력
SELECT 
	R.main_category,
	I.provider,
	COUNT(*) count,
	AVG(dis_price) dis_price,
    AVG(discount_percent) discount_percent
FROM items I
JOIN ranking R
ON R.item_code = I.item_code
WHERE I.provider IS NOT NULL AND provider != ''
GROUP BY I.provider, R.main_category
HAVING count >= 20
ORDER BY count DESC;

# items 테이블에서 dis_price가 5만원 이상인 상품들 중
# main_category 별 평균 dis_price의 discount_percent 출력
SELECT R. main_category, AVG(I.dis_price), AVG(I.discount_percent)
FROM ranking R
JOIN items I
ON R.item_code = I.item_code
WHERE I.dis_price >= 50000
GROUP BY R.main_category;