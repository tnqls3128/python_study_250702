USE musinsa_db_v2;

#1. 대표 코멘트 추출
-- # 카테고리별 대표 리뷰 코멘트 3개를 GROUP_CONCAT으로 연결해 한 줄에 보여주세요.
SELECT P.product_id, P.product_name, GROUP_CONCAT(R.review_text)
FROM reviews R
JOIN products P USING(product_id)
GROUP BY P.product_id
LIMIT 3;

#2. 카테고리 벤치마크 뷰 생성
-- # Cash COW 상품 도출
-- # 리뷰 수 상위 10%이면서(30개니까 3위) 평균 평점 ≥ 4.3인 상품을 Cash COW로 정의하고, 
-- # 카테고리별 상위 5개 상품을 추출해주세요.(상품개수는 달라질수있음)
SELECT COUNT(*)
FROM reviews;

SELECT product_name AS Cash_COW , AVG(R.rating) 
FROM products P
JOIN reviews R USING(product_id)
GROUP BY product_id
HAVING AVG(R.rating) >= 4.3
ORDER BY AVG(R.rating) DESC;

# 3. 카테고리 벤치마크 뷰 생성
-- # VIEW를 활용해 카테고리별 평점, 리뷰 수, Cash COW 수, 대표 코멘트, 대표 상품명을 
-- # 종합한 가상 테이블을 만들어주세요
CREATE OR REPLACE VIEW Cash_COW AS 
	SELECT product_name AS Cash_COW , AVG(R.rating) 
	FROM products P
	JOIN reviews R USING(product_id)
	GROUP BY product_id
	HAVING AVG(R.rating) >= 4.3
	ORDER BY AVG(R.rating) DESC;
    
SELECT COUNT(*) FROM Cash_COW;

SELECT 
	R.review_text, COUNT(*),
    R.rating, 
    P.name
FROM products P
JOIN reviews R USING(product_id)
GROUP BY product_id;