
-- 01_schema.sql
-- Create database tables

CREATE TABLE raw_transactions (
    invoice_no TEXT,
    stock_code TEXT,
    description TEXT,
    quantity INT,
    invoice_date TIMESTAMP,
    unit_price NUMERIC,
    customer_id TEXT,
    country TEXT
);