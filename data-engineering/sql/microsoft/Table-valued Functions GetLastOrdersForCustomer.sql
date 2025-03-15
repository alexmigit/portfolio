CREATE FUNCTION SalesLT.GetLastOrdersForCustomer
(
	@CustomerID int, @NumberOfOrders int
)
RETURNS TABLE
AS
RETURN (SELECT TOP(@NumberOfOrders)
			   soh.SalesOrderID
			  ,soh.OrderDate
			  ,soh.PurchaseOrderNumber
	    FROM SalesLT.SalesOrderHeader AS soh
		WHERE soh.CustomerID = @CustomerID
		ORDER BY soh.OrderDate DESC
	   );
GO

SELECT * FROM [SalesLT].[GetLastOrdersForCustomer] (
   29485
  ,2)
GO