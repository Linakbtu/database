--1.1
create table employees(
    emp_id int primary key,
    emp_name varchar(50),
    dept_id int,
    salary decimal(10,2)
);
create table departments(
    dept_id int primary key,
    dept_name varchar(50),
    location varchar(50)
);
create table projects(
    project_id int primary key,
    project_name varchar(50),
    dept_id int,
    budget decimal(10,2)
);

--1.2
insert into employees (emp_id, emp_name, dept_id, salary)
values
(1, 'John Smith', 101, 50000),
(2, 'Jane Doe', 102, 60000),
(3, 'Mike Johnson', 101, 55000),
(4, 'Sarah Williams', 103, 65000),
(5, 'Tom Brown', null, 45000);

insert into departments (dept_id, dept_name, location)
values
(101, 'IT', 'Building A'),
(102, 'HR', 'Building B'),
(103, 'Finance', 'Building C'),
(104, 'Marketing', 'Building D');

insert into projects (project_id, project_name, dept_id, budget)
values
(1, 'Website Redesign', 101, 100000),
(2, 'Employee Training', 102, 50000),
(3, 'Budget Analysis', 103, 75000),
(4, 'Cloud Migration', 101, 150000),
(5, 'AI Research', null, 200000);

--2.1
select e.emp_name, d.dept_name
from employees e
cross join departments d;
--5*4=20

--2.2
--a
select e.emp_name, d.dept_name
from employees e, departments d;
--b
select e.emp_name, d.dept_name
from employees e
inner join departments d on true;

--2.3
select e.emp_name, p.project_name
from employees e
cross join projects p;

--3.1
select e.emp_name, d.dept_name, d.location
from employees e
inner join departments d on e.dept_id = d.dept_id;
--4 rows (Tom Brown = Null dept)

--3.2
select emp_name, dept_name, location
from employees
inner join departments using(dept_id);
--column dept_id is not duplicated, a common column is used

--3.3
select emp_name, dept_name, location
from employees
natural inner join departments;

--3.4
select e.emp_name, d.dept_name, p.project_name
from employees e
inner join departments d on e.dept_id = d.dept_id
inner join projects p on d.dept_id = p.dept_id;

--4.1
select e.emp_name, e.dept_id, d.dept_id, d.dept_name
from employees e
left join departments d on e.dept_id = d.dept_id;
--Tom Brown: dept_name, dept_id = null

--4.2
select emp_name, dept_id, dept_name
from employees
left join departments using(dept_id);

--4.3
select e.emp_name, e.dept_id
from employees e
left join departments d on e.dept_id = d.dept_id
where d.dept_id is null;
--Employees without departments

--4.4
select d.dept_name, count(e.emp_id) as employee_count
from departments d
left join employees e on e.dept_id = d.dept_id
group by d.dept_id, d.dept_name
order by employee_count desc;
--Departments and number of employees

--5.1
select e.emp_name, d.dept_name
from employees e
right join departments d on e.dept_id = d.dept_id;

--5.2
select e.emp_name, d.dept_name
from departments d
left join employees e on d.dept_id = e.dept_id;

--5.3
select d.dept_name, d.location
from departments d
left join employees e on d.dept_id = e.dept_id
where e.emp_id is null;
--Departments without employees (fixed condition)

--6.1
select e.emp_name, e.dept_id, d.dept_id, d.dept_name
from employees e
full join departments d on e.dept_id = d.dept_id;
--null left = department without employees, null right = employee without department

--6.2
select d.dept_name, p.project_name, p.budget
from departments d
full join projects p on d.dept_id = p.dept_id;

--6.3
select
    case
        when e.emp_id is null then 'Department without employees'
        when d.dept_id is null then 'Employee without department'
        else 'Matched'
    end as record_status, e.emp_name, d.dept_name
from employees e
full join departments d on e.dept_id = d.dept_id
where e.emp_id is null or d.dept_id is null;
--Show only unmatched records

--7.1
select e.emp_name, d.dept_name, e.salary
from employees e
left join departments d on e.dept_id = d.dept_id and d.location = 'Building A';
--left join keeps all employees

--7.2
select e.emp_name, d.dept_name, e.salary
from employees e
left join departments d on e.dept_id = d.dept_id
where d.location = 'Building A';
--filter in where removes nulls (acts as inner join)

--7.3
select e.emp_name, d.dept_name, e.salary
from employees e
inner join departments d on e.dept_id = d.dept_id and d.location = 'Building A';
--no differences in result from 7.2

--8.1
select d.dept_name, e.emp_name, e.salary, p.project_name, p.budget
from departments d
left join employees e on d.dept_id = e.dept_id
left join projects p on d.dept_id = p.dept_id
order by d.dept_name, e.emp_name;
--departments, employees and their projects

--8.2
alter table employees add column manager_id int;
update employees set manager_id = 3 where emp_id in (1,2,4,5);
update employees set manager_id = null where emp_id = 3;

select e.emp_name, m.emp_name
from employees e
left join employees m on e.manager_id = m.emp_id;
--self join to show managers

--8.3
select d.dept_name, avg(e.salary)
from departments d
inner join employees e on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name
having avg(e.salary) > 50000;
--average salary above 50000


--1
--inner join-return a common rows
--left join-all rows from left table
--2
--when we need to return all combinations
--3
--to outer join filter on saved all without coincidences, filter where clause excludes them
--4
--select count(*)
--from table1
--cross join table2;
--5
--natural join-It automatically joins tables on all columns with the same names
--6
--if the tables have extra, identical column names, the join will be unexpected
--7
--select *
--from b
--right join a on a.id=b.id;
--8
--when you need to see all records from both the first and second tables, including the non-matching ones