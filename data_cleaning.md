Handling Missing Values

During data cleaning, NULL values were analyzed and handled based on business logic and data relevance.

1. order_approved_at (Orders Table)
Found NULL values in multiple records.
Analysis showed that some delivered orders had missing approval timestamps, which is logically inconsistent.
Fix Applied:
For delivered orders → replaced NULL with order_purchase_timestamp
Reason: Ensures consistency in order lifecycle.
2. order_delivered_customer_date (Orders Table)
NULL values observed across multiple order statuses.
Verified that NULL is expected for:
canceled, created, processing, shipped, etc.
However, some delivered orders had NULL delivery dates, which is incorrect.
Fix Applied:
For delivered orders → replaced NULL with order_estimated_delivery_date
Reason: Maintains logical consistency for completed orders.
3. product_category_name (Products Table)
Missing values found in product categories.
Fix Applied:
Replaced NULL with 'Unknown'
Reason: Prevents issues during category-based analysis and aggregation.
4. review_comment_message (Reviews Table)
NULL values observed.
No changes made.
Reason: This is an optional field — customers may leave ratings without comments.