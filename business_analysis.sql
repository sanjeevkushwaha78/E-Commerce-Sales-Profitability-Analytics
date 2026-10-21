-- ============================================================
-- E-Commerce Sales & Profitability Analytics
-- File: business_analysis.sql
-- Database: ecommerce_analytics
-- Purpose:
--   1. Validate source data and relationships
--   2. Analyze order outcomes and business KPIs
--   3. Explore revenue, profit, categories, regions, and returns
--
-- Note:
--   Revenue and profit analysis is restricted to Delivered orders.
--   Review table/column names against your actual MySQL schema.
-- ============================================================

USE ecommerce_analytics;


-- ============================================================
-- 01. DATA OVERVIEW AND ROW COUNTS
-- ============================================================

SELECT *
FROM customers;

SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT COUNT(*) AS total_returns
FROM returns;

SELECT 'Customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'OrderDetails', COUNT(*) FROM orderdetails
UNION ALL
SELECT 'Returns', COUNT(*) FROM returns;


-- ============================================================
-- 02. DUPLICATE PRIMARY-KEY CHECKS
-- Expected result: no rows for columns intended to be unique.
-- ============================================================

SELECT customerid, COUNT(*) AS duplicate_count
FROM customers
GROUP BY customerid
HAVING COUNT(*) > 1;

SELECT productid, COUNT(*) AS duplicate_count
FROM products
GROUP BY productid
HAVING COUNT(*) > 1;

SELECT orderid, COUNT(*) AS duplicate_count
FROM orders
GROUP BY orderid
HAVING COUNT(*) > 1;

SELECT orderdetailid, COUNT(*) AS duplicate_count
FROM orderdetails
GROUP BY orderdetailid
HAVING COUNT(*) > 1;

SELECT returnid, COUNT(*) AS duplicate_count
FROM returns
GROUP BY returnid
HAVING COUNT(*) > 1;


-- ============================================================
-- 03. NULL-VALUE CHECKS
-- ============================================================

SELECT
    SUM(customerid IS NULL) AS customerid_nulls,
    SUM(customername IS NULL) AS customername_nulls,
    SUM(gender IS NULL) AS gender_nulls,
    SUM(age IS NULL) AS age_nulls,
    SUM(city IS NULL) AS city_nulls,
    SUM(region IS NULL) AS region_nulls,
    SUM(signupdate IS NULL) AS signupdate_nulls
FROM customers;

SELECT
    SUM(productid IS NULL) AS productid_nulls,
    SUM(productname IS NULL) AS productname_nulls,
    SUM(category IS NULL) AS category_nulls
FROM products;

SELECT
    SUM(orderid IS NULL) AS orderid_nulls,
    SUM(customerid IS NULL) AS customerid_nulls,
    SUM(orderdate IS NULL) AS orderdate_nulls,
    SUM(orderstatus IS NULL) AS orderstatus_nulls
FROM orders;

SELECT
    SUM(orderdetailid IS NULL) AS orderdetailid_nulls,
    SUM(orderid IS NULL) AS orderid_nulls,
    SUM(productid IS NULL) AS productid_nulls,
    SUM(quantity IS NULL) AS quantity_nulls,
    SUM(salesamount IS NULL) AS salesamount_nulls,
    SUM(profit IS NULL) AS profit_nulls
FROM orderdetails;


-- ============================================================
-- 04. REFERENTIAL-INTEGRITY CHECKS
-- Expected result: no rows for valid foreign-key relationships.
-- ============================================================

-- Orders referencing customers that do not exist
SELECT o.orderid, o.customerid
FROM orders AS o
LEFT JOIN customers AS c
    ON o.customerid = c.customerid
WHERE c.customerid IS NULL;

-- Order details referencing orders that do not exist
SELECT od.orderdetailid, od.orderid
FROM orderdetails AS od
LEFT JOIN orders AS o
    ON od.orderid = o.orderid
WHERE o.orderid IS NULL;

-- Order details referencing products that do not exist
SELECT od.orderdetailid, od.productid
FROM orderdetails AS od
LEFT JOIN products AS p
    ON od.productid = p.productid
WHERE p.productid IS NULL;

-- Returns referencing orders that do not exist
SELECT r.returnid, r.orderid
FROM returns AS r
LEFT JOIN orders AS o
    ON r.orderid = o.orderid
WHERE o.orderid IS NULL;


-- ============================================================
-- 05. BASIC BUSINESS DATA VALIDATION
-- ============================================================

SELECT
    MIN(orderdate) AS first_order_date,
    MAX(orderdate) AS last_order_date,
    COUNT(*) AS total_order_records,
    COUNT(DISTINCT customerid) AS unique_customers
FROM orders;

-- Flag invalid quantities or negative sales amounts for review.
-- Negative profit can be legitimate and may indicate a loss-making sale.
SELECT *
FROM orderdetails
WHERE quantity <= 0
   OR salesamount < 0;

-- Review loss-making sales separately; negative profit is not
-- automatically a data-quality error.
SELECT *
FROM orderdetails
WHERE profit < 0;

-- Review order-status distribution
SELECT
    orderstatus,
    COUNT(*) AS total_orders,
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders),
        2
    ) AS percentage_of_orders
FROM orders
GROUP BY orderstatus
ORDER BY total_orders DESC;


-- ============================================================
-- 06. CORE BUSINESS KPIs
-- Revenue and profit are calculated on Delivered orders only.
-- ============================================================

SELECT
    COUNT(DISTINCT o.orderid) AS delivered_orders,
    ROUND(SUM(od.salesamount), 2) AS total_revenue,
    ROUND(SUM(od.profit), 2) AS total_profit,
    ROUND(
        100.0 * SUM(od.profit) / NULLIF(SUM(od.salesamount), 0),
        2
    ) AS profit_margin_pct
