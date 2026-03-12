
USE sales_dw;

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
    sales DECIMAL(10,3),
    quantity INT,
    discount DECIMAL(10,2),
    profit DECIMAL(10,2),

    FOREIGN KEY (order_id)    REFERENCES dim_order(order_id),
    FOREIGN KEY (order_date)  REFERENCES dim_date(order_date),
    FOREIGN KEY (product_id)  REFERENCES dim_product(product_id),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (postal_code) REFERENCES dim_location(postal_code)
);



/**/
