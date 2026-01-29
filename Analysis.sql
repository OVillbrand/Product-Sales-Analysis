/* BUSINESS QUESTION 1: Which products are the primary drivers of profit, 
and where is capital being wasted in overstock?
Created by: Ossian Villbrand
Date: 2025-01-15
*/

-- Sub question 1: What is the Profit Margin per product?
SELECT
    p.productName,
    (p.MSRP - p.buyPrice) AS profitMargin,
    ((p.MSRP - p.buyPrice) / p.MSRP * 100) AS marginPercentage
FROM products AS p;

--Sub question 2: Which products have a Low Stock-to-Sales Ratio?
SELECT
    p.productName,
    p.quantityInStock,
    SUM(od.quantityOrdered) AS totalSold,
    (p.quantityInStock * 1.0 / NULLIF(SUM(od.quantityOrdered), 0)) AS stockToSalesRatio
FROM products AS p
JOIN orderdetails AS od 
    ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName, p.quantityInStock
HAVING
    (p.quantityInStock * 1.0 / NULLIF(SUM(od.quantityOrdered), 0)) < 0.2
ORDER BY
    stockToSalesRatio ASC;
	
--Sub question 3: Which Product Lines generate the most total revenue?
SELECT 
    p.productLine,
    SUM(od.quantityOrdered * od.priceEach) AS totalRevenue
FROM orderDetails as od
JOIN products as p 
	ON od.productCode = p.productCode
GROUP BY p.productLine
ORDER BY 
	totalRevenue DESC;

/* BUSINESS QUESTION 2: Are we meeting our delivery promises, 
and where are the geographic bottlenecks?
Created by: Ossian Villbrand
*/

-- Sub question 1: What is the average Fulfillment Delay? (Since we don't have delivery dates we have to restrict ourselves to processing time for orders)
SELECT 
	AVG(julianday(o.shippedDate) - julianday(o.orderDate)) as avgDaysOfProcessing 
FROM orders AS o;

-- Sub question 2: Which countries have the highest rate of Late Shipments?
SELECT 
    c.country, 
    SUM(julianday(o.shippedDate) - julianday(o.requiredDate)) AS total_delay_days,
    COUNT(o.orderNumber) AS number_of_late_orders
FROM orders AS o
JOIN customers AS c 
    ON o.customerNumber = c.customerNumber
WHERE 
	o.shippedDate > o.requiredDate
GROUP BY c.country
ORDER BY 
	total_delay_days DESC;

-- After the initial search only found one delayed shipment I wanted to verify 
SELECT COUNT(*)
FROM orders AS o
JOIN customers AS c
	ON o.customerNumber = c.customerNumber
WHERE 
	julianday(o.shippedDate) > julianday(o.requiredDate);

-- Sub question 3: Which Office is the most efficient?
SELECT 
    ofc.city,
    ROUND(AVG(julianday(o.shippedDate) - julianday(o.orderDate)), 1) AS avg_shipping_time
FROM orders AS o 
JOIN customers AS c 
    ON o.customerNumber = c.customerNumber
JOIN employees AS e 
    ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN offices AS ofc 
    ON ofc.officeCode = e.officeCode
GROUP BY 
    ofc.city
ORDER BY 
    avg_shipping_time ASC;

/* BUSINESS QUESTION 3:  Who are our "VIP" customers, 
and which sales reps are the most effective at managing them?
Created by: Ossian Villbrand
*/

-- Sub question 1: What is the *Customer Lifetime Value (LTV)*?
WITH CustomerPerformance AS (
    SELECT 
        c.customerNumber,
        c.customerName,
        SUM(od.quantityOrdered * od.priceEach) AS totalRevenue,
        COUNT(DISTINCT o.orderNumber) AS totalOrders,
        MIN(o.orderDate) AS firstPurchase,
        MAX(o.orderDate) AS latestPurchase
    FROM customers AS c
    JOIN orders AS o 
		ON c.customerNumber = o.customerNumber
    JOIN orderdetails AS od 
		ON o.orderNumber = od.orderNumber
    GROUP BY 
		c.customerNumber
)
SELECT 
    customerName,
    totalRevenue,
    totalOrders,
    -- Calculating Customer Lifespan in days
    ROUND(julianday(latestPurchase) - julianday(firstPurchase), 0) AS lifespanDays,
    -- Calculating Average Order Value (AOV)
    ROUND(totalRevenue / totalOrders, 2) AS avgOrderValue,
    -- Labeling customers based on value to company 
    CASE 
        WHEN totalRevenue > 100000 THEN 'Tier 1'
        WHEN totalRevenue > 50000 THEN 'Tier 2'
        ELSE 'Tier 3'
    END AS CustomerValue
FROM CustomerPerformance
ORDER BY 
	totalRevenue DESC;

-- Sub question 2: Who are our *At-Risk Customers*?	
WITH customerRetention AS (
    SELECT 
        c.customerNumber,
        c.customerName,
        -- Linking the Sales Rep name here
        e.firstName || ' ' || e.lastName AS salesRep,
        MAX(julianday(o.orderDate)) AS lastOrderDate,
        SUM(od.quantityOrdered * od.priceEach) AS totalRevenue 
    FROM customers AS c
    JOIN orders AS o 
		ON o.customerNumber = c.customerNumber
    JOIN orderdetails AS od 
		ON o.orderNumber = od.orderNumber
    -- Joining employees to see who owns the account
    JOIN employees AS e 
		ON c.salesRepEmployeeNumber = e.employeeNumber
    GROUP BY 
		c.customerNumber
)
SELECT 
    customerName,
    salesRep,
	--Using a hard date instead of 'now' given the age of the data set to prove code efficacy 
    ROUND(julianday('2005-06-01') - lastOrderDate, 0) AS daysSinceLastOrder,
    totalRevenue
FROM customerRetention
WHERE 
	daysSinceLastOrder > 90 
ORDER BY 
	totalRevenue DESC;	
	
-- Sub question 3: What is the *Sales Rep ROI*?
 WITH RepPerformance AS (
    SELECT 
        e.firstName || ' ' || e.lastName AS salesRep,
        COUNT(DISTINCT c.customerNumber) AS totalAccounts,
        COUNT(DISTINCT o.orderNumber) AS totalOrders,
        SUM(od.quantityOrdered * od.priceEach) AS totalRevenue
    FROM employees e
    JOIN customers c 
	 	ON e.employeeNumber = c.salesRepEmployeeNumber
    JOIN orders o 
	 	ON c.customerNumber = o.customerNumber
    JOIN orderdetails od 
	 	ON o.orderNumber = od.orderNumber
    GROUP BY 
		e.employeeNumber
)
SELECT 
    salesRep,
    totalAccounts,
    totalRevenue,
    -- Efficiency Metric: Revenue per Account
    ROUND(totalRevenue / totalAccounts, 2) AS revenuePerAccount,
    -- Efficiency Metric: Average Order Value
    ROUND(totalRevenue / totalOrders, 2) AS avgOrderValue
FROM RepPerformance
ORDER BY 
	 totalRevenue DESC;

