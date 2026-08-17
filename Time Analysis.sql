--5.1** 
SELECT OrderDate,sum(LineTotal) as Total_revenue
FROM vw_SalesOrderProductDetails
GROUP BY OrderDate

--5.2**
SELECT MONTH(OrderDate) as miesiac, YEAR(OrderDate) as rok ,sum(LineTotal) as Total_revenue
FROM vw_SalesOrderProductDetails
GROUP BY MONTH(OrderDate),YEAR(OrderDate)
order by rok,miesiac asc

--5.3**
SELECT MONTH(OrderDate) as miesiac, YEAR(OrderDate) as rok ,sum(OrderQty) as Total_Qty
FROM vw_SalesOrderProductDetails
GROUP BY MONTH(OrderDate),YEAR(OrderDate)
order by rok,miesiac asc

--5.4**
SELECT MONTH(OrderDate) as miesiac, YEAR(OrderDate) as rok ,COUNT(DISTINCT SalesOrderID) as Total_Orders
FROM vw_SalesOrderProductDetails
GROUP BY MONTH(OrderDate),YEAR(OrderDate)
order by rok,miesiac asc

--5.5** 
SELECT TOP 1 MONTH(OrderDate) as miesiac, YEAR(OrderDate) as rok ,sum(LineTotal) as Total_revenue
FROM vw_SalesOrderProductDetails
GROUP BY MONTH(OrderDate),YEAR(OrderDate)
order by Total_revenue DESC

--5.6** 
SELECT MONTH(OrderDate) as miesiac, YEAR(OrderDate) as rok ,ProductID,SUM(LineTotal) AS revenue,sum(OrderQty) as Total_Qty
FROM vw_SalesOrderProductDetails
GROUP BY MONTH(OrderDate),YEAR(OrderDate),ProductID
order by rok,miesiac ,ProductID


--5.7 + 5.8** 
WITH MonthlySales AS(SELECT MONTH(OrderDate) as miesiac, YEAR(OrderDate) as rok ,ProductID,SUM(LineTotal) AS revenue
FROM vw_SalesOrderProductDetails
GROUP BY MONTH(OrderDate),YEAR(OrderDate),ProductID),


PreviousMonth AS(SELECT miesiac,rok,ProductID, revenue, LAG( revenue) OVER (PARTITION BY ProductID ORDER BY rok,miesiac) as previous
FROM MonthlySales)
SELECT miesiac,rok,ProductID, revenue,previous, revenue-previous AS MoM,(revenue-previous)/NULLIF(previous, 0) *100.0
FROM PreviousMonth


