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