/*
    Procedure: SQL Server & BI
    Purpose: Create query for Revenue projection by department

    Author: Alex Migit
    Last Modified: 2019-02-28
*/
USE [INTEL]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'tempdb..#rawdata10') IS NOT NULL
BEGIN
     DROP TABLE #rawdata10
END
IF OBJECT_ID(N'tempdb..#rawdata11') IS NOT NULL
BEGIN
     DROP TABLE #rawdata11
END
IF OBJECT_ID(N'tempdb..#rawdata9') IS NOT NULL
BEGIN
     DROP TABLE #rawdata9
END
IF OBJECT_ID(N'tempdb..#rawdata5') IS NOT NULL
BEGIN
     DROP TABLE #rawdata5
END
GO
   
-- DECLARE variables and SET start and end dates
-- CREATE procedure [dbo].[LindasBookingsRecognition]             
-- AS
DECLARE @yearIncoming varchar(4)
DECLARE @decider AS INT
DECLARE @yearr AS Varchar(4)
DECLARE @Lowyearr AS Varchar(4)
SET @Yearr = datepart(YEAR,Convert(date,Getdate()))
 
SET @YearIncoming = @yearr
DECLARE @username varchar(50)
SET @username = '_All'
DECLARE @period varchar(20)
SET @Period = 'Month'
DECLARE @kounter AS INT
SET @Kounter = 1
DECLARE @kount AS INT
SET @Kount = 0
DECLARE @beginFiscal datetime
DECLARE @endFiscal datetime
DECLARE @ActualBeginfiscal AS datetime
DECLARE @month01 varchar(6)
DECLARE @month02 varchar(6)
DECLARE @month03 varchar(6)
DECLARE @month04 varchar(6)
DECLARE @month05 varchar(6)
DECLARE @month06 varchar(6)
DECLARE @month07 varchar(6)
DECLARE @month08 varchar(6)
DECLARE @month09 varchar(6)
DECLARE @month10 varchar(6)
DECLARE @month11 varchar(6)
DECLARE @month12 varchar(6) 
SET @Month01 = Convert(varchar(4),DatePart(Year,Convert(date,getDate()))) + '01'
SET @Month02 = Convert(varchar(4),DatePart(Year,Convert(date,getDate()))) + '02'
SET @Month03 = Convert(varchar(4),DatePart(Year,Convert(date,getDate()))) + '03'
SET @Month04 = Convert(varchar(4),DatePart(Year,Convert(date,getDate()))) + '04'
SET @Month05 = Convert(varchar(4),DatePart(Year,Convert(date,getDate()))) + '05'
SET @Month06 = Convert(varchar(4),DatePart(Year,Convert(date,getDate()))) + '06'
SET @Month07 = Convert(varchar(4),DatePart(Year,Convert(date,getDate()))) + '07'
SET @Month08 = Convert(varchar(4),DatePart(Year,Convert(date,getDate()))) + '08'
SET @Month09 = Convert(varchar(4),DatePart(Year,Convert(date,getDate()))) + '09'
SET @Month10 = Convert(varchar(4),DatePart(Year,Convert(date,getDate()))) + '10'
SET @Month11 = Convert(varchar(4),DatePart(Year,Convert(date,getDate()))) + '11'
SET @Month12 = Convert(varchar(4),DatePart(Year,Convert(date,getDate()))) + '12'
-- SELECT @month01,@Month02, @month03, @Month04 , @Month05 , @Month06
-- SELECT @month07,@Month08, @month09, @Month10 , @Month11 , @Month12
 
 
SET @ActualBeginfiscal = convert(varchar(4),@Yearr) + '0101'
SET @Endfiscal   = convert(varchar(4),@Yearr) + '1231'
SET @Beginfiscal = convert(varchar(4),@Yearr-1) + '1201'
  
 
 SELECT 'Goods' AS Type, 
 department, [year], 
 convert(date,orderDate) AS orderDate,yearMth,
 case when Convert(date,OrderDate) < Convert(date,dbo.YearMth(convert(date,orderDate))+'21')  then 'nosplit' else 'split' end AS SplitYN,
 revenue INTO #rawdata9  
 FROM (
  SELECT Revenue, Department, OrderDate, Year, YearMth
 FROM dbo.Linda) a
 SET @Kount = @@Rowcount
 
 
 CREATE TABLE #rawdata10(
    [ID] [INT] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](9) NOT NULL,
	[Department] [varchar](15) NOT NULL,
	[Year] INT NULL,
	[orderDate] [date] NULL,
	[YearMth] varchar(6) NULL,
	[SplitYN] Varchar(7) NULL,
	[revenue] [decimal](38, 2) NULL  
) 
 
 -- SELECT * FROM #rawdata10  
 INSERT INTO #rawdata10
 SELECT 
	Type   ,
	[Department] , 
	[Year] ,
	[orderDate] ,
	[YearMth] ,
	[SplitYN] ,
	[revenue]   
	FROM #rawdata9
	
  
