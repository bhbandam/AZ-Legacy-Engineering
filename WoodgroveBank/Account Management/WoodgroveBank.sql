-- Woodgrove Bank SQL Server SQL file
-- Creates the SQL Server database and tables for moving data between
-- the host files associated with the Woodgrove Bank tutorial and SQL Server


-- Create the database
CREATE DATABASE WoodgroveBank

-- Create the tables
USE WoodgroveBank

CREATE TABLE Customers (Name VARCHAR(30), SSN VARCHAR(9), Phone VARCHAR(13), AccessPin VARCHAR(4))
CREATE TABLE CustomerAddress (SSN VARCHAR(9), Street VARCHAR(20), City VARCHAR(10), State VARCHAR(4), Zip Integer)
CREATE TABLE Transactions (SSN VARCHAR(9), AccountNumber VARCHAR(10), ItemNumber DECIMAL(7,0), TransactionType VARCHAR(1), TransactionDate VARCHAR(10), Amount DECIMAL(15,2))
CREATE TABLE Accounts (SSN VARCHAR(9), AccountNumber VARCHAR(10), TypeCode VARCHAR(1), TypeName VARCHAR(10))
CREATE TABLE CheckingAccounts (OverdraftCharge DECIMAL(7,2), OverdraftLimit DECIMAL(7,2), OverdraftLinkAccount VARCHAR(10), LastStatement VARCHAR(10), DetailItems DECIMAL(7,0), Balance DECIMAL(15,2))
CREATE TABLE SavingsAccounts (InterestRate DECIMAL(3,2), ServiceCharge DECIMAL(5,2), LastStatement VARCHAR(10), DetailItems DECIMAL(7,0), Balance DECIMAL(15,2))

-- Select commands for viewing the results of a transfer between a host file and SQL Server
SELECT * FROM Customers
SELECT * FROM CustomerAddress
SELECT * FROM Transactions
SELECT * FROM Accounts
SELECT * FROM CheckingAccounts
SELECT * FROM SavingsAccounts

-- Delete commands for clearing data from SQL Server tables
DELETE FROM Customers
DELETE FROM CustomerAddress
DELETE FROM Transactions
DELETE FROM Accounts
DELETE FROM CheckingAccounts
DELETE FROM SavingsAccounts



