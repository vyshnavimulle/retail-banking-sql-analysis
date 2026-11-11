CREATE DATABASE retail_banking;
USE retail_banking;

-- -------------------------------------------------------------------------------------------------------------------------------------------
-- Sprint 1: Business Understanding and Data Understanding
-- 1.4 Analytical Thinking from the ER Diagram

 -- 1.	The Customer team wants to identify customers and understand which customer segment they belong to. What information would you need?
 -- Table: customers
 -- Columns: customer_id, first_name, last_name, segment, plus city, state, annual_income, credit_score
 -- No joins needed. segment already tells which group each customer belongs to.


-- 2.	Management wants to identify customers who have more than one bank account. Which tables and columns would you need?
-- Tables: customers and accounts
-- Columns: customers.customer_id, name, accounts.account_id
-- Join: customers.customer_id = accounts.customer_id
-- Logic: group accounts by customer, count them, and keep customers with a count greater than 1.


-- 3.	The Branch team wants to compare the accounts associated with different branches. What information would you need from the database?
-- Tables: branches and accounts
-- Columns: branch_id, branch_name, city, region, account_type, current_balance, status
-- Join: branches.branch_id = accounts.branch_id
-- Logic: for each branch, compare the number of accounts, total balance, and account types.


-- 4.	The bank wants to understand how customers are using their accounts through transactions. Which tables would you need to connect?
-- Tables: customers, accounts, transactions
-- Join: customers.customer_id = accounts.customer_id, then accounts.account_id = transactions.account_id
-- Logic: look at how many transactions each customer or account has, the amounts, and the dates.


-- 5.	Management wants to identify which types of transactions are most common and through which channels they occur. Where would you find this information?
-- Table: transactions only
-- Columns: transaction_type, channel, amount
-- Logic: count rows grouped by type and by channel.


-- 6.	The Loans team wants to understand which customers have loans and what type of loans they have. Which tables and columns would you need?
-- Tables: customers and loans
-- Columns: customer_id, name, loan_type, purpose, loan_status
-- Join: customers.customer_id = loans.customer_id


-- 7.	The Loans team wants to examine whether loan customers are making their payments on time. What information would you need, and which tables would you connect?
-- Tables: loans and loan_payments (add customers if you want names)
-- Columns: loan_id, payment_date, scheduled_amount, paid_amount, days_late, penalty, status
-- Join: loans.loan_id = loan_payments.loan_id
-- Logic: compare scheduled and paid amounts, and check how many payments have days_late > 0.


-- 8.	Management wants to compare loan performance across different branches. Which tables and columns would you need?
-- Tables: branches, loans, loan_payments
-- Join: branches.branch_id = loans.branch_id, then loans.loan_id = loan_payments.loan_id
-- Logic: per branch, compare total loans, outstanding balance, late payments and penalties.


-- 9.	The bank wants to understand which customers have cards linked to their accounts. What information would you need to connect customers, accounts, and cards?
-- Tables: customers, accounts, cards
-- Join: customers.customer_id = accounts.customer_id, then accounts.account_id = cards.account_id
-- Note: cards has no customer_id. You must go through accounts.


-- 10.	Management wants to understand how customers are using different banking products such as accounts, cards, and loans. Which tables would you bring together?
-- Tables: customers, accounts, cards, loans
-- Logic: use LEFT JOIN from customers so you keep customers who don’t have every product. Then count who has account only, account + card, account + loan, or all three.


-- ---------------------------------------------------------------------------------------------------------------------------------------------

-- Sprint 2: Database Setup

-- Step 1: Install and open MySQL
-- Step 2: Create the database
-- Step 3: Create tables in the correct order 
-- Step 4: Import the CSVs
-- Step 5: Verify the import
-- Step 6: Check the text values first

-- 2.2 Data Import

CREATE TABLE branches (
    branch_id      VARCHAR(10) PRIMARY KEY,
    branch_name    VARCHAR(100) NOT NULL,
    city           VARCHAR(50),
    state          VARCHAR(30),
    region         VARCHAR(30),
    opening_date   DATE,
    employee_count INT DEFAULT 0
);


