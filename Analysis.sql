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
FROM
    products p
JOIN
    orderdetails od ON p.productCode = od.productCode
GROUP BY
    p.productCode, p.productName, p.quantityInStock
HAVING
    -- Defines "Low" as stock is less than 20% of total sales
    (p.quantityInStock / SUM(od.quantityOrdered)) < 0.2
ORDER BY
    stockToSalesRatio ASC;
	
--Sub question 3: Which Product Lines generate the most total revenue?
SELECT 
    p.productLine,
    SUM(od.quantityOrdered * od.priceEach) AS totalRevenue
FROM orderDetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.productLine
ORDER BY totalRevenue DESC;
