
--8.1** Create a CTE that aggregates total revenue and quantity sold for each product, then query the CTE to return products with revenue above a specified value.

WITH ProductsRevQty AS (
SELECT 
ProductID,SUM(LineTotal) AS revenue,
SUM(OrderQty) AS quantitysold
FROM Sales.SalesOrderDetail
GROUP BY ProductID)
SELECT *
FROM ProductsRevQty
WHERE revenue>1000

--8.2** Create a CTE with total revenue by product and use its result to find products with revenue above the average product revenue.


WITH ProductsRev AS (
SELECT 
ProductID,SUM(LineTotal) AS revenue
FROM Sales.SalesOrderDetail 
GROUP BY ProductID),

Avgproducts AS(
SELECT 
AVG(revenue) as Avgproductrevenue
FROM ProductsRev)

SELECT r.ProductID,r.revenue
FROM ProductsRev r, Avgproducts p
WHERE r.revenue>p.Avgproductrevenue


--8.3** 

WITH Monthlysales AS(
SELECT 
MONTH(soh.OrderDate) mies,
YEAR(soh.OrderDate) rok,
SUM(sod.LineTotal) revenue
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY 
MONTH(soh.OrderDate),
YEAR(soh.OrderDate)),

Avgmonthlysales AS(
SELECT AVG(revenue) AS srednia FROM Monthlysales)

SELECT mies,rok,revenue
FROM Monthlysales,Avgmonthlysales
WHERE revenue>srednia



--8.4

WITH Monthlysales AS(
SELECT 
MONTH(soh.OrderDate) mies,
YEAR(soh.OrderDate) rok,
sod.ProductID,
SUM(sod.LineTotal) revenue
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY 
MONTH(soh.OrderDate),
YEAR(soh.OrderDate), sod.ProductID)

SELECT
mies,rok,ProductID,revenue,LAG(revenue) OVER(PARTITION BY ProductID ORDER BY rok,mies) as pvs
FROM Monthlysales

--8.5

--In my opinion, DENSE_RANK() is a better choice because it shows the relative position of products in a continuous ranking, without gaps in the numbering.


WITH Productsales AS(
SELECT 
YEAR(soh.OrderDate) rok,
sod.ProductID,
SUM(sod.LineTotal) revenue
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY
YEAR(soh.OrderDate), sod.ProductID)

SELECT *,DENSE_RANK() OVER( PARTITION BY rok ORDER BY revenue DESC) as prodran
FROM Productsales

--8.6 is in procedures
