

CREATE TABLE dim_date(
    order_date DATE PRIMARY KEY,
    day INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    year INT
);