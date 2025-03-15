/* 
    Purpose: Determine if year is a leap year
    Language: Transact-SQL
    Author: Alex Migit
*/
WITH x (dy,mth)
    AS (
        SELECT dy, month(dy)
        FROM (
            SELECT dateadd(mm,1,(getdate()-datepart(dy,getdate()))+1) dy
            FROM [Schema].[Table]
        ) tmp1
        UNION ALL
        SELECT dateadd(dd,1,dy), mth
        FROM x
        WHERE month(dateadd(dd,1,dy)) = mth
        )
SELECT max(day(dy)) AS MonthDays
FROM x;

-- ======================================================
-- Create Scalar LeapYear Function for Azure SQL Database
-- ======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Alex Migit
-- Create Date: 2019-03-17
-- Description: Return 1 when @year is a leap year
-- =============================================
CREATE OR REPLACE FUNCTION dbo.LeapYear(@year INT)
RETURNS BIT AS
	BEGIN
		DECLARE @d DATETIME, @ans BIT
		SET @d = CONVERT(DATETIME,'31/01/'+CONVERT(VARCHAR(4),@year),103)
			IF DATEPART(DAY,DATEADD(MONTH,1,@d))=29 SET @ans=1 ELSE SET @ans=0
        --Return 1 for leap year, else 0
		RETURN @ans
	END
GO

SELECT dbo.LeapYear(2016) AS 'LeapYear?';

/*  Create Delimited List from Table Rows 
    NOTE: This is not a leap year query 
*/
WITH x (deptno, cnt, list, empno, len)
    AS (
        SELECT deptno, count(*) over (PARTITION by deptno),
        cast(ename AS varchar(100)),
        empno,
        1
        FROM emp
    UNION ALL
        SELECT x.deptno, x.cnt,
            cast(x.list + ',' + e.ename as varchar(100)),
            e.empno, x.len+1
        FROM emp e, x
        WHERE e.deptno = x.deptno
        AND e.empno > x.empno
        )
SELECT deptno,list
FROM x
WHERE len = cnt
ORDER BY 1  

