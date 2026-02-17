-- ============================================
-- TIME & TREND ANALYSIS
-- Dataset: Olist Brazilian E-Commerce
-- ============================================

--26. How does order volume change month over month in 2017?
SELECT strftime('%m', O.order_purchase_timestamp) AS Month,
COUNT(*) AS Order_Count
FROM Orders O 
WHERE strftime('%Y', O.order_purchase_timestamp) = '2017'
GROUP BY Month
ORDER BY Month;

--27. Are there seasonal spikes in 2017 for orders or revenue?
SELECT CASE 
WHEN strftime('%m', O.order_purchase_timestamp) IN ('12','01','02') THEN 'Winter'
WHEN strftime('%m', O.order_purchase_timestamp) IN ('03','04','05') THEN 'Spring'
WHEN strftime('%m', O.order_purchase_timestamp) IN ('06','07','08') THEN 'Summer'
WHEN strftime('%m', O.order_purchase_timestamp) IN ('09','10','11') THEN 'Fall'
ELSE NULL END AS Season,
COUNT(DISTINCT O.order_id) AS 'Orders',
SUM(oi.price + oi.freight_value) AS 'Revenue'
FROM Orders O
JOIN Order_Items oi ON O.order_id = oi.order_id
WHERE O.order_status = 'delivered' AND strftime('%Y', O.order_purchase_timestamp) = '2017'
GROUP BY 1
ORDER BY 3 DESC;

--28. What day of the week has the highest number of purchases?
SELECT
CASE strftime('%w', order_purchase_timestamp)
WHEN '0' THEN 'Sunday'
WHEN '1' THEN 'Monday'
WHEN '2' THEN 'Tuesday'
WHEN '3' THEN 'Wednesday'
WHEN '4' THEN 'Thursday'
WHEN '5' THEN 'Friday'
WHEN '6' THEN 'Saturday'
END AS day_of_week,
COUNT(*) AS orders
FROM Orders
GROUP BY 1
ORDER BY 2 DESC;

--29. What time of day do most purchases occur?
SELECT
CASE
WHEN CAST(strftime('%H', order_purchase_timestamp) AS INTEGER) BETWEEN 5 AND 11
THEN 'Morning'
WHEN CAST(strftime('%H', order_purchase_timestamp) AS INTEGER) BETWEEN 12 AND 16
THEN 'Afternoon'
WHEN CAST(strftime('%H', order_purchase_timestamp) AS INTEGER) BETWEEN 17 AND 20
THEN 'Evening'
ELSE 'Night'
END AS time_of_day,
COUNT(*) AS orders
FROM Orders
GROUP BY 1
ORDER BY 2 DESC;

--30. What days have the most orders in 2017?
SELECT strftime('%m-%d', order_purchase_timestamp) AS 'Day',
COUNT(*) AS orders
FROM Orders
WHERE strftime('%Y', order_purchase_timestamp) = '2017'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
