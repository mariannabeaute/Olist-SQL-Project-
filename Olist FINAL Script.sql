-- Exploring the Olist Database, made up of 9 tables.
--Exploratory data analysis

-- ORDERS & CUSTOMER RETENTION
--total number OF orders made IN 2016, 2017, AND 2018 -- 99441
SELECT COUNT(DISTINCT order_id) 
FROM orders o 

--total number OF orders IN 2016--329
SELECT count(DISTINCT order_id) AS total_2016_orders
FROM orders o 
WHERE order_purchase_timestamp LIKE "%2016%"

--total number OF orders IN 2017-- 45101
SELECT count(*) AS total_2017_orders
FROM orders o 
WHERE order_purchase_timestamp LIKE "%2017%"

--total number OF orders IN 2018-- 54011
SELECT count(*) AS total_2018_orders
FROM orders o 
WHERE order_purchase_timestamp LIKE "%2018%" 

--total distinct customers --99441 
SELECT count(DISTINCT customer_id) AS total_customers
FROM orders o 

--total number of customers who made orders IN 2016 -- 329
SELECT count(DISTINCT customer_id) AS total_2016_customers
FROM orders o 
WHERE order_purchase_timestamp LIKE "%2016%"

--total number of customers who made orders IN 2017 -- 45,101
SELECT count(DISTINCT customer_id) AS total_2017_customers
FROM orders o 
WHERE order_purchase_timestamp LIKE "%2017%"

--total number of customers who made orders IN 2018 -- 54,011
SELECT count(DISTINCT customer_id) AS total_2018_customers
FROM orders o 
WHERE order_purchase_timestamp LIKE "%2018%"

--REPEAT CUSTOMERS IN 2016 --0
SELECT customer_id, COUNT(DISTINCT order_purchase_timestamp)
FROM orders
WHERE order_purchase_timestamp LIKE "%2016%"
GROUP BY customer_id
ORDER BY COUNT(DISTINCT order_purchase_timestamp) DESC
    
--REPEAT CUSTOMERS IN 2017 --0
SELECT customer_id, COUNT(DISTINCT order_purchase_timestamp)
FROM orders
WHERE order_purchase_timestamp LIKE "%2017%"
GROUP BY customer_id
ORDER BY COUNT(DISTINCT order_purchase_timestamp) DESC
    
--REPEAT CUSTOMERS IN 2018 --0
SELECT customer_id, COUNT(DISTINCT order_purchase_timestamp)
FROM orders
WHERE order_purchase_timestamp LIKE "%2018%"
GROUP BY customer_id
ORDER BY COUNT(DISTINCT order_purchase_timestamp) DESC


SELECT COUNT(*) AS repeat_customers
FROM 
(
    SELECT customer_id, COUNT(customer_id) AS order_count
    FROM orders
    WHERE order_purchase_timestamp LIKE "%2016%" OR order_purchase_timestamp LIKE "%2017%" OR order_purchase_timestamp LIKE "%2018%"
    GROUP BY customer_id
    HAVING COUNT(DISTINCT order_purchase_timestamp) > 1
) AS repeat_customer_table;

---total number OF UNIQUE customers throughout ALL 3 years -- 99,441
SELECT count(DISTINCT(customer_id))
FROM orders o 

SELECT count(DISTINCT(customer_id))
FROM customers c 

--DELIVERY PERFORMANCE
--total number OF days BETWEEN time purchased AND delivery date
SELECT order_id, customer_id, order_purchase_timestamp, order_delivered_customer_date, (JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp)) AS days
FROM orders o 
GROUP BY o.order_id 
ORDER BY days DESC

-- avg, total number OF days BETWEEN time purchased AND delivery date throughout all years(13)
SELECT AVG(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) AS average_days
FROM orders 

