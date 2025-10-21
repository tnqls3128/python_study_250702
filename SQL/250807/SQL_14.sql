DESC ranking;
DESC items;

SELECT COUNT(*) FROM items;  # 10,201개
SELECT * FROM ranking 
LIMIT 1000;

SELECT * FROM items
INNER JOIN ranking ON ranking.item_code = items.item_code
WHERE ranking.main_category = "ALL";

SELECT * FROM items
JOIN ranking 
ON ranking.item_code = items.item_code
WHERE ranking.main_category = "ALL";

# 에러가 발생하는 주요 원인 => ON 뒤에 어떤 테이블에서 값을 찾아왔는가
SELECT * FROM items
JOIN ranking 
ON item_code = items.item_code
WHERE ranking.main_category = "ALL";

SELECT * FROM items AS A
JOIN ranking AS B
ON B.item_code = A.item_code
WHERE B.main_category = "ALL";

SELECT * FROM items A
JOIN ranking B
ON B.item_code = A.item_code
WHERE B.main_category = "ALL";

SELECT * FROM items A
JOIN ranking B
ON B.item_code = A.item_code
WHERE main_category = "ALL";  # 만약 조건절에서 설정한 데이터 값이 특정 테이블에서만 사용하는 경우, 테이블 언급 생략 가능

# 관습적으로 특정 테이블을 생략해서 키워드를 입력 => 해당 테이블의 첫 단어를 사용
SELECT title FROM items I
JOIN ranking R
ON R.item_code = I.item_code
WHERE main_category = "ALL";

# 메인 카테고리 ALL 에서 판매자별 베스트 상품 갯수를 출력
SELECT provider, COUNT(*) count FROM items I
JOIN ranking R
ON R.item_code = I.item_code
WHERE R.main_category = "ALL"
GROUP BY provider
ORDER BY count DESC;

# 메인카테고리가 "패션의류"인 서브카테고리 포함, 패션의류 전체 베스트 상품에서
# 판매자별 베스트 상품 갯수가 5 이상인 판매자와 해당 베스트 상품 갯수 출력
SELECT DISTINCT main_category FROM ranking;

SELECT provider, COUNT(*) count FROM items I
JOIN ranking R
ON R.item_code = I.item_code
WHERE R.main_category = "패션의류"
GROUP BY provider
HAVING count >= 5
ORDER BY count DESC;

# 메인카테고리가 신발/잡화 
# 판매자별 상품갯수가 10개 이상인 판매자명 & 상품 갯수 출력
SELECT DISTINCT main_category FROM ranking;

SELECT provider, COUNT(*) count FROM items I
JOIN ranking R
ON R.item_code = I.item_code
WHERE R.main_category = "신발/잡화"
GROUP BY provider
HAVING count >=10
ORDER BY count DESC;

# 메인카테고리가 화장품/헤어
# 해당 카테고리 내 평균, 최대, 최소 할인 가격을 출력
SELECT 
	AVG(dis_price),
    MAX(dis_price),
    MIN(dis_price) 
FROM items I
JOIN ranking R
ON R.item_code = I.item_code
WHERE R.main_category = "화장품/헤어";

# 육육걸즈 마케터 혹은 MD
# 지그재그 -> 리뷰 크롤링 -> #가성비 #저렴 #경제적
# 크롤링 -> 지그재그 -> 주요인기상품 및 카테고리 상품명&상품가격&할인가격 크롤링
# MySQL -> 평균/할인/최대할인

