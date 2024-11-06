-- Scalar Function
--This function checks what is the highest next pid in the table
CREATE FUNCTION ufn_GenerateNextProductId()
RETURNS CHAR(4)
AS
BEGIN
    DECLARE @PId CHAR(4);
    SELECT @PId = 'P' + CAST(SUBSTRING(MAX(ProductId), 2, 3) + 1 AS VARCHAR) FROM Products;
    RETURN @PId;
END;
GO

-- Calling the scalar function
SELECT dbo.ufn_GenerateNextProductId(); -- whenever we try to call the user-defined scalar function we should mention dbo.function_name else an error occurs

-- Deleting a product
DELETE FROM Products WHERE ProductId = 'P159';

-- Inserting a new product
INSERT INTO Products (ProductId, ProductName, CategoryId, Price, Stock)
VALUES (dbo.ufn_GenerateNextProductId(), 'Apple Magic Keyboard', 3, 75, 100);
GO

-- Table-Valued Function
-- Inline TVF
CREATE FUNCTION ufn_FetchPurchasesByUser (@EmailId VARCHAR(50))
RETURNS TABLE
AS
RETURN
    SELECT * FROM PurchaseDetails WHERE EmailId = @EmailId;
GO

-- Calling the table-valued function
SELECT * FROM ufn_FetchPurchasesByUser('Margret@gmail.com'); -- writing dbo is optional in inline table-valued functions
GO


-- Multi-statement Table-Valued Function
CREATE FUNCTION ufn_GetPurchasesByProduct
(
    @ProductId CHAR(4)
)
RETURNS @PurchaseByProducts TABLE
(
    PurchaseId BIGINT,
    EmailId VARCHAR(50),
    ProductId CHAR(4),
    QuantityPurchased INT
)
AS
BEGIN
    INSERT INTO @PurchaseByProducts
    SELECT PurchaseId, EmailId, ProductId, QuantityPurchased 
    FROM PurchaseDetails 
    WHERE ProductId = @ProductId;
    RETURN;
END;
GO

-- Calling the multi-statement table-valued function
SELECT * FROM ufn_GetPurchasesByProduct('P101');

-- Declare a table variable and execute the function
DECLARE @result TABLE 
(
    PurchaseId BIGINT,
    EmailId VARCHAR(50),
    ProductId CHAR(4),
    QuantityPurchased INT
);

INSERT INTO @result
EXEC dbo.ufn_GetPurchasesByProduct 'P101';

SELECT * FROM @result;

-- Generate the next ProductId and store it in a variable
DECLARE @Pid CHAR(4);
EXEC @Pid = dbo.ufn_GenerateNextProductId;
PRINT @Pid;
GO

-- Inline Table-Valued Function
CREATE FUNCTION ufn_GetProductDetails (@CategoryId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT ProductId, ProductName, Price, QuantityAvailable 
    FROM Products 
    WHERE CategoryId = @CategoryId
);
GO



-- Inline Table-Valued Function
CREATE FUNCTION ufn_GetProductDetails (@CategoryId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT ProductId, ProductName, Price, QuantityAvailable 
    FROM Products 
    WHERE CategoryId = @CategoryId
);
GO

-- Calling the inline table-valued function
SELECT * FROM ufn_GetProductDetails(1);
GO

-- Multi-statement Table-Valued Function
CREATE FUNCTION ufn_GetProductDetailsByCategory (@CategoryId INT)
RETURNS @ProductDetails TABLE
(
    ProductId CHAR(4), 
    ProductName VARCHAR(50),
    Price NUMERIC(8, 2), 
    QuantityAvailable INT
)
AS
BEGIN
    INSERT INTO @ProductDetails
    SELECT ProductId, ProductName, Price, QuantityAvailable 
    FROM Products 
    WHERE CategoryId = @CategoryId;
    RETURN;
END;
GO

-- Calling the multi-statement table-valued function
SELECT * FROM ufn_GetProductDetailsByCategory(1);
GO


