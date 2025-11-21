-- 1. Category Performance

--  Category wise most rentals and revenue & Ranking  Revenue-Generating Categories
SELECT 
    c.name AS category_name,
    ROUND(SUM(p.amount), 2) AS total_revenue,
    COUNT(r.rental_id) AS total_rentals,
    ROUND(SUM(p.amount) / COUNT(r.rental_id), 2) AS avg_revenue_per_rental,
    RANK() OVER (ORDER BY SUM(p.amount) DESC) AS revenue_rank
FROM category c
JOIN film_category fc 
    ON c.category_id = fc.category_id
JOIN film f 
    ON fc.film_id = f.film_id
JOIN inventory i 
    ON f.film_id = i.film_id
JOIN rental r 
    ON i.inventory_id = r.inventory_id
JOIN payment p 
    ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY total_revenue DESC


-- Average Revenue per Rental by Category
SELECT 
    c.name AS category_name,
    COUNT(r.rental_id) AS total_rentals,
    ROUND(SUM(p.amount), 2) AS total_revenue,
    ROUND(SUM(p.amount) / COUNT(r.rental_id), 2) AS avg_revenue_per_rental
FROM category c
JOIN film_category fc 
    ON c.category_id = fc.category_id
JOIN film f 
    ON fc.film_id = f.film_id
JOIN inventory i 
    ON f.film_id = i.film_id
JOIN rental r 
    ON i.inventory_id = r.inventory_id
JOIN payment p 
    ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY avg_revenue_per_rental DESC


-- Film versus Category Rental Performance
select 
    c.name AS category_name,
    COUNT(DISTINCT f.film_id) AS total_films,
    COUNT(r.rental_id) AS total_rentals,
    ROUND(COUNT(r.rental_id)  / COUNT(DISTINCT f.film_id) , 2) AS rental_to_film_ratio,  
    RANK() OVER (ORDER BY COUNT(r.rental_id) / COUNT(DISTINCT f.film_id)  DESC) AS rental_rank
FROM category c
JOIN film_category fc 
    ON c.category_id = fc.category_id
JOIN film f 
    ON fc.film_id = f.film_id
JOIN inventory i 
    ON f.film_id = i.film_id
JOIN rental r 
    ON i.inventory_id = r.inventory_id
JOIN payment p 
    ON r.rental_id = p.rental_id
GROUP BY c.name


-- 2 Film Performance
-- Which films are under performing on then basis of rental and revenue?
SELECT 
    f.title,
    COUNT(r.rental_id) AS rentals,
    SUM(p.amount) AS revenue
FROM film f
left JOIN inventory i 
   ON f.film_id = i.film_id
left JOIN rental r 
   ON i.inventory_id = r.inventory_id
left JOIN payment p 
   ON r.rental_id = p.rental_id
GROUP BY f.title
ORDER BY revenue asc

-- Highest  Ranking Revenue per film
SELECT 
    f.title,
    ROUND(SUM(p.amount), 2) AS total_revenue,
    RANK() OVER (ORDER BY SUM(p.amount) DESC) AS revenue_rank
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title

-- Average Revenue per Rental per Film
SELECT 
    f.title,
    ROUND(SUM(p.amount) / COUNT(r.rental_id), 2) AS avg_revenue_per_rental
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title
ORDER BY avg_revenue_per_rental desc



-- Customers & Demographics
-- Top-spending and most frequest customers
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.address_id,
    SUM(p.amount) AS total_spent,
    COUNT(p.payment_id) AS Number_of_payments,
    rank() over (order by SUM(p.amount) desc ) as High_revenue_customer,
    rank() over (order by COUNT(p.payment_id) desc ) as most_frequent_customer
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, customer_name, c.email, c.address_id
 

-- What is the average spend per customer?
SELECT 
    country AS country_name,
    ROUND(AVG(customer_total_spent), 2) AS avg_spend_per_customer
FROM (
    SELECT 
        co.country,
        SUM(p.amount) AS customer_total_spent
    FROM payment p
    JOIN customer c ON p.customer_id = c.customer_id
    JOIN address a ON c.address_id = a.address_id
    JOIN city ci ON a.city_id = ci.city_id
    JOIN country co ON ci.country_id = co.country_id
    GROUP BY co.country
) AS customer_spendings
GROUP BY country
ORDER BY avg_spend_per_customer DESC

