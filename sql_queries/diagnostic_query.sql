USE sales_dw;

--
SELECT
    l.region,
    c.segment,
    SUM(f.sales)    AS total_revenue,
    SUM(f.quantity) AS total_quantity,
    AVG(f.discount) AS avg_discount,
    SUM(f.profit)   AS total_profit
FROM fact_sales f
JOIN dim_product  p ON f.product_id   = p.product_id
JOIN dim_location l ON f.postal_code  = l.postal_code
JOIN dim_customer c ON f.customer_id  = c.customer_id
WHERE p.product_name LIKE '%Canon imageCLASS%'
GROUP BY l.region, c.segment
ORDER BY total_revenue DESC;

SELECT TOP 10
    p.product_name,
    p.category,
    p.sub_category,
    SUM(f.sales)    AS total_revenue,
    SUM(f.quantity) AS total_units
FROM fact_sales f
JOIN dim_product  p ON f.product_id  = p.product_id
JOIN dim_location l ON f.postal_code = l.postal_code
WHERE l.region = 'South'
GROUP BY p.product_name, p.category, p.sub_category
ORDER BY total_units DESC;

SELECT TOP 10
    p.product_name,
    p.sub_category,
    c.segment,
    SUM(f.sales)    AS total_revenue,
    SUM(f.quantity) AS total_units,
    AVG(f.discount) AS avg_discount,
    SUM(f.profit)   AS total_profit
FROM fact_sales f
JOIN dim_product  p ON f.product_id  = p.product_id
JOIN dim_location l ON f.postal_code = l.postal_code
JOIN dim_customer c ON f.customer_id = c.customer_id
WHERE l.region   = 'East'
AND   p.category = 'Technology'
GROUP BY p.product_name, p.sub_category, c.segment
ORDER BY total_revenue DESC;

SELECT
    l.region,
    AVG(f.discount)                        AS avg_discount,
    SUM(f.sales)                           AS total_revenue,
    SUM(f.profit)                          AS total_profit,
    (SUM(f.profit) / SUM(f.sales)) * 100   AS profit_margin
FROM fact_sales f
JOIN dim_location l ON f.postal_code = l.postal_code
GROUP BY l.region
ORDER BY avg_discount DESC;