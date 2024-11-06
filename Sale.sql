-- Creating the table with proper definitions
CREATE TABLE PurchaseDetailsWholesale (
    PurchaseId BIGINT,
    EmailId VARCHAR(50),
    ProductId CHAR(4),
    QuantityPurchased SMALLINT,
    DateOfPurchase SMALLDATETIME
);

-- Inserting values into the table
INSERT INTO PurchaseDetailsWholesale VALUES (10001, 'Franken@gmail.com', 'P101', 5, GETDATE());
INSERT INTO PurchaseDetailsWholesale VALUES (10002, 'Albert@gmail.com', 'P152', 3, GETDATE());

-- Setting IDENTITY_INSERT to ON for PurchaseDetails table
SET IDENTITY_INSERT PurchaseDetails ON;

-- Merging data from PurchaseDetailsWholesale into PurchaseDetails
MERGE PurchaseDetails AS [Target]
USING PurchaseDetailsWholesale AS [Source]
ON [Target].PurchaseId = [Source].PurchaseId
WHEN MATCHED THEN
    UPDATE SET 
        QuantityPurchased = Source.QuantityPurchased
WHEN NOT MATCHED THEN
    INSERT (PurchaseId, EmailId, ProductId, QuantityPurchased, DateOfPurchase)
    VALUES (Source.PurchaseId, Source.EmailId, Source.ProductId, Source.QuantityPurchased, Source.DateOfPurchase);

-- Setting IDENTITY_INSERT to OFF for PurchaseDetails table
SET IDENTITY_INSERT PurchaseDetails OFF;

-- Selecting all data from PurchaseDetails table
SELECT * FROM PurchaseDetails;




-- Aggregate Functions
SELECT Price FROM Products;

SELECT 
    MAX(Price) AS Max_Price, 
    MIN(Price) AS Min_Price, 
    AVG(Price) AS Avg_Price, 
    SUM(Price) AS Sum_Price 
FROM Products;

-- Ranking Function
SELECT 
    ProductId, 
    ProductName, 
    Price, 
    CategoryId,
    ROW_NUMBER() OVER (ORDER BY Price DESC) AS RowNo 
FROM Products;

SELECT 
    ProductId, 
    ProductName, 
    Price, 
    CategoryId,
    ROW_NUMBER() OVER (ORDER BY Price DESC) AS RowNo,
    RANK() OVER (ORDER BY Price DESC) AS [Rank]
FROM Products;

SELECT 
    ProductId, 
    ProductName, 
    Price, 
    CategoryId,
    ROW_NUMBER() OVER (ORDER BY Price DESC) AS RowNo,
    DENSE_RANK() OVER (ORDER BY Price DESC) AS [Dense_Rank]
FROM Products;

SELECT 
    ProductId, 
    ProductName, 
    Price, 
    CategoryId,
    ROW_NUMBER() OVER (ORDER BY Price DESC) AS RowNo,
    DENSE_RANK() OVER (ORDER BY Price DESC) AS [Dense_Rank],
    NTILE(10) OVER (ORDER BY Price DESC) AS [Ntile_1] -- Group divide equally
FROM Products;

SELECT 
    ProductId, 
    ProductName, 
    Price, 
    CategoryId, 
    RANK() OVER (PARTITION BY CategoryId ORDER BY Price DESC) AS [Rank]
FROM Products;

-- Mathematical Functions

-- Seeded random number generation
SELECT RAND(10) AS RandomNumber; 

-- Power function: 10 raised to the power of 2
SELECT POWER(10, 2) AS PowerResult; 

-- Natural logarithm of 10
SELECT LOG(10) AS LogResult; 

-- Square root of 36
SELECT SQRT(36) AS SqrtResult; 

-- Sine of 45 degrees (Note: SQL Server's SIN function expects radians, so this is the sine of 45 radians)
SELECT SIN(45) AS SinResult; 





