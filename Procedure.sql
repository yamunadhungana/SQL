-- Create procedure usp_GetProductByCategoryAndPrice
CREATE PROCEDURE usp_GetProductByCategoryAndPrice
(
    @CategoryId TINYINT,
    @Price NUMERIC(8, 2)
)
AS
BEGIN
    IF @CategoryId IS NULL
    BEGIN
        PRINT 'CATEGORY ID CANNOT BE NULL';
        RETURN;
    END
    ELSE IF @CategoryId = 0
    BEGIN
        PRINT 'Invalid category ID';
        RETURN;
    END
    ELSE IF @Price IS NULL OR @Price <= 0
    BEGIN
        PRINT 'Invalid price';
        RETURN;
    END
    ELSE
    BEGIN
        SELECT * FROM Products WHERE CategoryId = @CategoryId AND Price <= @Price;
    END
END;
GO

-- Declare variables and execute the procedure
DECLARE @CatId TINYINT, @Price NUMERIC(8, 2);
SET @CatId = 5;
SET @Price = 1000;
EXEC usp_GetProductByCategoryAndPrice @CatId, @Price;
GO



-- Create procedure usp_GenerateTotalBillAmount
CREATE PROCEDURE usp_GenerateTotalBillAmount
(
    @PurchaseId BIGINT,
    @TotalAmount NUMERIC(8, 2) OUTPUT
)
AS
BEGIN
    DECLARE @ProdId CHAR(4);
    DECLARE @QtyPurchased SMALLINT;
    DECLARE @Price NUMERIC(8, 2);

    SELECT 
        @ProdId = ProductId, 
        @QtyPurchased = QuantityPurchased, 
        @Price = Price
    FROM 
        Purchases 
    WHERE 
        PurchaseId = @PurchaseId;

    IF @ProdId IS NULL
    BEGIN
        PRINT 'Purchase ID does not exist';
        SET @TotalAmount = 0;
        RETURN;
    END

    SET @TotalAmount = @QtyPurchased * @Price;
END;
GO

-- Declare variables and execute the procedure
DECLARE @TotalAmount NUMERIC(8, 2);
EXEC usp_GenerateTotalBillAmount @PurchaseId = 12345, @TotalAmount = @TotalAmount OUTPUT;
PRINT @TotalAmount;
GO


CREATE PROCEDURE usp_DemoProc
WITH RECOMPILE
AS
BEGIN
    PRINT 'Hello World'
END
GO

-- Executing the stored procedure
EXEC usp_DemoProc



