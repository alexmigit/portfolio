--  Copyright (c) 2018 by Alex Migit Holdings, Inc. All Rights Reserved.
--
--  NAME   - cre_usr_grnt.sql
--  USAGE  - cre_usr_grnt.sql
--  RUN AS - the table owner or SYS.
--           (i.e., table owner can be calwind, regxx, simxx, rtxx)
--
--  PURPOSE
--     Creates SQL Server database user account
--
--  TARGET LOCATION FOR THIS SCRIPT
--     This script belongs in the directory for which you intend.
--
--  INPUTS/OUTPUTS
--     Parms: <USER> - Replace ALL with the User / Schema
--     Input Files: N/A
--     Output Files: cre_usr.lst - Spool file
--
--  NOTES
--     1.
--
--  MODIFICATION LOG
--  WHO  MM/DD/YYYY - Description of modification
--  APM  03/03/2019 - Script inception
--
--

-- Before User creation, Check if <USER> exists
USE [DatabaseName]
GO

IF NOT EXISTS (SELECT name 
                FROM [sys].[database_principals]
                WHERE [type] = 'S' AND name = N'IIS APPPOOL\MyWebApi AppPool')
BEGIN
-- Create User Using Transact-SQL
USE [DatabaseName];
GO
CREATE USER [ITSupport] FOR LOGIN [ITSupport] WITH
DEFAULT_SCHEMA=[dbo]
GO
END
-- Add Role Memberships
USE [DatabaseName]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ITSupport]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ITSupport]
GO

-- Grant Permissions
USE [DatabaseName];
GO
GRANT SELECT, INSERT, UPDATE, DELETE ON Production.Product
TO ITSupport;
GO

-- Review and Verify Permissions
USE [DatabaseName];
EXECUTE AS USER = 'ITSupport'
SELECT * FROM fn_my_permissions('Production.Product', 'OBJECT');
GO




























