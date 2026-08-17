

--6.1** Create a view called `vw_SalesOrderProductDetails` joining all three tables.
--6.2** Include product, order, quantity, price, and revenue information in the view.

CREATE VIEW vw_SalesOrderProductDetails AS
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

--6.3** Create a view containing aggregated sales results by product.

CREATE VIEW vs_AggregatedSales AS
SELECT 
ProductID,
SUM(LineTotal) AS REVENUE
FROM Sales.SalesOrderDetail
GROUP BY ProductID


--6.4** Create a monthly sales summary view.
CREATE VIEW vs_MonthlySales AS
SELECT 
MONTH(soh.OrderDate) AS Month,
YEAR(soh.OrderDate) AS Year
,SUM(sod.LineTotal) AS REVENUE
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY MONTH(soh.OrderDate) ,YEAR(soh.OrderDate)

--6.5** Use the created views in reporting queries.
SELECT * FROM vw_SalesOrderProductDetails
SELECT * FROM vs_AggregatedSales
SELECT * FROM vs_MonthlySales