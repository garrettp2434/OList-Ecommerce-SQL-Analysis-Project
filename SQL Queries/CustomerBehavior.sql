-- ============================================
-- CUSTOMER BEHAVIOR ANALYSIS
-- Dataset: Olist Brazilian E-Commerce
-- ============================================

--9. How many unique customers placed at least one order?
SELECT COUNT(DISTINCT customer_id) AS 'Unique_Customers'
FROM Customers;

--10. Are there any repeat customers?
SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
);

--11. How many orders does the average customer place?
SELECT AVG(Order_Count) AS avg_orders
FROM (
    SELECT COUNT(order_id) AS Order_Count
    FROM orders
    GROUP BY customer_id
    );

--12. Which states have the highest number of customers?
SELECT customer_state, COUNT(customer_unique_id) AS customer_count
FROM Customers
GROUP BY customer_state
ORDER BY 2 DESC
LIMIT 5;

--13. Which states generate the most revenue?
SELECT C.customer_state AS STATE, SUM(i.price + i.freight_value) AS Revenue
FROM Orders O
JOIN Order_Items i ON O.order_id = i.order_id
JOIN Customers C ON O.customer_id = C.customer_id
GROUP BY STATE
ORDER BY REVENUE DESC
LIMIT 5;
--14.How does customer order averages differ by state?
SELECT customer_state AS STATE, AVG(order_count) AS Order_Count
FROM(
    SELECT C.customer_state, COUNT(O.order_id) AS order_count
    FROM Orders O
    JOIN Customers C ON O.customer_id = C.customer_id
    GROUP BY C.customer_state, C.customer_id
    )
GROUP BY 1
ORDER BY 2;

