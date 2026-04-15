-- =========================
-- DATA VALIDATION CHECKS
-- =========================

-- Check total records
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_products FROM products;

-- ============================================
-- IMPORTANT NULL VALUE CHECKS
-- ============================================

-- 1. ORDERS → approval missing (very important)
SELECT *
FROM olist_orders_dataset
WHERE order_approved_at IS NULL;


-- 2. ORDERS → delivery missing
SELECT *
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NULL;


-- 3. PRODUCTS → missing category (critical for analysis)
SELECT *
FROM olist_products_dataset
WHERE product_category_name IS NULL;


-- 4. REVIEWS → missing comments (common but useful)
SELECT *
FROM olist_order_reviews_dataset
WHERE review_comment_message IS NULL;


-- 5. ORDER ITEMS → price missing (critical error if exists)
SELECT *
FROM olist_order_items_dataset
WHERE price IS NULL;


-- 6. PAYMENTS → payment value missing (very critical)
SELECT *
FROM olist_order_payments_dataset
WHERE payment_value IS NULL;

-- ============================================
-- DUPLICATE CHECK FOR ALL TABLES
-- ============================================

-- 1. CUSTOMERS (Primary Key: customer_id)
SELECT customer_id, COUNT(*) 
FROM olist_customers_dataset
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 2. ORDERS (Primary Key: order_id)
SELECT order_id, COUNT(*) 
FROM olist_orders_dataset
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 3. ORDER ITEMS (Composite Key: order_id + order_item_id)
SELECT order_id, order_item_id, COUNT(*) 
FROM olist_order_items_dataset
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;


-- 4. PAYMENTS (Composite Key: order_id + payment_sequential)
SELECT order_id, payment_sequential, COUNT(*) 
FROM olist_order_payments_dataset
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;


-- 5. REVIEWS (Primary Key: review_id)
SELECT review_id, COUNT(*) 
FROM olist_order_reviews_dataset
GROUP BY review_id
HAVING COUNT(*) > 1;


-- 6. PRODUCTS (Primary Key: product_id)
SELECT product_id, COUNT(*) 
FROM olist_products_dataset
GROUP BY product_id
HAVING COUNT(*) > 1;


-- 7. SELLERS (Primary Key: seller_id)
SELECT seller_id, COUNT(*) 
FROM olist_sellers_dataset
GROUP BY seller_id
HAVING COUNT(*) > 1;


-- 8. GEOLOCATION (No strict PK → check full row duplicates)
SELECT 
geolocation_zip_code_prefix,
geolocation_lat,
geolocation_lng,
geolocation_city,
geolocation_state,
COUNT(*) 
FROM olist_geolocation_dataset
GROUP BY 
geolocation_zip_code_prefix,
geolocation_lat,
geolocation_lng,
geolocation_city,
geolocation_state
HAVING COUNT(*) > 1;

-- =========================
-- STANDARDIZE CITY NAMES
-- =========================

-- Customers
UPDATE olist_customers_dataset
SET customer_city = UPPER(SUBSTR(customer_city, 1, 1)) || LOWER(SUBSTR(customer_city, 2));

-- Sellers
UPDATE olist_sellers_dataset
SET seller_city = UPPER(SUBSTR(seller_city, 1, 1)) || LOWER(SUBSTR(seller_city, 2));

-- Geolocation
UPDATE olist_geolocation_dataset
SET geolocation_city = UPPER(SUBSTR(geolocation_city, 1, 1)) || LOWER(SUBSTR(geolocation_city, 2));

-- Customers
UPDATE olist_customers_dataset
SET customer_city = UPPER(SUBSTR(customer_city, 1, 1)) || LOWER(SUBSTR(customer_city, 2));

-- Sellers
UPDATE olist_sellers_dataset
SET seller_city = UPPER(SUBSTR(seller_city, 1, 1)) || LOWER(SUBSTR(seller_city, 2));

-- Geolocation
UPDATE olist_geolocation_dataset
SET geolocation_city = UPPER(SUBSTR(geolocation_city, 1, 1)) || LOWER(SUBSTR(geolocation_city, 2));