CREATE TABLE customers (
    customer_id    VARCHAR(20) PRIMARY KEY,
    first_name     VARCHAR(50) NOT NULL,
    last_name      VARCHAR(50),
    date_of_birth  DATE,
    gender         VARCHAR(20),
    city           VARCHAR(50),
    state          VARCHAR(30),
    customer_since DATE,
    kyc_status     VARCHAR(20),
    segment        VARCHAR(30),
    annual_income  DECIMAL(12,2),
    credit_score   INT,
    is_active      VARCHAR(3) DEFAULT 'Yes'
);


CREATE TABLE accounts (
    account_id      VARCHAR(20) PRIMARY KEY,
    customer_id     VARCHAR(20) NOT NULL,
    branch_id       VARCHAR(10) NOT NULL,
    account_type    VARCHAR(30) NOT NULL,
    open_date       DATE,
    close_date      DATE NULL,
    current_balance DECIMAL(15,2) DEFAULT 0,
    interest_rate   DECIMAL(5,2),
    overdraft_limit DECIMAL(12,2) DEFAULT 0,
    status          VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id)   REFERENCES branches(branch_id)
);


CREATE TABLE loans (
    loan_id             VARCHAR(20) PRIMARY KEY,
    customer_id         VARCHAR(20) NOT NULL,
    branch_id           VARCHAR(10) NOT NULL,
    loan_type           VARCHAR(30),
    principal_amount    DECIMAL(15,2),
    interest_rate       DECIMAL(5,2),
    tenure_months       INT,
    disbursement_date   DATE,
    maturity_date       DATE,
    emi_amount          DECIMAL(12,2),
    outstanding_balance DECIMAL(15,2),
    loan_status         VARCHAR(30),
    purpose             VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id)   REFERENCES branches(branch_id)
);


CREATE TABLE loan_payments (
    payment_id       VARCHAR(20) PRIMARY KEY,
    loan_id          VARCHAR(20) NOT NULL,
    payment_date     DATE,
    scheduled_amount DECIMAL(12,2),
    paid_amount      DECIMAL(12,2),
    principal_paid   DECIMAL(12,2),
    interest_paid    DECIMAL(12,2),
    penalty          DECIMAL(12,2) DEFAULT 0,
    days_late        INT DEFAULT 0,
    payment_method   VARCHAR(30),
    status           VARCHAR(20),
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);


CREATE TABLE cards (
    card_id             VARCHAR(20) PRIMARY KEY,
    account_id          VARCHAR(20) NOT NULL,
    card_type           VARCHAR(20),
    issue_date          DATE,
    expiry_date         DATE,
    credit_limit        DECIMAL(12,2),
    outstanding_balance DECIMAL(12,2) DEFAULT 0,
    reward_points       INT DEFAULT 0,
    is_active           VARCHAR(3),
    network             VARCHAR(20),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);


CREATE TABLE transactions (
    transaction_id   VARCHAR(20) PRIMARY KEY,
    account_id       VARCHAR(20) NOT NULL,
    transaction_date DATE,
    transaction_time TIME,
    transaction_type VARCHAR(30),
    amount           DECIMAL(15,2),
    channel          VARCHAR(30),
    description      VARCHAR(50),
    balance_after    DECIMAL(15,2),
    status           VARCHAR(20),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);


select * from transactions;


SELECT 'customers', COUNT(*), 500 FROM customers;
SELECT 'accounts', COUNT(*), 700 FROM accounts;
SELECT 'loans', COUNT(*), 300 FROM loans;
SELECT 'loan_payments', COUNT(*), 2000 FROM loan_payments;
SELECT 'cards', COUNT(*), 600 FROM cards;
SELECT 'transactions', COUNT(*), 5000 FROM transactions;

-- -----------------------------------------------------------------------------------

CREATE TABLE accounts_staging (
    account_id      VARCHAR(20),
    customer_id     VARCHAR(20),
    branch_id       VARCHAR(10),
    account_type    VARCHAR(30),
    open_date       VARCHAR(20),
    close_date      VARCHAR(20),
    current_balance VARCHAR(30),
    interest_rate   VARCHAR(10),
    overdraft_limit VARCHAR(30),
    status          VARCHAR(20)
);

SELECT COUNT(*) FROM accounts_staging;  -- should be 700

INSERT INTO accounts
  (account_id, customer_id, branch_id, account_type, open_date, close_date,
   current_balance, interest_rate, overdraft_limit, status)
