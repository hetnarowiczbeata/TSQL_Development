


--7.1** 
-- Temporary table created from the view
DROP TABLE IF EXISTS #Monthly_sales
SELECT
MONTH(OrderDate) as month
,YEAR(OrderDate) as year
,SUM(LineTotal) as revenue
INTO #Monthly_sales
FROM vw_SalesOrderProductDetails
GROUP BY MONTH(OrderDate),YEAR(OrderDate)


select * from #Monthly_sales


--7.2**
DROP TABLE IF EXISTS #MonthlySales1
CREATE TABLE #MonthlySales1
(
month INT,
year INT,
revenue DECIMAL(18,2))
GO
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

--7.3**

SELECT TOP 1 *
FROM #Monthly_sales
ORDER BY revenue desc


--7.4
DROP TABLE IF EXISTS #TOP10_PRODUCTS
SELECT TOP (10)  WITH TIES
ProductID as produkt
,SUM(LineTotal) as revenue
INTO #TOP10_PRODUCTS
from vw_SalesOrderProductDetails
GROUP BY ProductID
ORDER BY revenue desc

--7.5

DROP TABLE IF EXISTS #TOP10_PRODUCTS_quantity
SELECT TOP (10)  WITH TIES
ProductID as produkt
,SUM(OrderQty) as Qty
INTO #TOP10_PRODUCTS_quantity
from vw_SalesOrderProductDetails
GROUP BY ProductID
ORDER BY Qty desc

SELECT COALESCE(r.produkt, q.produkt) as product,r.revenue,q.Qty
FROM #TOP10_PRODUCTS r
FULL OUTER JOIN #TOP10_PRODUCTS_quantity q ON r.produkt=q.produkt

--Top products by revenue are not the top products by quantity sold.
--7.6 is in procedures







