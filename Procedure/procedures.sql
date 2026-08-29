--6.6


CREATE PROCEDURE usp_GetMonthlySalesByYear
	@Year INT

AS 
BEGIN
	SELECT * FROM vs_MonthlySales
	WHERE Year=@Year
	ORDER BY Month
END

EXEC usp_GetMonthlySalesByYear @Year = 2022


--7.6

CREATE OR ALTER PROCEDURE usp_MonthlysalesTemptable
AS
BEGIN
	DROP TABLE IF EXISTS #MonthlySales1
	CREATE TABLE #MonthlySales1
	(
	month INT,
	year INT,
	revenue DECIMAL(18,2))
	
	INSERT INTO #MonthlySales1
	(month,year,revenue)
	SELECT 
    MONTH(OrderDate),
    YEAR(OrderDate),
    SUM(LineTotal)
	FROM vw_SalesOrderProductDetails
	GROUP BY 
	MONTH(OrderDate),
    YEAR(OrderDate)

	SELECT TOP(1)
	month,
	year,
	revenue
	from #MonthlySales1
	ORDER BY revenue DESC
END

EXEC dbo.usp_MonthlySalesTempTable

--8.6** Create a stored procedure that uses a CTE to calculate product sales and returns only products with revenue above a parameter provided to the procedure.


CREATE OR ALTER PROCEDURE usp_productsales
	@REVENUE INT

AS
BEGIN

	WITH Productsales AS(
		SELECT
		ProductID,
		SUM(LineTotal) revenue
		FROM Sales.SalesOrderDetail
		GROUP BY ProductID)
	    SELECT *
		FROM Productsales
		WHERE revenue>@REVENUE
END 


EXEC usp_productsales @REVENUE=7202

--11.1** Create `dbo.usp_GetProductSales` with a `@ProductID` parameter.

CREATE OR ALTER PROCEDURE dbo.usp_GetProductSales
   @ProductID INT 
AS
BEGIN
    SELECT 
	p.ProductID,
	SUM(sod.LineTotal) REV
	FROM Sales.SalesOrderHeader soh
    LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
    LEFT JOIN Production.Product p ON sod.ProductID=p.ProductID
	WHERE p.ProductID=@ProductID
	GROUP BY p.ProductID
END

EXEC dbo.usp_GetProductSales @ProductID=707

--11.2** Create `dbo.usp_GetSalesByDate` with `@DateFrom` and `@DateTo` parameters.

CREATE OR ALTER PROCEDURE dbo.usp_GetSalesByDate 
        @DateFrom DATE,
		@DateTo DATE

AS
BEGIN
     SELECT 
	 CAST(soh.OrderDate AS DATE) AS OrderDate,
	 soh.SalesOrderID,
	 SUM(sod.LineTotal) REV
	FROM Sales.SalesOrderHeader soh
    LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
	WHERE 
	CAST(soh.OrderDate AS DATE)>=@DateFrom 
	AND CAST(soh.OrderDate AS DATE)<=@DateTo
	GROUP BY CAST(soh.OrderDate AS DATE),soh.SalesOrderID
END

EXEC dbo.usp_GetSalesByDate  @DateFrom='2023-05-01', @DateTo='2024-05-01'

--11.3** Create `dbo.usp_ProductSalesSummary` with a `@ProductID` parameter.

CREATE OR ALTER PROCEDURE dbo.usp_ProductSalesSummary
	@ProductID INT
AS
BEGIN
    SELECT
        ProductID,
        SUM(OrderQty) AS Qty,
        SUM(LineTotal) AS revenue,
        COUNT(DISTINCT SalesOrderID) AS orders
    FROM Sales.SalesOrderDetail
    WHERE ProductID = @ProductID
    GROUP BY ProductID;
END;

EXEC dbo.usp_ProductSalesSummary @ProductID=707

--11.4** Create `dbo.usp_TopSellingProducts` with a `@TopN` parameter.
CREATE OR ALTER PROCEDURE dbo.usp_TopSellingProducts
	@TopN INT
AS
 BEGIN
     SELECT TOP(@TopN)
	 sod.ProductID,
	 SUM(sod.LineTotal) rev
	 FROM Sales.SalesOrderHeader soh
     LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
	 GROUP BY sod.ProductID
	 ORDER BY rev DESC
END 

EXEC dbo.usp_TopSellingProducts @TopN=5


--11.5** Create `dbo.usp_OrdersAboveValue` with a `@MinimumValue` parameter.

CREATE OR ALTER PROCEDURE dbo.usp_OrdersAboveValue
	@MinimumValue DECIMAL(18,2) 
AS
	BEGIN
		SELECT
	 soh.SalesOrderID,
	 SUM(sod.LineTotal) rev
	 FROM Sales.SalesOrderHeader soh
     LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
	 GROUP BY soh.SalesOrderID
	 HAVING SUM(sod.LineTotal)>@MinimumValue
	 ORDER BY rev DESC
END

EXEC dbo.usp_OrdersAboveValue @MinimumValue=250

--11.6** Create `dbo.usp_MonthlySalesSummary` using a temporary table.
-- The procedure should:
-- 1. Create a temporary table called #MonthlySales
-- 2. Store in it:
--    - Year
--    - Month
--    - TotalRevenue
--    - TotalQuantity
-- 3. Insert monthly sales data from AdventureWorks
-- 4. Return the results sorted by Year and Month


CREATE OR ALTER PROCEDURE dbo.usp_MonthlySalesSummary
AS 
BEGIN
	DROP TABLE IF EXISTS #MonthlySales
	SELECT 
    MONTH(soh.OrderDate) mies,
    YEAR(soh.OrderDate) rok,
	SUM(sod.LineTotal) rev,
	SUM(sod.OrderQty) Qty
	INTO #MonthlySales
	FROM Sales.SalesOrderHeader soh
    LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
	GROUP BY MONTH(soh.OrderDate),YEAR(soh.OrderDate)

	SELECT *
	FROM #MonthlySales
	ORDER BY rok,mies
END

EXEC dbo.usp_MonthlySalesSummary

