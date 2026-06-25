--Question 1
--a.	
SELECT 
    first_name, 
    last_name, 
    email
FROM 
    customers
WHERE 
    city = 'Lagos'
ORDER BY 
    last_name ASC, 
    first_name ASC;

--b.
SELECT DISTINCT 
    c.city
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
ORDER BY 
    c.city ASC;


--C.
SELECT 
    product_name, 
    category_id, 
    unit_price
FROM 
    products
ORDER BY 
    unit_price DESC
LIMIT 10;

--d.
SELECT 
    first_name || ' ' || last_name AS full_name,
    role,
    hire_date,
    salary
FROM 
    employees
WHERE 
    hire_date >= '2021-01-01'
ORDER BY 
    hire_date ASC;





--e.
SELECT 
    order_id,
    order_date,
    status,
    shipping_city
FROM 
    orders
WHERE 
    EXTRACT(MONTH FROM order_date) = 12
ORDER BY 
    order_date DESC;

--Question 2
--Aggregate functions
--a.
SELECT 
    status,
    COUNT(*) AS count,
    ROUND( (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders)), 2 ) AS pct_of_total
FROM 
    orders
GROUP BY 
    status
ORDER BY 
    count DESC;



--b
SELECT 
    c.category_name,
    MIN(p.unit_price) AS min_price,
    MAX(p.unit_price) AS max_price,
    ROUND(AVG(p.unit_price), 2) AS avg_price
FROM 
    products p
JOIN 
    categories c ON p.category_id = c.category_id
GROUP BY 
    c.category_name
ORDER BY 
    avg_price DESC;

--c.
SELECT ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)), 2) AS total_revenue, ROUND(AVG(quantity * unit_price * (1 - discount / 100.0)), 2) AS avg_revenue_per_item, ROUND(MAX(quantity * unit_price * (1 - discount / 100.0)), 2) AS max_line_item_revenue, ROUND(MIN(quantity * unit_price * (1 - discount / 100.0)), 2) AS min_line_item_revenue FROM order_items;
--d.
SELECT
    COUNT(DISTINCT customer_id) AS distinct_customers,
    ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT customer_id), 2) AS avg_orders_per_customer
FROM orders;



--Question 3
--a.
SELECT
    EXTRACT(YEAR FROM registration_date) AS registration_year,
    COUNT(*) AS customer_count
FROM customers
GROUP BY EXTRACT(YEAR FROM registration_date)
HAVING EXTRACT(YEAR FROM registration_date) BETWEEN 2018 AND 2024
ORDER BY registration_year ASC;
--b.
SELECT
    shipping_city,
    COUNT(*) AS delivered_order_count
FROM orders
WHERE status = 'Delivered'
GROUP BY shipping_city
HAVING COUNT(*) > 10
ORDER BY delivered_order_count DESC;




--c.
SELECT
    oi.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY oi.product_id, p.product_name
HAVING SUM(oi.quantity) > 50
ORDER BY total_quantity_sold DESC;
--d.
SELECT
    e.first_name || ' ' || e.last_name AS full_name,
    COUNT(o.order_id) AS total_orders_handled
FROM employees e
JOIN orders o
    ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING COUNT(o.order_id) >= 20
ORDER BY total_orders_handled DESC;



--e.
SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS distinct_customers
FROM orders
WHERE EXTRACT(YEAR FROM order_date) BETWEEN 2021 AND 2024
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY order_year ASC;

--Question 4
--a.
SELECT first_name, last_name, email
FROM customers
WHERE email ILIKE '%@gmail.com'
ORDER BY last_name ASC;
--b
SELECT product_name, category_id, unit_price
FROM products
WHERE product_name ILIKE '%set%'
ORDER BY unit_price DESC;
--c
SELECT first_name || ' ' || last_name AS full_name,
       city,
       registration_date
FROM customers
WHERE last_name ILIKE 'Ad%'
ORDER BY last_name ASC;
--d
SELECT product_name, category_id, unit_price
FROM products
WHERE product_name ILIKE '%combo%'
   OR product_name ILIKE '%kit%'
   OR product_name ILIKE '%pack%'
ORDER BY unit_price DESC;
--e
SELECT first_name, last_name, city, registration_date
FROM customers
WHERE city ILIKE '%an%'
ORDER BY city ASC, last_name ASC;

--Question 5
--a
SELECT o.order_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       e.first_name || ' ' || e.last_name AS employee_name,
       o.order_date,
       o.status,
       o.shipping_city
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
INNER JOIN employees e
    ON o.employee_id = e.employee_id
ORDER BY o.order_date DESC
LIMIT 50;
--b
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS full_name,
       c.city,
       COALESCE(COUNT(o.order_id), 0) AS order_count
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY order_count DESC, c.last_name ASC;
--c
SELECT oi.order_id,
       o.order_date,
       c.first_name || ' ' || c.last_name AS customer_name,
       p.product_name,
       oi.quantity,
       oi.unit_price,
       oi.discount,
       (oi.quantity * oi.unit_price * (1 - oi.discount)) AS line_total
