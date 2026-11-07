USE superstore;

-- Query 1: Sales and profit by region
SELECT region,
       ROUND(SUM(sales),2) AS total_sales,
       ROUND(SUM(profit),2) AS total_profit,
       ROUND(SUM(profit)/SUM(sales)*100,2) AS profit_margin_pct
FROM orders
GROUP BY region
ORDER BY total_profit DESC;

-- Query 2: Top 10 products by profit
SELECT product_name,
       ROUND(SUM(profit),2) AS total_profit,
       ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;

-- Query 3: Monthly sales trend with month-over-month growth (window function)
WITH monthly AS (
  SELECT DATE_FORMAT(order_dt,'%Y-%m') AS month,
         SUM(sales) AS sales
  FROM orders
  GROUP BY month
)
SELECT month,
       ROUND(sales,2) AS sales,
       ROUND((sales - LAG(sales) OVER (ORDER BY month))
             / LAG(sales) OVER (ORDER BY month) * 100, 2) AS mom_growth_pct
FROM monthly
ORDER BY month;

-- Query 4: Loss-making sub-categories and average discount
SELECT category, sub_category,
       ROUND(SUM(profit),2) AS total_profit,
       ROUND(AVG(discount)*100,1) AS avg_discount_pct
FROM orders
GROUP BY category, sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit;

-- Query 5: Customer segment performance
SELECT segment,
       COUNT(DISTINCT customer_id) AS customers,
       ROUND(SUM(sales),2) AS total_sales,
       ROUND(SUM(profit),2) AS total_profit,
       ROUND(SUM(profit)/SUM(sales)*100,2) AS profit_margin_pct,
       ROUND(SUM(sales)/COUNT(DISTINCT customer_id),2) AS sales_per_customer
FROM orders
GROUP BY segment
ORDER BY total_profit DESC;