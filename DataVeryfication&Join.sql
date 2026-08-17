SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Production.Product
--1. Data Verification
--1.1
SELECT count(*) FROM Sales.SalesOrderHeader --31465
SELECT count(*) FROM Sales.SalesOrderDetail --121317
SELECT count(*) FROM Production.Product --504
--1.2

Production.Product--[PK_Product_ProductID] 
Sales.SalesOrderHeader--[PK_SalesOrderHeader_SalesOrderID]
Sales.SalesOrderDetail--[PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID]--this primary key is not used in this case
--1.3
Sales.SalesOrderDetail --[FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID],[FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID]
--1.4
SELECT MIN(OrderDate) FROM Sales.SalesOrderHeader --2022-05-30
SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader --2025-06-29
--1.5
SELECT COUNT(DISTINCT ProductID) FROM Sales.SalesOrderDetail--266
--1.6
SELECT 
p.ProductID
,sod.ProductID
FROM Sales.SalesOrderDetail sod 
LEFT JOIN Production.Product p ON sod.ProductID=p.ProductID
WHERE p.ProductID IS NULL--NO
--




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
