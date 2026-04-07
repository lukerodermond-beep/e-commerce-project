-- 02_cleanign
-- Data quality checks and cleaning
-- 
-- Total rows in raw data
SELECT COUNT(*) AS raw_row_count
FROM raw_transactions;

-- Negative quantities (returns)
SELECT COUNT(*) AS negative_quantity_count
FROM raw_transactions
WHERE quantity < 0;

-- Cancelled invoices
SELECT COUNT(*) AS cancelled_invoice_count
FROM raw_transactions
WHERE invoice_no LIKE 'C%';

-- Missing customer IDs (empty strings)
SELECT COUNT(*) AS missing_customer_id_count
FROM raw_transactions
WHERE customer_id = '';

-- Create clean dataset
CREATE TABLE clean_transactions AS
SELECT *
FROM raw_transactions
WHERE quantity > 0
  AND invoice_no NOT LIKE 'C%'
  AND customer_id <> '';

-- Check clean data size
SELECT COUNT(*) AS clean_row_count
FROM clean_transactions;