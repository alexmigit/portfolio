-- Simple ETL Transformation.

SELECT 
  [TitleId] = [title_id] 
, [TitleName[RR1] ] = [title] 
, [TitleType] = [type] 
FROM [pubs].[dbo].[titles];

SELECT 
  [TitleId] = [title_id] 
, [TitleName] = [title]
, [TitleType] = CASE [type] 
   When 'business' Then 'Business'
   When 'mod_cook' Then 'Modern Cooking'                             
   When 'popular_comp' Then 'Popular Computing'                     
   When 'psychology' Then 'Psychology'                         
   When 'trad_cook' Then 'Traditional Cooking'    
   When 'UNDECIDED' Then 'Undecided'                                 
  End
FROM [pubs].[dbo].[titles];

CREATE TABLE [dbo].[titles]
( [title_id] [char](6) NOT NULL
, [title] [varchar](80) NOT NULL
, [type] [char](12) NOT NULL
);

SELECT 
  [TitleId] = [title_id] 
, [TitleName] = CAST([title] as nVarchar(100)) 
, [TitleType] = CASE CAST([type] as nVarchar(100)) 
   When 'business' Then 'Business'
   When 'mod_cook' Then 'Modern Cooking'                             
   When 'popular_comp' Then 'Popular Computing'                     
   When 'psychology' Then 'Psychology'                         
   When 'trad_cook' Then 'Traditional Cooking'    
   When 'UNDECIDED' Then 'Undecided'                                 
  End
FROM [pubs].[dbo].[titles];

-- Loading data
Use TempDB;
Go
-- Create a reporting table 
CREATE TABLE [dbo].[DimTitles]
( [TitleId] [char](6) NOT NULL
, [TitleName] [nVarchar](100) NOT NULL
, [TitleType] [nVarchar](100) NOT NULL
);
Go
-- Add transformed data
INSERT INTO [TempDB].[dbo].[DimTitles]
 SELECT 
   [TitleId] = [title_id] 
 , [TitleName] = CAST([title] as nVarchar(100)) 
 , [TitleType] = CASE CAST([type] as nVarchar(100)) 
    When 'business' Then 'Business'
    When 'mod_cook' Then 'Modern Cooking'                             
    When 'popular_comp' Then 'Popular Computing'                     
    When 'psychology' Then 'Psychology'                         
    When 'trad_cook' Then 'Traditional Cooking'    
    When 'UNDECIDED' Then 'Undecided'                                 
   End
 FROM [pubs].[dbo].[titles];
Go

-- Phone number is fine in an OLTP environment, but not typically for reporting

/*
Views provide an abstraction layer between the actual tables of a database and the software that uses those tables.

This is due to the simple fact that over time tables tend to need modifications to keep relevant to current needs. 
As long as a view’s code can be modified to make it appear that nothing has changed in the results of its query, 
applications that use the view do not need to be modified as a database changes.
*/
Use TempDB;
go
CREATE VIEW vETLSelectSourceDataForDimTitles
AS
 SELECT 
   [TitleId] = [title_id] 
 , [TitleName] = CAST([title] as nVarchar(100)) 
 , [TitleType] = CASE CAST([type] as nVarchar(100)) 
    When 'business' Then 'Business'
    When 'mod_cook' Then 'Modern Cooking'                             
    When 'popular_comp' Then 'Popular Computing'                     
    When 'psychology' Then 'Psychology'                         
    When 'trad_cook' Then 'Traditional Cooking'    
    When 'UNDECIDED' Then 'Undecided'                                 
   End
FROM [pubs].[dbo].[titles];
go

SELECT 
  [TitleId]
, [TitleName]
, [TitleType]
FROM vETLSelectSourceDataForDimTitles;

/*
Stored Procedures

While Views can encapsulate only select statements, stored procedures can include most SQL statements. 
    
The code below shows an example of an ETL procedure used to file the DimTitles reporting table.

using a simple Flush and Fill technique to clear the previous data from the table and then load it with the current data. 
After executing this stored procedure that table is filled with data ready for reports.
*/

CREATE PROCEDURE pETLInsDataToDimTitles 
AS 
DELETE FROM [TempDB].[dbo].[DimTitles]; 
INSERT INTO [TempDB].[dbo].[DimTitles] 
 SELECT  
   [TitleId] 
 , [TitleName] 
 , [TitleType] 
 FROM vETLSelectSourceDataForDimTitles; 