SELECT account_id, customer_id, branch_id, account_type,
       NULLIF(open_date,''),
       NULLIF(close_date,''),
       NULLIF(current_balance,''),
       NULLIF(interest_rate,''),
       NULLIF(overdraft_limit,''),
       status
FROM accounts_staging;

SELECT COUNT(*) FROM accounts;                              -- 700
SELECT COUNT(*) FROM accounts WHERE close_date IS NULL;     -- open accounts
SELECT * FROM accounts LIMIT 5;                             -- eyeball the dates
DROP TABLE accounts_staging;

-- ---------------------------------------------------------------------------------------------------------------------------------
DESCRIBE customers;
DESCRIBE branches;
DESCRIBE accounts;
DESCRIBE loans;
DESCRIBE loan_payments;
DESCRIBE cards;
DESCRIBE transactions;

-- ----------------------------------------------------

--  Step 5: Verify the import

SELECT 'customers' AS tbl, COUNT(*) AS rows_loaded FROM customers
UNION ALL SELECT 'accounts', COUNT(*) FROM accounts
UNION ALL SELECT 'branches', COUNT(*) FROM branches
UNION ALL SELECT 'loans', COUNT(*) FROM loans
UNION ALL SELECT 'loan_payments', COUNT(*) FROM loan_payments
UNION ALL SELECT 'cards', COUNT(*) FROM cards
UNION ALL SELECT 'transactions', COUNT(*) FROM transactions;

-- --------------------------------------------------------------------------------------------------

-- Sprint 3: Basic Analysis / Data Exploration

-- Write SQL queries to answer the following basic questions. 

-- 11.	What is the total number of customers?
SELECT COUNT(*) AS total_customers FROM customers;

-- 12.	What is the total number of accounts?
SELECT COUNT(*) AS total_accounts FROM accounts;

-- 13.	What are the different account types available?
SELECT DISTINCT account_type FROM accounts;

-- 14.	How many customers are currently active?
SELECT COUNT(*) AS active_customers FROM customers WHERE is_active = 'Yes';

-- 15.	What are the different transaction types available?
SELECT DISTINCT transaction_type FROM transactions;

-- 16.	What is the total amount of completed transactions?
SELECT SUM(amount) AS total_completed_amount
FROM transactions WHERE status = 'Completed';

-- 17.	What are the different loan types available?
SELECT DISTINCT loan_type FROM loans;

-- 18.	What is the total number of loans?
SELECT COUNT(*) AS total_loans FROM loans;

-- 19.	What are the different card types available?
SELECT DISTINCT card_type FROM cards;

-- 20.	What is the total outstanding loan balance?
SELECT SUM(outstanding_balance) AS total_outstanding FROM loans;



-- ------------------------------------------------------------
-- 4.1 Customer Profile and Segmentation

-- Q1. How many customers are in each segment, and what share of the total is that?
SELECT segment, COUNT(*) AS total_customers,
       ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM customers),2) AS pct_of_total
FROM customers GROUP BY segment ORDER BY total_customers DESC;


-- Q2. What is the gender and age-group mix of customers?
SELECT gender,
  CASE WHEN TIMESTAMPDIFF(YEAR,date_of_birth,CURDATE())<30 THEN 'Under 30'
       WHEN TIMESTAMPDIFF(YEAR,date_of_birth,CURDATE())<45 THEN '30-44'
       WHEN TIMESTAMPDIFF(YEAR,date_of_birth,CURDATE())<60 THEN '45-59'
       ELSE '60+' END AS age_group,
  COUNT(*) AS total_customers
FROM customers GROUP BY gender, age_group ORDER BY gender, age_group;


-- Q3. Which states and cities have the most customers?
SELECT state, city, COUNT(*) AS total_customers
FROM customers GROUP BY state, city ORDER BY total_customers DESC LIMIT 15;


-- Q4. How do average income and credit score differ by segment?
SELECT segment, ROUND(AVG(annual_income),2) AS avg_income,
       ROUND(AVG(credit_score),0) AS avg_credit_score,
       MIN(credit_score) AS min_score, MAX(credit_score) AS max_score
FROM customers GROUP BY segment ORDER BY avg_income DESC;


