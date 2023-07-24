-- SQL Day 1 Homework

/* MVP */
/* Q1 */
-- Find all the employees who work in the ‘Human Resources’ department.

SELECT *
FROM employees 
WHERE department = 'Human Resources';


/* MVP */
/* Q2 */
-- Get the first_name, last_name, and country of the employees who work in the
-- ‘Legal’ department.

SELECT first_name, last_name, country 
FROM employees 
WHERE department = 'Legal';


/* MVP */
/* Q3 */
-- Count the number of employees based in Portugal.
SELECT 
	COUNT(*) AS total_employees_portugal
FROM employees 
WHERE country = 'Portugal';


/* MVP */
/* Q4 */
-- Count the number of employees based in either Portugal or Spain.
SELECT 
	COUNT(*) AS total_employees_portugal_spain
FROM employees 
WHERE country IN ('Portugal', 'Spain');


/* MVP */
/* Q5 */
-- Count the number of pay_details records lacking a local_account_no.
SELECT 
	COUNT(*) AS total_no_local_account_no
FROM pay_details 
WHERE local_account_no IS NULL;


/* MVP */
/* Q6 */
-- Are there any pay_details records lacking both a local_account_no and iban number?
SELECT 
	COUNT(*) AS total_no_local_account_no_iban
FROM pay_details 
WHERE (local_account_no IS NULL) AND (iban IS NULL);
-- There are no pay_details records lacking both a local_account_no and iban number


/* MVP */
/* Q7 */
-- Get a table with employees first_name and last_name ordered alphabetically 
-- by last_name (put any NULLs last).
SELECT first_name, last_name
FROM employees 
ORDER BY last_name ASC NULLS LAST, first_name ASC NULLS LAST;


/* MVP */
/* Q8 */
-- Get a table of employees first_name, last_name and country, ordered 
-- alphabetically first by country and then by last_name (put any NULLs last).
SELECT first_name, last_name, country
FROM employees
ORDER BY 
	country ASC NULLS LAST, 
	last_name ASC NULLS LAST;


/* MVP */
/* Q9 */
-- Find the details of the top ten highest paid employees in the corporation.
SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST
LIMIT(10);


/* MVP */
/* Q10 */
-- Find the first_name, last_name and salary of the lowest paid employee in 
-- Hungary.
SELECT first_name, last_name, salary
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary ASC NULLS LAST;


/* MVP */
/* Q11 */
-- How many employees have a first_name beginning with ‘F’?
SELECT
	COUNT(*) AS total_employees_first_name_begins_f
FROM employees
WHERE first_name LIKE 'F%';


/* MVP */
/* Q12 */
-- Find all the details of any employees with a ‘yahoo’ email address?
SELECT *
FROM employees 
WHERE email LIKE '%yahoo%';


/* MVP */
/* Q13 */
-- Count the number of pension enrolled employees not based in either France 
-- or Germany.
SELECT *
FROM employees 
WHERE pension_enrol = TRUE 
	AND (country NOT IN ('France', 'Germany'));


/* MVP */
/* Q14 */
-- What is the maximum salary among those employees in the ‘Engineering’ 
-- department who work 1.0 full-time equivalent hours (fte_hours)?
SELECT max(salary) AS max_salary_engineering_fte_1
FROM employees 
WHERE department = 'Engineering' 
	AND fte_hours = 1.0;


/* MVP */
/* Q15 */
-- Return a table containing each employees first_name, last_name, full-time 
-- equivalent hours (fte_hours), salary, and a new column 
-- effective_yearly_salary which should contain fte_hours multiplied by salary.
SELECT first_name, last_name, fte_hours, salary, fte_hours * salary 
	AS effective_yearly_salary
FROM employees;


/* Extension */
/* Q16 */
-- The corporation wants to make name badges for a forthcoming conference. 
-- Return a column badge_label showing employees’ first_name and last_name 
-- joined together with their department in the following style: 
-- ‘Bob Smith - Legal’. Restrict output to only those employees with stored 
-- first_name, last_name and department.
SELECT 
	CONCAT(first_name, ' ', last_name, ' - ', department) AS badge_label
FROM employees 
WHERE first_name IS NOT NULL AND 
	last_name IS NOT NULL AND 
	department IS NOT NULL;

	
/* Extension */
/* Q17 */
-- One of the conference organisers thinks it would be nice to add the year 
-- of the employees’ start_date to the badge_label to celebrate long-standing 
-- colleagues, in the following style ‘Bob Smith - Legal (joined 1998)’. 
-- Further restrict output to only those employees with a stored start_date.
--
-- [If you’re really keen - try adding the month as a string: 
-- ‘Bob Smith - Legal (joined July 1998)’]
-- Research: 9.9.1. EXTRACT, date_part
-- 	https://www.postgresql.org/docs/current/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT
-- The extract function retrieves subfields such as year or hour from 
-- date/time values. source must be a value expression of type timestamp, time
-- , or interval
-- 
SELECT 
	CONCAT(first_name, ' ', last_name, ' - ', department, ' (joined ', 
	(TO_CHAR(start_date, 'FMMonth YYYY')), ')')
 AS badge_label
FROM employees 
WHERE first_name IS NOT NULL AND 
	last_name IS NOT NULL AND 
	department IS NOT NULL AND 
	start_date IS NOT NULL;


/* Extension */
/* Q18 */
-- Return the first_name, last_name and salary of all employees together with 
-- a new column called salary_class with a value 'low' where salary is less 
-- than 40,000 and value 'high' where salary is greater than or equal to 40,000. 
SELECT first_name, last_name, salary,
       CASE
           WHEN salary IS NULL THEN 'NA' -- we have no data available  
           WHEN salary < 40000 THEN 'low'
           WHEN salary >= 40000 THEN 'high'
       END salary_class
FROM employees;