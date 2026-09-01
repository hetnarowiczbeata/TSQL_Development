--13.1** Find products that have never been sold.

SELECT p.ProductID
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON sod.ProductID=p.ProductID
WHERE sod.SalesOrderID IS NULL

--13.2** Find the product appearing in the highest number of different orders.
SELECT 
TOP 1 WITH TIES
ProductID, COUNT(DISTINCT SalesOrderID) as orders
FROM Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY orders desc

--13.3** Find the highest-revenue product.
SELECT 
TOP 1 WITH TIES
ProductID, SUM(LineTotal) AS rev
FROM Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY rev desc
--13.4** Find the best-selling product for each month.
WITH RN AS (SELECT
p.ProductID,
MONTH(soh.OrderDate) miesiac,
YEAR(soh.OrderDate) rok,
SUM(sod.OrderQty) QTY,
RANK() OVER (PARTITION BY YEAR(soh.OrderDate),MONTH(soh.OrderDate) ORDER BY SUM(sod.OrderQty) DESC) RK 
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
LEFT JOIN Production.Product p ON sod.ProductID=p.ProductID
GROUP BY p.ProductID,MONTH(soh.OrderDate),YEAR(soh.OrderDate))
SELECT * 
FROM RN
WHERE RK=1

--13.5** Find products with sales above the average product sales.
WITH TOTAL AS (
SELECT
p.ProductID, SUM(sod.LineTotal) rev 
FROM Sales.SalesOrderDetail sod
LEFT JOIN Production.Product p ON sod.ProductID=p.ProductID
GROUP BY p.ProductID

),


AVG_TOTAL AS(
SELECT AVG(rev) REVAVG FROM TOTAL)

SELECT TOTAL.*,AVG_TOTAL.REVAVG
FROM 
TOTAL,AVG_TOTAL
WHERE TOTAL.rev>AVG_TOTAL.REVAVG


--13.6** Find products responsible for the highest percentage of total revenue.
select TOP 1
p.ProductID,
SUM(sod.LineTotal) rev,
SUM(SUM(sod.LineTotal)) OVER () as totslrev,
SUM(sod.LineTotal) /SUM(SUM(sod.LineTotal)) OVER ()*100 AS PER
FROM Sales.SalesOrderDetail sod
LEFT JOIN Production.Product p ON sod.ProductID=p.ProductID
GROUP BY p.ProductID 
ORDER BY PER DESC


--13.7** Create a monthly product ranking.

SELECT
YEAR(soh.OrderDate) rok,
MONTH(soh.OrderDate) mies,
SUM(sod.OrderQty) QTY,
p.ProductID,
DENSE_RANK() OVER(PARTITION  BY YEAR(soh.OrderDate),MONTH(soh.OrderDate) ORDER BY SUM(sod.OrderQty) DESC) RK
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
LEFT JOIN Production.Product p ON sod.ProductID=p.ProductID
GROUP BY YEAR(soh.OrderDate),MONTH(soh.OrderDate),p.ProductID
ORDER BY YEAR(soh.OrderDate),MONTH(soh.OrderDate)



--13.8** Identify products with decreasing sales between consecutive months.
SELECT
YEAR(soh.OrderDate) rok,
MONTH(soh.OrderDate) mies,
SUM(sod.OrderQty) QTY,
p.ProductID,
LAG(SUM(sod.OrderQty)) OVER (PARTITION BY p.ProductID  ORDER BY YEAR(soh.OrderDate),MONTH(soh.OrderDate)),
SUM(sod.OrderQty)-LAG(SUM(sod.OrderQty)) OVER (PARTITION BY p.ProductID  ORDER BY YEAR(soh.OrderDate),MONTH(soh.OrderDate)) diff
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
LEFT JOIN Production.Product p ON sod.ProductID=p.ProductID
GROUP BY YEAR(soh.OrderDate),MONTH(soh.OrderDate),p.ProductID
ORDER BY YEAR(soh.OrderDate),MONTH(soh.OrderDate)


--13.9** Find products whose revenue increased for at least two consecutive months.

WITH TOTAL AS(SELECT
YEAR(soh.OrderDate) rok,
MONTH(soh.OrderDate) mies,
SUM(sod.LineTotal) AS rev,
p.ProductID
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
LEFT JOIN Production.Product p ON sod.ProductID=p.ProductID
GROUP BY YEAR(soh.OrderDate),MONTH(soh.OrderDate),p.ProductID
),
LAGS AS(
SELECT 
*, LAG(rev,1) OVER (PARTITION BY ProductID   ORDER BY rok, mies) LG1
,LAG(rev,2) OVER (PARTITION BY ProductID  ORDER BY rok, mies) LG2
FROM TOTAL )

SELECT * FROM LAGS
WHERE rev>LG1
AND LG1>LG2
ORDER BY ProductID, rok, mies

--13.10** Find products sold in every month appearing in the dataset.







---13.11** Find products sold only once.
--13.12** Find products with no sales during the latest month in the dataset.
SELECT 
soh.SalesOrderID
,CAST(soh.OrderDate AS DATE) AS OrderDate
,sod.ProductID
,p.Name
,sod.OrderQty
,sod.UnitPrice
,sod.LineTotal

FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
LEFT JOIN Production.Product p ON sod.ProductID=p.ProductID
