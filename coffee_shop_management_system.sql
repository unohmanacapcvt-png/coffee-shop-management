-- APPDEV PRELIM EXAM
-- Coffee Shop Management System

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(30) NOT NULL,
    hire_date DATE NOT NULL
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INTEGER NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL UNIQUE,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO customers (first_name,last_name,phone,email) VALUES
('Maria','Santos','09171234567','maria.santos@email.com'),
('Juan','Dela Cruz','09181234567','juan.delacruz@email.com'),
('Angela','Reyes','09191234567','angela.reyes@email.com'),
('Carlos','Mendoza','09201234567','carlos.mendoza@email.com'),
('Sofia','Garcia','09211234567','sofia.garcia@email.com');

INSERT INTO employees (first_name,last_name,role,hire_date) VALUES
('Liam','Torres','Cashier','2024-01-15'),
('Bea','Navarro','Barista','2024-03-10'),
('Noah','Cruz','Barista','2024-06-05'),
('Mika','Ramos','Cashier','2025-01-20'),
('Ethan','Lim','Manager','2023-08-12');

INSERT INTO products (product_name,category,price,stock_quantity) VALUES
('Spanish Latte','Coffee',145.00,40),
('Americano','Coffee',110.00,50),
('Matcha Latte','Non-Coffee',155.00,30),
('Blueberry Cheesecake','Pastry',180.00,20),
('Chocolate Muffin','Pastry',95.00,35);

INSERT INTO orders (customer_id,employee_id,order_date,order_status,total_amount) VALUES
(1,1,'2026-09-01','Completed',290.00),
(2,2,'2026-09-02','Completed',250.00),
(3,3,'2026-09-03','Completed',180.00),
(4,4,'2026-09-04','Completed',300.00),
(5,1,'2026-09-05','Completed',205.00);

INSERT INTO order_items (order_id,product_id,quantity,unit_price) VALUES
(1,1,2,145.00),
(2,3,1,155.00),
(2,5,1,95.00),
(3,4,1,180.00),
(4,1,1,145.00),
(4,3,1,155.00),
(5,2,1,110.00),
(5,5,1,95.00);

INSERT INTO payments (order_id,payment_date,payment_method,amount,payment_status) VALUES
(1,'2026-09-01','Cash',290.00,'Paid'),
(2,'2026-09-02','GCash',250.00,'Paid'),
(3,'2026-09-03','Cash',180.00,'Paid'),
(4,'2026-09-04','GCash',300.00,'Paid'),
(5,'2026-09-05','Cash',205.00,'Paid');

-- QUERY 1: WHERE
SELECT product_id, product_name, category, price
FROM products
WHERE price >= 150
ORDER BY price DESC;

-- QUERY 2: JOIN
SELECT o.order_id,
       c.first_name || ' ' || c.last_name AS customer,
       o.order_date,
       o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id;

-- QUERY 3: GROUP BY + COUNT
SELECT category,
       COUNT(*) AS number_of_products,
       ROUND(AVG(price),2) AS average_price
FROM products
GROUP BY category
ORDER BY average_price DESC;

-- QUERY 4: JOIN + GROUP BY + SUM
SELECT p.product_name,
       SUM(oi.quantity) AS units_sold,
       ROUND(SUM(oi.quantity * oi.unit_price),2) AS sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY sales DESC;

-- QUERY 5: JOIN + GROUP BY + aggregate
SELECT e.first_name || ' ' || e.last_name AS employee,
       COUNT(o.order_id) AS orders_handled,
       ROUND(SUM(o.total_amount),2) AS total_sales
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY total_sales DESC;