FROM order_items oi
INNER JOIN orders o
    ON oi.order_id = o.order_id
INNER JOIN customers c
    ON o.customer_id = c.customer_id
INNER JOIN products p
    ON oi.product_id = p.product_id
ORDER BY oi.order_id ASC, p.product_name ASC;

--d
SELECT e.employee_id,
       e.first_name || ' ' || e.last_name AS full_name,
       e.role,
       r.region_name,
       COALESCE(COUNT(o.order_id), 0) AS total_orders
FROM employees e
INNER JOIN regions r
    ON e.region_id = r.region_id
LEFT JOIN orders o
    ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.role, r.region_name
ORDER BY total_orders DESC, e.last_name ASC;
--e
SELECT
    c.category_name,
    p.product_name,
    COUNT(DISTINCT oi.order_id) AS times_ordered,
    SUM(oi.quantity) AS total_qty_sold
FROM categories c
JOIN products p
    ON c.category_id = p.category_id
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY c.category_name, p.product_name
ORDER BY c.category_name ASC, total_qty_sold DESC;


--Question 6
--a
SELECT
    p.product_name,
    c.category_name,
    p.unit_price,
    CASE
        WHEN p.unit_price < 10000 THEN 'Budget'
        WHEN p.unit_price BETWEEN 10000 AND 99999 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS price_tier
FROM products p
JOIN categories c
    ON p.category_id = c.category_id
ORDER BY p.unit_price ASC;
--b
SELECT
    first_name || ' ' || last_name AS full_name,
    role,
    salary,
    CASE
        WHEN salary >= 100000 THEN 'Executive'
        WHEN salary BETWEEN 80000 AND 99999 THEN 'Senior'
        ELSE 'Entry Level'
    END AS pay_band
FROM employees
ORDER BY salary DESC;

--c
SELECT
    o.order_id,
    o.order_date,
    o.status,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount / 100.0)), 2) AS total_order_value,
    CASE
        WHEN SUM(oi.quantity * oi.unit_price * (1 - oi.discount / 100.0)) > 500000 THEN 'High Value'
        WHEN SUM(oi.quantity * oi.unit_price * (1 - oi.discount / 100.0)) BETWEEN 100000 AND 500000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS value_category
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date, o.status
ORDER BY total_order_value DESC;


--d
SELECT
    c.category_name,
    COUNT(CASE WHEN p.unit_price < 10000 THEN 1 END) AS budget_count,
    COUNT(CASE WHEN p.unit_price BETWEEN 10000 AND 99999 THEN 1 END) AS mid_range_count,
    COUNT(CASE WHEN p.unit_price >= 100000 THEN 1 END) AS premium_count
FROM categories c
JOIN products p
    ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY c.category_name;

--Question 7
--a
SELECT
    product_name,
    category_id,
    unit_price
FROM products
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM products
)
ORDER BY unit_price DESC;


--b
SELECT
    first_name || ' ' || last_name AS full_name,
    city
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM orders
);

--c
SELECT
    product_id,
    product_name,
    category_id,
    unit_price
FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id
    FROM order_items
);

--d
SELECT
    c.first_name || ' ' || c.last_name AS full_name,
    c.city,
    ROUND(t.total_revenue, 2) AS total_lifetime_revenue
FROM (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount / 100.0)) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) t
JOIN customers c
    ON t.customer_id = c.customer_id
ORDER BY total_lifetime_revenue DESC
LIMIT 5;
--e
SELECT
    c.first_name || ' ' || c.last_name AS full_name,
    c.city,
    ROUND(t.total_revenue, 2) AS total_revenue
FROM (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount / 100.0)) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) t
JOIN customers c
    ON t.customer_id = c.customer_id
WHERE t.total_revenue > (
    SELECT AVG(total_revenue)
    FROM (
        SELECT
            o.customer_id,
            SUM(oi.quantity * oi.unit_price * (1 - oi.discount / 100.0)) AS total_revenue
        FROM orders o
        JOIN order_items oi
            ON o.order_id = oi.order_id
        GROUP BY o.customer_id
    ) avg_table
)
ORDER BY total_revenue DESC;

--Question 8
--a
WITH customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount / 100.0)) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    c.city,
    ROUND(cr.total_revenue, 2) AS total_revenue
FROM customer_revenue cr
JOIN customers c
    ON cr.customer_id = c.customer_id
ORDER BY total_revenue DESC
LIMIT 10;


--b
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category_id,
        SUM(oi.quantity) AS total_qty_sold
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category_id
)
SELECT
    c.category_name,
    ps.product_name,
    ps.total_qty_sold
FROM product_sales ps
JOIN categories c
    ON ps.category_id = c.category_id
WHERE ps.total_qty_sold = (
    SELECT MAX(total_qty_sold)
    FROM product_sales ps2
    WHERE ps2.category_id = ps.category_id
);



