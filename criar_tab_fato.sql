DROP TABLE IF EXISTS dw.fact_sales CASCADE;
CREATE TABLE dw.fact_sales(
    invoice_nk    VARCHAR(20) PRIMARY KEY,
    date_sk       INTEGER NOT NULL REFERENCES dw.dim_date(date_sk),
    branch_sk     INTEGER NOT NULL REFERENCES dw.dim_branch(branch_sk),
    product_sk    INTEGER NOT NULL REFERENCES dw.dim_product(product_sk),
    customer_sk   INTEGER NOT NULL REFERENCES dw.dim_customer(customer_sk),
    payment_sk    INTEGER NOT NULL REFERENCES dw.dim_payment(payment_sk),
    unit_price    NUMERIC(10, 2) NOT NULL,
    quantity      INTEGER NOT NULL,
    total         NUMERIC(12, 2) NOT NULL,
    tax           NUMERIC(10, 4) NOT NULL,
    cogs          NUMERIC(12, 2) NOT NULL,
    gross_income  NUMERIC(10, 4) NOT NULL,
    rating        NUMERIC(4, 1) NOT NULL
);

INSERT INTO dw.fact_sales (
    invoice_nk, date_sk,
    branch_sk, product_sk, customer_sk, payment_sk,
    unit_price, quantity, total, tax, cogs, gross_income, rating
)
SELECT
    s.invoice_id,
    CAST(TO_CHAR(s.sale_ts, 'YYYYMMDD') AS INTEGER),
    db.branch_sk,
    dp.product_sk,
    dc.customer_sk,
    dpa.payment_sk,
    s.unit_price, 
    s.quantity, 
    s.total,
    s.tax_5pct, 
    s.cogs, 
    s.gross_income, 
    s.rating
FROM staging.sales s
JOIN dw.dim_branch db   ON db.branch_code = s.branch
JOIN dw.dim_product dp  ON dp.product_line = s.product_line
JOIN dw.dim_customer dc ON dc.customer_type = s.customer_type AND dc.gender = s.gender
JOIN dw.dim_payment dpa ON dpa.payment_type = s.payment;

SELECT * FROM dw.fact_sales;

SELECT
    d.year,
    d.month_name,
    b.branch_code                   AS filial,
    b.city,
    COUNT(*)                        AS vendas,
    SUM(f.total)::NUMERIC(12, 2)    AS receita,
    ROUND(AVG(f.total), 2)          AS ticket_medio
FROM dw.fact_sales f 
JOIN dw.dim_date   d ON d.date_sk   = f.date_sk 
JOIN dw.dim_branch b ON b.branch_sk = f.branch_sk
GROUP BY d.year, d.month, d.month_name, b.branch_code, b.city
ORDER BY d.month, filial;
