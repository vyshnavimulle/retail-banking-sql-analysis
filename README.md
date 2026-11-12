# Retail Banking Transaction Analysis (MySQL)

## About the project
A retail bank serves customers through accounts, cards and loans across 40 branches. This project builds the database in MySQL from an ER diagram, loads 7 tables, and answers business questions with SQL to support the Retail Banking team.

## Business objectives
1. Understand customer profile and segmentation
2. Understand account usage and branch activity
3. Analyse transaction patterns
4. Evaluate loan performance and repayment behaviour
5. Understand card usage and product engagement

## Dataset (7 tables)
| Table | Rows | Columns |
| --- | --- | --- |
| customers | 500 | 13 |
| accounts | 700 | 10 |
| branches | 40 | 7 |
| loans | 300 | 13 |
| loan_payments | 2,000 | 11 |
| cards | 600 | 10 |
| transactions | 5,000 | 10 |

## Tools
MySQL, MySQL Workbench, SQL

## Repository contents
- sql/ : the full SQL script, organised by sprint with comments: Sprint 1 (ER diagram thinking), Sprint 2 (database and table creation, data import), Sprint 3 (basic analysis), Sprint 4 (objective-based analysis with findings)
- docs/ : the project presentation (PDF)

## How to run
1. Create the database retail_banking in MySQL Workbench
2. Run the CREATE TABLE statements from the script
3. Import the CSV files in this order: branches, customers, accounts, loans, loan_payments, cards, transactions
4. Run the queries one at a time

## Note on dates
For time-based analysis (age, tenure, account life), the latest transaction_date in the data is treated as "today" instead of the current date, as the project instructions require.

## Key findings
- Only 28.6% of customers are fully KYC-verified
- Only 33.8% of transactions are completed; the rest are pending or failed
- About 56% of loans are defaulted or in arrears, holding about 73% of the money still owed
- About 94% of cards are inactive
- Only 124 customers (24.8%) use accounts, cards and loans together

## Recommendations
Follow up the troubled loans, find out why transactions fail, complete KYC for active customers, promote auto debit, reactivate or close unused cards, and redefine customer segments.

## Video walkthrough
[https://lnkd.in/p/dE78DKaJ]

## LinkedIn Profile
[https://www.linkedin.com/in/vyshnavi-mulle]

## Acknowledgements
Thanks to my trainer Sai Manoj Pacha, my mentor Bhargav Kunapareddy and Innomatics Research Labs.

## Authors
Vyshnavi Mulle, Likhitha Jami, R. Naina Patel Yadav
