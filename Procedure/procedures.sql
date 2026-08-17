--6.6** Create at least one stored procedure based on a view instead of directly querying the source tables


CREATE PROCEDURE usp_GetMonthlySalesByYear
	@Year INT

AS 
BEGIN
	SELECT * FROM vs_MonthlySales
	WHERE Year=@Year
	ORDER BY Month
END

EXEC usp_GetMonthlySalesByYear @Year = 2022


--7.6** Create a stored procedure that stores monthly sales data in a temporary table and returns the month with the highest revenue

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