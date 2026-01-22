/* BUSINESS QUESTION 1: Which products are the primary drivers of profit, 
and where is capital being wasted in overstock?
Created by: Ossian Villbrand
Date: 2025-01-15
*/

-- Sub question 1: What is the Profit Margin per product?
SELECT
    products.productName,
    (products.MSRP - products.buyPrice) AS profitMargin,
    ((products.MSRP - products.buyPrice) / products.MSRP * 100) AS marginPercentage
FROM products;

--Sub question 2: Which products have a Low Stock-to-Sales Ratio?
SELECT
    p.productName,
    p.quantityInStock,
    SUM(od.quantityOrdered) AS totalSold,
    -- Calculating the ratio: Stock divided by Sales
    (p.quantityInStock * 1.0 / SUM(od.quantityOrdered)) AS stockToSalesRatio
FROM products as p
JOIN orderdetails as od 
	ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName, p.quantityInStock
HAVING
    -- Defines "Low" as stock is less than 20% of total sales
    (p.quantityInStock / SUM(od.quantityOrdered)) < 0.2
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
SELECT julianday(orders.shippedDate) - julianday(orders.orderDate) as daysOfProcessing 
FROM orders 

-- Sub question 2: Which countries have the highest rate of Late Shipments?
SELECT 
    cust.country, 
    SUM(julianday(ord.shippedDate) - julianday(ord.requiredDate)) AS total_delay_days,
    COUNT(ord.orderNumber) AS number_of_late_orders
FROM orders AS ord 
JOIN customers AS cust 
    ON ord.customerNumber = cust.customerNumber
WHERE 
	ord.shippedDate > ord.requiredDate
GROUP BY cust.country
ORDER BY 
	total_delay_days DESC;

-- After the initial search only found one delayed shipment I wanted to verify 
SELECT COUNT(*)
FROM orders 
JOIN customers 
	ON orders.customerNumber = customers.customerNumber
WHERE 
	julianday(orders.shippedDate) > julianday(orders.requiredDate);

-- Sub question 3: Which Office is the most efficient?
SELECT ofc.city,
	ROUND(AVG(julianday(ord.shippedDate) - julianday(ord.orderDate)), 1) AS avg_shipping_time
FROM orders as ord 
JOIN customers as cust 
	on ord.customerNumber = cust.customerNumber
JOIN employees as emp 
	on emp.employeeNumber = cust.salesRepEmployeeNumber
JOIN offices as ofc 
	on ofc.officeCode = emp.officeCode
GROUP BY ofc.city;
