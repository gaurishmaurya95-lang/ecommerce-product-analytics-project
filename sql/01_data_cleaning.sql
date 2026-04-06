-- =========================
-- DATA VALIDATION CHECKS
-- =========================

-- Check total records
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_products FROM products;

-- =========================
-- NULL VALUE CHECKS
-- =========================

SELECT *
FROM orders
WHERE order_delivered_customer_date IS NULL;

SELECT *
FROM reviews
WHERE review_score IS NULL;

-- =========================
-- DUPLICATE CHECKS
-- =========================

SELECT customer_id,
       COUNT(*) AS duplicates
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- =========================
-- STANDARDIZE CITY NAMES
-- =========================

UPDATE geolocation
SET geolocation_city = LOWER(geolocation_city);
