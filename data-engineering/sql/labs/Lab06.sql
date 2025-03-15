-- Retrieve Products whose list price is higher than the average unit price in the SalesOrderDetail table
SELECT ProductID, Name, ListPrice
FROM SalesLT.Product
WHERE ListPrice > 
	(SELECT AVG(UnitPrice)
	 FROM SalesLT.SalesOrderDetail)
ORDER BY ProductID; 

-- Retrieve products that are priced $100 or more
-- but have sold for a unit price of less than $100
SELECT ProductID, Name, ListPrice
FROM SalesLT.Product
	WHERE ProductID 
	IN (SELECT ProductID 
		FROM SalesLT.SalesOrderDetail
		WHERE UnitPrice < '100.00')
AND ListPrice >= '100.00'
ORDER BY ProductID;

-- Retrieve cost, list price, and average selling price for each product
SELECT ProductID, Name, StandardCost, ListPrice,
	(SELECT AVG(UnitPrice)
	 FROM SalesLT.SalesOrderDetail AS sod
	 WHERE p.ProductID = sod.ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS p
ORDER BY p.ProductID;

-- Find products where the average selling price is less than cost
SELECT ProductID, Name, StandardCost, ListPrice,
	(SELECT AVG(UnitPrice)
	 FROM SalesLT.SalesOrderDetail AS sod
	 WHERE p.ProductID = sod.ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS p
WHERE StandardCost >
	(SELECT AVG(UnitPrice)
	 FROM SalesLT.SalesOrderDetail AS sod
	 WHERE p.ProductID = sod.ProductID)
ORDER BY p.ProductID;

-- Retrieve sales order data with customer information from a function
SELECT soh.SalesOrderID, soh.CustomerID, ci.FirstName, ci.LastName, soh.TotalDue
FROM SalesLT.SalesOrderHeader AS soh
CROSS APPLY dbo.ufnGetCustomerInformation (soh.CustomerID) AS ci
ORDER BY soh.SalesOrderID;

-- Retrieve addresses with customer information from a function
SELECT ca.CustomerID, ci.FirstName, ci.LastName, a.AddressLine1, a.City
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca
ON a.AddressID = ca.AddressID
CROSS APPLY dbo.ufnGetCustomerInformation (ca.CustomerID) AS ci
ORDER BY ca.CustomerID; 