GO
EXECUTE pETLInsDataToDimTitles; 
GO
SELECT * FROM [TempDB].[dbo].[DimTitles] 
GO

-- It is a best practice for professionals use both views and 
-- stored procedure as abstraction layer in their ETL solutions.

-- Transformation view used for Loading via a Stored Procedure
CREATE -- Fill Dim Customers Procedure
PROCEDURE pETLFillDimCustomers
AS
  /**********************************************************************
  Desc: Fills the DimCustomers dimension table
  Changelog: When, How, What
  20190309,RRoot,Created Procedure
  ***********************************************************************/
BEGIN -- Procedure Code
  DECLARE
    @RC int = 0
  , @EventName NVARCHAR(200) = 'Exec pETLFillDimCustomers'
  , @EventStatus NVARCHAR(50) = ''
  , @EventErrorInfo NVARCHAR(1000) = ''
  ;
BEGIN TRY
  BEGIN TRANSACTION;

-- ETL Code ---------------------------------------------------

INSERT INTO [DWAdventureWorksLT2017].[dbo].[DimCustomers]
SELECT
  [CustomerID]
, [CompanyName]
, [ContactFullName]
FROM [DWAdventureWorksLT2017].[dbo].[vETLDimCustomersData];

-- ETL Code ---------------------------------------------------

COMMIT TRANSACTION;
SELECT @EventStatus = 'Success', @EventErrorInfo = 'NA';
SET @RC = 100; -- Success
END TRY
BEGIN CATCH
  ROLLBACK TRAN;
  SELECT @EventStatus = 'Failure';
  -- select and format information about any error (JSON) --
  EXECUTE pSelErrorInfo @ErrorInfo = @EventErrorInfo OUTPUT;
---------------------------------------------------------------
SET @RC = -100; -- Failure
END CATCH
-- Logging Code -----------------------------------------------
  EXECUTE pInsETLEvents
      @ETLEventName = @EventName
    , @ETLEventStatus = @EventStatus
    , @ETLEventErrorInfo = @EventErrorInfo
    ;
-- Logging Code -----------------------------------------------
-- Now insert it into the ETLEvents table
RETURN @RC;
END
;
GO






































--**********************************************************--
-- Create the ETL Logging Objects (JSON formatting)
--**********************************************************--
CREATE -- Logging Table
TABLE ETLEvents
( ETLEventID int NOT NULL CONSTRAINT [pkETLLog] PRIMARY KEY IDENTITY(1,1)
, ETLEventName NVARCHAR(200) NOT NULL
, ETLEventDateTime DATETIME NOT NULL CONSTRAINT dfCurrentDateTime DEFAULT (getdate())
, ETLEventStatus NVARCHAR(50) NOT NULL
, ETLEventErrorInfo NVARCHAR(1000) NOT NULL
);
GO

CREATE -- Error Handling Info
PROCEDURE pSelErrorInfo
( @ErrorInfo NVARCHAR(1000) OUTPUT)
AS
BEGIN -- Procedure
  SELECT @ErrorInfo =
    '{"ErrorNumber" : ''' + CAST(ERROR_NUMBER() AS varchar(50))
  + ''', "ErrorSeverity" : ''' + CAST(ERROR_SEVERITY() AS varchar(50))   
  + ''', "ErrorState" : ''' + CAST(ERROR_STATE() AS varchar(50))
  + ''', "ErrorProcedure" : ''' + ISNULL(ERROR_PROCEDURE(), 'NA')
  + ''', "ErrorLine" : ''' + CAST(ERROR_LINE() AS varchar(50))
  + ''', "ErrorMessage" : ''' + ERROR_MESSAGE()
  + '''}';
END -- Procedure
;
GO




-- Custom User Defined Functions (UDFs) can use parameters! unlike views...they span the difference between a vw and a sp
CREATE FUNCTION fETLDimCustomerData
( @MinModifiedDate DATETIME)
RETURNS TABLE
AS
RETURN (
  SELECT
      [CustomerID]
    , [CompanyName] = CAST(CompanyName AS NVARCHAR(200))
    , [ContactFullName] = [FirstName] + '' + [LastName] 
  FROM [AdventureWorksLT2017].[SalesLT].[Customer]
  WHERE [ModifiedDate] > @MinModifiedDate 
  );
GO

