
-- ============================================================
-- 1. BASIC DATA EXTRACTION
-- ============================================================

-- Fetch all customer records
SELECT * FROM banking_case.customer;

-- Preview first 10 rows
SELECT * FROM banking_case.customer LIMIT 10;

-- Get total number of customers
SELECT COUNT(*) AS total_customers
FROM banking_case.customer;

-- Get column-level summary
SELECT
    COUNT(*) AS total_records,
    MIN(Age) AS min_age,
    MAX(Age) AS max_age,
    ROUND(AVG(Age), 1) AS avg_age
FROM banking_case.customer;


-- ============================================================
-- 2. KEY PERFORMANCE INDICATORS (KPIs)
-- ============================================================

-- Core financial KPIs
SELECT
    COUNT(*) AS total_customers,
    ROUND(SUM(`Bank Deposits`), 0) AS total_deposits,
    ROUND(SUM(`Bank Loans`), 0) AS total_loans,
    ROUND(SUM(`Business Lending`), 0) AS total_business_lending,
    ROUND(SUM(`Credit Card Balance`), 0) AS total_cc_balance,
    ROUND(SUM(`Saving Accounts`), 0) AS total_savings,
    ROUND(SUM(`Checking Accounts`), 0) AS total_checking,
    ROUND(AVG(`Estimated Income`), 0) AS avg_income,
    ROUND(AVG(`Bank Deposits`), 0) AS avg_deposit_per_customer,
    ROUND(AVG(`Bank Loans`), 0) AS avg_loan_per_customer,
    ROUND(SUM(`Bank Loans`) / SUM(`Bank Deposits`), 2) AS loan_to_deposit_ratio
FROM banking_case.customer;


-- ============================================================
-- 3. CUSTOMER SEGMENTATION
-- ============================================================

-- Loyalty tier breakdown
SELECT
    `Loyalty Classification`,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM banking_case.customer), 1) AS pct_share,
    ROUND(AVG(`Bank Deposits`), 0) AS avg_deposits,
    ROUND(AVG(`Bank Loans`), 0) AS avg_loans,
    ROUND(AVG(`Estimated Income`), 0) AS avg_income
FROM banking_case.customer
GROUP BY `Loyalty Classification`
ORDER BY customer_count DESC;

-- Fee structure breakdown
SELECT
    `Fee Structure`,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM banking_case.customer), 1) AS pct_share,
    ROUND(AVG(`Bank Deposits`), 0) AS avg_deposits,
    ROUND(AVG(`Estimated Income`), 0) AS avg_income
FROM banking_case.customer
GROUP BY `Fee Structure`
ORDER BY customer_count DESC;

-- Nationality distribution
SELECT
    `Nationality`,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM banking_case.customer), 1) AS pct_share,
    ROUND(AVG(`Estimated Income`), 0) AS avg_income,
    ROUND(AVG(`Bank Deposits`), 0) AS avg_deposits
FROM banking_case.customer
GROUP BY `Nationality`
ORDER BY customer_count DESC;

-- Gender breakdown
SELECT
    CASE WHEN GenderId = 1 THEN 'Male' ELSE 'Female' END AS Gender,
    COUNT(*) AS customer_count,
    ROUND(AVG(`Estimated Income`), 0) AS avg_income,
    ROUND(AVG(`Bank Deposits`), 0) AS avg_deposits,
    ROUND(AVG(`Bank Loans`), 0) AS avg_loans
FROM banking_case.customer
GROUP BY GenderId;

-- Risk weighting distribution
SELECT
    `Risk Weighting`,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM banking_case.customer), 1) AS pct_share,
    ROUND(AVG(`Bank Loans`), 0) AS avg_loans,
    ROUND(AVG(`Credit Card Balance`), 0) AS avg_cc_balance
FROM banking_case.customer
GROUP BY `Risk Weighting`
ORDER BY `Risk Weighting`;


-- ============================================================
-- 4. DEPOSIT ANALYSIS
-- ============================================================

-- Total and average deposits by loyalty tier
SELECT
    `Loyalty Classification`,
    COUNT(*) AS customer_count,
    ROUND(SUM(`Bank Deposits`), 0) AS total_deposits,
    ROUND(AVG(`Bank Deposits`), 0) AS avg_deposits,
    ROUND(MAX(`Bank Deposits`), 0) AS max_deposits,
    ROUND(MIN(`Bank Deposits`), 0) AS min_deposits
FROM banking_case.customer
GROUP BY `Loyalty Classification`
ORDER BY total_deposits DESC;

-- High-value customers: deposits above $500,000
SELECT
    `Client ID`,
    `Name`,
    `Loyalty Classification`,
    `Fee Structure`,
    `Nationality`,
    ROUND(`Bank Deposits`, 0) AS deposits,
    ROUND(`Estimated Income`, 0) AS income
FROM banking_case.customer
WHERE `Bank Deposits` > 500000
ORDER BY `Bank Deposits` DESC;

-- Count of high-value customers
SELECT
    COUNT(*) AS high_value_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM banking_case.customer), 1) AS pct_of_total
FROM banking_case.customer
WHERE `Bank Deposits` > 500000;

-- Deposits by nationality
SELECT
    `Nationality`,
    ROUND(SUM(`Bank Deposits`), 0) AS total_deposits,
    ROUND(AVG(`Bank Deposits`), 0) AS avg_deposits
FROM banking_case.customer
GROUP BY `Nationality`
ORDER BY total_deposits DESC;


-- ============================================================
-- 5. LOAN ANALYSIS
-- ============================================================