CREATE FUNCTION ufnCheckEmailId
(
    @EmailId VARCHAR(50)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT
    IF EXISTS (SELECT 1 FROM Users WHERE EmailId = @EmailId)
        SET @Result = 0
    ELSE
        SET @Result = 1
    RETURN @Result
END
GO

SELECT dbo.ufnCheckEmailId('abc@gmail.com')
GO

--Scalar Function
--This function checks what is the highest next pid in the table
CREATE FUNCTION ufn_GenerateNextProductId()
RETURNS CHAR(4)
AS
BEGIN
    DECLARE @PId CHAR(4);
    SELECT @PId = 'P' + CAST(SUBSTRING(MAX(ProductId), 2, 3) + 1 AS VARCHAR) FROM Products;
    RETURN @PId;
END;
GO

select * from ufn_GenerateNextProductId()
Go


-- CREATE FUNCTION ufnValidateUserCredentials
-- (
--     @RoleId VARCHAR(50),
--     @UserPassword VARCHAR(50)
-- )
-- RETURNS TINYINT
-- AS

-- BEGIN
--     IF EXISTS (SELECT 1 FROM Users WHERE RoleId = @RoleId AND UserPassword = @UserPassword)
--         RETURN @RoleId
--     ELSE
--         RETURN 1
--     --RETURN @RoleId (Not sure what this line does, uncomment if needed)
-- END;

-- GO

-- SELECT * from dbo.ufnValidateUserCredentials('1', 'don@123')
-- GO

CREATE FUNCTION ufnFetchCustomerPurchases
(
    @EmailId VARCHAR(30)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        P.ProductName, 
        PD.QuantityPurchased, 
        (PD.QuantityPurchased * P.Price) AS TotalAmount, 
        PD.DateOfPurchase, 
        P.CategoryId 
    FROM 
        PurchaseDetails PD
    INNER JOIN 
        Products P ON PD.ProductId = P.ProductId 
    WHERE 
        EmailId = @EmailId
)
GO

SELECT * FROM ufnFetchCustomerPurchases('franken@gmail.com')
GO



CREATE FUNCTION ufnFetchPurchasedProduct()
RETURNS TABLE
AS
RETURN
(SELECT 
        p.ProductId, 
        p.ProductName, 
        p.Price, 
        c.CategoryName, 
        pd.QuantityPurchased, 
        (pd.QuantityPurchased * p.Price) AS TotalAmount, 
        pd.DateOfPurchase 
    FROM 
        PurchaseDetails pd
    JOIN 
        Products p ON pd.ProductId = p.ProductId
    JOIN 
        Categories c ON c.CategoryId = p.CategoryId
)
GO

SELECT * FROM ufnFetchPurchasedProduct()
GO

--DROP FUNCTION ufnFetchPurchasedProduct

CREATE FUNCTION ufnFetchPurchasedProductofUser(
    @EmailId VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        pd.PurchaseId, 
        pd.EmailId, 
        pd.DateOfPurchase, 
        p.ProductName, 
        pd.QuantityPurchased, 
        (pd.QuantityPurchased * p.Price) AS TotalAmount
    FROM 
        PurchaseDetails pd
    JOIN 
        Products p ON p.ProductId = pd.ProductId
    WHERE 
        pd.EmailId = @EmailId
)
GO

SELECT * FROM ufnFetchPurchasedProductofUser('Matti@gmail.com')
GO

--DROP FUNCTION ufnFetchPurchasedProductofUser




CREATE FUNCTION ufnFetchLastTenPurchases
(
    @EmailId VARCHAR(20)
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 10 
        pd.PurchaseId, 
        pd.EmailId, 
        pd.DateOfPurchase, 
        p.ProductName, 
        pd.QuantityPurchased, 
        pd.QuantityPurchased * p.Price AS TotalAmount
    FROM 
        PurchaseDetails pd 
    JOIN 
        Products p ON pd.ProductId = p.ProductId 
    WHERE 
        pd.EmailId = @EmailId 
    ORDER BY 
        pd.PurchaseId DESC
)
GO

SELECT * FROM ufnFetchLastTenPurchases('Matti@gmail.com')
GO


CREATE FUNCTION ufnGetCategories()
RETURNS TABLE
AS
RETURN
(
    SELECT CategoryId, CategoryName 
    FROM Categories
)
GO

SELECT * FROM ufnGetCategories()






