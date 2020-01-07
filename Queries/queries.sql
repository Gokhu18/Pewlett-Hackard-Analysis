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
-- then export into a new table

SELECT r.emp_no, r.first_name, r.last_name, d.to_date
INTO current_emp
FROM retirement_info AS r
LEFT JOIN dept_emp AS d
ON r.emp_no = d.emp_no
WHERE d.to_date = '9999-01-01';

SELECT * FROM current_emp;