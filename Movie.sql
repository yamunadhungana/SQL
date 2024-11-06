CREATE database MovieProject 
USE MovieProject;

CREATE TABLE Users (
    UserId VARCHAR(50) PRIMARY KEY,
    UserName VARCHAR(50) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    Age INT NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    EmailId VARCHAR(50) UNIQUE,
    PhoneNumber NUMERIC(10) NOT NULL
);

CREATE TABLE TheatreDetails (
    TheatreId INT PRIMARY KEY IDENTITY(1,1),
    TheatreName VARCHAR(50) NOT NULL,
    Location VARCHAR(50) NOT NULL
);

-- Create Table ShowDetails
CREATE TABLE ShowDetails (
    ShowId INT CONSTRAINT pk_ShowId PRIMARY KEY IDENTITY(1001,1),
    TheatreId INT CONSTRAINT fk_TheatreId FOREIGN KEY REFERENCES TheatreDetails(TheatreId) NOT NULL,
    ShowDate DATE NOT NULL,
    ShowTime TIME NOT NULL,
    MovieName VARCHAR(50) NOT NULL,
    TicketCost DECIMAL(6,2) NOT NULL,
    TicketsAvailable INT NOT NULL
);

-- Create Table BookingDetails
CREATE TABLE BookingDetails (
    BookingId VARCHAR(50) CONSTRAINT pk_BookingId PRIMARY KEY,
    UserId VARCHAR(50) CONSTRAINT fk_UserId FOREIGN KEY REFERENCES Users(UserId) NOT NULL,
    ShowId INT CONSTRAINT fk_ShowId FOREIGN KEY REFERENCES ShowDetails(ShowId) NOT NULL,
    NoOfTickets INT NOT NULL,
    TotalAmt DECIMAL(6,2) NOT NULL,
    CONSTRAINT BookingId_Chk CHECK (BookingId LIKE 'BX' AND BookingId BETWEEN 'B1001' AND 'B89999')
);

-- Inserting values
INSERT INTO Users (UserId, UserName, Password, Age, Gender, EmailId, PhoneNumber)
VALUES ('mary_potter', 'Mary Potter', 'Mary@123', 25, 'F', 'mary_p@gmail.com', 9786543211),
       ('jack_sparrow', 'Jack Sparrow', 'Spar78ljack', 28, 'M', 'jack_spa@yahoo.com', 7865432102);



-- Inserting values into TheatreDetails table
SET IDENTITY_INSERT TheatreDetails ON;

INSERT INTO TheatreDetails (TheatreId, TheatreName, Location) VALUES (1, N'PVR', N'Pune');
INSERT INTO TheatreDetails (TheatreId, TheatreName, Location) VALUES (2, N'Inox', N'Delhi');

SET IDENTITY_INSERT TheatreDetails OFF;

-- Inserting values into ShowDetails table
SET IDENTITY_INSERT ShowDetails ON;

INSERT INTO ShowDetails (ShowId, TheatreId, ShowDate, ShowTime, MovieName, TicketCost, TicketsAvailable)
VALUES (1081, 2, '2018-05-28', '14:30', 'Avengers', 250.00, 100),
       (1982, 2, '2018-05-30', '17:30', 'Hit Man', 200.00, 150);

SET IDENTITY_INSERT ShowDetails OFF;



-- Inserting values into BookingDetails table
INSERT INTO BookingDetails (BookingId, UserId, ShowId, NoOfTickets, TotalAmt)
VALUES (N'B101', N'jack_sparrow', 1001, 2, 500.00),
       (N'B1002', N'mary_potter', 1002, 5, 1000.00);





