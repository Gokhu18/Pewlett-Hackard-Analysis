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
