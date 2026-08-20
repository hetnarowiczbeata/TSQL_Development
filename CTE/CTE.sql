
--8.1** Create a CTE that aggregates total revenue and quantity sold for each product, then query the CTE to return products with revenue above a specified value.

WITH ProductsRevQty AS (
SELECT 
ProductID,SUM(LineTotal) AS revenue,
SUM(OrderQty) AS quantitysold
FROM Sales.SalesOrderDetail
GROUP BY ProductID)
SELECT *
FROM ProductsRevQty
WHERE revenue>1000

--8.2** Create a CTE with total revenue by product and use its result to find products with revenue above the average product revenue.


WITH ProductsRev AS (
SELECT 
ProductID,SUM(LineTotal) AS revenue
FROM Sales.SalesOrderDetail 
GROUP BY ProductID),

Avgproducts AS(
SELECT 
AVG(revenue) as Avgproductrevenue
FROM ProductsRev)

SELECT r.ProductID,r.revenue
FROM ProductsRev r, Avgproducts p
WHERE r.revenue>p.Avgproductrevenue


--8.3** 

WITH Monthlysales AS(
SELECT 
MONTH(soh.OrderDate) mies,
YEAR(soh.OrderDate) rok,
SUM(sod.LineTotal) revenue
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
GROUP BY 
MONTH(soh.OrderDate),
YEAR(soh.OrderDate)),

Avgmonthlysales AS(
SELECT AVG(revenue) AS srednia FROM Monthlysales)

SELECT mies,rok,revenue
FROM Monthlysales,Avgmonthlysales
WHERE revenue>srednia



* [ ] **8.4** Create a CTE with monthly sales for each product and use `LAG()` to compare each product's revenue with its previous sales month.
* [ ] **8.5** Create a CTE with product sales and use `RANK()` or `DENSE_RANK()` to rank products by revenue within each year.
* [ ] **8.6** Create a stored procedure that uses a CTE to calculate product sales and returns only products with revenue above a parameter provided to the procedure.
