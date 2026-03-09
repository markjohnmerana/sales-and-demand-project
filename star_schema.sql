
/*

CREATE TABLE dim_order(
    order_id VARCHAR(50) PRIMARY KEY,
    ship_date DATE,
    ship_mode VARCHAR(20)
);


CREATE TABLE dim_date(
    order_date DATE PRIMARY KEY,
    day INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    year INT
);

CREATE TABLE dim_product(
    product_id VARCHAR(50) PRIMARY KEY,
    category VARCHAR(20),
    sub_category VARCHAR(20),
    product_name VARCHAR(255)
);

CREATE TABLE dim_customer(
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(20)
);

CREATE TABLE dim_location(
    postal_code INT PRIMARY KEY,
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    region VARCHAR(20)
);

CREATE TABLE fact_sales(
    row_id INT PRIMARY KEY IDENTITY(1,1),
    order_date DATE,
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    customer_id VARCHAR(50),
    postal_code INT,
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(10,2),
    profit DECIMAL(10,2),

    FOREIGN KEY (order_id)    REFERENCES dim_order(order_id),
    FOREIGN KEY (order_date)  REFERENCES dim_date(order_date),
    FOREIGN KEY (product_id)  REFERENCES dim_product(product_id),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (postal_code) REFERENCES dim_location(postal_code)
); */

/*USE sales_dw;

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
DELETE FROM dim_location;*/


--COUNT(*)Counts all rows — 9,994
--COUNT(DISTINCT order_id)Counts unique orders — 5,009
/*SELECT 
	SUM(sales) AS revenue,
	COUNT(DISTINCT order_id) AS total_orders
FROM fact_sales;*/


