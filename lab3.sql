--part A
--Create database and tables
CREATE DATABASE advanced_lab;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(100) DEFAULT 'General',
    salary INTEGER DEFAULT 0,
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100),
    budget INTEGER,
    manager_id INTEGER
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INTEGER REFERENCES departments(dept_id),
    start_date DATE,
    end_date DATE,
    budget INTEGER
);

--part B
--2.INSERT with column specification
INSERT INTO employees (emp_id, first_name, last_name, department)
VALUES (1001, 'Alice', 'Kim', 'IT');
--3.INSERT with DEFAULT
INSERT INTO employees (first_name, last_name, department, salary, status)
VALUES ('Carol', 'Ng', 'Finance', DEFAULT, DEFAULT);
--4.INSERT multiple rows
INSERT INTO departments (dept_name, budget, manager_id)
VALUES ('HR',150000,NULL),('IT',300000,NULL),('Finance',250000,NULL);
--5.INSERT with expressions
INSERT INTO employees (first_name, last_name, department, hire_date, salary, status)
VALUES ('Daniel','Park','IT',CURRENT_DATE,(50000*1.1)::int,'Active');
--6.INSERT from SELECT
CREATE TEMP TABLE temp_employees (LIKE employees INCLUDING DEFAULTS);
INSERT INTO temp_employees
SELECT * FROM employees WHERE department='IT';


--part C
--7.UPDATE arithmetic
UPDATE employees SET salary=(salary*1.10)::int;
--8.UPDATE with conditions
UPDATE employees SET status='Senior'
WHERE salary>60000 AND hire_date<'2020-01-01';
--9.UPDATE CASE
UPDATE employees
SET department=CASE
  WHEN salary>80000 THEN 'Management'
  WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
  ELSE 'Junior' END;
--10.UPDATE DEFAULT
UPDATE employees SET department=DEFAULT WHERE status='Inactive';
--11.UPDATE subquery
UPDATE departments d
SET budget=(SELECT ROUND(AVG(e.salary)*1.2) FROM employees e WHERE e.department=d.dept_name)
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.department=d.dept_name);
--12. UPDATE multiple cols
UPDATE employees SET salary=(salary*1.15)::int,status='Promoted'
WHERE department='Sales';

--part D
--13. DELETE simple
DELETE FROM employees WHERE status='Terminated';
--14. DELETE complex
DELETE FROM employees
WHERE salary<40000 AND hire_date>'2023-01-01' AND department IS NULL;
--15. DELETE subquery
DELETE FROM departments d
WHERE NOT EXISTS (SELECT 1 FROM employees e WHERE e.department=d.dept_name);
--16. DELETE RETURNING
DELETE FROM projects WHERE end_date<'2023-01-01' RETURNING *;

--part E
--17. INSERT NULLs
INSERT INTO employees (first_name,last_name,salary,department,hire_date,status)
VALUES ('Evelyn','Cho',NULL,NULL,CURRENT_DATE,'Active');
--18.UPDATE NULL handling
UPDATE employees SET department='Unassigned' WHERE department IS NULL;
--19. DELETE NULL conditions
DELETE FROM employees WHERE salary IS NULL OR department IS NULL;


part F
--20. INSERT RETURNING
INSERT INTO employees (first_name,last_name,department,salary,hire_date,status)
VALUES ('Frank','Miller','IT',60000,CURRENT_DATE,'Active')
RETURNING emp_id,(first_name||' '||last_name) AS full_name;
--21. UPDATE RETURNING
UPDATE employees SET salary=salary+5000
WHERE department='IT'
RETURNING emp_id,(salary-5000) AS old_salary,salary AS new_salary;
--22. DELETE RETURNING
DELETE FROM employees WHERE hire_date<'2020-01-01' RETURNING *;
--23. Conditional INSERT
INSERT INTO employees (first_name,last_name,department,salary,hire_date,status)
SELECT 'Grace','Han','IT',70000,CURRENT_DATE,'Active'
WHERE NOT EXISTS (SELECT 1 FROM employees WHERE first_name='Grace' AND last_name='Han');
--24. UPDATE with JOIN logic
UPDATE employees e
SET salary=CASE WHEN d.budget>100000 THEN (e.salary*1.10)::int ELSE (e.salary*1.05)::int END
FROM departments d
WHERE e.department=d.dept_name;
--26. Data migration
CREATE TABLE IF NOT EXISTS employee_archive (LIKE employees INCLUDING ALL);
INSERT INTO employee_archive SELECT * FROM employees WHERE status='Inactive';
DELETE FROM employees WHERE status='Inactive';
--27. Complex business logic
UPDATE projects p
SET end_date=COALESCE(p.end_date,CURRENT_DATE)+INTERVAL '30 days'
FROM departments d
WHERE p.dept_id=d.dept_id AND p.budget>50000
  AND (SELECT COUNT(*) FROM employees e WHERE e.department=d.dept_name)>3;
