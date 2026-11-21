-- Department Headcount, Salary & Rating Breakdown

SELECT
    d.dept_name,
    COUNT(*) AS headcount,
    ROUND(AVG(f.salary), 2) AS avg_salary,
    ROUND(AVG(f.performance_rating), 2) AS avg_rating,
    ROUND(AVG(f.tenure_years), 2) AS avg_tenure_years
FROM fact_employee f
JOIN dim_department d ON f.dept_id = d.dept_id
GROUP BY d.dept_name
ORDER BY headcount DESC;

--  City-Level Summary & Duplicate ID Audit
SELECT
    c.city_name,
    COUNT(*) AS headcount,
    SUM(f.is_duplicate_customer_id) AS duplicate_id_rows,
    ROUND(AVG(f.salary), 2) AS avg_salary
FROM fact_employee f
JOIN dim_city c ON f.city_id = c.city_id
GROUP BY c.city_name
ORDER BY headcount DESC;


--- Top Paid Employees Within Each Department (Window Function)
SELECT
    d.dept_name,
    f.full_name,
    f.salary,
    f.performance_rating,
    DENSE_RANK() OVER (PARTITION BY d.dept_name ORDER BY f.salary DESC) AS dept_salary_rank
FROM fact_employee f
JOIN dim_department d ON f.dept_id = d.dept_id;