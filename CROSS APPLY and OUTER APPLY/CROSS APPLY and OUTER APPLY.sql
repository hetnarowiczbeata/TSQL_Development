--10.1** Use `OUTER APPLY` to return the most recent sales order for each product.

SELECT a.SalesOrderID,p.ProductID,a.OrderDate
FROM Production.Product p
OUTER APPLY( SELECT TOP(1)
			CAST(soh.OrderDate AS DATE) AS OrderDate,sod.SalesOrderID
			FROM Sales.SalesOrderHeader soh
			LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
			WHERE sod.ProductID=p.ProductID
			ORDER BY OrderDate DESC) a


--10.2** Use `OUTER APPLY` with `TOP 1` and `ORDER BY` to find the last date on which each product was sold.

SELECT p.ProductID,a.orderdate
FROM Production.Product p
OUTER APPLY (SELECT TOP(1)
             CAST(soh.OrderDate AS DATE) AS orderdate 
			FROM Sales.SalesOrderHeader soh
			LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
			WHERE sod.ProductID=p.ProductID
			ORDER BY OrderDate DESC) a

--10.3** Use `OUTER APPLY` to return the highest-value order line for each product.
SELECT p.ProductID,a.LineTotal,a.SalesOrderID
FROM Production.Product p
OUTER APPLY ( SELECT TOP(1)
             sod.LineTotal ,sod.SalesOrderID
			 FROM Sales.SalesOrderHeader soh
             LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
             LEFT JOIN Production.Product p1 ON sod.ProductID=p1.ProductID
			 WHERE p1.ProductID=p.ProductID
			 ORDER BY LineTotal DESC ) a

--10.4** Use `OUTER APPLY` to calculate total quantity and total revenue for each product.
SELECT p.ProductID,a.Qty,a.REV
FROM Production.Product p
OUTER APPLY ( SELECT
             SUM(sod.OrderQty) Qty,
			 SUM(sod.LineTotal) REV
			 FROM Sales.SalesOrderHeader soh
             LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
             LEFT JOIN Production.Product p1 ON sod.ProductID=p1.ProductID
			 WHERE p1.ProductID=p.ProductID) a

--10.5** Use `CROSS APPLY` to return only products that have matching sales data.
SELECT p.ProductID,a.*
FROM Production.Product p
CROSS APPLY( SELECT 
        soh.SalesOrderID,
        soh.OrderDate,
        sod.SalesOrderDetailID,
        sod.OrderQty,
        sod.UnitPrice,
        sod.LineTotal
			 FROM Sales.SalesOrderHeader soh
             LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
             LEFT JOIN Production.Product p1 ON sod.ProductID=p1.ProductID
			 WHERE p1.ProductID=p.ProductID) a
            