-- Which customers have spent more than $5 on average per order, and what are their names, emails, and average spent?
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    round(AVG(p.amount),2) AS avg_spent_per_order,
    COUNT(p.payment_id) AS total_orders,
    SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, customer_name, c.email
HAVING AVG(p.amount) > 5
ORDER BY avg_spent_per_order DESC

-- cities and countries wise active & inactive customers?
SELECT 
    ci.city AS city_name,
    co.country AS country_name,
    COUNT(CASE WHEN c.active = 1 THEN 1 END) AS active_customers,
    COUNT(CASE WHEN c.active = 0 THEN 1 END) AS inactive_customers,
    ROUND(COUNT(CASE WHEN c.active = 1 THEN 1 END) / COUNT(*) * 100.0,2) AS active_percentage
FROM customer c
left JOIN address a ON c.address_id = a.address_id
left JOIN city ci ON a.city_id = ci.city_id
left JOIN country co ON ci.country_id = co.country_id
GROUP BY ci.city, co.country
ORDER BY active_customers asc

-- Top Countries by Total Revenue
SELECT 
    co.country,
    ROUND(SUM(p.amount), 2) AS total_revenue
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY co.country
ORDER BY total_revenue DESC


-- Most Recent Active Customers (Loyalty)  
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    MAX(p.payment_date) AS last_payment_date
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY last_payment_date DESC














-- Monthly Revenue Trend
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    ROUND(SUM(amount), 2) AS total_revenue,
    COUNT(payment_id) AS total_transactions,
    ROUND(AVG(amount), 2) AS avg_transaction_value
FROM payment
GROUP BY month
ORDER BY month;

-- Which Store Generates More Revenue
SELECT 
    s.store_id,
    c.city,
    co.country,
    ROUND(SUM(p.amount), 2) AS total_revenue,
    COUNT(p.payment_id) AS total_transactions
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
GROUP BY s.store_id, c.city, co.country
ORDER BY total_revenue DESC;

-- Which Staff Process the Most Payments
SELECT 
    st.staff_id,
    CONCAT(st.first_name, ' ', st.last_name) AS staff_name,
    s.store_id,
    ROUND(SUM(p.amount), 2) AS total_revenue_processed,
    COUNT(p.payment_id) AS total_payments_processed,
    ROUND(AVG(p.amount), 2) AS avg_payment_value
FROM staff st
JOIN payment p ON st.staff_id = p.staff_id
JOIN store s ON st.store_id = s.store_id
GROUP BY st.staff_id, staff_name, s.store_id
ORDER BY total_revenue_processed DESC;

Weekly Revenue Trend (Global Level)
SELECT 
    YEAR(payment_date) AS year,
    WEEK(payment_date) AS week_number,
    CONCAT(YEAR(payment_date), '-W', WEEK(payment_date)) AS week_label,
    ROUND(SUM(amount), 2) AS total_revenue,
    COUNT(payment_id) AS total_transactions,
    ROUND(AVG(amount), 2) AS avg_payment_value
FROM payment
GROUP BY YEAR(payment_date), WEEK(payment_date)
ORDER BY year, week_number;

Weekly Revenue by Store
SELECT 
    s.store_id,
    YEAR(p.payment_date) AS year,
    WEEK(p.payment_date) AS week_number,
    CONCAT(YEAR(p.payment_date), '-W', WEEK(p.payment_date)) AS week_label,
    ROUND(SUM(p.amount), 2) AS total_revenue,
    COUNT(p.payment_id) AS total_transactions
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id, YEAR(p.payment_date), WEEK(p.payment_date)
ORDER BY s.store_id, year, week_number

Transactions per Day (Global View)
SELECT 
    DATE(payment_date) AS transaction_date,
    COUNT(payment_id) AS total_transactions
FROM payment
GROUP BY DATE(payment_date)
ORDER BY transaction_date

-- Peak Rental Times
SELECT 
    HOUR(rental_date) AS rental_hour,
    COUNT(rental_id) AS total_rentals
FROM rental
GROUP BY HOUR(rental_date)
ORDER BY total_rentals DESC

-- Average Rental Duration
SELECT 
    ROUND(AVG(DATEDIFF(return_date, rental_date)), 2) AS avg_rental_duration_days
FROM rental
WHERE return_date IS NOT NULL;


