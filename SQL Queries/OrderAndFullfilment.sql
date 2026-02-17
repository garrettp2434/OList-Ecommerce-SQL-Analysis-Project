-- ============================================
-- ORDER AND FULLFILMMENT ANALYSIS
-- Dataset: Olist Brazilian E-Commerce
-- ============================================

--15. How many orders fall into each order status?
SELECT COUNT(order_id) AS 'Order Count', order_status
FROM Orders
GROUP BY order_status
ORDER BY 1 DESC;

--16. What percentage of orders are delivered vs canceled?
SELECT 1.0 * D_Total/Order_Total AS Delivered_Percent, 1.0 * C_Total/Order_Total AS Canceled_Percent
FROM (
    SELECT COUNT(order_status) AS Order_Total,
    SUM( CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) AS D_Total,
    SUM( CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) AS C_Total
    FROM Orders
    WHERE order_status = 'delivered' OR order_status = 'canceled'
);

--17. What is the average delivery time (purchase → delivery)?
SELECT AVG(JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp)) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

--18. How does delivery time vary by state?
SELECT c.customer_state AS State, AVG(JULIANDAY(o.order_delivered_customer_date) - JULIANDAY(o.order_purchase_timestamp)) AS avg_delivery_days
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY 1
ORDER BY 2;

--19. What percentage of orders are delivered late (after estimated delivery date)?
SELECT 
1.0 * On_Time/Order_Total AS On_Time_Percent, 
1.0 * Late/Order_Total AS Late_Percent
FROM(
    SELECT 
    COUNT(*) AS Order_Total,
    SUM(CASE WHEN JULIANDAY(order_delivered_customer_date) <= JULIANDAY(order_estimated_delivery_date) THEN 1 ELSE 0 END) AS On_Time,
    SUM(CASE WHEN JULIANDAY(order_delivered_customer_date) > JULIANDAY(order_estimated_delivery_date) THEN 1 ELSE 0 END) AS Late
    FROM Orders
    WHERE order_status = 'delivered'
    );

--20. How does late delivery rate vary by product category?
SELECT T.product_category_name_english,
1.0 * SUM(CASE WHEN JULIANDAY(O.order_delivered_customer_date) 
> JULIANDAY(O.order_estimated_delivery_date) THEN 1 ELSE 0 END) 
/ COUNT(*) * 100 AS Late_Percent
FROM Orders O
JOIN Order_Items oi
  ON O.order_id = oi.order_id
JOIN Products P
  ON oi.product_id = P.product_id
JOIN Translation t
  ON P.product_category_name = T.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 2 DESC;