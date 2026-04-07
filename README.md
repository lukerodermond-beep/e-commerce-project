# E-commerce Customer and Revenue Analysis (SQL)

## Overview

This project analyzes an e-commerce dataset using SQL. The goal is to understand revenue patterns and customer behavior based on transaction data.

The dataset contains more than 500,000 transactions from an online retail store.

## Data

The dataset used in this project is too large to be stored in this repository.

You can download it from:
https://www.kaggle.com/datasets/ulrikthygepedersen/online-retail-dataset

After downloading, place the CSV file in the `data/` folder.

---

## Objective

The main goals of this project are:

* Clean raw transaction data
* Analyze total and monthly revenue
* Identify top customers
* Understand order value distribution
* Perform customer segmentation using RFM

---

## Tools Used

* PostgreSQL
* DBeaver
* SQL

---

## Dataset

The data comes from the Online Retail dataset (Kaggle). It includes:

* Invoice number
* Product description
* Quantity
* Unit price
* Customer ID
* Country

---

## Data Cleaning

The raw dataset contained returns, cancelled orders, and missing customer IDs. These were removed before analysis:

```sql
CREATE TABLE clean_transactions AS
SELECT *
FROM raw_transactions
WHERE quantity > 0
AND invoice_no NOT LIKE 'C%'
AND customer_id <> '';
```

The cleaned dataset is stored as a new table (`clean_transactions`) in PostgreSQL rather than as a separate file.

---

## Analysis and Results

### Total Revenue

The total revenue across all transactions is approximately:

8,911,407

---

### Monthly Revenue

Revenue was grouped by month to observe trends.

There is a clear increase in revenue towards the end of the year, especially in the last quarter. This likely reflects seasonal demand (for example holidays).

---

### Top Customers

The top customers were identified based on total spending.

The highest spending customer spent over 280,000. This shows that a relatively small group of customers contributes a large share of total revenue.

---

### Order Value Distribution

The average and median order values were compared:

* Average order value: 480
* Median order value: 303

The average is higher than the median, which indicates a skewed distribution. This means that a small number of large orders increase the average, while most orders are smaller.

---

### Customer Segmentation (RFM)

Customers were segmented based on:

* Recency (how recently they purchased)
* Frequency (how often they purchased)
* Monetary value (how much they spent)

The distribution of customers across segments is:

* Cold / Low / Low Value: 3442 customers
* Cold / Medium / Low Value: 482 customers
* Cold / High / Low Value: 140 customers
* Cold / High / Medium Value: 111 customers
* Cold / High / High Value: 86 customers
* Other segments contain smaller numbers of customers

Most customers fall into the low frequency and low value group, while only a small number of customers are high value.

All customers are classified as "Cold". This is because the dataset is from 2011, while recency is calculated using the current date. As a result, all customers appear inactive.

---

## Project Structure

ecommerce_project/

├── data/
│   └── online_retail.csv (raw dataset)

├── sql/
│   ├── 01_schema.sql (table creation)
│   ├── 02_cleaning.sql (data cleaning)
│   └── 03_analysis.sql (analysis queries)

├── README.md

├── requirements.txt
├── .gitignore


---

## Conclusion

This project shows how SQL can be used to clean and analyze transaction data to identify revenue patterns, customer concentration, and differences in purchasing behavior.

Key findings:

* Revenue is concentrated among a small group of customers
* There are clear seasonal patterns in revenue
* Order values are skewed due to large purchases
* Most customers have low engagement, while a small group has high value

---

## Possible Improvements

* Add visualizations using Python or Power BI
* Use a relative recency measure instead of the current date
* Build a predictive model for customer value or churn
