
-- Variable Declaration and Initialization
DECLARE @firstName NVARCHAR(50) = 'YamUNa';

-- String Functions
SELECT LOWER(@firstName) AS LowerCaseName, UPPER(@firstName) AS UpperCaseName;
SELECT LEN(@firstName) AS NameLength, CONCAT(@firstName, @firstName) AS ConcatenatedName;

-- Date and Time Functions
SELECT GETDATE() AS CurrentDateTime;
SELECT DAY(GETDATE()) AS CurrentDay, MONTH(GETDATE()) AS CurrentMonth, YEAR(GETDATE()) AS CurrentYear;
SELECT DATEPART(DD, GETDATE()) AS DayPart;
SELECT DATEPART(YY, GETDATE()) AS YearPart;
SELECT DATEPART(HH, GETDATE()) AS HourPart;
SELECT DATEPART(MI, GETDATE()) AS MinutePart;
SELECT DATEPART(SS, GETDATE()) AS SecondPart;
SELECT DATEPART(MS, GETDATE()) AS MillisecondPart;

SELECT DATEADD(DD, 2, GETDATE()) AS DatePlusTwoDays;
SELECT DATEADD(MM, 2, GETDATE()) AS DatePlusTwoMonths;

-- Using a valid date format in DATEDIFF function
SELECT DATEDIFF(YY, '1995-06-22', GETDATE()) AS YearsSince1995;

-- Conversion Functions
DECLARE @AGE INT = 30;
PRINT 'YOUR AGE IS ' + CAST(@AGE AS VARCHAR); -- CAST conversion
PRINT 'YOUR AGE IS ' + CONVERT(VARCHAR, @AGE); -- CONVERT conversion

-- Displaying current date and time with conversion
SELECT GETDATE() AS CurrentDateTime, CONVERT(VARCHAR, GETDATE()) AS ConvertedDateTime;

-- Changing the format of the date
SELECT GETDATE() AS CurrentDateTime, CONVERT(VARCHAR, GETDATE(), 1) AS FormattedDate1;
SELECT GETDATE() AS CurrentDateTime, CONVERT(VARCHAR, GETDATE(), 2) AS FormattedDate2;
SELECT GETDATE() AS CurrentDateTime, CONVERT(VARCHAR, GETDATE(), 3) AS FormattedDate3;


-- Conversion Functions
DECLARE @AGE INT = 30;
PRINT 'YOUR AGE IS ' + CAST(@AGE AS VARCHAR); -- Using CAST for conversion

-- Using CONVERT for conversion
PRINT 'YOUR AGE IS ' + CONVERT(VARCHAR, @AGE); -- Using CONVERT for conversion

-- Displaying current date and time with conversion
SELECT GETDATE() AS CurrentDateTime, CONVERT(VARCHAR, GETDATE()) AS ConvertedDateTime;

-- Changing the format of the date
SELECT GETDATE() AS CurrentDateTime, CONVERT(VARCHAR, GETDATE(), 1) AS FormattedDate1;
SELECT GETDATE() AS CurrentDateTime, CONVERT(VARCHAR, GETDATE(), 2) AS FormattedDate2;
SELECT GETDATE() AS CurrentDateTime, CONVERT(VARCHAR, GETDATE(), 3) AS FormattedDate3;
SELECT GETDATE() AS CurrentDateTime, CONVERT(VARCHAR, GETDATE(), 10) AS FormattedDate10;

-- Last day of the month
SELECT EOMONTH(GETDATE()) AS EndOfMonth;

-- Making a date from given data
SELECT DATEFROMPARTS(2090, 2, 22) AS ConstructedDate;


