CREATE DATABASE IF NOT EXISTS employee_analytics_db;
USE employee_analytics_db;

CREATE TABLE IF NOT EXISTS dim_department (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_city (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS fact_employee (
    emp_record_id INT PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    full_name VARCHAR(120) NOT NULL,
    dept_id INT NOT NULL,
    city_id INT NOT NULL,
    join_date DATE NOT NULL,
    tenure_years DECIMAL(5,2) NOT NULL,
    age INT NOT NULL CHECK (age BETWEEN 18 AND 65),
    salary INT NOT NULL CHECK (salary BETWEEN 10000 AND 500000),
    performance_rating INT NOT NULL CHECK (performance_rating BETWEEN 1 AND 5),
    is_duplicate_customer_id BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES dim_department(dept_id),
    CONSTRAINT fk_emp_city FOREIGN KEY (city_id) REFERENCES dim_city(city_id)
);

-- 1. Department headcount, average salary, and average rating
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

-- 2. Rank departments by average salary within each city
SELECT
    c.city_name,
    d.dept_name,
    COUNT(*) AS staff_count,
    ROUND(AVG(f.salary), 2) AS avg_salary,
    DENSE_RANK() OVER (PARTITION BY c.city_name ORDER BY AVG(f.salary) DESC) AS salary_rank_in_city
FROM fact_employee f
JOIN dim_city c ON f.city_id = c.city_id
JOIN dim_department d ON f.dept_id = d.dept_id
GROUP BY c.city_name, d.dept_name;

-- 3. Audit repeated Customer_ID values
SELECT
    customer_id,
    COUNT(*) AS occurrence_count
FROM fact_employee
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC, customer_id;



---------------------------------------------
CREATE DATABASE IF NOT EXISTS employee_analytics_db;
USE employee_analytics_db;

CREATE TABLE IF NOT EXISTS dim_department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dim_city (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS fact_employee (
    emp_record_id INT PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    full_name VARCHAR(120) NOT NULL,
    dept_id INT NOT NULL,
    city_id INT NOT NULL,
    join_date DATE NOT NULL,
    tenure_years DECIMAL(5,2) NOT NULL,
    age INT NOT NULL CHECK (age BETWEEN 18 AND 65),
    salary INT NOT NULL CHECK (salary BETWEEN 10000 AND 500000),
    performance_rating INT NOT NULL CHECK (performance_rating BETWEEN 1 AND 5),
    is_duplicate_customer_id TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES dim_department(dept_id),
    CONSTRAINT fk_emp_city FOREIGN KEY (city_id) REFERENCES dim_city(city_id)
);