-- Q5. What is the KYC status split, and how many customers are active versus inactive?
SELECT kyc_status, is_active, COUNT(*) AS total_customers
FROM customers GROUP BY kyc_status, is_active ORDER BY kyc_status;


-- Q6. How long have customers been with the bank, by segment?
SELECT segment, ROUND(AVG(DATEDIFF(CURDATE(),customer_since)/365),1) AS avg_tenure_years
FROM customers GROUP BY segment ORDER BY avg_tenure_years DESC;


-- FINDINGS (4.1):
-- Student is the largest segment (100 customers, 20%). Income ($140K-$159K) and credit score (679-687) are almost the same in every segment, so segment labels say little about customer value.
-- 30-44 is the largest age group (33.6%); only 14% of customers are under 30. No city holds more than 3% of customers.
-- Only 28.6% of customers are fully KYC verified; 241 of 375 active customers have Partial or Pending KYC.
-- Average tenure is about 7.4 years; Premium (6.8) and Wealth (6.9) are the newest customers.
-- RECOMMENDATION: Run a KYC completion drive and redefine segments using income and credit-score bands.

-- -------------------------------------------------------------------------------------------------------

-- 4.2 Account Usage and Branch Activity

-- Q1. How many accounts and what average balance does each account type have?
SELECT account_type, COUNT(*) AS total_accounts,
       ROUND(AVG(current_balance),2) AS avg_balance, SUM(current_balance) AS total_balance
FROM accounts GROUP BY account_type ORDER BY total_balance DESC;

-- Q2. Which customers hold the most accounts?
SELECT customer_id, COUNT(*) AS accounts_held, SUM(current_balance) AS total_balance
FROM accounts GROUP BY customer_id ORDER BY accounts_held DESC, total_balance DESC LIMIT 10;

-- Q3. Which branches have the most accounts and the highest total balance?
SELECT branch_id, COUNT(*) AS total_accounts, SUM(current_balance) AS total_balance,
       ROUND(AVG(current_balance),2) AS avg_balance
FROM accounts GROUP BY branch_id ORDER BY total_balance DESC;


-- Q4. How do interest rates differ across account types?
SELECT account_type, MIN(interest_rate) AS min_rate, MAX(interest_rate) AS max_rate,
       ROUND(AVG(interest_rate),2) AS avg_rate
FROM accounts GROUP BY account_type;


-- Q5. Active vs closed accounts
SELECT status, COUNT(*) AS total_accounts, ROUND(AVG(current_balance),2) AS avg_balance,
       ROUND(AVG(DATEDIFF(COALESCE(close_date,(SELECT MAX(transaction_date) FROM transactions)),open_date)/365),1) AS avg_life_years
FROM accounts GROUP BY status;


-- Q6. How many accounts have a negative balance or use the overdraft limit?
SELECT account_type, COUNT(*) AS accounts_overdrawn
FROM accounts WHERE current_balance < 0 GROUP BY account_type;

-- Query 2 for Q6
SELECT account_type, COUNT(*) AS accounts_with_overdraft_limit,
       ROUND(AVG(overdraft_limit),2) AS avg_overdraft_limit
FROM accounts WHERE overdraft_limit > 0
GROUP BY account_type;


-- FINDINGS (4.2):
-- Deposits total $10.2M; IRA, CD and Money Market hold about 70% and pay higher rates (3.3% to 4.6% on average). Savings and Checking have many accounts but small balances.
-- Customers hold 1.4 accounts on average. Branch balances vary widely (BR025 $501,926 vs BR010 $58,688), and more accounts does not mean more money (BR011).
-- 203 of 700 accounts (29%) are closed with zero balance. No account has a negative balance.
-- RECOMMENDATION: Add retention offers and review the low-balance branches (BR010, BR017, BR022).

-- -------------------------------------------------------------------------------------------------

-- 4.3 Analyze Transaction Patterns
-- Business Objective: The bank wants to understand how customers use their accounts and how money moves through the banking system.

-- Q1. How do transaction types compare by count and total amount?
SELECT transaction_type, COUNT(*) AS txn_count, SUM(amount) AS total_amount,
       ROUND(AVG(amount),2) AS avg_amount, MAX(amount) AS largest
