-- Create database
CREATE DATABASE MyHospitalDB;
GO

-- Use the new database
USE MyHospitalDB;
GO

-- Drop existing tables if they exist
IF OBJECT_ID('Surgery') IS NOT NULL
    DROP TABLE Surgery;
GO

IF OBJECT_ID('DoctorSpecialization') IS NOT NULL
    DROP TABLE DoctorSpecialization;
GO

IF OBJECT_ID('Doctor') IS NOT NULL
    DROP TABLE Doctor;
GO

IF OBJECT_ID('Specialization') IS NOT NULL
    DROP TABLE Specialization;
GO

-- Create tables and insert sample data
-- Create Specialization table
CREATE TABLE Specialization (
    SpecializationCode CHAR(3) CONSTRAINT pk_SpecializationCode PRIMARY KEY,
    SpecializationName VARCHAR(20) NOT NULL
);
GO

-- Insert sample data into Specialization table
INSERT INTO Specialization (SpecializationCode, SpecializationName) VALUES ('GYN', 'Gynecologist');
INSERT INTO Specialization (SpecializationCode, SpecializationName) VALUES ('CAR', 'Cardiologist');
INSERT INTO Specialization (SpecializationCode, SpecializationName) VALUES ('ANE', 'Anesthesiologist');
GO

-- Create Doctor table
CREATE TABLE Doctor (
    DoctorID INT IDENTITY(1,1) PRIMARY KEY,
    DoctorName VARCHAR(50) NOT NULL,
    -- Add other columns as needed
);
GO

-- Create DoctorSpecialization table
CREATE TABLE DoctorSpecialization (
    DoctorID INT,
    SpecializationCode CHAR(3),
    CONSTRAINT fk_DoctorID FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
    CONSTRAINT fk_SpecializationCode FOREIGN KEY (SpecializationCode) REFERENCES Specialization(SpecializationCode),
    PRIMARY KEY (DoctorID, SpecializationCode)
);
GO

-- Create Surgery table
CREATE TABLE Surgery (
    SurgeryID INT IDENTITY(1,1) PRIMARY KEY,
    SurgeryName VARCHAR(50) NOT NULL,
    DoctorID INT,
    CONSTRAINT fk_SurgeryDoctor FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
    -- Add other columns as needed
);
GO

-- Create Doctor table
CREATE TABLE Doctor (
    DoctorID INT IDENTITY (1001, 1) CONSTRAINT pk_DoctorID PRIMARY KEY,
    DoctorName VARCHAR(25) NOT NULL
);
GO

-- Insert data into Doctor table
INSERT INTO Doctor (DoctorName) VALUES ('Albert');
INSERT INTO Doctor (DoctorName) VALUES ('Olivia');
INSERT INTO Doctor (DoctorName) VALUES ('Susan');
GO

-- Create DoctorSpecialization table
CREATE TABLE DoctorSpecialization (
    DoctorID INT CONSTRAINT fk_DoctorID REFERENCES Doctor(DoctorID),
    SpecializationCode CHAR(3) CONSTRAINT fk_SpecializationCode REFERENCES Specialization(SpecializationCode),
    SpecializationDate DATE NOT NULL,
    CONSTRAINT pk_DoctorSpecialization PRIMARY KEY (DoctorID, SpecializationCode)
);
GO

-- Insert data into DoctorSpecialization table
INSERT INTO DoctorSpecialization (DoctorID, SpecializationCode, SpecializationDate) VALUES (1001, 'ANE', '2010-01-01');
INSERT INTO DoctorSpecialization (DoctorID, SpecializationCode, SpecializationDate) VALUES (1002, 'CAR', '2010-01-01');
INSERT INTO DoctorSpecialization (DoctorID, SpecializationCode, SpecializationDate) VALUES (1003, 'CAR', '2010-01-01');
GO

-- Create Surgery table
CREATE TABLE Surgery (
    SurgeryID INT IDENTITY (5000, 1) CONSTRAINT pk_SurgeryID PRIMARY KEY,
    DoctorID INT CONSTRAINT fk_DoctorID_Surgery REFERENCES Doctor(DoctorID),
    SurgeryDate DATE NOT NULL,
    StartTime DECIMAL (4, 2) NOT NULL,
    EndTime DECIMAL (4, 2) NOT NULL,
    SurgeryCategory CHAR(3) CONSTRAINT fk_SpecializationCode_Surgery REFERENCES Specialization(SpecializationCode)
);
GO

-- Create Surgery table
CREATE TABLE Surgery (
    SurgeryID INT IDENTITY(1,1) PRIMARY KEY,
    SurgeryName VARCHAR(50) NOT NULL,
    DoctorID INT,
    CONSTRAINT fk_SurgeryDoctor FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
    -- Add other columns as needed
);
GO
