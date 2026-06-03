-- ============================================
-- BUSINESS ANALYSIS QUERIES
-- Project: E-commerce Analysis (Olist Dataset)
-- Author: Gaurish Maurya
-- ============================================
-- ============================================
-- 1. TOTAL REVENUE
-- ============================================

SELECT ROUND(SUM(payment_value), 2) AS total_revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p 
ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable');

-- ============================================
-- 2. REVENUE BY MONTH
-- ============================================

SELECT 
    STRFTIME('%Y', order_purchase_timestamp) AS year,
    STRFTIME('%m', order_purchase_timestamp) AS month,
    ROUND(SUM(payment_value), 2) AS revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p 
ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY year, month
ORDER BY year, month;

-- ============================================
-- 3. TOTAL ORDERS
-- ============================================

SELECT COUNT(*) AS total_orders
FROM olist_orders_dataset
WHERE order_status NOT IN ('canceled', 'unavailable');

-- ============================================
-- 4. ORDERS BY MONTH
-- ============================================

SELECT 
    STRFTIME('%Y', order_purchase_timestamp) AS year,
    STRFTIME('%m', order_purchase_timestamp) AS month,
    COUNT(*) AS orders
FROM olist_orders_dataset
WHERE order_status NOT IN ('canceled', 'unavailable')
GROUP BY year, month
ORDER BY year, month;

-- ============================================
-- 5. TOP PRODUCT CATEGORIES BY REVENUE
-- ============================================

SELECT 
    p.product_category_name,
    ROUND(SUM(op.payment_value), 2) AS total_revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset op 
    ON o.order_id = op.order_id
JOIN olist_order_items_dataset oi 
    ON o.order_id = oi.order_id
JOIN olist_products_dataset p 
    ON oi.product_id = p.product_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- ============================================
-- 6. AVERAGE ORDER VALUE (AOV)
-- ============================================

SELECT 
    ROUND(AVG(payment_value), 2) AS avg_order_value
FROM olist_order_payments_dataset op
JOIN olist_orders_dataset o 
    ON op.order_id = o.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable');

-- ============================================
-- 7. AOV BY PAYMENT TYPE
-- ============================================

SELECT 
    payment_type,
    ROUND(AVG(payment_value), 2) AS avg_order_value
FROM olist_order_payments_dataset op
JOIN olist_orders_dataset o 
    ON op.order_id = o.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY payment_type
ORDER BY avg_order_value DESC;

-- ============================================
-- 8. MOST USED PAYMENT METHODS
-- ============================================

SELECT 
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_orders DESC;

-- ============================================
-- 9. REPEAT CUSTOMERS
-- ============================================

SELECT 
    COUNT(*) AS repeat_customers
FROM (
    SELECT 
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c 
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1
);

-- ============================================
-- 10. TOTAL CUSTOMERS
-- ============================================

SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM olist_customers_dataset;

-- ============================================
-- 11. REPEAT CUSTOMER PERCENTAGE
-- ============================================

WITH repeat AS (
    SELECT c.customer_unique_id
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c 
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1
)

SELECT 
    ROUND(
        (COUNT(DISTINCT repeat.customer_unique_id) * 100.0) /
        COUNT(DISTINCT c.customer_unique_id),
    2) AS repeat_customer_percentage
FROM olist_customers_dataset c
LEFT JOIN repeat 
ON c.customer_unique_id = repeat.customer_unique_id;

-- ============================================
-- 12. TOP SPENDING CUSTOMERS
-- ============================================

SELECT 
    c.customer_unique_id,
    ROUND(SUM(op.payment_value), 2) AS total_spent
FROM olist_orders_dataset o
JOIN olist_customers_dataset c 
    ON o.customer_id = c.customer_id
JOIN olist_order_payments_dataset op 
    ON o.order_id = op.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;

-- ============================================
-- 13. CUSTOMER SEGMENTATION
-- ============================================

SELECT 
    CASE 
        WHEN total_spent >= 1000 THEN 'High Value'
        WHEN total_spent >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(*) AS num_customers
FROM (
    SELECT 
        c.customer_unique_id,
        SUM(op.payment_value) AS total_spent
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c 
        ON o.customer_id = c.customer_id
    JOIN olist_order_payments_dataset op 
        ON o.order_id = op.order_id
    GROUP BY c.customer_unique_id
)
GROUP BY customer_segment
ORDER BY num_customers DESC;

-- ============================================
-- 14. TOTAL ACTIVE SELLERS
-- ============================================

SELECT COUNT(DISTINCT seller_id) AS total_sellers
FROM olist_order_items_dataset;

-- ============================================
-- 15. ACTIVE SELLERS BY YEAR
-- ============================================

SELECT 
    STRFTIME('%Y', o.order_purchase_timestamp) AS year,
    COUNT(DISTINCT oi.seller_id) AS active_sellers
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi 
    ON o.order_id = oi.order_id
GROUP BY year
ORDER BY year;

-- ============================================
-- 16. TOP SELLERS BY REVENUE
-- ============================================

SELECT 
    oi.seller_id,
    ROUND(SUM(op.payment_value), 2) AS total_revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi 
    ON o.order_id = oi.order_id
JOIN olist_order_payments_dataset op 
    ON o.order_id = op.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY oi.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

-- ============================================
-- 17. SELLER PERFORMANCE (REVENUE + RATING)
-- ============================================

SELECT 
    oi.seller_id,
    ROUND(SUM(op.payment_value), 2) AS total_revenue,
    AVG(r.review_score) AS avg_rating
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi 
    ON o.order_id = oi.order_id
JOIN olist_order_payments_dataset op 
    ON o.order_id = op.order_id
JOIN olist_order_reviews_dataset r 
    ON o.order_id = r.order_id
GROUP BY oi.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

-- ============================================
-- 18. REVENUE BY REVIEW SCORE
-- ============================================

SELECT 
    r.review_score,
    COUNT(DISTINCT r.order_id) AS total_orders,
    ROUND(SUM(op.payment_value), 2) AS total_revenue,
    ROUND(AVG(op.payment_value), 2) AS avg_order_value
FROM olist_order_reviews_dataset r
JOIN olist_order_payments_dataset op 
    ON r.order_id = op.order_id
GROUP BY r.review_score
ORDER BY r.review_score DESC;

-- ============================================
-- 19. CANCELLATION RATE
-- ============================================

SELECT 
    ROUND(
        SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 
    2) AS cancellation_rate
FROM olist_orders_dataset;