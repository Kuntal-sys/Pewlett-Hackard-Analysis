-- Data Analysis part 1: Retirement Eligibility
SELECT emp_no, birth_date, first_name, last_name, genger, hire_date
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Data Analysis Part 2: Current Retirement Eligibility 
SELECT r.emp_no, r.first_name, r.last_name,d.dep_no, d.to_date
INTO current_emp
FROM retirement_info AS r
LEFT JOIN dept_emp AS d
ON r.emp_no = d.emp_no
WHERE d.to_date = '9999-01-01';
-------------------------------------------------------------
-------------------------------------------------------------
/*Part 1 Instructions
Generate the following tables:
Number of [titles] Retiring
Create a new table using an INNER JOIN that contains the following information:
Employee number
First and last name
Title
from_date
Salary*/--Export the data as a CSV.
SELECT ce.emp_no AS Employee_number,ce.first_name, ce.last_name, 
    ti.title AS Title, ti.from_date, sa.salary AS Salary
INTO challenge_emp_info
FROM current_emp AS ce
INNER JOIN titles AS ti ON ce.emp_no = ti.emp_no
INNER JOIN salaries AS sa ON ce.emp_no = sa.emp_no;
-------------------------------------------------------------
-------------------------------------------------------------
/*Reference your ERD to help determine which tables you’ll use to complete this join.
Only the Most Recent Titles
Exclude the rows of data containing duplicate names. (This is tricky.) Hint: Refer to Partitioning Your Data (Links to an external site.) for help.
In descending order (by date), list the frequency count of employee titles (i.e., how many employees share the same title?).
Export the data as a CSV.*/
SELECT employee_number, first_name, last_name, title, from_date, salary
INTO current_title_info
FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY (ce.employee_number, ce.first_name, ce.last_name)
                ORDER BY ce.from_date DESC) AS emp_row_number
      FROM challenge_emp_info AS ce) AS unique_emp	  
WHERE emp_row_number =1;
-------------------------------------------------------------
-------------------------------------------------------------
/*Who’s Ready for a Mentor?
Create a new table that contains the following information:
Employee number
First and last name
Title
from_date and to_date
Note: The birth date needs to be between January 1, 1965 and December 31, 1965. 
Also, make sure only current employees are included in this list.
Export the data as a CSV.*/

-- Get frequency count of employee titles 
SELECT *, count(ct.Employee_number) 
		OVER (PARTITION BY ct.title ORDER BY ct.from_date DESC) AS emp_count
INTO challenge_title_info
FROM current_title_info AS ct;

-- get total count per title group
SELECT COUNT(employee_number), title
FROM challenge_title_info
GROUP BY title;

-- eleigible for mentor program
SELECT em.emp_no,em.first_name, em.last_name, 
    ti.title AS Title, ti.from_date, ti.to_date
INTO challenge_mentor_info
FROM Employees AS em
INNER JOIN titles AS ti ON em.emp_no = ti.emp_no
INNER JOIN dept_emp AS de ON em.emp_no = de.emp_no
WHERE (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01');

-------------------------------------------------------------
-------------------------------------------------------------
