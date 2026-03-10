USE sales_dw;

SELECT COUNT(*) AS total_rows FROM fact_sales;
SELECT COUNT(*) AS total_customers FROM dim_customer;
SELECT COUNT(*) AS total_products FROM dim_product;
SELECT COUNT(*) AS total_orders FROM dim_order;
SELECT COUNT(*) AS total_locations FROM dim_location;
SELECT COUNT(*) AS total_dates FROM dim_date;

USE sales_dw;

DELETE FROM fact_sales;
DELETE FROM dim_order;
DELETE FROM dim_date;
DELETE FROM dim_customer;
DELETE FROM dim_product;
DELETE FROM dim_location;

SELECT 
	SUM(sales) AS revenue,
	COUNT(DISTINCT order_id) AS total_orders
FROM fact_sales;