-- 03_analysis.sql
-- Business analysis & RFM segmentation

-- TOTAL REVENUE
SELECT 
    SUM(quantity * unit_price) AS total_revenue
FROM clean_transactions;

-- MONTHLY REVENUE
SELECT 
    DATE_TRUNC('month', invoice_date) AS month,
    SUM(quantity * unit_price) AS revenue
FROM clean_transactions
GROUP BY month
ORDER BY month;

-- TOP CUSTOMERS BY SPEND
SELECT 
    customer_id,
    SUM(quantity * unit_price) AS total_spent
FROM clean_transactions
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- TOP CUSTOMERS BY NUMBER OF ORDERS
SELECT 
    customer_id,
    COUNT(DISTINCT invoice_no) AS number_of_orders
FROM clean_transactions
GROUP BY customer_id
ORDER BY number_of_orders DESC
LIMIT 10;

-- RFM SEGMENTATION
SELECT 
    customer_id,
    MAX(invoice_date) AS last_purchase,
    (CURRENT_DATE - MAX(invoice_date)::date) AS recency_days,
    COUNT(DISTINCT invoice_no) AS frequency,
    SUM(quantity * unit_price) AS monetary,
    
    CASE 
        WHEN (CURRENT_DATE - MAX(invoice_date)::date) < 30 THEN 'Recent'
        WHEN (CURRENT_DATE - MAX(invoice_date)::date) < 90 THEN 'Warm'
        ELSE 'Cold'
    END AS recency_segment,
    
    CASE 
        WHEN COUNT(DISTINCT invoice_no) > 10 THEN 'High'
        WHEN COUNT(DISTINCT invoice_no) > 5 THEN 'Medium'
        ELSE 'Low'
    END AS frequency_segment,
    
    CASE 
        WHEN SUM(quantity * unit_price) > 10000 THEN 'High Value'
        WHEN SUM(quantity * unit_price) > 5000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS monetary_segment
FROM clean_transactions
GROUP BY customer_id;

-- TOP PRODUCTS BY REVENUE
SELECT 
    description,
    SUM(quantity) AS total_sold,
    SUM(quantity * unit_price) AS revenue
FROM clean_transactions
GROUP BY description
ORDER BY revenue DESC
LIMIT 10;

-- REVENUE BY COUNTRY
SELECT 
    country,
    SUM(quantity * unit_price) AS revenue
FROM clean_transactions
GROUP BY country
ORDER BY revenue DESC;

-- AVERAGE ORDER VALUE
SELECT AVG(order_total) AS avg_order_value
FROM (
    SELECT 
        invoice_no,
        SUM(quantity * unit_price) AS order_total
    FROM clean_transactions
    GROUP BY invoice_no
) sub;

-- MEDIAN ORDER VALUE
SELECT 
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY order_total) AS median_order_value
FROM (
    SELECT 
        invoice_no,
        SUM(quantity * unit_price) AS order_total
    FROM clean_transactions
    GROUP BY invoice_no
) sub;

-- TOP 10 HIGHEST VALUE ORDERS
SELECT 
    invoice_no,
    SUM(quantity * unit_price) AS order_total
FROM clean_transactions
GROUP BY invoice_no
ORDER BY order_total DESC
LIMIT 10;

SELECT 
    recency_segment,
    frequency_segment,
    monetary_segment,
    COUNT(*) AS number_of_customers
FROM (
    SELECT 
        customer_id,
        
        CASE 
            WHEN (CURRENT_DATE - MAX(invoice_date)::date) < 30 THEN 'Recent'
            WHEN (CURRENT_DATE - MAX(invoice_date)::date) < 90 THEN 'Warm'
            ELSE 'Cold'
        END AS recency_segment,
        
        CASE 
            WHEN COUNT(DISTINCT invoice_no) > 10 THEN 'High'
            WHEN COUNT(DISTINCT invoice_no) > 5 THEN 'Medium'
            ELSE 'Low'
        END AS frequency_segment,
        
        CASE 
            WHEN SUM(quantity * unit_price) > 10000 THEN 'High Value'
            WHEN SUM(quantity * unit_price) > 5000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS monetary_segment

    FROM clean_transactions
    GROUP BY customer_id
) sub
GROUP BY recency_segment, frequency_segment, monetary_segment
ORDER BY number_of_customers DESC;