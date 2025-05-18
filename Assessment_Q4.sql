-- Index to optimize JOIN and WHERE clause filtering on commonly queried columns
CREATE INDEX idx_savings_success 
    ON savings_savingsaccount(owner_id, transaction_status, confirmed_amount);

-- Query to calculate Estimated CLV per customer    
SELECT us.id AS customer_id, concat(us.first_name,' ',us.last_name) AS name, 
		ROUND(DATEDIFF(curdate(),us.date_joined)/30.0) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        ROUND(
        COUNT(s.id) / NULLIF(DATEDIFF(CURDATE(), us.date_joined) / 30.0, 0) 
        * 12 
        * AVG(s.confirmed_amount / 100.0 * 0.001), 
    2) AS estimated_clv
FROM users_customuser us
INNER JOIN savings_savingsaccount s ON us.id = s.owner_id
WHERE s.transaction_status = 'success'
GROUP BY us.id, us.first_name, us.last_name, us.date_joined;
