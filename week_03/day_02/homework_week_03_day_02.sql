-- SQL Day 2 Lab and Homework
-- Author: Lesley Duff
-- Date created: 2023-07-25

--MVP
--Q1 (a)
--Question 1.
--(a). Find the first name, last name and team name of employees who are members 
--of teams.
--
--Hint
--We only want employees who are also in the teams table. So which type of join 
--should we use?
SELECT 
	e.first_name, 
	e.last_name, 
	t.name  
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id; 

--MVP
--Q1 (b)
--(b). Find the first name, last name and team name of employees who are members
--of teams and are enrolled in the pension scheme.
SELECT 
	e.first_name, 
	e.last_name, 
	t.name
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id 
WHERE e.pension_enrol = TRUE;

--MVP
--Q1 (c)
--(c). Find the first name, last name and team name of employees who are members 
--of teams, where their team has a charge cost greater than 80.
--
--Hint
--charge_cost may be the wrong type to compare with value 80. Can you find a way 
--to convert it without changing the database?
SELECT 
	e.first_name, 
	e.last_name, 
	t.name
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id 
WHERE CAST (t.charge_cost AS INTEGER) > 80;

--

--MVP
--Q2 (a)
--Question 2.
--(a). Get a table of all employees details, together with their 
--local_account_no and local_sort_code, if they have them.
--
--Hints
--local_account_no and local_sort_code are fields in pay_details, and 
--employee details are held in employees, so this query requires a JOIN.
--
--What sort of JOIN is needed if we want details of all employees, even if they 
--don’t have stored local_account_no and local_sort_code?
SELECT 
	e.*, 
	p.local_account_no, 
	p.local_sort_code  
FROM employees AS e
LEFT JOIN pay_details AS p
ON e.pay_detail_id = p.id; 

--MVP
--Q2 (b)
--(b). Amend your query above to also return the name of the team that each 
--employee belongs to.
--
--Hint
--The name of the team is in the teams table, so we will need to do another join.
SELECT 
	e.*, 
	p.local_account_no, 
	p.local_sort_code, 
	t.name AS team_name
FROM employees AS e
LEFT JOIN pay_details AS p
ON e.pay_detail_id = p.id 
LEFT JOIN teams AS t
ON e.team_id = t.id;

--

--MVP
--Q3 (a)
--Question 3.
--(a). Make a table, which has each employee id along with the team that 
-- employee belongs to.
SELECT 
	e.id,
	t.name 
FROM employees AS e
left JOIN teams AS t
ON e.team_id = t.id;

--MVP
--Q3 (b)
--(b). Breakdown the number of employees in each of the teams.
--Hint
-- You will need to add a group by to the table you created above.
SELECT 
	t.name AS team_name, 
	count(*) AS num_employees_teams
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id 
GROUP BY t.name;

--MVP
--Q3 (c)
--(c). Order the table above by so that the teams with the least employees come 
--first.
SELECT 
	t.name AS team_name, 
	count(*) AS num_employees_teams
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id 
GROUP BY t.name
ORDER BY num_employees_teams;

--

--MVP
--Q4 (a)
--Question 4.
--(a). Create a table with the team id, team name and the count of the number of 
--employees in each team.
--
--Hint
--If you GROUP BY teams.id, because it’s the primary key, you can SELECT any 
--other column of teams that you want (this is an exception to the rule that 
-- normally you can only SELECT a column that you GROUP BY).
--
SELECT 
	t.id, 
	t.name,
	count(e.*) AS num_employees_team
FROM teams AS t
LEFT JOIN employees AS e 
ON t.id = e.team_id 
GROUP BY t.id;

--MVP
--Q4 (b)
--(b). The total_day_charge of a team is defined as the charge_cost of the team
--multiplied by the number of employees in the team. Calculate the 
--total_day_charge for each team.
SELECT 
	t.name,
	CAST(t.charge_cost AS INTEGER) * count(e.*) AS total_day_charge
FROM teams AS t
LEFT JOIN employees AS e 
ON t.id = e.team_id 
GROUP BY t.id;

--MVP
--Q4 (c)
--(c). How would you amend your query from above to show only those teams with a
-- total_day_charge greater than 5000?
SELECT 
	t.name,
	CAST(t.charge_cost AS INTEGER) * count(e.*) AS total_day_charge
FROM teams AS t
LEFT JOIN employees AS e 
ON t.id = e.team_id 
GROUP BY t.id
HAVING CAST(t.charge_cost AS INTEGER) * count(e.*) > 5000;

--

--Question 5.
--How many of the employees serve on one or more committees?
--
--Hints
--All of the details of membership of committees is held in a single table: 
--employees_committees, so this doesn’t require a join.
--
--Some employees may serve in multiple committees. Can you find the number of 
-- distinct employees who serve? [Extra hint - do some research on the 
-- DISTINCT() function].
SELECT 
	count(*) AS num_employees_multiple_committees
FROM
(SELECT DISTINCT 
	employee_id, 
	count(*)
FROM employees_committees 
GROUP BY employees_committees.employee_id
HAVING count(*) > 1)
 employees_committees;

--Question 6.
--How many of the employees do not serve on a committee?
--
--Hints
--This requires joining over only two tables
--
--Could you use a join and find rows without a match in the join?
SELECT 
	count(*) AS num_employees_no_committee 
FROM employees
LEFT JOIN employees_committees 
ON employees.id = employees_committees.employee_id 
WHERE committee_id IS NULL;