-- Creating an index to speed up lookups on plan type filters
CREATE INDEX idx_plan_type 
    ON plans_plan(id, is_a_fund, is_regular_savings);

-- Creating an index to optimize filtering and aggregation on transaction data
CREATE INDEX idx_savings_plan 
    ON savings_savingsaccount(plan_id, transaction_date);

-- Main query to identify plans with over 365 days of inactivity
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
FROM (
    -- Subquery: Aggregates last transaction date per plan
    SELECT 
        s.plan_id, 
        s.owner_id,
        CASE 
            WHEN p.is_a_fund = 1 THEN 'Investment'
            WHEN p.is_regular_savings = 1 THEN 'Savings'
        END AS type,
        DATE(MAX(s.transaction_date)) AS last_transaction_date
    FROM plans_plan p
    INNER JOIN savings_savingsaccount s ON p.id = s.plan_id
    WHERE p.is_a_fund = 1 OR p.is_regular_savings = 1
    GROUP BY s.plan_id, s.owner_id, type
) AS sub
WHERE DATEDIFF(CURDATE(), last_transaction_date) > 365;
