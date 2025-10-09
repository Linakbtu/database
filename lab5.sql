/* ============================================================
Database Constraints - Laboratory Work
Author: Kaldanova Lina
Date: 2025-10-09
============================================================ */
 --PART 1: CHECK Constraints

-- 1.1 Basic CHECK
CREATE TABLE employees(
  employee_id INT PRIMARY KEY,
  first_name TEXT,
  last_name TEXT,
  age INT CHECK (age BETWEEN 18 AND 65),
  salary NUMERIC(10,2) CHECK (salary > 0)
);
INSERT INTO employees VALUES (1,'Aida','Sultan',25,350000);
-- INSERT INTO employees VALUES (2,'Invalid','Age',17,200000); -- age<18

-- 1.2 Named CHECK
CREATE TABLE products_catalog(
  product_id INT PRIMARY KEY,
  product_name TEXT,
  regular_price NUMERIC(10,2),
  discount_price NUMERIC(10,2),
  CONSTRAINT valid_discount CHECK (
    regular_price>0 AND discount_price>0 AND discount_price<regular_price)
);
INSERT INTO products_catalog VALUES (1,'Cream',9990,7990);
-- INSERT INTO products_catalog VALUES (2,'Invalid',15000,15000); -- discount=regular

-- 1.3 Multi-column CHECK
CREATE TABLE bookings(
  booking_id INT PRIMARY KEY,
  check_in DATE,
  check_out DATE,
  num_guests INT,
  CHECK (num_guests BETWEEN 1 AND 10),
  CHECK (check_out > check_in)
);
INSERT INTO bookings VALUES (1,'2025-12-01','2025-12-03',2);
-- INSERT INTO bookings VALUES (2,'2025-12-03','2025-12-01',2); -- invalid dates

 --PART 2: NOT NULL

-- 2.1 Simple NOT NULL
CREATE TABLE customers(
  customer_id INT PRIMARY KEY,
  email TEXT NOT NULL,
  phone TEXT,
  registration_date DATE NOT NULL
);
INSERT INTO customers VALUES (1,'aida@example.kz',NULL,'2025-10-01');
-- INSERT INTO customers VALUES (2,NULL,'+7701','2025-10-01'); -- email NULL

-- 2.2 Combined Constraints
CREATE TABLE inventory(
  item_id INT PRIMARY KEY,
  item_name TEXT NOT NULL,
  quantity INT NOT NULL CHECK (quantity>=0),
  unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price>0),
  last_updated TIMESTAMP NOT NULL
);
INSERT INTO inventory VALUES (1,'Cable',100,1990,now());
-- INSERT INTO inventory VALUES (2,'Mouse',NULL,6990,now()); -- quantity NULL

 --PART 3: UNIQUE

-- 3.1 Named UNIQUE
CREATE TABLE users(
  user_id INT PRIMARY KEY,
  username TEXT,
  email TEXT,
  created_at TIMESTAMP,
  CONSTRAINT unique_username UNIQUE(username),
  CONSTRAINT unique_email UNIQUE(email)
);
INSERT INTO users VALUES (1,'aray','aray@example.kz',now());
-- INSERT INTO users VALUES (2,'aray','x@example.kz',now()); -- duplicate username

-- 3.2 Multi-column UNIQUE
CREATE TABLE course_enrollments(
  enrollment_id INT PRIMARY KEY,
  student_id INT,
  course_code TEXT,
  semester TEXT,
  CONSTRAINT uq_student_course_sem UNIQUE(student_id,course_code,semester)
);
INSERT INTO course_enrollments VALUES (1,1001,'CS101','Fall-25');
-- INSERT INTO course_enrollments VALUES (2,1001,'CS101','Fall-25'); -- duplicate combo

 --PART 4: PRIMARY KEY

-- 4.1 Single-column PK
CREATE TABLE departments(
  dept_id INT PRIMARY KEY,
  dept_name TEXT NOT NULL,
  location TEXT
);
INSERT INTO departments VALUES (10,'Finance','Astana');
-- INSERT INTO departments VALUES (10,'Dup','Almaty'); -- duplicate PK

-- 4.2 Composite PK
CREATE TABLE student_courses(
  student_id INT,
  course_id INT,
  enrollment_date DATE,
  grade TEXT,
  PRIMARY KEY(student_id,course_id)
);
INSERT INTO student_courses VALUES (1001,1,'2025-09-01','A');
-- INSERT INTO student_courses VALUES (1001,1,'2025-09-02','B'); -- duplicate PK

