-- Create Function to get booked details
CREATE FUNCTION ufn_BookedDetails
(
    @BookingId VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        b.BookingId, 
        u.UserName, 
        s.MovieName, 
        t.TheatreName, 
        s.ShowDate, 
        s.ShowTime, 
        b.NoofTickets, 
        b.TotalAmt
    FROM 
        TheatreDetails t 
    JOIN 
        ShowDetails s ON t.TheatreId = s.TheatreId
    JOIN 
        BookingDetails b ON s.ShowId = b.ShowId
    JOIN 
        Users u ON b.UserId = u.UserId
    WHERE 
        b.BookingId = @BookingId
);
GO





-- Create function to get movie showtimes based on movie name and location
CREATE FUNCTION ufn_GetMovieShowtimes
(
    @MovieName VARCHAR(50),
    @Location VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        sd.MovieName, 
        sd.ShowDate, 
        sd.ShowTime, 
        td.TheatreName, 
        sd.TicketCost
    FROM 
        TheatreDetails td 
    JOIN 
        ShowDetails sd ON td.TheatreId = sd.TheatreId
    WHERE 
        td.Location = @Location 
        AND sd.MovieName = @MovieName
);
GO



-- Select from Categories ordered by CategoryId
SELECT * 
FROM Categories 
ORDER BY CategoryId;
GO

-- Alter stored procedure to add a new category
ALTER PROCEDURE usp_AddCategory
(
    @CategoryId TINYINT OUT,
    @CategoryName VARCHAR(20)
)
AS
BEGIN
    DECLARE @RetVal INT;
    SET @CategoryId = 0;

    IF @CategoryName IS NULL
    BEGIN
        SET @RetVal = -1;
    END
    ELSE IF EXISTS (SELECT * FROM Categories WHERE CategoryName = @CategoryName)
    BEGIN
        SET @RetVal = -2;
    END
    ELSE
    BEGIN
        INSERT INTO Categories (CategoryName) VALUES (@CategoryName);
        SET @RetVal = 1;
        SELECT @CategoryId = SCOPE_IDENTITY();
    END

    RETURN @RetVal;
END;
GO



-- Create stored procedure to book the ticket
CREATE PROCEDURE usp_BookTheTicket
(
    @UserId VARCHAR(50),
    @ShowId INT,
    @NoOfTickets INT
)
AS
BEGIN
    DECLARE @TicketCost DECIMAL(6,1);

    -- Check if the user exists in Bookingdetails
    IF NOT EXISTS (SELECT UserId FROM BookingDetails WHERE UserId = @UserId)
    BEGIN
        RETURN -1;
    END

    -- Check if the show exists in Bookingdetails
    IF NOT EXISTS (SELECT ShowId FROM BookingDetails WHERE ShowId = @ShowId)
    BEGIN
        RETURN -2;
    END

    -- Check if the number of tickets is valid
    IF @NoOfTickets <= 0
    BEGIN
        RETURN -3;
    END

    -- Check ticket availability
    DECLARE @TicketsAvailable INT;
    SELECT @TicketsAvailable = s.TicketsAvailable 
    FROM ShowDetails s
    WHERE s.ShowId = @ShowId;

    IF @TicketsAvailable < @NoOfTickets
    BEGIN
        RETURN -4;
    END

    BEGIN TRY
    -- Generate a new BookingId
    SELECT @BookingId = 'B' + CAST(CAST(SUBSTRING(MAX(BookingId), 2, 3) AS INT) + 1 AS CHAR) FROM BookingDetails;

    -- Retrieve ticket cost
    SELECT @TicketCost = TicketCost FROM ShowDetails;

    -- Insert booking details
    INSERT INTO BookingDetails ([BookingId], [UserId], [ShowId], [NoOfTickets], [TotalAmount])
    VALUES (@BookingId, @UserId, @ShowId, @NoOfTickets, @NoOfTickets * @TicketCost);

    -- Return success code
    RETURN 1;
END TRY
BEGIN CATCH
    -- Return error code
    RETURN -99;
END CATCH;


CREATE PROCEDURE usp_AddProduct
    @ProductId CHAR(4),
    @ProductName VARCHAR(50),
    @CategoryId TINYINT,
    @Price NUMERIC(8,2),
    @QuantityAvailable INT
