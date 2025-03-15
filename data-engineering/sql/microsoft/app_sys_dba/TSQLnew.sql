/*
	Created by: 	Alex Migit
	Last modified:  09/19/2016
*/
SELECT TOP 1000 td.Call_Key
      ,td.Call_Track_ID
      ,td.Cnty_of_Res
      ,td.Lang_Cd
      ,td.Answering_Cnty
      ,td.Answering_Queue_Num
      ,td.Call_Disp_Cd
      ,td.Agent_Id_Num
	  ,al.UPD_USR_ID AS UserNm
      ,td.Transfer_Call_DateTime AS CallTransfer
      ,td.Agent_Available
      ,ISNULL(td.Test_Fl, 0) AS TestCall
  FROM [ContactCalWINp].[dbo].[Covered_CA_Call_Transfer_Detail] AS td
  JOIN ContactCalWINp.dbo.[Covered_CA_Queue_Status] AS qs
  ON td.Answering_Queue_Num = qs.QueueNumber
  JOIN [ContactCalWINp].[dbo].[Covered_CA_Agent_Login] AS al
  ON td.Agent_Id_Num = al.Agent_Id_Num 
  WHERE td.Inbound_Call_dt = GETDATE()
  AND td.Test_Fl = '0'
  ORDER BY td.Transfer_Call_DateTime DESC;