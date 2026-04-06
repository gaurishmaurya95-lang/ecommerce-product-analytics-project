-- Duplicate check

SELECT order_id, COUNT(*)
FROM olist_orders_dataset
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT order_id, order_item_id, COUNT(*)
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


SELECT seller_id, COUNT(*)
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;


SELECT order_id, COUNT(*)
FROM order_payments
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT review_id, COUNT(*)
FROM olist_order_reviews_dataset
GROUP BY review_id
HAVING COUNT(*) > 1;

-- Duplicate Checks:

- orders: No duplicates found in order_id
- order_items: Multiple rows per order_id observed (expected behavior)
- customers: No duplicate customer_id found
- payments: Multiple entries per order_id (valid due to installments)


-- NULL Value Checks

-- Customers
SELECT COUNT(*) FROM olist_customers_dataset WHERE customer_id IS NULL;

-- Orders
SELECT COUNT(*) FROM olist_orders_dataset WHERE order_id IS NULL;
SELECT COUNT(*) FROM olist_orders_dataset WHERE order_approved_at IS NULL;

-- Products
SELECT COUNT(*) FROM olist_products_dataset WHERE product_category_name IS NULL;

-- Reviews
SELECT COUNT(*) FROM olist_order_reviews_dataset WHERE review_comment_message IS NULL;