AS
BEGIN
    DECLARE @returnVal INT;
    BEGIN TRY
        IF (@ProductId IS NULL)
            SET @returnVal = -1;
        ELSE IF (@ProductId NOT LIKE 'P%') OR (LEN(@ProductId) < 4)
            SET @returnVal = -2;
        ELSE IF (@ProductName IS NULL)
            SET @returnVal = -3;
        ELSE IF (@CategoryId IS NULL)
            SET @returnVal = -4;
        ELSE IF NOT EXISTS (SELECT @CategoryId FROM Categories WHERE CategoryId = @CategoryId)
            SET @returnVal = -5;
        ELSE IF (@Price = 0 OR @Price IS NULL)
            SET @returnVal = -6;
        ELSE IF (@QuantityAvailable <= 0 OR @QuantityAvailable IS NULL)
            SET @returnVal = -7;
        ELSE
        BEGIN
            INSERT INTO Products (ProductId, ProductName, CategoryId, Price, QuantityAvailable)
            VALUES (@ProductId, @ProductName, @CategoryId, @Price, @QuantityAvailable);
            SET @returnVal = 1;
        END;
    END TRY
    BEGIN CATCH
        SET @returnVal = -8; -- Some error occurred
    END CATCH;
    RETURN @returnVal;
END;



CREATE PROCEDURE usp_AddProduct
    @ProductId CHAR(4),
    @ProductName VARCHAR(50),
    @CategoryId TINYINT,
    @Price NUMERIC(8, 2),
    @QuantityAvailable INT
AS
BEGIN
    DECLARE @returnVal INT;
    BEGIN TRY
        IF (@ProductId IS NULL)
            SET @returnVal = -1;
        ELSE IF (@ProductId NOT LIKE 'P%') OR (LEN(@ProductId) < 4)
            SET @returnVal = -2;
        ELSE IF (@ProductName IS NULL)
            SET @returnVal = -3;
        ELSE IF (@CategoryId IS NULL)
            SET @returnVal = -4;
        ELSE IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryId = @CategoryId)
            SET @returnVal = -5;
        ELSE IF (@Price = 0 OR @Price IS NULL)
            SET @returnVal = -6;
        ELSE IF (@QuantityAvailable <= 0 OR @QuantityAvailable IS NULL)
            SET @returnVal = -7;
        ELSE
        BEGIN
            INSERT INTO Products (ProductId, ProductName, CategoryId, Price, QuantityAvailable)
            VALUES (@ProductId, @ProductName, @CategoryId, @Price, @QuantityAvailable);
            SET @returnVal = 1;
        END;
    END TRY
    BEGIN CATCH
        SET @returnVal = -99; -- Some error occurred
    END CATCH;
    RETURN @returnVal;
END;
GO

DECLARE @pId CHAR(4) = 'P159';
DECLARE @pName VARCHAR(50) = 'iRobot Vacuum Cleaner';
DECLARE @cId TINYINT = 3;
DECLARE @price NUMERIC(8, 2) = 550;
DECLARE @qtyAvail INT = 25;
DECLARE @result INT;

EXEC @result = usp_AddProduct @pId, @pName, @cId, @price, @qtyAvail;
PRINT @result;
SELECT * FROM Products;



CREATE PROCEDURE usp_FetchAllProducts
AS
BEGIN
    SELECT * FROM Products;
END;
GO

-- Execute the usp_FetchAllProducts procedure
EXEC usp_FetchAllProducts;
GO


CREATE PROCEDURE usp_GetProductsByCategory
    @CategoryId TINYINT
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
    ELSE
    BEGIN
        SELECT * FROM Products WHERE CategoryId = @CategoryId;
    END
END;
GO

-- Declare a variable and execute the usp_GetProductsByCategory procedure
DECLARE @CatId TINYINT;
SET @CatId = 3;
EXEC usp_GetProductsByCategory @CatId;
GO


CREATE PROCEDURE usp_GetProductByCategoryAndPrice
    @CategoryId TINYINT,
    @Price NUMERIC(8, 2)
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


CREATE PROCEDURE usp_GetProductByCategoryAndPrice
    @CategoryId TINYINT,
    @Price NUMERIC(8, 2)
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





      
       



