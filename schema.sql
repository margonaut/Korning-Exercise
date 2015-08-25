-- Paired Margaret & Aja

-- DEFINE YOUR DATABASE SCHEMA HERE
DROP TABLE IF EXISTS sales, customers, employees CASCADE;

CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  customer_name varchar(100) NOT NULL,
  account_no varchar(100) NOT NULL
);


CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  employee_name varchar(100) NOT NULL,
  employee_email varchar(50) NOT NULL
);

CREATE TABLE sales (
  id SERIAL PRIMARY KEY,
  invoice_no int NOT NULL,
  sale_date varchar(100) NOT NULL,
  product_name varchar(100) NOT NULL,
  units_sold int NOT NULL,
  sale_amount varchar(100) NOT NULL,
  invoice_frequency varchar(100) NOT NULL,
  customer_id SERIAL NOT NULL REFERENCES customers,
  employee_id SERIAL NOT NULL REFERENCES employees
);

-- Ways to view the entire linked table

-- SELECT *
-- FROM sales
--   JOIN customers ON sales.customer_id = customers.id
--   JOIN employees ON sales.employee_id = employees.id;

-- SELECT * FROM sales JOIN customers ON sales.customer_id = customers.id;
-- SELECT * FROM sales JOIN employees ON sales.employee_id = employees.id;

-- SELECT * FROM sales JOIN customers ON sales.customer_id = customers.id JOIN employees ON sales.employee_id = employees.id;
