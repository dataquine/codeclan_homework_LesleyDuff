-- Final SQL Lab and Homework
-- Author: Lesley Duff
-- Date created: 2023-07-26


--MVP
--Q1
--Question 1.
--How many employee records are lacking both a grade and salary?

SELECT count(id) AS no_grade_salary
FROM employees 
WHERE grade IS NULL AND salary IS NULL;


--MVP
--Q2
--Question 2.
--Produce a table with the two following fields (columns):
--the department
--the employees full name (first and last name)
--Order your resulting table alphabetically by department, and then by last name
SELECT 
	department, 
	first_name, 
	last_name 
FROM employees 
ORDER BY department, last_name;


--MVP
--Q3
--Question 3.
--Find the details of the top ten highest paid employees who have a last_name 
-- beginning with ‘A’.
-- MY ASSUMPTION: You are asking literally for starting with upper case 'A'
SELECT *
FROM employees
WHERE last_name LIKE 'A%'
ORDER BY salary DESC NULLS LAST
LIMIT 10;


--MVP
--Q4
--Question 4.
--Obtain a count by department of the employees who started work with the 
--corporation in 2003.
SELECT department, count(id) AS num_department_employee_2013
FROM employees 
WHERE start_date BETWEEN '2013-01-01' AND '2013-12-31'
GROUP BY department;


--MVP
--Q5
--Question 5.
--Obtain a table showing department, fte_hours and the number of employees in 
-- each department who work each fte_hours pattern. Order the table 
-- alphabetically by department, and then in ascending order of fte_hours.
-- Hint
-- You need to GROUP BY two columns here.
SELECT department, fte_hours, count(id) AS num_department_employees_fte
FROM employees 
GROUP BY department, fte_hours 
ORDER BY department ASC, fte_hours ASC


--MVP
--Q6
--Question 6.
--Provide a breakdown of the numbers of employees enrolled, not enrolled, and 
-- with unknown enrollment status in the corporation pension scheme.
SELECT pension_enrol, COUNT (id) AS num_employees 
FROM employees 
GROUP BY pension_enrol;


--MVP
--Q7
--Question 7.
--Obtain the details for the employee with the highest salary in the 
-- ‘Accounting’ department who is not enrolled in the pension scheme?
SELECT *
FROM employees 
WHERE department = 'Accounting' AND pension_enrol = FALSE
ORDER BY salary DESC NULLS LAST
LIMIT 1;


--MVP
--Q8
--Question 8.
--Get a table of country, number of employees in that country, and the average 
--salary of employees in that country for any countries in which more than 30 
-- employees are based. Order the table by average salary descending.
-- Hint
--A HAVING clause is needed to filter using an aggregate function.
--You can pass a column alias to ORDER BY.
SELECT 
	country, 
	count(id) AS num_employees_country,
	round(avg(salary)) AS avg_salary_employees_country
FROM employees 
GROUP BY country
HAVING count(id) > 30
ORDER BY avg_salary_employees_country DESC;


--MVP
--Q9
--Question 9.
--11. Return a table containing each employees first_name, last_name, 
-- full-time equivalent hours (fte_hours), salary, and a new column 
-- effective_yearly_salary which should contain fte_hours multiplied by salary. 
-- Return only rows where effective_yearly_salary is more than 30000.
SELECT 
	first_name, 
	last_name,
	fte_hours,
	salary,
	fte_hours * salary AS effective_yearly_salary
FROM employees
WHERE fte_hours * salary > 30000;


--MVP
--Q10
--Question 10
--Find the details of all employees in either Data Team 1 or Data Team 2
--Hint
--name is a field in table `teams
SELECT e.*
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id 
WHERE t.name IN ('Data Team 1', 'Data Team 2');


--MVP
--Q11
--Question 11
--Find the first name and last name of all employees who lack a local_tax_code.
--Hint
--local_tax_code is a field in table pay_details, and first_name and last_name 
-- are fields in table employees
SELECT first_name, last_name
FROM employees AS e
INNER JOIN pay_details AS pd
ON e.pay_detail_id = pd.id 
WHERE pd.local_tax_code IS NULL;


--MVP
--Q12
--Question 12.
--The expected_profit of an employee is defined as 
-- (48 * 35 * charge_cost - salary) * fte_hours, where charge_cost depends upon 
-- the team to which the employee belongs. Get a table showing expected_profit 
-- for each employee.
--
--Hints
--charge_cost is in teams, while salary and fte_hours are in employees, so a 
-- join will be necessary
--
--You will need to change the type of charge_cost in order to perform the 
-- calculation
-- 
SELECT 
	e.first_name, 
	e.last_name,
	(48 * 35 * t.charge_cost::NUMERIC - e.salary) * e.fte_hours AS 
	expected_profit
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id;


--MVP
--Q13
--Question 13. [Tough]
--Find the first_name, last_name and salary of the lowest paid employee in 
-- Japan who works the least common full-time equivalent hours across the 
-- corporation.”
--
--Hint
--You will need to use a subquery to calculate the mode
SELECT 
	first_name, 
	last_name,
	salary
FROM employees 
WHERE 
	country = 'Japan' AND 
	fte_hours = (
		SELECT fte_hours AS num_employes_fte
		FROM employees 
		GROUP BY fte_hours
		ORDER BY count(id)
		LIMIT 1
	)
ORDER BY salary
LIMIT 1;


--MVP
--Q14
--Question 14.
--Obtain a table showing any departments in which there are two or more 
-- employees lacking a stored first name. Order the table in descending order 
-- of the number of employees lacking a first name, and then in alphabetical 
-- order by department.
WITH no_first_name(id) AS (
	SELECT id
	FROM employees 
	WHERE first_name IS NULL
)
SELECT 
	e.department, 
	count(e.id) AS num_employees_no_first_name
FROM employees AS e
INNER JOIN no_first_name
ON e.id = no_first_name.id
GROUP BY department
HAVING count(e.id) >= 2
ORDER BY 
	num_employees_no_first_name DESC,
	department ASC;
	
	
--MVP
--Q15
--Question 15. [Bit tougher]
--Return a table of those employee first_names shared by more than one employee,
-- together with a count of the number of times each first_name occurs. Omit 
-- employees without a stored first_name from the table. Order the table 
-- descending by count, and then alphabetically by first_name.
WITH no_first_name(id) AS (
	SELECT id
	FROM employees 
	WHERE first_name IS NOT NULL
)
SELECT 
	first_name, 
	COUNT(e.id) AS num_employee_first_name
FROM employees AS e
INNER JOIN no_first_name
ON e.id = no_first_name.id
GROUP BY first_name
HAVING COUNT(e.id) > 1
ORDER BY 
	num_employee_first_name DESC,
	first_name ASC;
	

--Question 16. [Tough]
--Find the proportion of employees in each department who are grade 1.
--Hints
--Think of the desired proportion for a given department as the number of 
--employees in that department who are grade 1, divided by the total number of 
-- employees in that department.
--You can write an expression in a SELECT statement, e.g. grade = 1. This would 
-- result in BOOLEAN values.
--If you could convert BOOLEAN to INTEGER 1 and 0, you could sum them. The 
-- CAST() function lets you convert data types.
--In SQL, an INTEGER divided by an INTEGER yields an INTEGER. To get a REAL 
-- value, you need to convert the top, bottom or both sides of the division to 
-- REAL.
SELECT department, 
	sum((grade = 1)::int)::REAL /(COUNT(id))::REAL AS 
	proportion_employees_department_grade_1
FROM employees 
GROUP BY department;