FROM orders AS o
INNER JOIN orderdetails AS od
    ON o.orderid = od.orderid
WHERE o.orderstatus = 'Delivered';

-- Total delivered orders
SELECT COUNT(*) AS total_delivered_orders
FROM orders
WHERE orderstatus = 'Delivered';

-- Average order value: aggregate line items to order level first
SELECT
    ROUND(AVG(order_totals.order_revenue), 2) AS average_order_value
FROM (
    SELECT
        o.orderid,
        SUM(od.salesamount) AS order_revenue
    FROM orders AS o
    INNER JOIN orderdetails AS od
        ON o.orderid = od.orderid
    WHERE o.orderstatus = 'Delivered'
    GROUP BY o.orderid
) AS order_totals;


-- ============================================================
-- 07. CATEGORY PERFORMANCE
-- ============================================================

SELECT
    p.category,
    ROUND(SUM(od.salesamount), 2) AS revenue,
    ROUND(SUM(od.profit), 2) AS profit,
    ROUND(
        100.0 * SUM(od.profit) / NULLIF(SUM(od.salesamount), 0),
        2
    ) AS profit_margin_pct
FROM orders AS o
INNER JOIN orderdetails AS od
    ON o.orderid = od.orderid
INNER JOIN products AS p
    ON od.productid = p.productid
WHERE o.orderstatus = 'Delivered'
GROUP BY p.category
ORDER BY revenue DESC;


-- ============================================================
-- 08. MONTHLY REVENUE TREND
-- ============================================================

SELECT
    YEAR(o.orderdate) AS sales_year,
    MONTH(o.orderdate) AS sales_month,
    DATE_FORMAT(o.orderdate, '%Y-%m') AS year_month,
    ROUND(SUM(od.salesamount), 2) AS revenue,
    ROUND(SUM(od.profit), 2) AS profit
FROM orders AS o
INNER JOIN orderdetails AS od
    ON o.orderid = od.orderid
WHERE o.orderstatus = 'Delivered'
GROUP BY
    YEAR(o.orderdate),
    MONTH(o.orderdate),
    DATE_FORMAT(o.orderdate, '%Y-%m')
ORDER BY sales_year, sales_month;


-- ============================================================
-- 09. REGION-WISE PERFORMANCE
-- ============================================================

SELECT
    c.region,
    COUNT(DISTINCT o.orderid) AS delivered_orders,
    ROUND(SUM(od.salesamount), 2) AS revenue,
    ROUND(SUM(od.profit), 2) AS profit,
    ROUND(
        100.0 * SUM(od.profit) / NULLIF(SUM(od.salesamount), 0),
        2
    ) AS profit_margin_pct
FROM customers AS c
INNER JOIN orders AS o
    ON c.customerid = o.customerid
INNER JOIN orderdetails AS od
    ON o.orderid = od.orderid
WHERE o.orderstatus = 'Delivered'
GROUP BY c.region
ORDER BY revenue DESC;


-- ============================================================
-- 10. TOP 10 CUSTOMERS BY REVENUE
-- ============================================================

SELECT
    c.customerid,
    c.customername,
    ROUND(SUM(od.salesamount), 2) AS revenue,
    ROUND(SUM(od.profit), 2) AS profit
FROM customers AS c
INNER JOIN orders AS o
    ON c.customerid = o.customerid
INNER JOIN orderdetails AS od
    ON o.orderid = od.orderid
WHERE o.orderstatus = 'Delivered'
GROUP BY c.customerid, c.customername
ORDER BY revenue DESC
LIMIT 10;


-- ============================================================
-- 11. TOP 10 PRODUCTS BY REVENUE
-- ============================================================

SELECT
    p.productid,
    p.productname,
    p.category,
    SUM(od.quantity) AS units_sold,
    ROUND(SUM(od.salesamount), 2) AS revenue,
    ROUND(SUM(od.profit), 2) AS profit
FROM products AS p
INNER JOIN orderdetails AS od
    ON p.productid = od.productid
INNER JOIN orders AS o
    ON od.orderid = o.orderid
WHERE o.orderstatus = 'Delivered'
GROUP BY p.productid, p.productname, p.category
ORDER BY revenue DESC
LIMIT 10;


-- ============================================================
-- 12. PAYMENT-METHOD ANALYSIS
-- Counts delivered orders by payment method.
-- ============================================================

SELECT
    paymentmethod,
    COUNT(DISTINCT orderid) AS delivered_orders
FROM orders
WHERE orderstatus = 'Delivered'
GROUP BY paymentmethod
ORDER BY delivered_orders DESC;


-- ============================================================
-- 13. RETURN-REASON ANALYSIS
-- ============================================================

SELECT
    returnreason,
    COUNT(*) AS total_returns,
    ROUND(
        100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM returns), 0),
        2
    ) AS percentage_of_return_records
FROM returns
GROUP BY returnreason
ORDER BY total_returns DESC;


-- ============================================================
-- 14. RETURNED-ORDER RATE
-- Denominator includes all orders; numerator counts distinct
-- orders with a return record.
-- ============================================================

SELECT
    COUNT(DISTINCT r.orderid) AS returned_orders,
    COUNT(DISTINCT o.orderid) AS total_orders,
    ROUND(
        100.0 * COUNT(DISTINCT r.orderid)
        / NULLIF(COUNT(DISTINCT o.orderid), 0),
        2
    ) AS returned_order_rate_pct
FROM orders AS o
LEFT JOIN returns AS r
    ON o.orderid = r.orderid;


-- ============================================================
-- 15. CUSTOMER DISTRIBUTION BY REGION
-- ============================================================

SELECT
    region,
    COUNT(*) AS total_customers
FROM customers
GROUP BY region
ORDER BY total_customers DESC;
