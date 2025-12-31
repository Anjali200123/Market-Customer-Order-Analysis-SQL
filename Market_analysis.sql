USE project_orders;
SHOW TABLES;
SELECT 
    o.order_id,
    o.user_id,
    o.order_dow,
    o.order_hour_of_day,
    o.days_since_prior_order,
    opt.product_id,
    opt.add_to_cart_order,
    opt.reordered,
    p.product_name,
    a.aisle,
    d.department
FROM orders o
JOIN order_products_train opt 
    ON o.order_id = opt.order_id
JOIN products p 
    ON opt.product_id = p.product_id
JOIN aisles a 
    ON p.aisle_id = a.aisle_id
JOIN departments d 
    ON p.department_id = d.department_id;

## Top 10 aisles with highest number of products
SELECT a.aisle, COUNT(p.product_id) AS total_products
FROM products p
JOIN aisles a ON p.aisle_id = a.aisle_id
GROUP BY a.aisle
ORDER BY total_products DESC
LIMIT 10;


## Number of unique departments
SELECT COUNT(DISTINCT department_id) AS total_departments
FROM departments;

##Distribution of products across departments
SELECT d.department, COUNT(p.product_id) AS total_products
FROM products p
JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department
ORDER BY total_products DESC;

##Number of unique users
SELECT COUNT(DISTINCT user_id) AS total_users
FROM orders;

##Average days between orders per user
SELECT user_id,
AVG(days_since_prior_order) AS avg_days
FROM orders
GROUP BY user_id;


## Peak order hours
SELECT order_hour_of_day,
COUNT(*) AS total_orders
FROM orders
GROUP BY order_hour_of_day
ORDER BY total_orders DESC;



##Orders by day of week
SELECT order_dow,
COUNT(*) AS total_orders
FROM orders
GROUP BY order_dow
ORDER BY total_orders DESC;

##Top 10 most ordered products
SELECT p.product_name, COUNT(*) AS order_count
FROM order_products_train opt
JOIN products p ON opt.product_id = p.product_id
GROUP BY p.product_name
ORDER BY order_count DESC
LIMIT 10;

##Number of users who ordered from each department
SELECT d.department,
       COUNT(DISTINCT o.user_id) AS total_users
FROM orders o
JOIN order_products_train opt ON o.order_id = opt.order_id
JOIN products p ON opt.product_id = p.product_id
JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department;

USE project_orders;

## Average number of products per order
SELECT AVG(product_count) AS avg_products_per_order
FROM (
    SELECT order_id, COUNT(product_id) AS product_count
    FROM order_products_train
    GROUP BY order_id
) t;

##Most reordered products in each department
SELECT d.department,
       p.product_name,
       SUM(opt.reordered) AS total_reorders
FROM order_products_train opt
JOIN products p ON opt.product_id = p.product_id
JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department, p.product_name
ORDER BY d.department, total_reorders DESC;


##Products reordered more than once
SELECT p.product_name,
       SUM(opt.reordered) AS reorder_count
FROM order_products_train opt
JOIN products p ON opt.product_id = p.product_id
GROUP BY p.product_name
HAVING reorder_count > 1;
									       
##Average number of products added to cart per order
SELECT AVG(product_count) AS avg_cart_size
FROM (
    SELECT order_id, COUNT(add_to_cart_order) AS product_count
    FROM order_products_train
    GROUP BY order_id
) t;


##Distribution of order sizes
SELECT product_count,
       COUNT(*) AS total_orders
FROM (
    SELECT order_id, COUNT(product_id) AS product_count
    FROM order_products_train
    GROUP BY order_id
) t
GROUP BY product_count
ORDER BY product_count;


##Average reorder rate for products in each aisle
SELECT a.aisle,
       AVG(opt.reordered) AS avg_reorder_rate
FROM order_products_train opt
JOIN products p ON opt.product_id = p.product_id
JOIN aisles a ON p.aisle_id = a.aisle_id
GROUP BY a.aisle
ORDER BY avg_reorder_rate DESC;

## Average order size by day of the week
SELECT o.order_dow,
       AVG(t.product_count) AS avg_order_size
FROM orders o
JOIN (
    SELECT order_id, COUNT(product_id) AS product_count
    FROM order_products_train
    GROUP BY order_id
) t ON o.order_id = t.order_id
GROUP BY o.order_dow;

##Top 10 users with highest number of orders
SELECT user_id,
       COUNT(order_id) AS total_orders
FROM orders
GROUP BY user_id
ORDER BY total_orders DESC
LIMIT 10;


##Number of products in each aisle and department
SELECT a.aisle,
       d.department,
       COUNT(p.product_id) AS total_products
FROM products p
JOIN aisles a ON p.aisle_id = a.aisle_id
JOIN departments d ON p.department_id = d.department_id
GROUP BY a.aisle, d.department
ORDER BY total_products DESC;




                                    

