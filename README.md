# Pewlett-Hackard-Analysis
Build Employee Database with PostgreSQL and perform SQL queries to explore and analysis data by applying skills of Data Modeling, Data Engineer and Data Analysis.

# Challenge

## Object

Create a list of candidates for the mentorship program.


1. the ERD demonstrates relationships between original 6 tables:
![EmployeeDB.png](/EmployeeDB.png)

2. Queries for determining the number of individuals retiring:

- SQL for all Retirement Eligibility:[retirement_info.csv](/Data/retirement_info.csv)

```

SELECT emp_no, birth_date, first_name, last_name, genger AS gender, hire_date
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
```

**In conclusion, There are 41,380 records of individuals ready to retirement**

3. Queries for determining the number of individuals being hired:
- SQL for Current Retirement Eligibility:
```
SELECT r.emp_no, r.first_name, r.last_name,d.dep_no, d.to_date
INTO current_emp
FROM retirement_info AS r
LEFT JOIN dept_emp AS d
ON r.emp_no = d.emp_no
WHERE d.to_date = '9999-01-01';
```


**In conclusion, there are 33,118 records of Current Retirement Eligibility** 

- SQL for Current Retirement Eligibility with title and salary information:
[challenge_emp_info.csv](/Data/challenge_emp_info.csv)
```
SELECT ce.emp_no AS Employee_number,ce.first_name, ce.last_name, 
    t.title AS Title, t.from_date, s.salary AS Salary
INTO challenge_emp_info
FROM current_emp AS ce
INNER JOIN titles AS t ON ce.emp_no = t.emp_no
INNER JOIN salaries AS s ON ce.emp_no = s.emp_no;

```


4. Queries for each employee ONLY display the most recent title:

- By using partition by and row_number() function.
```
SELECT employee_number, first_name, last_name, title, from_date, salary
INTO current_title_info
FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY (cei.employee_number, cei.first_name, cei.last_name)
                ORDER BY cei.from_date DESC) AS emp_row_number
      FROM challenge_emp_info AS cei) AS unique_employee	  
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

**Conclusion**
**In the 33118 records of Current Retirement Eligibility, there are 251 Assistant Engineers, 2711 engineers, two managers 2022 staffs,12872 Senior Staffs and 1609 Technique Leaders**

6. Queries for determining the number of individuals available for mentorship role:
SQL for eligible for mentor program, [challenge_mentor_info.csv](/Data/challenge_mentor_info.csv)

```
SELECT em.emp_no,em.first_name, em.last_name, 
    t.title AS Title, t.from_date, t.to_date
INTO challenge_mentor_info
FROM Employees AS em
INNER JOIN titles AS t ON em.emp_no = t.emp_no
WHERE (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (t.to_date = '9999-01-01');
```
**In conclusion, there are 1549 active employees eligible for mentor plan.**

### Limitation and Suggestion
 
 1. This project assumed retirement years between 1952 and 1955. 
 We need to narrow down period into 3 single year for more accurate estimate and better analysis of potential job opening. 

 2. More detail information and analysis are needed for potential mentor table, 
 to compare with the title table of current ready-to-retirement 
 and get a better estimate of outside hiring request. 

 