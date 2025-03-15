'
' SingleQuoteAdd Macro 
' Comma delimited text formatted cells
' ASCII 2 Text conversions: 
' Chr(39) =: '  AND Chr(44) =: ,
' Author: Alex Migit
'
'
Sub SingleQuoteAdd()

Dim i As Long, j As Long
Dim inputData As Variant
Dim outputData As Variant

	' Only act on a range
	If TypeName(Selection) = "Range" Then
    ' Assign selection value to a Variant array
    inputData = Selection.Value
    ' Create an output array of the same size
    ReDim outputData(LBound(inputData) To UBound(inputData), _
                     LBound(inputData, 2) To UBound(inputData, 2))

    ' Loop through all array dimensions
    For i = LBound(inputData) To UBound(inputData)
		For j = LBound(inputData, 2) To UBound(inputData, 2)
        ' Array element will be = Empty if cell was empty
		' Leading ASCII Chr(39) => Set cell(s) text format 
			If Not IsEmpty(inputData(i, j)) Then
				outputData(i, j) = Chr(39) & Chr(39) & inputData(i, j) & Chr(39) & Chr(44)
			End If
		Next j
    Next i

    Selection.Value = outputData
	End If

End Sub

