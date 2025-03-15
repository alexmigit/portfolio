'
' Macro name: MakeBackup
' Procedure: Saves your document object, and 
' makes backup copy to any location desired
' BACKUP_FOLDER = {path}
' Author: Alex Migit
' Last modified: 2017-06-07
'
Sub MakeBackup()
	Dim currFile As String
	Dim backupFile As String
	Const BACKUP_FOLDER = "C:\Users\migita\OneDrive - Hewlett Packard Enterprise\_SAFE\_pc_file_backups\"
	' MS Word object name
	With ActiveDocument
	' MS Excel object name
	'With Application.
		'
		' If the document is unchanged or new, cancel backup
		'
		If .Saved Or .Path = "" Then Exit Sub
		'
		' Mark current position in document
		'
		.Bookmarks.Add Name:="LastPosition"
		'
		' Turn off screen updating
		'
		Application.ScreenUpdating = False
		'
		' Save the file
		'
		.Save
		'
		' Store the current file path, construct the path for the
		' backup file, and then save it to the OneDrive backup DIR
		'
		currFile = .FullName
		backupFile = BACKUP_FOLDER & .Name & _ & Date
		.SaveAs FileName:=backupFile
	End With
	'
	' Close the backup copy (which is now active)
	'
	ActiveDocument.Close
	'
	' Reopen the current file
	'
	Documents.Open FileName:=currFile
	'
	' Return to the pre-backup position
	'
	Selection.GoTo What:=wdGoToBookmark, Name:="LastPosition"
	'
	' Turn screen updating back on
	'
	Application.ScreenUpdating = True
'
' MakeBackup procedure automation code
' MS Application object e.g. Word will automatically
' Example: run backup every 5 minutes
' Edit TimeValue for desired interval time
'
Application.OnTime _
	When:=Now + TimeValue("00:05:00"), _
	Name:="MakeBackup"
End Sub

	
