CREATE DATABASE ecommerce_db;
USE ecommerce_db;
-- USERS
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100)
);

-- PRODUCTS
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    stock INT CHECK (stock >= 0)
);

-- ORDERS
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);



-- ORDER ITEMS
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- PAYMENTS
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10,2),
    status VARCHAR(50),
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO users (name, email, password) VALUES
('Aarav Sharma','aarav@gmail.com','pass123'),
('Vivaan Reddy','vivaan@gmail.com','pass123'),
('Aditya Verma','aditya@gmail.com','pass123'),
('Sai Kiran','saikiran@gmail.com','pass123'),
('Arjun Mehta','arjun@gmail.com','pass123'),
('Rahul Nair','rahul@gmail.com','pass123'),
('Karthik Rao','karthik@gmail.com','pass123'),
('Vikram Singh','vikram@gmail.com','pass123'),
('Rohit Gupta','rohit@gmail.com','pass123'),
('Manish Kumar','manish@gmail.com','pass123'),
('Anjali Sharma','anjali@gmail.com','pass123'),
('Priya Reddy','priya@gmail.com','pass123'),
('Sneha Kapoor','sneha@gmail.com','pass123'),
('Pooja Verma','pooja@gmail.com','pass123'),
('Neha Singh','neha@gmail.com','pass123'),
('Meera Nair','meera@gmail.com','pass123'),
('Divya Rao','divya@gmail.com','pass123'),
('Kavya Gupta','kavya@gmail.com','pass123'),
('Ishita Jain','ishita@gmail.com','pass123'),
('Riya Sharma','riya@gmail.com','pass123'),
('Suresh Babu','suresh@gmail.com','pass123'),
('Ramesh Patel','ramesh@gmail.com','pass123'),
('Mahesh Yadav','mahesh@gmail.com','pass123'),
('Sunil Kumar','sunil@gmail.com','pass123'),
('Naresh Reddy','naresh@gmail.com','pass123'),
('Deepak Singh','deepak@gmail.com','pass123'),
('Amit Shah','amit@gmail.com','pass123'),
('Naveen Kumar','naveen@gmail.com','pass123'),
('Harsha Gurrala','harsha@gmail.com','pass123'),
('Teja Varma','teja@gmail.com','pass123');

INSERT INTO products (name, price, stock) VALUES
('iPhone 14',70000,15),
('Samsung Galaxy S23',65000,20),
('OnePlus 11',60000,18),
('Dell Laptop',55000,10),
('HP Laptop',52000,12),
('Boat Headphones',2000,50),
('Sony Headphones',5000,25),
('LG Smart TV',45000,8),
('Mi Smart TV',30000,10),
('Apple Watch',35000,14),
('Noise Smartwatch',4000,40),
('Logitech Mouse',800,60),
('Mechanical Keyboard',3000,35),
('Gaming Chair',15000,7),
('Office Chair',7000,20);

INSERT INTO orders (user_id) VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15),(16),(17),(18),(19),(20);


INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1,1,1),
(2,2,2),
(3,3,1),
(4,4,1),
(5,5,2),
(6,6,3),
(7,7,1),
(8,8,1),
(9,9,2),
(10,10,1),
(11,11,2),
(12,12,3),
(13,13,1),
(14,14,1),
(15,15,2),
(16,1,1),
(17,2,1),
(18,3,2),
(19,4,1),
(20,5,1);


INSERT INTO payments (order_id, amount, status) VALUES
(1,70000,'Completed'),
(2,130000,'Completed'),
(3,60000,'Pending'),
(4,55000,'Completed'),
(5,104000,'Completed'),
(6,6000,'Failed'),
(7,5000,'Completed'),
(8,45000,'Completed'),
(9,60000,'Pending'),
(10,35000,'Completed'),
(11,8000,'Completed'),
(12,2400,'Failed'),
(13,3000,'Completed'),
(14,15000,'Completed'),
(15,14000,'Pending'),
(16,70000,'Completed'),
(17,65000,'Completed'),
(18,120000,'Completed'),
(19,55000,'Failed'),
(20,52000,'Completed');

SELECT * FROM users;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM payments;

SELECT u.name, o.order_id, p.name AS product, oi.quantity
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

SELECT SUM(amount) AS total_revenue
FROM payments
WHERE status = 'Completed';


SELECT p.name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.name
ORDER BY total_sold DESC
LIMIT 1;


SELECT u.name, COUNT(o.order_id) AS total_orders
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.name;

SELECT 
    u.name,
    SUM(p.amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(p.amount) DESC) AS customer_rank
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN payments p ON o.order_id = p.order_id
WHERE p.status = 'Completed'
GROUP BY u.name;

SELECT 
    p.name,
    SUM(oi.quantity) AS total_sold,
    DENSE_RANK() OVER (ORDER BY SUM(oi.quantity) DESC) AS product_rank
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.name;


SELECT 
    DATE(payment_date) AS day,
    SUM(amount) AS daily_revenue,
    SUM(SUM(amount)) OVER (ORDER BY DATE(payment_date)) AS running_total
FROM payments
WHERE status = 'Completed'
GROUP BY day;

SELECT 
    o.order_id,
    u.name,
    p.amount,
    ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY p.amount DESC) AS order_rank
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN payments p ON o.order_id = p.order_id;

SELECT *
FROM (
    SELECT 
        u.name,
        COUNT(o.order_id) AS total_orders,
        RANK() OVER (ORDER BY COUNT(o.order_id) DESC) AS rnk
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    GROUP BY u.name
) t
WHERE total_orders > 1;