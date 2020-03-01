# Pewlett-Hackard-Analysis
Build Employee Database with PostgreSQL and perform SQL queries to explore and analysis data by applying skills of Data Modeling, Data Engineer and Data Analysis.

# Challenge

## Object

Create a list of candidates for the mentorship program.

1.ERD demonstrates relationships between original 6 tables:
![EmployeeDB](https://user-images.githubusercontent.com/59859527/75624222-53911e80-5b67-11ea-8f65-a86ac1c5beff.png)

2. Queries to determine the number of individuals retiring:

- SQL for all Retirement Eligibility:[retirement_info.csv](/Data/retirement_info.csv)

```
SELECT emp_no, birth_date, first_name, last_name, genger AS gender, hire_date
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
```

** There are 41,380 records of individuals ready to retirement**

3. Queries to determine the number of individuals being hired:
- SQL for Current Retirement Eligibility:
```
SELECT r.emp_no, r.first_name, r.last_name,d.dep_no, d.to_date
INTO current_emp
FROM retirement_info AS r
LEFT JOIN dept_emp AS d
ON r.emp_no = d.emp_no
WHERE d.to_date = '9999-01-01';
```


**There are 33,118 records of Current Retirement Eligibility** 
- SQL for Current Retirement Eligibility with title and salary information:
[challenge_emp_info.csv](/Data/challenge_emp_info.csv)
```
SELECT ce.emp_no AS Employee_number,ce.first_name, ce.last_name, 
    ti.title AS Title, ti.from_date, sa.salary AS Salary
INTO challenge_emp_info
FROM current_emp AS ce
INNER JOIN titles AS ti ON ce.emp_no = ti.emp_no
INNER JOIN salaries AS sa ON ce.emp_no = sa.emp_no;

```
4. Queries for each employee ONLY display the most recent title:
- By using partition by and row_number() function.
```
SELECT employee_number, first_name, last_name, title, from_date, salary
INTO current_title_info
FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY (ce.employee_number, ce.first_name, ce.last_name)
                ORDER BY ce.from_date DESC) AS emp_row_number
      FROM challenge_emp_info AS ce) AS unique_emp  
WHERE emp_row_number =1;
```

5. Queries for the frequency count of employee titles:
[challenge_title_info.csv](/Data/challenge_title_info.csv)
```
SELECT *, count(ct.Employee_number) 
		OVER (PARTITION BY ct.title ORDER BY ct.from_date DESC) AS emp_count
INTO challenge_title_info
FROM current_title_info AS ct;
```
and a summary count of employees for each title:[challenge_title_count_info.csv](/Data/challenge_title_count_info.csv)
```
SELECT COUNT(employee_number), title
FROM challenge_title_info
GROUP BY title;
```
**3311 of Current Retirement Eligibility following is split by titles, there are 251 Assistant Engineers, 2711 engineers, 2 managers, 2022 staffs,12872 Senior Staffs and 1609 Technique Leaders**

6. Queries to determine the number of individuals available for mentorship role:
SQL [challenge_mentor_info.csv](/Data/challenge_mentor_info.csv)

```
SELECT em.emp_no,em.first_name, em.last_name, 
    ti.title AS Title, ti.from_date, ti.to_date
INTO challenge_mentor_info
FROM Employees AS em
INNER JOIN titles AS ti ON em.emp_no = ti.emp_no
WHERE (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (ti.to_date = '9999-01-01');
```
**There are 1549 active employees eligible for mentor plan.**

### Limitation and Suggestion
 
 1.More detail information and analysis needed for potential mentor table.
 2.Want better estimate of outside hiring request.
 
 