FROM transactions GROUP BY transaction_type ORDER BY total_amount DESC;


-- Q2. Which channels are used most, and which carry the largest amounts?
SELECT channel, COUNT(*) AS txn_count, SUM(amount) AS total_amount, ROUND(AVG(amount),2) AS avg_amount
FROM transactions GROUP BY channel ORDER BY txn_count DESC;


-- Q3. What are the most common transaction descriptions?
SELECT description, COUNT(*) AS frequency, SUM(amount) AS total_amount
FROM transactions GROUP BY description ORDER BY frequency DESC LIMIT 10;


-- Q4. How does transaction volume change month by month?
SELECT DATE_FORMAT(transaction_date,'%Y-%m') AS month, COUNT(*) AS txn_count, SUM(amount) AS total_amount
FROM transactions GROUP BY month ORDER BY month;


-- Q5. Which accounts have the highest transaction activity?
SELECT account_id, COUNT(*) AS txn_count, SUM(amount) AS total_amount
FROM transactions GROUP BY account_id ORDER BY txn_count DESC LIMIT 10;


-- Q6. What share of transactions are failed or not completed?
SELECT status, COUNT(*) AS txn_count,
       ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM transactions),2) AS pct
FROM transactions GROUP BY status;


-- Q7. How do transactions relate to balances (average balance after each transaction type)?
SELECT transaction_type, ROUND(AVG(balance_after),2) AS avg_balance_after
FROM transactions GROUP BY transaction_type;


-- Bonus Query (activity by customer segment):

SELECT c.segment, COUNT(t.transaction_id) AS txn_count, ROUND(AVG(t.amount),2) AS avg_amount
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
GROUP BY c.segment ORDER BY txn_count DESC;


-- FINDINGS (4.3):
-- Only 33.8% of transactions are Completed; 33.7% are Pending and 32.6% Failed.
-- Online and Mobile carry 49.9% of transactions. Investment, Utility and Rent are the most common descriptions; Salary is only 5.6%. Business is the most active segment and Premium the least.
-- Volume grew from 1,279 (2022) to 1,723 (2023) to 1,933 (2024), but growth is slowing. Fee and Interest averages (about $7,000) look high and need validation.
-- RECOMMENDATION: Find out why two thirds of transactions fail or stay pending.


-- ----------------------------------------------------------------------------------------------------
-- 4.4 Evaluate Loan Performance and Repayment Behaviour
-- Business Objective: The bank wants to understand how its loans are performing and whether customers are repaying their loans as expected.

-- Q1. How do loan types and purposes compare by number of loans and amount?
SELECT loan_type, purpose, COUNT(*) AS total_loans, SUM(principal_amount) AS total_principal
FROM loans GROUP BY loan_type, purpose ORDER BY total_principal DESC;


-- Q2. What is the outstanding balance by loan status, and how much of the principal is still owed?
SELECT loan_status, COUNT(*) AS total_loans, SUM(principal_amount) AS principal,
       SUM(outstanding_balance) AS outstanding,
       ROUND(SUM(outstanding_balance)*100.0/SUM(principal_amount),1) AS pct_outstanding
FROM loans GROUP BY loan_status;


-- Q3. Which loans have repayment delays?
SELECT loan_id, COUNT(*) AS late_payments, MAX(days_late) AS max_days_late, SUM(penalty) AS total_penalty
FROM loan_payments WHERE days_late > 0
GROUP BY loan_id ORDER BY late_payments DESC LIMIT 15;


-- Q4. How much penalty has been charged, by loan type?
SELECT l.loan_type, COUNT(*) AS late_payments, SUM(p.penalty) AS total_penalty,
       ROUND(AVG(p.days_late),1) AS avg_days_late
FROM loan_payments p JOIN loans l ON p.loan_id = l.loan_id
WHERE p.days_late > 0 GROUP BY l.loan_type ORDER BY total_penalty DESC;


