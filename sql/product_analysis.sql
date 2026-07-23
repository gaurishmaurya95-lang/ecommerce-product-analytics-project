-- =====================================================
-- Product Performance Analysis
-- Project: E-commerce Product & Customer Analytics Project
-- Purpose: Analyze product and category performance
-- =====================================================


-- =====================================================
-- Query 1: Top Categories by Revenue
-- Objective:
-- Identify the highest revenue-generating product categories.
-- =====================================================

SELECT
    p.product_category_name,
    ROUND(SUM(pay.payment_value), 2) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN order_payments pay
    ON oi.order_id = pay.order_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10



-- =====================================================
-- Query 2: Top Products by Number of Orders
-- Objective:
-- Identify products purchased most frequently.
-- =====================================================

SELECT
    product_id,
    COUNT(*) AS total_orders
FROM order_items
GROUP BY product_id
ORDER BY total_orders DESC
LIMIT 10;



-- =====================================================
-- Query 3: Top Products by Revenue
-- Objective:
-- Identify products contributing the highest revenue.
-- =====================================================

SELECT
    oi.product_id,
    ROUND(SUM(pay.payment_value), 2) AS revenue
FROM order_items oi
JOIN order_payments pay
    ON oi.order_id = pay.order_id
GROUP BY oi.product_id
ORDER BY revenue DESC
LIMIT 10;



-- =====================================================
-- Query 4: Category Revenue Contribution Percentage
-- Objective:
-- Determine how much each category contributes to total revenue.
-- =====================================================

SELECT
    p.product_category_name,
    ROUND(
        SUM(pay.payment_value) * 100.0 /
        (SELECT SUM(payment_value)
         FROM order_payments),
    2) AS revenue_percentage
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN order_payments pay
    ON oi.order_id = pay.order_id
GROUP BY p.product_category_name
ORDER BY revenue_percentage DESC;



-- =====================================================
-- Query 5: Monthly Category Revenue
-- Objective:
-- Analyze category revenue trends over time.
-- =====================================================

SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) AS month,
    p.product_category_name,
    ROUND(SUM(pay.payment_value), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN order_payments pay
    ON o.order_id = pay.order_id
GROUP BY month, p.product_category_name
ORDER BY month;