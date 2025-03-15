Sub RemoveSingleQuote

Dim i As Long, j As Long
Dim outputData As Variant
Dim inputData As Variant
	' Only act on a range
	If TypeName(Selection) = "Range" Then
	inputData = Selection.Value
	' Create an output array of the same size
	ReDim outputData(LBound(inputData) To UBound(inputData), _ 		LBound(inputData,2) To UBound(inputData,2))
	'Loop through all array dimensions
	For i = LBound(inputData) To UBound(inputData)
		For j = LBound(inputData,2) To UBound(inputData,2)
		' Array element will be empty if cell was empty	
		If Not IsEmpty(inputData(i,j)) Then outputData(i,j) = inputData(i,j)
		End If
	Next j
Next i

Selection.Value = outputData
End If

End Sub

