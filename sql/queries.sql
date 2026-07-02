-- ============================================================
-- 🛒 Olist E-Commerce — Business SQL Queries
-- Tool: SQLite (or any SQL engine)
-- Author: Your Name
-- ============================================================

-- SETUP: Load CSVs into SQLite tables first using Python:
-- import sqlite3, pandas as pd
-- conn = sqlite3.connect('olist.db')
-- for name, file in tables.items():
--     pd.read_csv(f'data/{file}').to_sql(name, conn, if_exists='replace', index=False)


-- ============================================================
-- 1. TOTAL REVENUE, ORDERS & AVG ORDER VALUE
-- ============================================================
SELECT
    COUNT(DISTINCT o.order_id)                   AS total_orders,
    ROUND(SUM(p.payment_value), 2)               AS total_revenue,
    ROUND(AVG(p.payment_value), 2)               AS avg_order_value,
    COUNT(DISTINCT o.customer_id)                AS unique_customers
FROM orders o
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered';


-- ============================================================
-- 2. MONTHLY REVENUE TREND
-- ============================================================
SELECT
    STRFTIME('%Y-%m', order_purchase_timestamp)  AS year_month,
    COUNT(DISTINCT o.order_id)                   AS total_orders,
    ROUND(SUM(p.payment_value), 2)               AS monthly_revenue
FROM orders o
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY year_month
ORDER BY year_month;


-- ============================================================
-- 3. TOP 10 PRODUCT CATEGORIES BY REVENUE
-- ============================================================
SELECT
    t.product_category_name_english              AS category,
    COUNT(oi.order_id)                           AS units_sold,
    ROUND(SUM(oi.price), 2)                      AS total_revenue,
    ROUND(AVG(oi.price), 2)                      AS avg_price
FROM order_items oi
JOIN products pr ON oi.product_id = pr.product_id
JOIN category_translation t ON pr.product_category_name = t.product_category_name
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 4. CUSTOMER ORDER FREQUENCY DISTRIBUTION
-- ============================================================
SELECT
    order_count,
    COUNT(*) AS num_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_customers
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) t
GROUP BY order_count
ORDER BY order_count;


-- ============================================================
-- 5. TOP 10 STATES BY REVENUE
-- ============================================================
SELECT
    c.customer_state                             AS state,
    COUNT(DISTINCT o.order_id)                   AS total_orders,
    ROUND(SUM(p.payment_value), 2)               AS total_revenue,
    ROUND(AVG(p.payment_value), 2)               AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY state
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 6. AVERAGE DELIVERY TIME BY STATE
-- ============================================================
SELECT
    c.customer_state                             AS state,
    COUNT(DISTINCT o.order_id)                   AS total_orders,
    ROUND(AVG(
        JULIANDAY(o.order_delivered_customer_date) -
        JULIANDAY(o.order_purchase_timestamp)
    ), 1)                                        AS avg_delivery_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY state
HAVING total_orders > 100
ORDER BY avg_delivery_days DESC
LIMIT 15;


-- ============================================================
-- 7. REVIEW SCORE DISTRIBUTION
-- ============================================================
SELECT
    review_score,
    COUNT(*)                                     AS num_reviews,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM reviews
GROUP BY review_score
ORDER BY review_score;


-- ============================================================
-- 8. REVIEW SCORE VS DELIVERY TIME
-- ============================================================
SELECT
    r.review_score,
    COUNT(*)                                     AS orders,
    ROUND(AVG(
        JULIANDAY(o.order_delivered_customer_date) -
        JULIANDAY(o.order_purchase_timestamp)
    ), 1)                                        AS avg_delivery_days,
    ROUND(AVG(
        JULIANDAY(o.order_estimated_delivery_date) -
        JULIANDAY(o.order_delivered_customer_date)
    ), 1)                                        AS avg_days_before_estimate
FROM orders o
JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;


-- ============================================================
-- 9. PAYMENT METHOD BREAKDOWN
-- ============================================================
SELECT
    payment_type,
    COUNT(DISTINCT order_id)                     AS total_orders,
    ROUND(SUM(payment_value), 2)                 AS total_value,
    ROUND(AVG(payment_installments), 1)          AS avg_installments
FROM payments
GROUP BY payment_type
ORDER BY total_value DESC;


-- ============================================================
-- 10. TOP 10 SELLERS BY REVENUE
-- ============================================================
SELECT
    oi.seller_id,
    s.seller_state,
    COUNT(DISTINCT oi.order_id)                  AS total_orders,
    ROUND(SUM(oi.price), 2)                      AS total_revenue,
    ROUND(AVG(r.review_score), 2)                AS avg_review_score
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN reviews r ON oi.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id, s.seller_state
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 11. LATE DELIVERY RATE BY CATEGORY
-- ============================================================
SELECT
    t.product_category_name_english              AS category,
    COUNT(*)                                     AS total_orders,
    SUM(CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1
        ELSE 0
    END)                                         AS late_deliveries,
    ROUND(SUM(CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*), 2)                 AS late_rate_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products pr ON oi.product_id = pr.product_id
JOIN category_translation t ON pr.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY category
HAVING total_orders > 200
ORDER BY late_rate_pct DESC
LIMIT 10;


-- ============================================================
-- 12. YEAR-OVER-YEAR REVENUE GROWTH
-- ============================================================
SELECT
    STRFTIME('%Y', o.order_purchase_timestamp)   AS year,
    COUNT(DISTINCT o.order_id)                   AS total_orders,
    ROUND(SUM(p.payment_value), 2)               AS total_revenue
FROM orders o
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY year
ORDER BY year;


-- ============================================================
-- 13. FREIGHT COST ANALYSIS BY CATEGORY
-- ============================================================
SELECT
    t.product_category_name_english              AS category,
    ROUND(AVG(oi.price), 2)                      AS avg_product_price,
    ROUND(AVG(oi.freight_value), 2)              AS avg_freight,
    ROUND(AVG(oi.freight_value) / AVG(oi.price) * 100, 1) AS freight_pct_of_price
FROM order_items oi
JOIN products pr ON oi.product_id = pr.product_id
JOIN category_translation t ON pr.product_category_name = t.product_category_name
GROUP BY category
HAVING COUNT(*) > 200
ORDER BY freight_pct_of_price DESC
LIMIT 10;


-- ============================================================
-- 14. REPEAT CUSTOMER REVENUE CONTRIBUTION
-- ============================================================
SELECT
    CASE WHEN order_count = 1 THEN 'One-time' ELSE 'Repeat' END AS customer_type,
    COUNT(*)                                     AS num_customers,
    ROUND(SUM(total_spent), 2)                   AS total_revenue,
    ROUND(AVG(total_spent), 2)                   AS avg_spent_per_customer
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id)               AS order_count,
        SUM(p.payment_value)                     AS total_spent
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) t
GROUP BY customer_type;


-- ============================================================
-- 15. HOURLY ORDER PATTERN (PEAK HOURS)
-- ============================================================
SELECT
    STRFTIME('%H', order_purchase_timestamp)     AS hour_of_day,
    COUNT(*)                                     AS total_orders
FROM orders
GROUP BY hour_of_day
ORDER BY hour_of_day;
