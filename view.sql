-- The database is relatively small, so all records are included in the view
-- However, for specific business needs, it is recommended to limit the dataset
-- to only the required records in order to reduce the load on the database

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