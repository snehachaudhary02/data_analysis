# Employee Analytical Dashboard (End-to-End Data Analytics Project)

An end-to-end data analytics project transforming a raw, messy 10,000-record HR dataset into a structured MySQL star schema and an interactive single-page Power BI executive dashboard.

---

## Project Overview

The goal of this project is to demonstrate a complete analytics workflow—from raw data inspection and programmatic cleaning to relational database modeling, SQL querying, and business intelligence reporting.

### Tech Stack
* **Python (Pandas, NumPy, OpenPyXL):** Data cleaning, validation, outlier imputation, deduplication flagging, and feature engineering.
* **MySQL:** Star schema design (`employee_analytics_db`), DDL/DML setup, foreign key integrity, and analytical queries.
* **Power BI & DAX:** Star schema relationship modeling, custom DAX measures, interactive slicers, and single-page visual storytelling.

---

## Project Architecture & Workflow

### 1. Data Cleaning & Feature Engineering (Python)
Starting from `Uncleaned_Employee_Dataset_10000.xlsx` (`10,000` rows), a reproducible cleaning pipeline was implemented to address real-world data quality issues while preserving full headcount accuracy:
* **Text & Format Standardization:** Trimmed leading/trailing whitespace and standardized inconsistent casing across names, departments, and cities.
* **Missing Value Preservation:** Retained rows with missing categorical attributes by labeling them as `"Unknown"` so the total employee headcount (`10,000`) remained intact without silent row drops.
* **Date Parsing:** Standardized mixed date formats into clean `YYYY-MM-DD` values for `join_date`.
* **Outlier & Invalid Value Treatment:** Replaced out-of-range values for `age`, `salary`, and `performance_rating` using whole-integer medians while retaining raw audit columns (`_raw`) for traceability.
* **Duplicate Audit Flagging:** Flagged recurring `customer_id` entries (`is_duplicate_customer_id`) rather than deleting records blindly.
* **Feature Engineering:** Engineered `tenure_years` from `join_date` and standardized full name fields (`full_name`).

### 2. Relational Database Modeling (MySQL)
The cleaned dataset was normalized into a star schema inside the `employee_analytics_db` database:
* **`dim_department` (6 rows):** Unique department lookup table (`dept_id`, `dept_name`).
* **`dim_city` (8 rows):** Unique city lookup table (`city_id`, `city_name`).
* **`fact_employee` (10,000 rows):** Core employee fact table (`emp_record_id`, `customer_id`, `full_name`, `dept_id`, `city_id`, `age`, `salary`, `join_date`, `tenure_years`, `performance_rating`, `is_duplicate_customer_id`).

### 3. Interactive Dashboard & DAX (Power BI)
Connected Power BI Desktop directly to MySQL (`employee_analytics_db`), established one-to-many relationships from dimension tables to `fact_employee`, and built core DAX measures:
* `Total Headcount = COUNTROWS(fact_employee)` (`10,000` / `10K`)
* `Avg Salary = AVERAGE(fact_employee[salary])` (`~63K`)
* `Avg Performance Rating = AVERAGE(fact_employee[performance_rating])` (`3.45`)
* `Avg Tenure Years = AVERAGE(fact_employee[tenure_years])` (`2.93`)

#### Dashboard Visuals
* **Interactive Slicers:** Filter dynamically by `Department`, `City`, and `Performance Rating`.
* **KPI Summary Cards:** Executive overview of Headcount, Average Salary, Average Performance Rating, and Average Tenure.
* **Headcount by Department:** Horizontal bar chart comparing workforce distribution across IT, Sales, Marketing, Unknown, HR, and Finance.
* **Average Salary by City:** Column chart comparing compensation across Bangalore, Kolkata, Hyderabad, Pune, Delhi, Mumbai, Unknown, and Chennai.
* **Performance Rating Distribution:** Donut chart breaking down employee distribution across ratings `1` through `5`.
* **Employee Detail Table:** Granular employee-level view with ID, Name, Department, City, Join Date, and Tenure Years.

---

## Repository Structure

```text
├── data/
│   ├── Uncleaned_Employee_Dataset_10000.xlsx   # Raw input dataset
│   └── cleaned_employee_data.csv               # Processed dataset ready for SQL load
├── scripts/
│   └── data_cleaning.py                        # Python / Pandas cleaning & feature engineering script
├── sql/
│   ├── schema_setup.sql                        # MySQL star schema DDL & table creation
│   └── analysis_queries.sql                    # SQL queries for department, city & rating insights
├── powerbi/
│   ├── Employee_Dashboard.pbix                 # Power BI Desktop report file
│   └── Employee_Analytical_Dashboard.pdf       # Exported dashboard PDF
└── README.md
```

---

## How to Reproduce

1. **Run the Python Cleaning Script:**
   * Install dependencies: `pip install pandas numpy openpyxl`
   * Run `scripts/data_cleaning.py` against the raw Excel dataset to generate the cleaned output.
2. **Load Data into MySQL:**
   * Execute `sql/schema_setup.sql` in MySQL Workbench to create `employee_analytics_db`, `dim_department`, `dim_city`, and `fact_employee`.
   * Load the cleaned dimension and fact tables and run `sql/analysis_queries.sql` to verify row counts and KPIs.
3. **Open in Power BI Desktop:**
   * Open `powerbi/Employee_Dashboard.pbix`, update the MySQL server/database credentials if needed, and click **Refresh**.

---

## Dashboard Preview

> *Tip: Upload a PNG screenshot of your dashboard (`dashboard_preview.png`) to your repository and link it below:*
> `![Employee Analytical Dashboard](dashboard_preview.png)`