# Pewlett-Hackard-Analysis
Build employee Database with PostgreSQL


# Challenge

To create the new list of potential mentors, you will need to create a query that returns a list of current employees eligible for retirement, as well as their most recent titles. To get the final list with the recent titles, you’ll also need to partition the data so that each employee is only included on the list once. In addition, you’ll need to perform a query that shows how many current employees of each title are presently eligible for retirement. The final query should return the potential mentor’s employee number, first and last name, their title, birth date and employment dates.

## Object

Create a list of candidates for the mentorship program.
Use SQL perform several queries.

1. Use an ERD to understand relationships between SQL tables.




2. Create new tables in pgAdmin by using different joins.

```

-- Number of title Retiring
SELECT ce.emp_no AS Employee_number,ce.first_name, ce.last_name, 
    t.title AS Title, t.from_date, s.salary AS Salary
INTO challenge_emp_info
FROM current_emp AS ce
INNER JOIN titles AS t ON ce.emp_no = t.emp_no
INNER JOIN salaries AS s ON ce.emp_no = s.emp_no;

```


```
-- for each employee ONLY display the most recent title
-- by using partition by and row_number() function.

SELECT employee_number, first_name, last_name, title, from_date, salary
INTO current_title_info
FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY (cei.employee_number, cei.first_name, cei.last_name)
                ORDER BY cei.from_date DESC) AS emp_row_number
      FROM challenge_emp_info AS cei) AS unique_employee	  
WHERE emp_row_number =1;

-- Get frequency count of employee titles 
SELECT *, count(ct.Employee_number) 
		OVER (PARTITION BY ct.title ORDER BY ct.from_date DESC) AS emp_count
FROM current_title_info AS ct;
```

3. Write basic- to intermediate-level SQL statements.

4. Export new tables to a CSV file.