-- avg, min, and max total number OF days BETWEEN time purchased AND delivery date in 2016 (20,5,70)
SELECT AVG(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2016%"

SELECT MIN(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2016%"

SELECT MAX(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2016%"

-- avg, min, and max total number OF days BETWEEN time purchased AND delivery date in 2017 (13,1,210)
SELECT AVG(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2017%"

SELECT MIN(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2017%"

SELECT MAX(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2017%"

-- avg, min, and max total number OF days BETWEEN time purchased AND delivery date in 2018 (12,1,208)
SELECT AVG(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2018%"

SELECT MIN(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2018%"

SELECT MAX(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2018%"

--total number OF days BETWEEN delivery date AND estimated delivery date--pos means early AND neg means late
SELECT order_id, customer_id, order_estimated_delivery_date, order_delivered_customer_date, (JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_delivered_customer_date)) AS days
FROM orders o 
GROUP BY o.order_id 
ORDER BY days DESC 


WITH cte AS (
    SELECT *,
        CASE
            WHEN total_days > 0 THEN 'Early'
            WHEN total_days < 0 THEN 'Late'
            ELSE 'On Time'
        END AS delivery_status
    FROM (
        SELECT order_id, customer_id, order_estimated_delivery_date, order_delivered_customer_date,
            julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date) AS total_days
        FROM orders 
    )
)
SELECT * FROM cte;

--avg, min AND max total number OF days BETWEEN delivery date AND estimated delivery date IN 2016--(36,-36,76)
SELECT AVG(julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2016%"

SELECT MIN(julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2016%"

SELECT MAX(julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2016%"


--avg, min AND max total number OF days BETWEEN delivery date AND estimated delivery date IN 2017--(12,-181,140)
SELECT AVG(julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2017%"

SELECT MIN(julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2017%"

SELECT MAX(julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2017%"

--avg, min AND max total number OF days BETWEEN delivery date AND estimated delivery date IN 2018--(11,-188,147)
SELECT AVG(julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2018%"

SELECT MIN(julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2018%"

SELECT MAX(julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date)) AS average_days
FROM orders 
WHERE order_purchase_timestamp LIKE "%2018%"

--total orders by number of days delivered before estimated delivery date

SELECT 
	ROUND(julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date)) AS delay_days,
	COUNT(order_id) AS total_order
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY delay_days
HAVING delay_days > 0
ORDER BY total_order DESC;

--delivery delays 
SELECT 
	ROUND(julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date)) AS delay_days,
	COUNT(order_id) AS total_order
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY delay_days
HAVING delay_days < 0
ORDER BY total_order DESC;


----- LOCATION 
--Cities where customers are making purchases 
SELECT o.order_id, o.customer_id, g.geolocation_city 
FROM orders o 
JOIN customers c 
ON o.customer_id = c.customer_id 
JOIN geolocation g 
ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix  
GROUP BY order_id 

--DISTINCT states IN Brazil WHERE orders were made --- 27
SELECT DISTINCT g.geolocation_state 
FROM orders o 
JOIN customers c 
ON o.customer_id = c.customer_id 
JOIN geolocation g 
ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix  
GROUP BY order_id 

----total orders IN EACH state 
SELECT DISTINCT c.customer_state, COUNT(DISTINCT o.order_id) AS total_orders 
FROM orders o 
JOIN customers c 
ON o.customer_id = c.customer_id 
GROUP BY c.customer_state 
ORDER BY total_orders DESC

--REVIEWS
-- althogh 99,000 orders, there ARE 155,832 for 78,325 DISTINCT orders. Why?
SELECT count(review_id)
FROM order_reviews or2

SELECT count(DISTINCT order_id)
FROM order_reviews or2

SELECT *
FROM order_reviews or2

SELECT DISTINCT review_score
FROM order_reviews or2

-- total number reviews with score 5, 4, 3, 2, 1. --89,908, 30,160, 18,002, 12,826 , 4,936
SELECT DISTINCT review_score, count(review_ID)
FROM order_reviews or2
GROUP BY review_score

--total comment messages -- 64,639 
SELECT count(review_comment_message)
FROM order_reviews or2
WHERE review_comment_message > ' '


--- types OF products with reviews 
SELECT DISTINCT (product_category_name)
FROM products p2 

SELECT or2.review_id, or2.order_id, review_score, p.product_category_name 
FROM order_reviews or2 
JOIN order_items oi 
ON or2.order_id = oi.order_id 
JOIN products p 
ON oi.product_id = p.product_id 

--number of review scores per category
SELECT p.product_category_name, count(or2.review_score) AS numreviews
FROM order_reviews or2 
JOIN order_items oi 
ON or2.order_id = oi.order_id 
JOIN products p 
ON oi.product_id = p.product_id 
GROUP BY p.product_category_name 
ORDER BY numreviews DESC

-- number of review comments per product category
SELECT p.product_category_name, count(or2.review_comment_message) AS numreviewcomment
FROM order_reviews or2 
JOIN order_items oi 
ON or2.order_id = oi.order_id 
JOIN products p 
ON oi.product_id = p.product_id
WHERE or2.review_comment_message > ' '
GROUP BY p.product_category_name 
ORDER BY numreviewcomment DESC

SELECT p.product_category_name, count(or2.review_comment_message) AS numreviewcomment
FROM order_reviews or2 
JOIN order_items oi 
ON or2.order_id = oi.order_id 
JOIN products p 
ON oi.product_id = p.product_id
WHERE or2.review_score = 5
GROUP BY p.product_category_name 
ORDER BY numreviewcomment DESC


--- count of orders per product category
SELECT p.product_category_name, count(o.order_id) AS totalorders
FROM orders o
JOIN order_items oi 
ON o.order_id = oi.order_id 
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY p.product_category_name 
ORDER BY totalorders DESC

--top 10 product categories most ordered by customers
WITH customer_products AS 
(
SELECT *
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id= o.order_id
JOIN products p ON p.product_id = oi.product_id
)
SELECT product_category_name, SUM(order_item_id) AS units
FROM customer_products
GROUP BY product_category_name
ORDER BY units DESC
LIMIT 10

--- CUSTOMER REVIEWS VS DELIVERY PERFORMANCE ANALYSIS

--total order by status
SELECT 
	DISTINCT order_status,
	COUNT(*) AS total_order
FROM orders
GROUP BY order_status
ORDER BY total_order DESC;

--Do customers leave better reviews when their delivery date is earlier than their estimated delivery date?

WITH cte AS (
    SELECT *,
        CASE
            WHEN total_days > 0 THEN 'Early'
            WHEN total_days < 0 THEN 'Late'
            ELSE 'On Time'
        END AS delivery_status
    FROM (
        SELECT order_id, customer_id, order_estimated_delivery_date, order_delivered_customer_date,
            julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date) AS total_days
        FROM orders 
    )
)
SELECT cte.order_id, or2.review_score, cte.total_days, cte.delivery_status
FROM cte
JOIN order_reviews or2 
ON or2.order_id = cte.order_id 
ORDER BY cte.total_days DESC;


--find avg number OF delivery days between estimated and delivered date per rating

WITH cte AS
(
SELECT o.order_id, or2.review_score, (julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date)) AS days
FROM orders o
JOIN order_reviews or2 
ON or2.order_id = o.order_id 
ORDER BY days DESC 
)
SELECT cte.review_score, avg(cte.days)
FROM cte 
GROUP BY cte.review_score 


----find avg number OF delivery days between purchase and delivery date per rating?
WITH cte AS
(
SELECT o.order_id, or2.review_score, (julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) AS days
FROM orders o
JOIN order_reviews or2 
ON or2.order_id = o.order_id 
ORDER BY days DESC 
)
SELECT cte.review_score, avg(cte.days)
FROM cte 
GROUP BY cte.review_score 

