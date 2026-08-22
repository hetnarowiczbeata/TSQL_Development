
--9.1** Use a subquery to find products with sales revenue above the average product revenue.

SELECT
sod.ProductID,
sod.revenue
FROM 
(
SELECT ProductID,
SUM(LineTotal) revenue
FROM
Sales.SalesOrderDetail
GROUP BY ProductID) sod
WHERE sod.revenue>
(SELECT AVG(p.revenue) 
FROM 
(SELECT ProductID,
SUM(LineTotal) revenue
FROM
Sales.SalesOrderDetail
GROUP BY ProductID) p)

--9.2** Use a correlated subquery to calculate total revenue for each product.

SELECT 
DISTINCT sod.ProductID,
(SELECT SUM(LineTotal) revenue FROM Sales.SalesOrderDetail sod1 WHERE sod.ProductID=sod1.ProductID)
FROM Sales.SalesOrderDetail sod 

--9.3** Find orders whose total value is greater than the average order value.


SELECT 
soh.SalesOrderID
,SUM(sod.LineTotal) revenue
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY soh.SalesOrderID
HAVING SUM(sod.LineTotal)>(
SELECT AVG(g.revenue) FROM(

select soh.SalesOrderID
,SUM(sod.LineTotal) revenue
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY soh.SalesOrderID) g)

--9.4** Use `EXISTS` to find products that have appeared in at least one sales order.

SELECT p.ProductID
FROM Production.Product p
WHERE EXISTS (
SELECT 1 
FROM Sales.SalesOrderDetail sod 
WHERE p.ProductID=sod.ProductID)
--9.5** Use `NOT EXISTS` to find products that have never been sold.

SELECT p.ProductID
FROM Production.Product p
WHERE NOT EXISTS (
SELECT 1 
FROM Sales.SalesOrderDetail sod 
WHERE p.ProductID=sod.ProductID)

--9.6** Use `NOT EXISTS` to find sales orders that do not contain a selected product.

SELECT soh.SalesOrderID
FROM Sales.SalesOrderHeader soh
WHERE NOT EXISTS (
SELECT 1
FROM Sales.SalesOrderDetail sod	WHERE soh.SalesOrderID=sod.SalesOrderID AND sod.ProductID=707)

--9.7** Use `NOT EXISTS` to identify products that were sold in one month but not in the following month.
WITH ProductMonths AS(
SELECT DISTINCT 
sod.ProductID,
YEAR(soh.OrderDate) ROK,
MONTH(soh.OrderDate) MIESIAC
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID)


SELECT 
pm.ProductID,
pm.MIESIAC,
pm.ROK
FROM ProductMonths pm
WHERE NOT EXISTS( SELECT 1 FROM ProductMonths nextm
WHERE nextm.ProductID=pm.ProductID
AND DATEFROMPARTS(nextm.ROK,nextm.MIESIAC,1)=DATEADD(MONTH,1,DATEFROMPARTS(pm.ROK,pm.MIESIAC,1)))




--9.8** Use `EXISTS` to find products sold in more than one selected time period.
--9.9** Rewrite a query using `LEFT JOIN ... IS NULL` as a `NOT EXISTS` query and compare the results.
--9.10** Compare `NOT EXISTS`, `NOT IN`, and `LEFT JOIN ... IS NULL`.