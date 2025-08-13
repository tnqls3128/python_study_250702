USE sakila;

SELECT * FROM address
LIMIT 1;

SELECT * FROM customer
LIMIT 1;

SELECT COUNT(*) count FROM customer C
RIGHT OUTER JOIN address A
ON C.address_ID = A.address_ID
WHERE customer_ID IS NULL;

# 서브 카테고리가 "여성신발"인 상품 타이틀만 가져오기
USE bestproducts;

SELECT title FROM items I
JOIN ranking R
ON I.item_code = R.item_code
WHERE R.sub_category = "여성신발";

# 서브쿼리 구문을 활용해서 서로 다른 두개의 테이블을 연결해서 값을 찾아온다면?
SELECT item_code FROM items
LIMIT 3;

SELECT title FROM items I
WHERE
	item_code = "102425348" or
    item_code = "104914497" or
    item_code = "106332300";
    
SELECT title FROM items 
WHERE item_code IN 
	("102425348", "104914497", "106332300");
    
SELECT title FROM items 
WHERE item_code IN 
	(SELECT item_code FROM ranking
    WHERE sub_category = "여성신발");
    
USE sakila;

SELECT * FROM category ;

SELECT category_id, COUNT(*)
FROM film_category 
WHERE film_category.category_id > 
	(SELECT category.category_id FROM category
    WHERE category.name = "Comedy")
GROUP BY film_category.category_id;

# bestproducts > 메인 카테고리별로 할인 가격이 10만원 이상인 상품이 몇 개 있는지 출력 (Join 활용)
USE bestproducts;

SELECT main_category, COUNT(*) count FROM items I
JOIN ranking R
ON R.item_code = I.item_code
WHERE dis_price >= 100000
GROUP BY main_category
ORDER BY count DESC;

# 방금 작성했떤 코드를 서브쿼리로 구현하기
SELECT main_category, COUNT(*) count
FROM ranking
WHERE item_code in
	(SELECT item_code FROM items
    WHERE dis_price >= 100000)
GROUP BY main_category
ORDER BY count DESC;

# 할인된 금액이 20만원 이상인 아이템들의 서브 카테고리별 상품 갯수를 출력해주세요
SELECT sub_category, COUNT(*) count FROM ranking R
JOIN items I
ON R.item_code = I.item_code
WHERE I.dis_price >= 200000
GROUP BY sub_category
ORDER BY count DESC;

# 위 구문을 서브쿼리로 바꿔보기
SELECT sub_category, COUNT(*) count
FROM ranking
WHERE item_code IN
	(SELECT item_code FROM items
    WHERE dis_price >= 200000)
GROUP BY sub_category
ORDER BY count DESC;