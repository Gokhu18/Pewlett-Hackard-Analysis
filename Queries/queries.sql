-- creating tables for PH-EmployeeDB
CREATE TABLE departments(
	dep_no VARCHAR(4) NOT NULL, 
	dep_name VARCHAR(40) NOT NULL,
	PRIMARY KEY(dep_no),
	UNIQUE (dep_name)
);

CREATE TABLE Employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	genger VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dep_no VARCHAR (4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	
	FOREIGN KEY (emp_no) REFERENCES Employees (emp_no),
	FOREIGN KEY (dep_no) REFERENCES departments(dep_no),
	PRIMARY KEY (dep_no, emp_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dep_no VARCHAR (4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES Employees (emp_no),
	FOREIGN KEY (dep_no) REFERENCES departments(dep_no),
	PRIMARY KEY (dep_no, emp_no)
);

CREATE TABLE titles (
    emp_no INT NOT NULL,
    title VARCHAR NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES Employees (emp_no),
	PRIMARY KEY (emp_no, title)	
);

CREATE TABLE salaries (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES Employees (emp_no),
	PRIMARY KEY (emp_no)
);
-- use SELECT query to confirm tables creation
SELECT * FROM departments;
SELECT * FROM Employees;
SELECT * FROM dept_manager;
SELECT * FROM dept_emp;
SELECT * FROM titles;
SELECT * FROM salaries;
SELECT * FROM retirement_info;

-- fix 'titles' table problem
DROP TABLE titles CASCADE;

CREATE TABLE titles (
    emp_no INT NOT NULL,
    title VARCHAR NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES Employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)	
);

-- PRACTICE JOIN 
SELECT departments.dep_name, 
	   dept_manager.emp_no, dept_manager.from_date, dept_manager.to_date
FROM departments
INNER JOIN dept_manager 
ON departments.dep_no = dept_manager.dep_no;

SELECT Employees.first_name, Employees.last_name, dept_emp.dep_no
FROM Employees 
JOIN dept_emp 
ON Employees.emp_no = dept_emp.emp_no;

-- Data Analysis part 1: Retirement Eligibility

SELECT first_name, last_name
FROM Employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31');

SELECT first_name, last_name
FROM Employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT COUNT(*)
FROM Employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE retirement_info;  -- A query created table, dont need CASCADE

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Data Analysis Part 2: Retirement Eligibility with JOIN with dep_info
-- then export into a new table OF CURRENT Employees

SELECT r.emp_no, r.first_name, r.last_name, d.to_date
INTO current_emp
FROM retirement_info AS r
LEFT JOIN dept_emp AS d
ON r.emp_no = d.emp_no
WHERE d.to_date = '9999-01-01';

SELECT * FROM current_emp;

-- GROUP BY , ORDER BY and JOIN clause together
SELECT COUNT(ce.emp_no), de.dep_no
INTO current_emp_per_dep
FROM current_emp AS ce
LEFT JOIN dept_emp AS de
ON ce.emp_no = de.emp_no
GROUP BY de.dep_no
ORDER BY de.dep_no;

SELECT * FROM current_emp_per_dep;

/*SELECT COUNT(ce.emp_no), de.dep_no, d.dep_name
FROM current_emp AS ce
LEFT JOIN dept_emp AS de
LEFT JOIN departments AS d
ON ce.emp_no = de.emp_no
ON de.dep_no = d.dep_no
GROUP BY de.dep_no
ORDER BY de.dep_name;
*/

-- additional LIST 1: current and eligible of retirement employee info plus salary
--  the lack of employee raises
SELECT em.emp_no, em.last_name, em.first_name, em.genger AS gender, 
	 s.salary
INTO emp_info
FROM Employees AS em
INNER JOIN salaries AS s ON em.emp_no = s.emp_no
INNER JOIN dept_emp AS d ON em.emp_no = d.emp_no

WHERE (em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (em.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (d.to_date = '9999-01-01');

-- additional LIST 2: departuring manager(active now) per department
-- How can only five departments have active managers? total is 9
SELECT dm.dep_no, d.dep_name, dm.emp_no, ce.last_name, ce.first_name,
		dm.from_date, dm.to_date	 
INTO manager_info
FROM dept_manager AS dm
INNER JOIN current_emp AS ce ON ce.emp_no = dm.emp_no
INNER JOIN departments AS d ON d.dep_no = dm.dep_no;

-- additional LIST 3: department retirees
-- someone are appearing twice. Maybe they moved departments?
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dep_name	
INTO dept_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de ON ce.emp_no = de.emp_no 
INNER JOIN departments AS d ON d.dep_no = de.dep_no;

-- Check output tables 
SELECT * FROM emp_info;
SELECT * FROM manager_info;
SELECT * FROM dept_info;

-- Tailored list 1 (filter) : only for sales team

SELECT ce.emp_no, ce.first_name, ce.last_name, d.dep_name
INTO sales_dept_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de ON ce.emp_no = de.emp_no 
INNER JOIN departments AS d ON d.dep_no = de.dep_no
WHERE d.dep_name = 'Sales';

-- Tailored list 2 (filter) : either of sales and develop team

SELECT ce.emp_no, ce.first_name, ce.last_name, d.dep_name
INTO mentor_dept_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de ON ce.emp_no = de.emp_no 
INNER JOIN departments AS d ON d.dep_no = de.dep_no
WHERE d.dep_name IN ('Sales', 'Development');
