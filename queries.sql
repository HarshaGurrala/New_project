use ecommerce_db;


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