-- Q5(a). How does repayment behaviour compare across loan types and branches?
-- (by loan type):- 
SELECT l.loan_type, COUNT(*) AS total_payments,
       SUM(CASE WHEN p.days_late > 0 THEN 1 ELSE 0 END) AS late_payments,
       ROUND(SUM(CASE WHEN p.days_late > 0 THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS late_pct
FROM loan_payments p JOIN loans l ON p.loan_id = l.loan_id
GROUP BY l.loan_type ORDER BY late_pct DESC;


-- Q5(b). Which branches have the highest and lowest share of late loan payments?
-- (by branch):-
SELECT l.branch_id, COUNT(*) AS total_payments,
       ROUND(SUM(CASE WHEN p.days_late > 0 THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS late_pct
FROM loan_payments p JOIN loans l ON p.loan_id = l.loan_id
GROUP BY l.branch_id ORDER BY late_pct DESC;


-- Q6. Which payment methods do customers use most?
SELECT payment_method, COUNT(*) AS total_payments, SUM(paid_amount) AS total_paid
FROM loan_payments GROUP BY payment_method ORDER BY total_payments DESC;

-- FINDINGS (4.4):
-- $53.44M of $72.21M (74%) is still outstanding. 169 loans (56.3%) are Defaulted or In Arrears and hold 73.3% of the outstanding balance.
-- One in four payments (25%) is late, across all loan types (21.7% to 28.2%). Penalties total $93,961, under 0.2% of the money owed.
-- Cheque, Bank Transfer and Cash make up about 57% of payments; Auto Debit only 5.6%.
-- The late-payment share by branch runs from 5.9% (BR037) to 45.5% (BR012).
-- RECOMMENDATION: Follow up the troubled loans first, promote Auto Debit and review the worst branches.

-- -------------------------------------------------------------------------------------------
-- 4.5 Understand Card Usage and Product Engagement
-- Business Objective: The bank wants to understand how customers use its card products and how card usage relates to their broader banking relationship.

-- Q1. How do card types compare by count, credit limit and outstanding balance?
SELECT card_type, COUNT(*) AS total_cards, ROUND(AVG(credit_limit),2) AS avg_limit,
       SUM(outstanding_balance) AS total_outstanding
FROM cards GROUP BY card_type;


-- Q2. How many cards are active versus inactive?
SELECT is_active, COUNT(*) AS total_cards FROM cards GROUP BY is_active;


-- Q3. How many reward points does each card type and network hold?
SELECT network, card_type, SUM(reward_points) AS total_points, ROUND(AVG(reward_points),0) AS avg_points
FROM cards GROUP BY network, card_type ORDER BY total_points DESC;


-- Q4. What share of the credit limit is being used (utilisation)?
SELECT card_type, ROUND(SUM(outstanding_balance)*100.0/SUM(credit_limit),1) AS utilisation_pct
FROM cards WHERE credit_limit > 0 GROUP BY card_type;


-- Q5. How many customers use accounts, cards and loans together?
SELECT COUNT(*) AS customers_with_all_three
FROM customers c
WHERE EXISTS (SELECT 1 FROM accounts a WHERE a.customer_id = c.customer_id)
  AND EXISTS (SELECT 1 FROM accounts a JOIN cards cd ON a.account_id = cd.account_id
              WHERE a.customer_id = c.customer_id)
  AND EXISTS (SELECT 1 FROM loans l WHERE l.customer_id = c.customer_id);


-- Q6. Do customers with cards also hold loans?
SELECT
  COUNT(DISTINCT a.customer_id) AS customers_with_cards,
  COUNT(DISTINCT CASE WHEN l.customer_id IS NOT NULL THEN a.customer_id END) AS also_have_loans
FROM cards cd
JOIN accounts a ON cd.account_id = a.account_id
LEFT JOIN loans l ON a.customer_id = l.customer_id;


-- FINDINGS (4.5):
-- 563 of 600 cards (93.8%) are inactive. Credit card utilisation is 41.8%.
-- Debit and Credit cards hold similar reward points; Visa holds the most (28%).
-- Only 124 customers (24.8%) use accounts, cards and loans together; 267 hold a card and 124 of them also have a loan.
-- RECOMMENDATION: Reactivate or close inactive cards and cross-sell cards and loans.

-- --------------------------------------------------------------------------------------------------------------------

-- FINAL CONCLUSION:
-- The customer base is balanced and active, but KYC completion is the most urgent compliance issue.
-- The biggest risks are the troubled loan book (56.3% Defaulted or In Arrears) and a transaction completion rate of only 33.8%.
-- Card engagement is weak, but the cross-sell potential is large.