-- Create Index to Optimize plan filtering and joins
CREATE INDEX idx_plan_owner_type 
	ON plans_plan(owner_id, is_regular_savings, is_a_fund);

-- Create Index to Optimize savings aggregation
CREATE INDEX idx_savings_plan_amount 
	ON savings_savingsaccount(plan_id, confirmed_amount);

SELECT 
    p.owner_id, 
    CONCAT(us.first_name, ' ', us.last_name) AS name,
    COUNT(CASE WHEN p.is_regular_savings = 1 THEN 1 END) AS savings_count,
    COUNT(CASE WHEN p.is_a_fund = 1 THEN 1 END) AS investment_count,
    SUM(s.confirmed_amount / 100.0) AS total_deposits
FROM users_customuser us
INNER JOIN plans_plan p ON us.id = p.owner_id
INNER JOIN savings_savingsaccount s ON p.id = s.plan_id
WHERE p.is_regular_savings = 1 AND p.is_a_fund = 1
GROUP BY p.owner_id, us.first_name, us.last_name
ORDER BY total_deposits DESC;
