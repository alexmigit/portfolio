-- ======================================================
-- FormatPhoneNumber Scalar Function for Azure SQL Database
-- ======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Alex Migit
-- Create Date: 2019-03-19
-- Description: Function to format phone numbers
-- =============================================
CREATE FUNCTION dbo.FormatPhoneNumber
(
    @PhoneNumberToFormat nvarchar(16)
)
RETURNS nvarchar(16)
AS
BEGIN
    RETURN TRIM(FORMAT(1234567890, '(###) ###-####'))
		  ,TRIM(FORMAT(12345678, '####-####'))
		  ,TRIM(FORMAT(1234567, '###-####'))
		  ,TRIM(FORMAT(123456, '###-###'))
END
GO


/*
Any phone number beginning with the international dialing code (ie: a + sign), should be left unformatted.
Phone numbers that contain 10 digits should be formatted as: (XXX) XXX-XXXX DONE
Phone numbers that contain 8 digits should be formatted as: XXXX-XXXX DONE
Phone numbers that contain 7 digits should be formatted as: XXX-XXXX DONE
Phone numbers that contain 6 digits should be formatted as: XXX-XXX DONE
All other characters should be stripped out
Phone numbers that have different numbers of digits should have only the digits returned ie: (9234) 2345-2342 should be returned as 923423452342.
*/