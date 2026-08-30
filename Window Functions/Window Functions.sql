--12.1** Rank products by total sales revenue using `RANK()`.

SELECT 
sod.ProductID
,SUM(sod.LineTotal) Rev
,RANK() OVER ( ORDER BY SUM(sod.LineTotal) DESC) rk
FROM Sales.SalesOrderDetail sod 
GROUP BY  sod.ProductID

--12.2** Rank products by quantity sold using `DENSE_RANK()`.
SELECT
sod.ProductID
,sum(sod.OrderQty) Qty
, DENSE_RANK() OVER(ORDER BY sum(sod.OrderQty) DESC)
FROM Sales.SalesOrderDetail sod 
GROUP BY  sod.ProductID

--12.3** Assign row numbers to products using `ROW_NUMBER()`
SELECT
ProductID, ROW_NUMBER() OVER(order by ProductID) rn 
FROM Sales.SalesOrderDetail

--12.4** Calculate running total sales by month.

SELECT 
YEAR(soh.OrderDate) rok
,MONTH(soh.OrderDate) miesiac
,SUM(sod.LineTotal) rev
,SUM(SUM(sod.LineTotal)) over (ORDER BY YEAR(soh.OrderDate),MONTH(soh.OrderDate) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS Runnintotal
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY YEAR(soh.OrderDate),MONTH(soh.OrderDate)
ORDER BY rok,miesiac

--12.5** Calculate each product's percentage share of total revenue.
SELECT
sod.ProductID,
SUM(sod.LineTotal),
sum(SUM(sod.LineTotal)) OVER() AS totalrev,
SUM(sod.LineTotal)/sum(SUM(sod.LineTotal)) OVER()*100
FROM Sales.SalesOrderDetail sod
GROUP BY sod.ProductID


--12.6** Compare current month sales with previous month sales using `LAG()`.

SELECT
MONTH(soh.OrderDate) miesiac,
YEAR(soh.OrderDate) rok,
SUM(sod.LineTotal) rev,
LAG(SUM(sod.LineTotal)) OVER( ORDER BY YEAR(soh.OrderDate),MONTH(soh.OrderDate) ) LAGREV
,SUM(sod.LineTotal)-LAG(SUM(sod.LineTotal)) OVER( ORDER BY YEAR(soh.OrderDate),MONTH(soh.OrderDate) ) DIFF
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY MONTH(soh.OrderDate),YEAR(soh.OrderDate)



--12.7** Compare current month sales with next month sales using `LEAD()`.

SELECT
MONTH(soh.OrderDate) miesiac,
YEAR(soh.OrderDate) rok,
SUM(sod.LineTotal) rev,
LEAD(SUM(sod.LineTotal)) OVER( ORDER BY YEAR(soh.OrderDate),MONTH(soh.OrderDate) ) LAGREV
,SUM(sod.LineTotal)-LEAD(SUM(sod.LineTotal)) OVER( ORDER BY YEAR(soh.OrderDate),MONTH(soh.OrderDate) ) DIFF
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY MONTH(soh.OrderDate),YEAR(soh.OrderDate)


--12.8** Create a monthly product ranking using `PARTITION BY`.

SELECT
MONTH(soh.OrderDate) miesiac,
YEAR(soh.OrderDate) rok,
SUM(sod.LineTotal) rev,
sod.ProductID,
RANK() OVER(PARTITION BY YEAR(soh.OrderDate),MONTH(soh.OrderDate) ORDER BY SUM(sod.LineTotal) DESC)
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY MONTH(soh.OrderDate),YEAR(soh.OrderDate),sod.ProductID
ORDER BY YEAR(soh.OrderDate),MONTH(soh.OrderDate)

