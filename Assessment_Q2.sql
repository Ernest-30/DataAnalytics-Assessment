-- Creating an index to speed up WHERE clause filtering by transaction_status
CREATE INDEX idx_transaction_status 
    ON savings_savingsaccount(transaction_status);

-- Creating a composite index to optimize filtering and grouping by owner_id and transaction_date
CREATE INDEX idx_owner_date 
    ON savings_savingsaccount(owner_id, transaction_date);


-- Step 1: Calculate total transactions per user per month
WITH Monthly_transactions AS (
    SELECT 
        owner_id, 
        YEAR(transaction_date) AS year_id, 
        MONTH(transaction_date) AS month_id, 
        COUNT(*) AS total_transactions
    FROM savings_savingsaccount
    WHERE transaction_status = 'success'
    GROUP BY 
        owner_id, 
        YEAR(transaction_date), 
        MONTH(transaction_date)
),

-- Step 2: Calculate average transactions per month for each user
Average_transactions AS (
    SELECT 
        owner_id,
        COUNT(*) AS active_months, -- Number of months with transactions
        SUM(total_transactions) AS total_txns, -- Total transactions across all months
        CAST(SUM(total_transactions) AS DECIMAL(10,2)) / COUNT(*) AS avg_txn_per_month -- Average transactions per active month
    FROM Monthly_transactions
    GROUP BY owner_id
),

-- Step 3: Classify users based on their average transaction frequency
Frequency_classification AS (
    SELECT 
        owner_id, 
        active_months, 				
        total_txns, 
        avg_txn_per_month,
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month > 2 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM Average_transactions
)

-- Step 4: Aggregate by frequency category to get user count and average transaction frequency
SELECT 
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(SUM(total_txns * 1.0) / SUM(active_months), 1) AS avg_transactions_per_month
FROM frequency_classification
GROUP BY frequency_category;
