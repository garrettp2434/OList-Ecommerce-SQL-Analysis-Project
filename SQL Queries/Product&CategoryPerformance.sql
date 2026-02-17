-- ============================================
-- PRODUCT AND CATEGORY PERFORMANCE ANALYSIS
-- Dataset: Olist Brazilian E-Commerce
-- ============================================

--21. How many products exist in each product category (English)?
SELECT T.product_category_name_english AS Product_Category,
COUNT(P.product_id) AS Product_Count
FROM Products P
JOIN Translation T ON P.product_category_name = T.product_category_name
GROUP BY 1;

--22. Which product categories have the highest average price?
SELECT T.product_category_name_english AS 'Product Category', AVG(oi.price) AS 'AVG Price'
FROM Order_Items oi
JOIN Products P ON oi.product_id = P.product_id
JOIN Translation T ON P.product_category_name = T.product_category_name
GROUP BY 1
ORDER BY 2 DESC;

--23. Which categories generate the most orders (not revenue)?
SELECT T.product_category_name_english AS 'Product Category', COUNT(*) AS 'Number of Orders'
FROM Orders O
JOIN Order_Items oi ON O.order_id = oi.order_id
JOIN Products P ON oi.product_id = P.product_id
JOIN Translation T ON P.product_category_name = T.product_category_name
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--24. What categories have the lowest average freight cost?
SELECT T.product_category_name_english AS 'Product Category', AVG(oi.freight_value) AS 'AVG Freight Value'
FROM Order_Items oi
JOIN Products P ON oi.product_id = P.product_id
JOIN Translation T ON P.product_category_name = T.product_category_name
GROUP BY 1
ORDER BY 2;

--25. Which categories have the highest freight-to-price ratio?
SELECT T.product_category_name_english AS 'Product Category',
ROUND((SUM(oi.freight_value)/SUM(oi.price)),3) AS 'Freight to Price Ratio'
FROM Order_Items oi
JOIN Products P ON oi.product_id = P.product_id
JOIN Translation T ON P.product_category_name = T.product_category_name
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;