CREATE TABLE #rawdata11(
   	[Type] [varchar](9) NOT NULL,
	[Department] [varchar](15) NOT NULL,
	[Year] INT NULL,
	[orderDate] [date] NULL,
	[YearMth] varchar(6) NULL,
	[NewYearMth] varchar(6) NULL,
	[SplitYN] Varchar(7) NULL,
	[revenue] [decimal](38, 2) NULL ,
	[Origrevenue] [decimal](38, 2) NULL  
) 
 
DECLARE @NextMonth AS varchar(6)
SET @kounter = 1
WHILE @Kounter <= @Kount
 
BEGIN
-- if [SplitYN] = 'split'
      INSERT INTO #rawdata11
      SELECT Type,Department, [Year] ,[orderDate] ,[YearMth] ,[YearMth]  AS NewYearMth,[SplitYN][SplitYN] ,[revenue] *.70 AS Revenue, revenue AS OrigRevenue
      FROM #rawdata10
      -- Predicate says only those 70% within the current fiscal year WHERE revenue is to be split and
      -- Current Record = the record ID. and the year part of YearMth = current year
      -- There for  WHILE yearmth may be 201412, the new yearMth would be 201501 which is what we want
      WHERE (ID = @Kounter) and (SplitYN = 'split') 
      and (substring(YearMth,1,4) = convert(varchar(4),convert(date,getdate())))
      
      INSERT INTO #rawdata11
      SELECT Type,Department, [Year] ,[orderDate] ,[YearMth],
      case when right([YearMth],2) = '12' then Convert(Varchar(4),DatePart(Year,convert(Date,Getdate())) )  +'01'  else  [YearMth] +1 end
      AS NewYearMth ,[SplitYN] ,[revenue] *.30 AS Revenue,revenue AS OrigRevenue
      FROM #rawdata10
      -- Insert any ‘second parts’ AS they will all fall into the calendar / fiscal year
      -- and the current year FROM getdate() = Year part FROM YearMTH i.e.2015 < 2016
 
      WHERE (ID = @Kounter) and  (SplitYN = 'split') and (substring(YearMth,1,4) <= Convert(Varchar(4),DatePart(Year,convert(Date,Getdate())) ) )
      
   
-- if [SplitYN] = 'Nosplit'
      INSERT INTO #rawdata11
      SELECT Type,Department, [Year] ,[orderDate] ,[YearMth] ,[YearMth] AS NewYearMth,[SplitYN] ,[revenue]
      ,revenue AS OrigRevenue
      FROM #rawdata10  
      WHERE (ID = @Kounter) and (SplitYN = 'nosplit') and (substring(YearMth,1,4) = convert(varchar(4),convert(date,getdate()))) 
   
SET @kounter = @Kounter +1
end
 -- SELECT * FROM #rawdata11
 
SELECT Type, Department,
    Sum(month01) AS Month01,
    Sum(month02) AS Month02,
    Sum(month03) AS Month03,
    Sum(month04) AS Month04,
    Sum(month05) AS Month05,
    Sum(month06) AS Month06,
    Sum(month07) AS Month07,
    Sum(month08) AS Month08,
    Sum(month09) AS Month09,
    Sum(month10) AS Month10,
    Sum(month11) AS Month11,
    Sum(month12) AS Month12
FROM (
    SELECT Type, Department, 
        case when NewYearMth = @Month01 then Revenue else 0 end AS Month01,
        case when NewYearMth = @Month02 then Revenue else 0 end AS Month02,
        case when NewYearMth = @Month03 then Revenue else 0 end AS Month03,
        case when NewYearMth = @Month04 then Revenue else 0 end AS Month04,
        case when NewYearMth = @Month05 then Revenue else 0 end AS Month05,
        case when NewYearMth = @Month06 then Revenue else 0 end AS Month06,
        case when NewYearMth = @Month07 then Revenue else 0 end AS Month07,
        case when NewYearMth = @Month08 then Revenue else 0 end AS Month08,
        case when NewYearMth = @Month09 then Revenue else 0 end AS Month09,
        case when NewYearMth = @Month10 then Revenue else 0 end AS Month10,
        case when NewYearMth = @Month11 then Revenue else 0 end AS Month11,
        case when NewYearMth = @Month12 then Revenue else 0 end AS Month12
    FROM #rawdata11
    ) a
GROUP BY Type, Department