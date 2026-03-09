
-- Total Revenue and Total Orders
SELECT
    SUM(sales)               AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders
FROM fact_sales;

-- Top 10 Products by Revenue
SELECT TOP 10
    p.product_name,
    SUM(f.sales) AS total_revenue
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Sales by Region and Category
SELECT
    l.region,
    p.category,
    SUM(f.sales)  AS total_revenue,
    SUM(f.profit) AS total_profit
FROM fact_sales f
JOIN dim_location l ON f.postal_code  = l.postal_code
JOIN dim_product  p ON f.product_id   = p.product_id
GROUP BY l.region, p.category
ORDER BY l.region, total_revenue DESC;

-- Monthly Revenue Trends
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.sales)             AS total_revenue,
    COUNT(DISTINCT f.order_id) AS total_orders
FROM fact_sales f
JOIN dim_date d ON f.order_date = d.order_date
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;



