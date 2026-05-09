Banking Insights and Decision Support System

SQL · Power BI · Python · Data Modelling

A comprehensive banking analytics project analyzing 38,576 loan applications worth $435.8M to surface portfolio risk, borrower trends, and financial KPIs for data-driven decision-making.


Project Overview

This project builds an end-to-end analytics pipeline on a real-world banking loan dataset — from raw data cleaning in Python to SQL-based KPI calculations to interactive Power BI dashboards — designed to give a bank's risk and operations team a single source of truth for portfolio health.


Key Insights Uncovered

- $435.8M total funded vs $473.1M total received — healthy repayment spread
- 13.8% bad loan ratio — isolating $64.9M in non-performing assets for risk mitigation
- 6.9% MoM increase in loan application volume — portfolio growth signal
- Average Debt-to-Income (DTI) ratio of 13.3% across all borrowers
- Loan grade, home ownership, and purpose are the strongest risk predictors


Project Structure

Banking_Insights_and_Decision_Support_System/

│── Banking.csv                  ← Raw dataset (38,576 records) |

│── Banking.xlsx                 ← Cleaned dataset |
│── Banking.ipynb                ← Data cleaning & preprocessing |
│── EDA.ipynb                    ← Exploratory Data Analysis |
│── Banking Dashboard.pbix       ← Power BI dashboard |
│── Home.png                     ← Dashboard screenshot — Summary view |
│── Deposit Analysis.png         ← Dashboard screenshot — Deposit analysis |
│── Loan Analysis.png            ← Dashboard screenshot — Loan analysis |
│── Drill Through.png            ← Dashboard screenshot — Drill-through view |
│── README.md |


Dashboard Preview

Summary View
[Summary Dashboard](Home.png)

Loan Analysis
[Loan Analysis](Loan%20Analysis.png)

Deposit Analysis
[Deposit Analysis](Deposit%20Analysis.png)

Drill-Through View
[Drill Through](Drill%20Through.png)


Sample SQL Queries Used

sql
-- Monthly loan application trend
SELECT
    DATE_FORMAT(issue_date, '%Y-%m') AS month,
    COUNT(*) AS total_applications,
    SUM(loan_amount) AS total_funded
FROM banking
GROUP BY month
ORDER BY month;

-- Bad loan ratio by grade
SELECT
    grade,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_status IN ('Charged Off', 'Default') THEN 1 ELSE 0 END) AS bad_loans,
    ROUND(100.0 * SUM(CASE WHEN loan_status IN ('Charged Off', 'Default') THEN 1 ELSE 0 END) / COUNT(*), 2) AS bad_loan_pct
FROM banking
GROUP BY grade
ORDER BY bad_loan_pct DESC;

-- Average DTI by home ownership
SELECT
    home_ownership,
    ROUND(AVG(dti), 2) AS avg_dti,
    COUNT(*) AS applicant_count
FROM banking
GROUP BY home_ownership;


Tech Stack

Tools & Purpose-

Python - (Pandas, NumPy) - Data cleaning & preprocessing , (Matplotlib, Seaborn) - EDA visualizations |
SQL (MySQL) - KPI queries & aggregations |
Power BI + DAX - Interactive dashboards |
Jupyter Notebook - Analysis environment |


How to Run

# 1. Clone the repo
git clone https://github.com/BeHarsha/Banking_Insights_and_Decision_Support_System
cd Banking_Insights_and_Decision_Support_System

# 2. Install Python dependencies
pip install pandas numpy matplotlib seaborn jupyter

# 3. Run notebooks
jupyter notebook Banking.ipynb     Data cleaning
jupyter notebook EDA.ipynb         Exploratory analysis

# 4. Open dashboard
Open Banking Dashboard.pbix in Power BI Desktop


Author

Bethineedi Deva Harsha
- [LinkedIn](https://www.linkedin.com/in/bethineedi-deva-harsha-3933aa2a9)
- [GitHub](https://github.com/BeHarsha)
- harsha.fieldmaster@gmail.com
