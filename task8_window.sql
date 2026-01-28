
-- task8_window.sql

-- Total sales per customer
SELECT customer_id, customer_name, region, SUM(sales) AS total_sales
FROM orders
GROUP BY customer_id, customer_name, region;

-- Ranking customers by region
SELECT customer_id, customer_name, region, SUM(sales) AS total_sales,
DENSE_RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rank_in_region
FROM orders
GROUP BY customer_id, customer_name, region;

-- Running total of sales
SELECT order_date, sales,
SUM(sales) OVER (ORDER BY order_date) AS running_total_sales
FROM orders;

-- Monthly sales and MoM growth
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', order_date) AS month,
           SUM(sales) AS monthly_total
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT month, monthly_total,
LAG(monthly_total) OVER (ORDER BY month) AS prev_month_sales,
monthly_total - LAG(monthly_total) OVER (ORDER BY month) AS mom_growth
FROM monthly_sales;
