-- ============================================
-- SALES & REVENUE ANALYSIS
-- Dataset: Olist Brazilian E-Commerce
-- ============================================

--1. What is the total revenue from delivered orders?
SELECT SUM(i.price + i.freight_value) AS 'Total Revenue'
FROM Order_Items i
JOIN Orders O
ON O.order_id = i.order_id
WHERE O.order_status = 'delivered';

--2. How does monthly revenue trend over time (2017)?
SELECT strftime('%m',O.order_purchase_timestamp) AS Month,
SUM(i.price + i.freight_value) AS Revenue
FROM Order_Items i
JOIN Orders O
ON O.order_id = i.order_id
WHERE strftime('%Y',O.order_purchase_timestamp) = '2017'
GROUP BY Month
ORDER BY Month;

--3. Which product categories (English) generate the most revenue?
SELECT T.product_category_name_english AS 'Product Category', SUM(i.price + i.freight_value) AS 'Revenue'
FROM Order_Items i 
JOIN Products P ON i.product_id = p.product_id
JOIN Translation T ON T.product_category_name = P.product_category_name
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--4. What are the top 10 products by total revenue?
SELECT P.product_id AS 'Product ID', SUM(i.price + i.freight_value) AS 'Total Revenue'
FROM Order_Items i 
JOIN Products P ON i.product_id = p.product_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
--5. What is the average order value (AOV)?
SELECT AVG(order_total) AS AOV
FROM (
    SELECT O.order_id,
           SUM(i.price + i.freight_value) AS order_total
    FROM Orders O
    JOIN Order_Items i ON O.order_id = i.order_id
    GROUP BY O.order_id
);

--6. How does AOV change by month?
SELECT strftime('%Y - %m', order_purchase_timestamp) as Month, AVG(order_total) AS AOV
FROM (
    SELECT SUM(i.price + i.freight_value) AS order_total, O.order_purchase_timestamp
    FROM Orders O
    JOIN Order_Items i ON O.order_id = i.order_id
    GROUP BY 2)
GROUP BY Month
ORDER BY Month;

--7. What percentage of total revenue comes from the top 20% of products?
SELECT top20.top_20_rev / total.total_rev AS top_20_revenue_share
FROM
  -- total revenue
    (SELECT SUM(price + freight_value) AS total_rev FROM order_items) AS total,
  -- revenue from top 20% of products
    (SELECT SUM(prod_rev) AS top_20_rev
    FROM (
        SELECT SUM(price + freight_value) AS prod_rev
        FROM order_items
        GROUP BY product_id
        ORDER BY prod_rev DESC
        LIMIT CAST(
            (SELECT COUNT(DISTINCT product_id) FROM order_items) * 0.2
            AS INTEGER)
    )
  ) AS top20;

--8. Which orders have the highest total value?
SELECT i.order_id AS 'Order ID',(i.price + i.freight_value) AS 'Order Value'
FROM Order_Items i 
ORDER BY 2 DESC;