-- 4.3 Explanation
-- PRIMARY KEY = UNIQUE + NOT NULL (main identifier)
-- UNIQUE allows NULLs; PK does not.
-- Only one PK per table; many UNIQUE allowed.

 --PART 5: FOREIGN KEY

-- 5.1 Basic FK
CREATE TABLE employees_dept(
  emp_id INT PRIMARY KEY,
  emp_name TEXT NOT NULL,
  dept_id INT REFERENCES departments(dept_id),
  hire_date DATE
);
INSERT INTO employees_dept VALUES (1,'Aruzhan',10,'2025-01-10');
-- INSERT INTO employees_dept VALUES (2,'Dana',99,'2025-01-11'); -- FK fail

-- 5.2 Library DB
CREATE TABLE authors(
  author_id INT PRIMARY KEY,
  author_name TEXT NOT NULL
);
CREATE TABLE publishers(
  publisher_id INT PRIMARY KEY,
  publisher_name TEXT NOT NULL
);
CREATE TABLE books(
  book_id INT PRIMARY KEY,
  title TEXT NOT NULL,
  author_id INT REFERENCES authors(author_id),
  publisher_id INT REFERENCES publishers(publisher_id),
  isbn TEXT UNIQUE
);
INSERT INTO authors VALUES (1,'Abai');
INSERT INTO publishers VALUES (1,'Qazaq Press');
INSERT INTO books VALUES (1,'Kara Sozder',1,1,'ISBN-001');
-- INSERT INTO books VALUES (2,'Another',1,1,'ISBN-001'); -- duplicate ISBN

-- 5.3 ON DELETE
CREATE TABLE categories(
  category_id INT PRIMARY KEY,
  category_name TEXT NOT NULL
);
CREATE TABLE products_fk(
  product_id INT PRIMARY KEY,
  product_name TEXT NOT NULL,
  category_id INT REFERENCES categories(category_id) ON DELETE RESTRICT
);
CREATE TABLE orders(
  order_id INT PRIMARY KEY,
  order_date DATE NOT NULL
);
CREATE TABLE order_items(
  item_id INT PRIMARY KEY,
  order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
  product_id INT REFERENCES products_fk(product_id),
  quantity INT CHECK (quantity>0)
);
INSERT INTO categories VALUES (1,'Electronics');
INSERT INTO products_fk VALUES (1,'Headphones',1);
INSERT INTO orders VALUES (1,'2025-10-01');
INSERT INTO order_items VALUES (1,1,1,2);
-- DELETE FROM categories WHERE category_id=1; -- RESTRICT fail
-- DELETE FROM orders WHERE order_id=1; -- CASCADE order_items deleted

-- PART 6: E-commerce Schema

CREATE TABLE customers_ec(
  customer_id INT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  phone TEXT,
  registration_date DATE NOT NULL
);
CREATE TABLE products_ec(
  product_id INT PRIMARY KEY,
  name TEXT NOT NULL,
  price NUMERIC(10,2) NOT NULL CHECK (price>=0),
  stock_quantity INT NOT NULL CHECK (stock_quantity>=0)
);
CREATE TABLE orders_ec(
  order_id INT PRIMARY KEY,
  customer_id INT REFERENCES customers_ec(customer_id) ON DELETE RESTRICT,
  order_date DATE NOT NULL,
  total_amount NUMERIC(12,2) NOT NULL CHECK (total_amount>=0),
  status TEXT NOT NULL CHECK (status IN ('pending','processing','shipped','delivered','cancelled'))
);
CREATE TABLE order_details_ec(
  order_detail_id INT PRIMARY KEY,
  order_id INT REFERENCES orders_ec(order_id) ON DELETE CASCADE,
  product_id INT REFERENCES products_ec(product_id) ON DELETE RESTRICT,
  quantity INT CHECK (quantity>0),
  unit_price NUMERIC(10,2) CHECK (unit_price>=0)
);

-- Minimal sample data
INSERT INTO customers_ec VALUES (1,'Aida','aida@example.kz',NULL,'2025-10-01');
INSERT INTO products_ec VALUES (1,'Cable',1990,100);
INSERT INTO orders_ec VALUES (1,1,'2025-10-06',1990,'pending');
INSERT INTO order_details_ec VALUES (1,1,1,1,1990);

-- Tests
-- INSERT INTO customers_ec VALUES (2,'Dup','aida@example.kz',NULL,'2025-10-02'); -- duplicate email
-- INSERT INTO orders_ec VALUES (2,1,'2025-10-07',1000,'unknown'); -- invalid status
-- DELETE FROM products_ec WHERE product_id=1; -- RESTRICT fail
-- DELETE FROM orders_ec WHERE order_id=1; -- CASCADE delete details