--c
WITH monthly_revenue AS (
    SELECT
        EXTRACT(MONTH FROM o.order_date) AS month_num,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount / 100.0)) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE EXTRACT(YEAR FROM o.order_date) = 2023
    GROUP BY month_num
),
avg_revenue AS (
    SELECT AVG(total_revenue) AS avg_monthly_revenue
    FROM monthly_revenue
)
SELECT
    mr.month_num,
    ROUND(mr.total_revenue, 2) AS total_revenue,
    CASE
        WHEN mr.total_revenue > ar.avg_monthly_revenue THEN 'Above Average'
        ELSE 'Below Average'
    END AS vs_average
FROM monthly_revenue mr
CROSS JOIN avg_revenue ar
ORDER BY mr.month_num ASC;

--d

WITH customer_orders AS (
    SELECT
        c.customer_id,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)
SELECT
    CASE
        WHEN total_orders >= 8 THEN 'High Frequency'
        WHEN total_orders BETWEEN 4 AND 7 THEN 'Regular'
        WHEN total_orders BETWEEN 1 AND 3 THEN 'Occasional'
        ELSE 'Inactive'
    END AS segment,
    COUNT(*) AS customer_count
FROM customer_orders
GROUP BY segment
ORDER BY customer_count DESC;

--e
WITH yearly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM o.order_date) AS order_year,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount / 100.0)) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY order_year
)
SELECT
    order_year,
    ROUND(total_revenue, 2) AS total_revenue
FROM yearly_revenue
ORDER BY order_year ASC;

--Question 9
WITH order_revenue AS (
    -- CTE 1: Calculate total revenue per order
    SELECT
        oi.order_id,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount / 100.0)) AS order_total
    FROM order_items oi
    GROUP BY oi.order_id
),

employee_performance AS (
    -- CTE 2: Aggregate delivered order metrics per employee
    SELECT
        o.employee_id,
        COUNT(o.order_id) AS total_delivered_orders,
        SUM(orv.order_total) AS total_revenue,
        AVG(orv.order_total) AS avg_order_value,
        MAX(orv.order_total) AS best_single_order
    FROM orders o
    JOIN order_revenue orv
        ON o.order_id = orv.order_id
    WHERE o.status = 'Delivered'
    GROUP BY o.employee_id
)

-- Final SELECT: Join employees + regions + metrics
SELECT
    e.first_name || ' ' || e.last_name AS employee_name,
    e.role,
    r.region_name,
    COALESCE(ep.total_delivered_orders, 0) AS total_delivered_orders,
    ROUND(COALESCE(ep.total_revenue, 0), 2) AS total_revenue,
    ROUND(COALESCE(ep.avg_order_value, 0), 2) AS avg_order_value,
    ROUND(COALESCE(ep.best_single_order, 0), 2) AS best_single_order,
    CASE
        WHEN COALESCE(ep.total_revenue, 0) > 5000000 THEN 'Elite'
        WHEN COALESCE(ep.total_revenue, 0) BETWEEN 1000000 AND 5000000 THEN 'Strong'
        WHEN COALESCE(ep.total_revenue, 0) BETWEEN 100000 AND 999999 THEN 'Developing'
        ELSE 'Inactive'
    END AS performance_band
FROM employees e
LEFT JOIN employee_performance ep
    ON e.employee_id = ep.employee_id
JOIN regions r
    ON e.region_id = r.region_id
ORDER BY total_revenue DESC, employee_name ASC;


-- Question 10
WITH customer_metrics AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city,
        EXTRACT(YEAR FROM c.registration_date) AS registration_year,

        COUNT(o.order_id) AS total_orders,

        COUNT(CASE WHEN o.status = 'Delivered' THEN 1 END) AS delivered_orders,

        COUNT(CASE WHEN o.status = 'Cancelled' THEN 1 END) AS cancelled_orders,

        SUM(
            CASE 
                WHEN o.status = 'Delivered'
                THEN oi.quantity * oi.unit_price * (1 - oi.discount / 100.0)
                ELSE 0
            END
        ) AS lifetime_revenue

    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE c.registration_date < '2024-01-01'
    GROUP BY
        c.customer_id, c.first_name, c.last_name, c.city, registration_year
)

SELECT
    first_name || ' ' || last_name AS customer_name,
    city,
    registration_year,
    total_orders,
    delivered_orders,
    cancelled_orders,
    ROUND(COALESCE(lifetime_revenue, 0), 2) AS lifetime_revenue,

    ROUND(
        CASE 
            WHEN delivered_orders > 0 THEN lifetime_revenue / delivered_orders
            ELSE 0
        END, 2
    ) AS avg_order_value,

    CASE
        WHEN COALESCE(lifetime_revenue, 0) > 500000
             AND delivered_orders >= 5 THEN 'VIP'

        WHEN COALESCE(lifetime_revenue, 0) BETWEEN 100000 AND 500000
             OR delivered_orders BETWEEN 2 AND 4 THEN 'Loyal'

        WHEN delivered_orders = 1 THEN 'One-Time Buyer'





