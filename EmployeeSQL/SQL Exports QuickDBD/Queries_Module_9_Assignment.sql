-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE employees (
    emp_no SERIAL   NOT NULL,
    emp_title_id VARCHAR(10)   NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR(255)   NOT NULL,
    last_name VARCHAR(255)   NOT NULL,
    sex VARCHAR(6)   NOT NULL,
    hire_date DATE   NOT NULL,
    CONSTRAINT pk_employees PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE departments (
    dept_no VARCHAR(10)   NOT NULL,
    dept_name VARCHAR(255)   NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (
        dept_no
     )
);

CREATE TABLE dept_emp (
    emp_no INTEGER   NOT NULL,
    dept_no VARCHAR(10)   NOT NULL
);

CREATE TABLE dept_manager (
    dept_no VARCHAR(10)   NOT NULL,
    emp_no INTEGER   NOT NULL
);

CREATE TABLE salaries (
    emp_no INTEGER   NOT NULL,
    salary INTEGER   NOT NULL
);

CREATE TABLE titles (
    title_id VARCHAR(10)   NOT NULL,
    title VARCHAR(255)   NOT NULL,
    CONSTRAINT pk_titles PRIMARY KEY (
        title_id
     )
);

ALTER TABLE employees ADD CONSTRAINT fk_employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES titles (title_id);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

select * from departments;

select * from dept_emp;

select * from dept_manager;

select * from employees;

select * from salaries;

select * from titles;

-- Question 1:
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
INNER JOIN salaries ON
salaries.emp_no=employees.emp_no;

-- Question 2: List the first name, last name, and hire date for the employees who were hired in 1986.

SELECT first_name, last_name, hire_date
From employees
where extract(year from hire_date) = 1986;

-- Question 3: List the manager of each department along with their 
-- department number, department name, employee number, last name, and first name.

SELECT dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, 
employees.last_name, employees.first_name
FROM dept_manager
INNER JOIN departments ON
dept_manager.dept_no=departments.dept_no
INNER JOIN employees ON 
dept_manager.emp_no=employees.emp_no;

-- Question 4: List the department number for each employee along with that 
--employee’s employee number, last name, first name, and department name.

SELECT departments.dept_no, employees.emp_no, 
employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp ON
employees.emp_no=dept_emp.emp_no
JOIN departments ON 
departments.dept_no=dept_emp.dept_no;


-- Question 5: List first name, last name, and sex of each employee 
-- whose first name is Hercules and whose last name begins with the letter B.

SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

-- Question 6: List each employee in the Sales department, including 
-- their employee number, last name, and first name.

SELECT d.dept_name, de.emp_no, e.last_name, e.first_name
FROM departments as d
join dept_emp as de on 
d.dept_no = de.dept_no
join employees as e on
de.emp_no=e.emp_no
where dept_name = 'Sales';

-- Question 7: List each employee in the Sales and Development departments, 
-- including their employee number, last name, first name, and department name.

SELECT de.emp_no, e.last_name, e.first_name, d.dept_name
FROM departments as d
join dept_emp as de on 
d.dept_no = de.dept_no
join employees as e on
de.emp_no=e.emp_no
where dept_name = 'Sales'
or dept_name = 'Development';


-- Question 8: List the frequency counts, in descending order, of all the 
-- employee last names (that is, how many employees share each last name).

SELECT last_name, count(last_name) as "last_name_count"
FROM employees
GROUP BY last_name
ORDER BY "last_name_count" DESC;