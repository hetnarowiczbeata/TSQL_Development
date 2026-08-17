-- View created to simplify further sales analysis and aggregations
-- It combines order, product, quantity, price, and revenue data
-- into a single reusable dataset
SELECT *
FROM vw_SalesOrderProductDetails

--3.1 
SELECT ProductID,SUM(OrderQty) AS Quantity
FROM vw_SalesOrderProductDetails
GROUP BY ProductID

--3.2 
SELECT ProductID,ROUND(SUM(LineTotal),0) AS Revenue
FROM vw_SalesOrderProductDetails
GROUP BY ProductID

--3.3 
SELECT ProductID, COUNT(DISTINCT SalesOrderID) AS Number_of_orders
FROM vw_SalesOrderProductDetails
GROUP BY ProductID

--3.4 
SELECT TOP 10 
ProductID,SUM(OrderQty) AS Total_Quantity
FROM vw_SalesOrderProductDetails
GROUP BY ProductID
ORDER BY Total_Quantity DESC

--3.5 
SELECT TOP 10
ProductID,ROUND(SUM(LineTotal), 0) AS Revenue
FROM vw_SalesOrderProductDetails
GROUP BY ProductID
ORDER BY Revenue DESC

--3.6 
SELECT ProductID, ROUND(AVG(UnitPrice),2) AS AVG_Price
FROM vw_SalesOrderProductDetails
GROUP BY ProductID

--3.7 
SELECT AVG(CAST(OrderQty AS DECIMAL(10,2))) AS AVG_Quantity
FROM vw_SalesOrderProductDetails