-- Loan summary by fee structure
SELECT
    `Fee Structure`,
    COUNT(*) AS customer_count,
    ROUND(SUM(`Bank Loans`), 0) AS total_loans,
    ROUND(AVG(`Bank Loans`), 0) AS avg_loans,
    ROUND(SUM(`Business Lending`), 0) AS total_business_lending
FROM banking_case.customer
GROUP BY `Fee Structure`
ORDER BY total_loans DESC;

-- Loan-to-Deposit ratio by loyalty tier
SELECT
    `Loyalty Classification`,
    ROUND(SUM(`Bank Loans`), 0) AS total_loans,
    ROUND(SUM(`Bank Deposits`), 0) AS total_deposits,
    ROUND(SUM(`Bank Loans`) / NULLIF(SUM(`Bank Deposits`), 0), 2) AS ldr
FROM banking_case.customer
GROUP BY `Loyalty Classification`
ORDER BY ldr DESC;

-- Customers with loans above average
SELECT
    `Client ID`,
    `Name`,
    `Age`,
    `Loyalty Classification`,
    ROUND(`Bank Loans`, 0) AS loans,
    ROUND(`Bank Deposits`, 0) AS deposits,
    `Risk Weighting`
FROM banking_case.customer
WHERE `Bank Loans` > (SELECT AVG(`Bank Loans`) FROM banking_case.customer)
ORDER BY `Bank Loans` DESC
LIMIT 50;

-- High-risk loan customers (Risk Weighting 4 or 5)
SELECT
    `Client ID`,
    `Name`,
    `Risk Weighting`,
    ROUND(`Bank Loans`, 0) AS loans,
    ROUND(`Credit Card Balance`, 0) AS cc_balance,
    `Loyalty Classification`
FROM banking_case.customer
WHERE `Risk Weighting` >= 4
ORDER BY `Risk Weighting` DESC, `Bank Loans` DESC;


-- ============================================================
-- 6. INCOME & SAVINGS ANALYSIS
-- ============================================================

-- Income band segmentation
SELECT
    CASE
        WHEN `Estimated Income` < 100000 THEN 'Low (<100K)'
        WHEN `Estimated Income` BETWEEN 100000 AND 299999 THEN 'Mid (100K-300K)'
        ELSE 'High (300K+)'
    END AS income_band,
    COUNT(*) AS customer_count,
    ROUND(AVG(`Bank Deposits`), 0) AS avg_deposits,
    ROUND(AVG(`Bank Loans`), 0) AS avg_loans,
    ROUND(AVG(`Superannuation Savings`), 0) AS avg_super_savings
FROM banking_case.customer
GROUP BY income_band
ORDER BY customer_count DESC;

-- Superannuation savings by age group
SELECT
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 44 THEN '30–44'
        WHEN Age BETWEEN 45 AND 59 THEN '45–59'
        WHEN Age BETWEEN 60 AND 74 THEN '60–74'
        ELSE '75+'
    END AS age_group,
    COUNT(*) AS customer_count,
    ROUND(AVG(`Superannuation Savings`), 0) AS avg_super_savings,
    ROUND(AVG(`Estimated Income`), 0) AS avg_income
FROM banking_case.customer
GROUP BY age_group
ORDER BY age_group;


-- ============================================================
-- 7. CREDIT CARD ANALYSIS
-- ============================================================

-- Credit card distribution
SELECT
    `Amount of Credit Cards`,
    COUNT(*) AS customer_count,
    ROUND(AVG(`Credit Card Balance`), 0) AS avg_cc_balance,
    ROUND(SUM(`Credit Card Balance`), 0) AS total_cc_balance
FROM banking_case.customer
GROUP BY `Amount of Credit Cards`
ORDER BY `Amount of Credit Cards`;


-- ============================================================
-- 8. BANKING CONTACT (RELATIONSHIP MANAGER) PERFORMANCE
-- ============================================================

-- Deposits and loans managed per relationship manager
SELECT
    `Banking Contact`,
    COUNT(*) AS customers_managed,
    ROUND(SUM(`Bank Deposits`), 0) AS total_deposits_managed,
    ROUND(SUM(`Bank Loans`), 0) AS total_loans_managed,
    ROUND(AVG(`Estimated Income`), 0) AS avg_client_income
FROM banking_case.customer
GROUP BY `Banking Contact`
ORDER BY total_deposits_managed DESC;


-- ============================================================
-- 9. MULTI-DIMENSIONAL ANALYSIS
-- ============================================================

-- Loyalty × Nationality cross-tab
SELECT
    `Loyalty Classification`,
    `Nationality`,
    COUNT(*) AS customer_count,
    ROUND(AVG(`Bank Deposits`), 0) AS avg_deposits
FROM banking_case.customer
GROUP BY `Loyalty Classification`, `Nationality`
ORDER BY `Loyalty Classification`, customer_count DESC;

-- Fee Structure × Risk Weighting matrix
SELECT
    `Fee Structure`,
    `Risk Weighting`,
    COUNT(*) AS customer_count,
    ROUND(AVG(`Bank Loans`), 0) AS avg_loans
FROM banking_case.customer
GROUP BY `Fee Structure`, `Risk Weighting`
ORDER BY `Fee Structure`, `Risk Weighting`;

-- Properties owned vs. deposits
SELECT
    `Properties Owned`,
    COUNT(*) AS customer_count,
    ROUND(AVG(`Bank Deposits`), 0) AS avg_deposits,
    ROUND(AVG(`Bank Loans`), 0) AS avg_loans,
    ROUND(AVG(`Estimated Income`), 0) AS avg_income
FROM banking_case.customer
GROUP BY `Properties Owned`
ORDER BY `Properties Owned`;
