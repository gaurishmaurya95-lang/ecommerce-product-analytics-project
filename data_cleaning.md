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

5. City Standardization (Multiple Tables)

City names were inconsistent in terms of capitalization and formatting.

Fix Applied:

Converted city names into proper case
(e.g., sao paulo → Sao paulo)
Removed leading and trailing spaces using TRIM()

Tables Updated:

customers
sellers
geolocation

Reason:
Ensures consistency in grouping and aggregation during analysis.

6. Removal of Numeric Values (Geolocation Table)

Some city names contained numeric characters (e.g., abc123).

Fix Applied:

Removed all numeric characters from city names

Reason:
City names should not contain numbers; this improves data quality and accuracy.

7. Removal of Special Characters (Geolocation Table)

Special characters such as ', *, and ... were found in city names.

Fix Applied:

Removed unwanted symbols and leading characters
Cleaned malformed city names

Reason:
Improves readability and prevents incorrect grouping in analysis.

8. Handling Encoding Issues (Geolocation Table)

Some city names contained encoded strings like %26apos%3B and %26.

Fix Applied:

Replaced encoded values with correct characters (e.g., ' and &)

Reason:
Ensures proper text representation and avoids confusion in reporting.

9. State Standardization (Multiple Tables)

State names were stored as abbreviations (e.g., SP, RJ).

Fix Applied:

Converted abbreviations into full state names
(e.g., SP → Sao Paulo)

Tables Updated:

customers
sellers
geolocation

Reason:
Improves readability and makes the dataset more suitable for business reporting and visualization.