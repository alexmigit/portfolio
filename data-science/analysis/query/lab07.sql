-- Retrieve product model descriptions
SELECT p.ProductID, p.Name AS ProductName, pm.Name AS ProductModel, pm.Summary
FROM SalesLT.Product AS p
JOIN SalesLT.vProductModelCatalogDescription AS pm
ON p.ProductModelID = pm.ProductModelID
ORDER BY ProductID;

-- Create a table of distinct colors
DECLARE @colors AS TABLE (Color nvarchar(15));

INSERT INTO @colors
SELECT DISTINCT Color FROM SalesLT.Product;

SELECT ProductID, Name, Color
FROM SalesLT.Product
WHERE Color IN (SELECT Color FROM @colors);

-- Retrieve product parent categories from a function
SELECT c.ParentProductCategoryName AS ParentCategory
	,c.ProductCategoryName AS Category
	,p.ProductID 
	,p.Name AS ProductName	
FROM SalesLT.Product AS p
JOIN dbo.ufnGetAllCategories() AS c
ON p.ProductCategoryID = c.ProductCategoryID
ORDER BY ParentCategory
	,Category
	,ProductName;

-- Get sales revenue by company and contact (using derived table)
SELECT CompanyContact, SUM(SalesAmount) AS Revenue
FROM
	(SELECT CONCAT(c.CompanyName, CONCAT(' (' + c.FirstName + ' ', c.LastName + ')')), soh.TotalDue
	 FROM SalesLT.SalesOrderHeader AS soh
	 JOIN SalesLT.Customer AS c
	 ON soh.CustomerID = c.CustomerID) AS CustomerSales(CompanyContact, SalesAmount)
GROUP BY CompanyContact
ORDER BY CompanyContact;

-- Get sales revenue by company and contact (using CTE)
WITH CustomerSales(CompanyContact, SalesAmount)
AS
(
	SELECT CONCAT(c.CompanyName, CONCAT(' (' + c.FirstName + ' ', c.LastName + ')')), SOH.TotalDue
	FROM SalesLT.SalesOrderHeader AS SOH
	JOIN SalesLT.Customer AS c
	ON SOH.CustomerID = c.CustomerID
)
SELECT CompanyContact, SUM(SalesAmount) AS Revenue
FROM CustomerSales
GROUP BY CompanyContact
ORDER BY CompanyContact;

