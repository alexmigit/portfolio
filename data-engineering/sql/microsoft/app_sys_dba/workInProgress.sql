/****** Script for SelectTopNRows command from SSMS  ******/
SELECT --TOP 1000 
	DISTINCT 
	   DATENAME(WEEKDAY,Inbound_Call_dt)+','+' '+CAST(DATEPART(DAY,Inbound_Call_dt) AS varchar)+' '+DATENAME(MONTH,Inbound_Call_dt)+','+' '+CAST(DATEPART(yyyy,Inbound_Call_dt) AS varchar) AS 'DateForm'
	  ,COUNT(ISNULL(CONVERT(time(7),DATEADD(s, DATEDIFF(s,Inbound_Call_tm,Transfer_Call_Tm),'00:00:00'))),1) AS 'Calls'
	  ,'In range' AS Count[Call_Key]
      /*,[Call_Track_ID]
      ,[Cnty_of_Res]
      ,[Lang_Cd]
      ,[Inbound_Call_dt]
      ,[Inbound_Call_tm]
      ,[SSC_Caller_ID]
      ,[Answering_Cnty]
      ,[Answering_Queue_Num]
      ,[Transfer_Call_Dt]
      ,[Transfer_Call_Tm]
      ,[Call_Disp_Cd]
      ,[Call_Back_Num]
      ,[Agent_Id_Num]
      ,[Call_Stop_Dt]
      ,[Call_Stop_Tm]
      ,[Agent_Answer_Dt]
      ,[Agent_Answer_Tm]
      ,[Call_Disp_Dt]
      ,[Call_Disp_Tm]
      ,[UPD_USR_ID]
      ,[Average_Call_Hndl_Tm]
      ,[Transfer_Call_DateTime]
      ,[Agent_Available]
      ,[Test_Fl]*/
FROM [ContactCalWINp].[dbo].[Covered_CA_Call_Transfer_Detail] 
--JOIN
--ON 
WHERE Call_Init_dt = '2016-05-27' 
AND Call_Init_tm BETWEEN '08:00:00.0000000' AND '18:15:00.0000000'
AND Test_Fl = '0'
GROUP BY DATENAME(WEEKDAY,Inbound_Call_dt)+','+' '+CAST(DATEPART(DAY,Inbound_Call_dt) AS varchar)+' '+DATENAME(MONTH,Inbound_Call_dt)+','+' '+CAST(DATEPART(yyyy,Inbound_Call_dt) AS varchar)
PIVOT(COUNT(Call_Stop_Tm) FOR Answering_Cnty IN([01],[07],[10],[30],[31],[34],[37],[38],[40],[41],[42],[43],[44],[48],[49],[54],[56],[57])
ORDER BY /*DATENAME(WEEKDAY,Inbound_Call_dt)+','+' '+CAST(DATEPART(DAY,Inbound_Call_dt) AS varchar)+' '+DATENAME(MONTH,Inbound_Call_dt)+','+' '+CAST(DATEPART(yyyy,Inbound_Call_dt) AS varchar) AS*/ DateForm;








SELECT --Call_Key
	DISTINCT DATENAME(WEEKDAY,Inbound_Call_dt)+','+' '+CAST(DATEPART(DAY,Inbound_Call_dt) AS varchar)+' '+DATENAME(MONTH,Inbound_Call_dt)+','+' '+CAST(DATEPART(yyyy,Inbound_Call_dt) AS varchar) AS 'DateForm'
	,COUNT(ISNULL(CONVERT(time(7),DATEADD(s, DATEDIFF(s,Inbound_Call_tm,Transfer_Call_Tm),'00:00:00')),0),1) AS 'Calls'
	  
      /*,[Call_Track_ID]
      ,[Cnty_of_Res]
      ,[Lang_Cd]
      ,[Inbound_Call_dt]
      ,[Inbound_Call_tm]
      ,[SSC_Caller_ID]
      ,[Answering_Cnty]
      ,[Answering_Queue_Num]
      ,[Transfer_Call_Dt]
      ,[Transfer_Call_Tm]
      ,[Call_Disp_Cd]
      ,[Call_Back_Num]
      ,[Agent_Id_Num]
      ,[Call_Stop_Dt]
      ,[Call_Stop_Tm]
      ,[Agent_Answer_Dt]
      ,[Agent_Answer_Tm]
      ,[Call_Disp_Dt]
      ,[Call_Disp_Tm]
      ,[UPD_USR_ID]
      ,[Average_Call_Hndl_Tm]
      ,[Transfer_Call_DateTime]
      ,[Agent_Available]
      ,[Test_Fl]*/
FROM [ContactCalWINp].[dbo].[Covered_CA_Call_Transfer_Detail] 
WHERE /*Call_Init_dt >= '2016-06-01' --AND '2016-06-31'
AND*/ Call_Init_tm BETWEEN '08:00:00.0000000' AND '18:15:00.0000000'
AND Test_Fl = '0'
GROUP BY DATENAME(WEEKDAY,Inbound_Call_dt)+','+' '+CAST(DATEPART(DAY,Inbound_Call_dt) AS varchar)+' '+DATENAME(MONTH,Inbound_Call_dt)+','+' '+CAST(DATEPART(yyyy,Inbound_Call_dt) AS varchar), Call_Key
HAVING Call_Init_dt BETWEEN '2016-06-01' AND '2016-06-31'
ORDER BY DateForm DESC;




COUNT ( { [ [ ALL | DISTINCT ] expression ] | * } )   
    [ OVER (   
        [ partition_by_clause ]   
        [ order_by_clause ]   
        [ ROW_or_RANGE_clause ]  
    ) ] 
	
	
	
	
	
	
	
	
USE ContactCalWINp
GO
SELECT 
	DISTINCT County_CD AS County, County_Queue_No "Queue Number"
FROM dbo.County_Queues AS d01
WHERE Max_Queue_Size =
  (SELECT MAX(Max_Queue_Size)
  FROM dbo.County_Queues AS d02
  WHERE d01.County_Queue_Key = d02.County_Queue_Key)
GROUP BY County_CD, County_Queue_No 
ORDER BY County;
GO