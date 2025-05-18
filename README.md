# DataAnalytics-Assessment

## ASSESSMENT_Q1

### High-Value Customers with Multiple Products

**Goal:** Identify customers who have both a savings and an investment plan (cross-selling opportunity).

This SQL query provides a summary of customer savings and investment behavior, including:

•	Number of savings and investment plans per customer

•	Total confirmed deposits (converted from Kobo to Naira)

**Steps Taken:**

- Added indexes on `owner_id`, `is_regular_savings`, and `is_a_fund` to speed up filtering by plan type and ensures efficient aggregation.

- Used conditional counts via `CASE WHEN` to distinguish between users who use savings, investments, or both.

- Used 'INNER JOIN' and 'Where Clause' to ensure that only users who have at least one plan (plans_plan) and at least one savings record (savings_savingsaccount) are included.

- Used sum of `confirmed_amount / 100.0` to convert transaction values from kobo to naira for readability.

- Sorted by `total_deposits` to quickly highlight high-value customers for potential upselling or rewards.

#### N/B: It is worthy to note that the result of this query did not return any data. This is because the dataset currently does not contain any customer who has both a savings plan and an investment plan simultaneously.


## ASSESSMENT_Q2

### Transaction Frequency Analysis

**Goal:**  Analyze how often customers transact to segment them (e.g., frequent vs. occasional users).

This query classifies customers based on their average monthly transaction frequency using savings account data.

**Steps Taken:**

- Created indexes on `transaction_status`, `owner_id`, and `transaction_date` to speed filtering and grouping.
  
- Used a CTE (`Monthly_transactions`) to calculate total successful transactions per user per month.
  
- Aggregated monthly data per user (`Average_transactions`) to compute average transactions and active months.
  
- Classified users into frequency categories (High, Medium, Low) with a CASE statement in a third CTE (`Frequency_classification`).
  
- Final aggregation summarized counts per frequency category and calculated average transactions per month.


## ASSESSMENT_Q3
### Account Inactivity Alert

**Goal:**  Flag accounts with no inflow transactions for over one year.

This query identifies customer plans (either savings or investment) with over 365 days of inactivity, based on the most recent transaction date.

**Steps Taken:**

- Indexed key columns on `plans_plan` and `savings_savingsaccount` to optimize joins and date filtering.
  
- Aggregated the latest transaction date per plan and owner using `MAX(transaction_date)`
  
- Classified plan types as 'Investment' or 'Savings' using CASE logic.
  
- Filtered results to only include plans inactive for more than one year.



## ASSESSMENT_Q4

### Customer Lifetime Value (CLV) Estimation

**Goal:** estimate CLV based on account tenure and transaction volume (simplified model).

This query calculates an estimated CLV (Customer Lifetime Value) for each user based on their successful transactions, using tenure and average contribution per transaction.

**Steps Taken:**

- Created composite index on `owner_id`, `transaction_status`, and `confirmed_amount` for fast filtering and joins.
  
- Calculated tenure in months for each user.
  
- Counted total successful transactions per user.
  
- Converted confirmed deposits from Kobo to Naira
  
- Computed estimated CLV by annualizing monthly transactions multiplied by average transaction value, with safeguards against division by zero.

- Grouped by user details for granular insights.


#### Each query was iteratively refined with indexes and CTEs for clarity, maintainability, and performance on large datasets.

# Challenges Faced During SQL Query Development

Below are the key challenges encountered while developing and optimizing the SQL queries for task;


## 1. Accurate Aggregation Logic

- Ensuring correct counts and averages across time periods.
  
- Avoiding duplicated counts from improper joins or grouping.
  
- Used Common Table Expressions (CTEs) and `GROUP BY` to organize logic.
  
- Prevented divide-by-zero errors using `NULLIF`.

## 2. Performance Optimization

- Queries initially ran slowly.
  
- Without indexes, filtering and joining caused full table scans.
  
- Created composite indexes on frequently filtered columns (`transaction_status`, `owner_id`, `plan_id`) to speed up execution.

## 3. Complex Conditional Logic

- Needed to classify users by transaction frequency (High, Medium, Low).
  
- Differentiated plans by type (Savings vs Investment) using conditional `CASE` statements.
  
- Modularized with CTEs to maintain readability and ease debugging.


 
