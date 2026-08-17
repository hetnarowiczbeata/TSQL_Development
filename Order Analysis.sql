--4.1
SELECT COUNT(DISTINCT ProductID) AS Unique_products,SalesOrderID
FROM vw_SalesOrderProductDetails
GROUP BY SalesOrderID
--4.2
SELECT SUM(OrderQty) AS Total_Qty,SalesOrderID
FROM vw_SalesOrderProductDetails
GROUP BY SalesOrderID
--4.3
SELECT SUM(LineTotal) AS Total_Value,SalesOrderID
FROM vw_SalesOrderProductDetails
GROUP BY SalesOrderID

--4.4
SELECT TOP 1 SalesOrderID, SUM(LineTotal) AS Total
FROM vw_SalesOrderProductDetails
GROUP BY SalesOrderID
ORDER BY Total DESC

--4.5
SELECT  SalesOrderID, SUM(LineTotal) AS Total
FROM vw_SalesOrderProductDetails
GROUP BY SalesOrderID
HAVING SUM(LineTotal)>5000

--4.6
SELECT AVG(p.Total_value) AS AVG_Order_Value
FROM
(SELECT SalesOrderID,SUM(LineTotal) AS Total_value
from vw_SalesOrderProductDetails
GROUP BY SalesOrderID) p