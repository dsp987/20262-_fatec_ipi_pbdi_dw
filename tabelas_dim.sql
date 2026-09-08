DROP TABLE IF EXISTS dw.dim_branch CASCADE;
CREATE TABLE dw.dim_branch(
    branch_sk SERIAL PRIMARY KEY,
    branch_code CHAR(1) NOT NULL UNIQUE,
    city VARCHAR(40) NOT NULL
);

SELECT * FROM dw.dim_branch;

DROP TABLE IF EXISTS dw.dim_product CASCADE;
CREATE TABLE dw.dim_product(
    product_sk SERIAL PRIMARY KEY,
    product_line VARCHAR(40) NOT NULL UNIQUE
);

SELECT * FROM dw.dim_product;

DROP TABLE IF EXISTS dw.dim_customer CASCADE;
CREATE TABLE dw.dim_customer(
    customer_sk SERIAL PRIMARY KEY,
    customer_type VARCHAR(10) NOT NULL,
    gender        VARCHAR(10) NOT NULL,
    UNIQUE(customer_type, gender)
);

SELECT * FROM dw.dim_customer;

DROP TABLE IF EXISTS dw.dim_payment CASCADE;
CREATE TABLE dw.dim_payment(
    payment_sk      SERIAL PRIMARY KEY,
    payment_type    VARCHAR(20) NOT NULL UNIQUE
);

SELECT * FROM dw.dim_customer;
