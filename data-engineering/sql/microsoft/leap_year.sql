--Find Leap Year
WITH x (dy,mth)
AS (
SELECT dy, MONTH(dy)
FROM (
SELECT DATEADD(mm,1,(getdate()-datepart(dy,getdate()))+1) dy
FROM SalesLT.Customer
) tmp1
UNION ALL
SELECT DATEADD(dd,1,dy), mth
FROM x
WHERE MONTH(dateadd(dd,1,dy)) = mth
)
SELECT MAX(day(dy)) AS MonthDays
	  ,LeapYear = CASE WHEN MonthDays = 28 THEN 1 ELSE 0 END
FROM x

--add boolean column LeapYear (Y/N)