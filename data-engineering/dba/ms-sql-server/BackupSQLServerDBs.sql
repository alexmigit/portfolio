--
--
-- ******************************************
-- Backup SQL Server databases using a cursor
-- Author: 			Alex Migit
-- Last modified:   2016-09-28
-- ******************************************
--
--
DECLARE @dbName VARCHAR(50)
DECLARE @backupPath VARCHAR(256)
DECLARE @backupFileName VARCHAR(256)

SET @backupPath = 'C:\Program Files\Microsoft SQL Server\...'
/*
SET @backupPath = 'OneDrive - Hewlett Packard Enterprise\Microsoft SQL Server\...'
*/
DECLARE backup_cursor CURSOR FOR
SELECT Name FROM sys.databases WHERE Name NOT IN ('Model','TempDB')
OPEN backup_cursor
FETCH NEXT FROM backup_cursor INTO @dbName
WHILE @@FETCH_STATUS = 0 
BEGIN
SET @backupFileName = @backupPath + @dbName
BACKUP DATABASE @dbName TO DISK = @backupFileName
FETCH NEXT FROM backup_cursor INTO @dbName
END
CLOSE backup_cursor
DEALLOCATE backup_cursor

-- ********************************************
-- Backup SQL Server databases using while loop
-- ********************************************

DECLARE @dbName VARCHAR(50)
DECLARE @backupPath VARCHAR(256)
DECLARE @backupFileName VARCHAR(256)
DECLARE	@id INT
/*
SET @backupPath = 'C:\Program Files\Microsoft SQL Server\...'
*/
SET @backupPath = 'OneDrive - Hewlett Packard Enterprise\Microsoft SQL Server\...'

SET @id = (SELECT MIN(database_id) FROM sys.databases WHERE Name NOT IN ('Model','TempDB'))
WHILE @id IS NOT NULL
BEGIN
SET @dbName = (SELECT Name FROM sys.databases WHERE database_id = @id)
SET @backupFileName = @backupPath + @dbName
BACKUP DATABASE @dbName TO DISK = @backupFileName
SET @id = (SELECT MIN(database_id) FROM sys.databases WHERE Name NOT IN ('Model','TempDB') AND database_id > @id)
END

