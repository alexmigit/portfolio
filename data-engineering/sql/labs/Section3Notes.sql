/*
Section 3: Modules 6-8 Notes
*/

-- Using Correlated Subqueries
SELECT CustomerID, SalesOrderID, OrderDate
FROM SalesLT.SalesOrder AS S01
WHERE orderdate =
(SELECT MAX(orderdate)
FROM SalesLT.SalesOrder AS S02
WHERE S02.CustomerID = S01.CustomerID)
ORDER BY CustomerID

-- Displays the definition of a user-defined rule, default, unencrypted Transact-SQL stored procedure, user-defined Transact-SQL function, trigger, computed column, CHECK constraint, view, or system object such as a system stored procedure.
-- sp_helptext [ @objname = ] 'name' [ , [ @columnname = ] computed_column_name ]
sp_helptext 'dbo.ufnGetAllCategories'

-- DROP FUNCTION [dbo].[ufnGetAllCategories]

CREATE FUNCTION [dbo].[ufnGetAllCategories]()
RETURNS @retCategoryInformation TABLE 
(
    -- Columns returned by the function
    [ParentProductCategoryName] [nvarchar](50) NULL, 
    [ProductCategoryName] [nvarchar](50) NOT NULL,
	[ProductCategoryID] [int] NOT NULL
)
AS 
-- Returns the CustomerID, first name, and last name for the specified customer.
BEGIN
	WITH CategoryCTE([ParentProductCategoryID], [ProductCategoryID], [Name]) AS 
	(
		SELECT [ParentProductCategoryID], [ProductCategoryID], [Name]
		FROM SalesLT.Prod
uctCategory
		WHERE ParentProductCategoryID IS NULL

	UNION ALL

		SELECT C.[ParentProductCategoryID], C.[ProductCategoryID], C.[Name]
		FROM SalesLT.ProductCategory AS C
		INNER JOIN CategoryCTE AS BC ON BC.ProductCategoryID = C.ParentProductCategoryID
	
)

	INSERT INTO @retCategoryInformation
	SELECT PC.[Name] AS [ParentProductCategoryName], CCTE.[Name] as [ProductCategoryName], CCTE.[ProductCategoryID]  
	FROM CategoryCTE AS CCTE
	JOIN SalesLT.ProductCategory AS PC 
	ON PC.[ProductCategoryID] = CCTE.[Pa
rentProductCategoryID];
	RETURN;
END;

--Cross apply example
SELECT SOH.SalesOrderID, MUP.MaxUnitPrice
FROM SalesLT.SalesOrderHeader AS SOH
CROSS APPLY SalesLT.udfMaxUnitPrice(SOH.SalesOrderID) AS MUP
ORDER BY SOH.SalesOrderID

-- Pivoting Data
SELECT OrderID, Bikes, Accessories, Clothing
FROM
	(SELECT OrderID, Category, Revenue
	 FROM Sales.SalesDetails) AS sales
PIVOT(SUM(Revenue)FOR Category IN([Bikes], [Accessories], [Clothing])) AS pvt

SELECT *
FROM
	(SELECT p.ProductID, pc.Name,ISNULL(p.Color, 'Uncolored') AS Color
	 FROM SalesLT.ProductCategory AS pc
	 JOIN SalesLT.Product AS p
	 ON pc.ProductCategoryID = p.ProductCategoryID) AS ppc
PIVOT(COUNT(ProductID) FOR Color IN([Red],[Blue],[Black],[Silver],[Yellow],[Grey],[Multi],[Uncolored])
ORDER BY Name; 

-- Unpivot
CREATE TABLE #ProductColorPivot
(Name varchar(50), Red int, Blue int, Black int, Silver int, Yellow int, Grey int, Multi int, Uncolored int)

INSERT INTO #ProductColorPivot
SELECT *
FROM
	(SELECT p.ProductID, pc.Name, ISNULL(p.Color, 'Uncolored') AS Color
	 FROM SalesLT.ProductCategory AS pc
	 JOIN SalesLT.Product AS p
	 ON pc.ProductCategoryID = p.ProductCategoryID) AS ppc
PIVOT(COUNT(ProductID) FOR Color IN([Red],[Blue],[Black],[Silver],[Yellow],[Grey],[Multi],[Uncolored])
ORDER BY Name;






































