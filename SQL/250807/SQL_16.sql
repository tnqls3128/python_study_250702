CREATE DATABASE IF NOT EXISTS musinsa_db_v2;
USE musinsa_db_v2;

CREATE TABLE IF NOT EXISTS customers (
	customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    address TEXT,   -- 2바이트 메모리 값을 고정값으로 가져감
    phone VARCHAR(50),
    email VARCHAR(100),
    grade VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS products (
	product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    stock INT,
    main_category VARCHAR(50),
    sub_category VARCHAR(50),
    price INT,
    discount_price INT,
    discount_rate INT
);

CREATE TABLE IF NOT EXISTS orders (
	order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE IF NOT EXISTS reviews (
	review_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    rating INT,
    review_text TEXT,
    review_date DATE,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

DESC customers ;

SELECT grade, COUNT(*) count 
FROM customers
GROUP BY grade
ORDER BY count DESC;

SELECT P.product_id, AVG(rating) AVG FROM products P
JOIN reviews R
ON P.product_id = R.product_id
GROUP BY P.product_id
ORDER BY AVG(rating);

SELECT * FROM orders LIMIT 10;

SELECT COUNT(*) recent_order_count
FROM orders
WHERE order_date >= CURDATE() - INTERVAL 30 DAY;

# 상품별 최근 한달간 주문 건수를 구하세요
SELECT * FROM orders LIMIT 1;
SELECT * FROM products LIMIT 1;

SELECT O.product_id, P.product_name, COUNT(*) recent_order_count
FROM orders O
JOIN products P ON O.product_id = P.product_id
WHERE O.order_date >= CURDATE() - INTERVAL 30 DAY
GROUP BY product_id
ORDER BY recent_order_count DESC;

# 고객별 총 구매 건수와 구매 수량을 구하세요 -> 고객맞춤형 쿠폰,메시지,퍼널,초개인화 등
SELECT * FROM customers LIMIT 1;
SELECT * FROM orders LIMIT 1;

SELECT O.customer_id, C.name, COUNT(*) order_count, SUM(O.quantity) total_quantity
FROM orders O
JOIN customers C
ON O.customer_id = C.customer_id
GROUP BY O.customer_id, C.name
ORDER BY order_count DESC;

# 고객별 총 구매금액 (*할인가 기준)을 계산 후 출력해주세요
SELECT * FROM orders LIMIT1 ;
SELECT * FROM products LIMIT1 ;

SELECT 
	C.customer_id, 
    C.name, 
    SUM(quantity*discount_price) AS total_spent
FROM customers C
JOIN orders O
ON C.customer_id = O.customer_id
JOIN products P
ON O.product_id = P.product_id
GROUP BY C.customer_id
ORDER BY total_spent DESC;

SELECT 
	O.customer_id,
    C.name,
    SUM(P.discount_price * O.quantity) AS total_spent
FROM orders O
JOIN customers C
ON C.customer_id = O.customer_id
JOIN products P
ON O.product_id = P.product_id
GROUP BY O.customer_id
ORDER BY total_spent DESC;

# 지금까지 가장 많이 판매된 (*수량) 상품 TOP5 를 출력
SELECT O.product_id, O.quantity, COUNT(*), P.product_name FROM orders O
JOIN products P
ON P.product_id = O.product_id
GROUP BY O.product_id, O.quantity
ORDER BY COUNT(*) DESC
LIMIT 5;

SELECT P.product_name, SUM(O.quantity) total_sold FROM orders O
JOIN products P
ON P.product_id = O.product_id
GROUP BY O.product_id
ORDER BY total_sold DESC
LIMIT 5;

# 평균 평점이 4.5점 이상인 상품명과 평점 출력 (*인기상품)
SELECT P.product_name, AVG(R.rating) avg_rating FROM reviews R
JOIN products P
ON P.product_id = R.product_id
GROUP BY P.product_id
HAVING avg_rating >= 4.5
ORDER BY avg_rating DESC;