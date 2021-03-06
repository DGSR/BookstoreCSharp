﻿--
-- Script was generated by Devart dbForge Studio 2019 for MySQL, Version 8.1.22.0
-- Product home page: http://www.devart.com/dbforge/mysql/studio
-- Script date 07.06.2019 18:46:46
-- Server version: 5.7.22
-- Client version: 4.1
--

-- 
-- Disable foreign keys
-- 
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 
-- Set SQL mode
-- 
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 
-- Set character set the client will use to send SQL statements to the server
--



--
-- Set default database
--
USE "base-islamov";

--
-- Drop procedure "InsShop"
--
DROP PROCEDURE IF EXISTS InsShop;

--
-- Drop procedure "user_orders"
--
DROP PROCEDURE IF EXISTS user_orders;

--
-- Drop table "shopping_cart"
--
DROP TABLE IF EXISTS shopping_cart;

--
-- Drop procedure "DelOrd"
--
DROP PROCEDURE IF EXISTS DelOrd;

--
-- Drop procedure "InsOrd"
--
DROP PROCEDURE IF EXISTS InsOrd;

--
-- Drop table "orders"
--
DROP TABLE IF EXISTS orders;

--
-- Drop table "registry"
--
DROP TABLE IF EXISTS registry;

--
-- Drop procedure "book_count"
--
DROP PROCEDURE IF EXISTS book_count;

--
-- Drop table "receipts"
--
DROP TABLE IF EXISTS receipts;

--
-- Drop procedure "authorp"
--
DROP PROCEDURE IF EXISTS authorp;

--
-- Drop procedure "genrep"
--
DROP PROCEDURE IF EXISTS genrep;

--
-- Drop procedure "publishp"
--
DROP PROCEDURE IF EXISTS publishp;

--
-- Drop table "book"
--
DROP TABLE IF EXISTS book;

--
-- Drop table "authors"
--
DROP TABLE IF EXISTS authors;

--
-- Drop table "genres"
--
DROP TABLE IF EXISTS genres;

--
-- Drop table "publishers"
--
DROP TABLE IF EXISTS publishers;

--
-- Drop table "branch"
--
DROP TABLE IF EXISTS branch;

--
-- Drop table "cities"
--
DROP TABLE IF EXISTS cities;

--
-- Set default database
--
USE "base-islamov";

--
-- Create table "cities"
--
CREATE TABLE cities (
  ID_City INT IDENTITY(1,1) NOT NULL,
  City_Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (ID_City)
)

--
-- Create table "branch"
--
CREATE TABLE branch (
  ID_Branch INT  NOT NULL IDENTITY(1,1),
  Address VARCHAR(255) NOT NULL,
  ID_City INT  NOT NULL,
  PRIMARY KEY (ID_Branch)
)

--
-- Create foreign key
--
ALTER TABLE branch 
  ADD CONSTRAINT FK_branch_ID_City FOREIGN KEY (ID_City)
    REFERENCES cities(ID_City) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Create table "publishers"
--
CREATE TABLE publishers (
  ID_Publisher INT  NOT NULL IDENTITY(1,1),
  Publisher_name VARCHAR(255) NOT NULL,
  PRIMARY KEY (ID_Publisher)
)

--
-- Create table "genres"
--
CREATE TABLE genres (
  ID_Genre INT  NOT NULL IDENTITY(1,1),
  Genre_Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (ID_Genre)
)

--
-- Create table "authors"
--
CREATE TABLE authors (
  ID_Author INT  NOT NULL IDENTITY(1,1),
  Author_Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (ID_Author)
)

--
-- Create table "book"
--
CREATE TABLE book (
  ID_Book INT  NOT NULL IDENTITY(1,1),
  Vendor_Code VARCHAR(255) NOT NULL,
  Publication_Year INT  NOT NULL,
  Book_Name VARCHAR(255) NOT NULL,
  ID_Genre INT  NOT NULL,
  ID_Author INT  NOT NULL,
  ID_Publisher INT  NOT NULL,
  PRIMARY KEY (ID_Book)
)

--
-- Create index "UK_book_Vendor_Code" on table "book"
--
 CREATE UNIQUE INDEX UK_book_Vendor_Code on book (Vendor_Code);

--
-- Create foreign key
--
ALTER TABLE book 
  ADD CONSTRAINT FK_book_ID_Author FOREIGN KEY (ID_Author)
    REFERENCES authors(ID_Author) ON DELETE NO ACTION;

--
-- Create foreign key
--
ALTER TABLE book 
  ADD CONSTRAINT FK_book_ID_Genre FOREIGN KEY (ID_Genre)
    REFERENCES genres(ID_Genre) ON DELETE NO ACTION;

--
-- Create foreign key
--
ALTER TABLE book 
  ADD CONSTRAINT FK_book_ID_Publisher FOREIGN KEY (ID_Publisher)
    REFERENCES publishers(ID_Publisher) ON DELETE NO ACTION;

--
-- Create procedure "publishp"
--
GO
CREATE PROCEDURE publishp(@pub VARCHAR(255))
 AS
 Begin
SELECT
  book_name
FROM book
  JOIN publishers ON (book.id_publisher=publishers.id_publisher)
WHERE publisher_name = @pub;
END
GO
--
-- Create procedure "genrep"
--
GO 
CREATE PROCEDURE genrep(@gen VARCHAR(255))
AS
BEGIN
SELECT
  book_name
FROM book
  JOIN genres ON (book.id_genre=genres.ID_Genre)
WHERE genre_name = @gen;
END
GO
--
-- Create procedure "authorp"
--
GO
CREATE PROCEDURE authorp(@aut VARCHAR(255))  
  as
BEGIN
SELECT
  book_name
FROM book
  JOIN authors ON (book.id_author=authors.ID_Author)
WHERE author_name = @aut;
END
GO

 

--
-- Create table "receipts"
--
CREATE TABLE receipts (
  ID_Receipt INT  NOT NULL IDENTITY(1,1),
  Receipt_Amount INT  NOT NULL,
  Receipt_Date DATE NOT NULL,
  ID_Branch INT  NOT NULL,
  ID_Book INT  NOT NULL,
  PRIMARY KEY (ID_Receipt)
)


--
-- Create foreign key
--
ALTER TABLE receipts 
  ADD CONSTRAINT FK_receipt_ID_Book FOREIGN KEY (ID_Book)
    REFERENCES book(ID_Book) ON DELETE NO ACTION;

--
-- Create foreign key
--
ALTER TABLE receipts 
  ADD CONSTRAINT FK_receipt_ID_Branch FOREIGN KEY (ID_Branch)
    REFERENCES branch(ID_Branch) ON DELETE NO ACTION;


--
-- Create procedure "book_count"
--
GO 
create PROCEDURE book_count(@bookname VARCHAR(255))
AS
BEGIN
SELECT
  SUM(receipt_amount)
FROM "base-islamov".book
  JOIN "base-islamov".receipts
    ON "base-islamov".book.id_book = "base-islamov".receipts.id_book
WHERE "base-islamov".book.Book_name = @bookname;
END
GO
--
-- Create table "registry"
--
CREATE TABLE registry (
  ID_User INT  NOT NULL IDENTITY(1,1),
  Login VARCHAR(255) NOT NULL,
  Password VARCHAR(255) NOT NULL,
  User_Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (ID_User)
)
--
-- Create index "UK_registry" on table "registry"
--
  CREATE UNIQUE INDEX UK_registry on registry (Login, Password);
   
--
-- Create table "orders"
--
CREATE TABLE orders (
  ID_Order INT  NOT NULL IDENTITY(1,1),
  Order_Date DATE NOT NULL,
  Status VARCHAR(255) NOT NULL,
  ID_User INT  NOT NULL,
  PRIMARY KEY (ID_Order)
)

--
-- Create foreign key
--
ALTER TABLE orders 
  ADD CONSTRAINT FK_orders_ID_User FOREIGN KEY (ID_User)
    REFERENCES registry(ID_User) ON DELETE NO ACTION;

 

--
-- Create procedure "InsOrd"
--
 GO
CREATE PROCEDURE InsOrd(@log VARCHAR(255))
AS
BEGIN
INSERT INTO "base-islamov".orders (Order_date, Status, Id_user)
  (SELECT
      CONVERT (date, GETDATE()),
      'Order Formed',
      Id_user
    FROM registry
    WHERE login = @log);
END
GO
--
-- Create procedure "DelOrd"
--
 GO
CREATE PROCEDURE DelOrd(@ord VARCHAR(255))
AS
BEGIN
DELETE
  FROM orders
WHERE id_order = @ord;
END
GO
--
-- Create table "shopping_cart"
--
CREATE TABLE shopping_cart (
  ID_Cart INT  NOT NULL IDENTITY(1,1),
  ID_Order INT  NOT NULL,
  ID_Receipt INT  NOT NULL,
  Amount DECIMAL(8, 0) NOT NULL DEFAULT 1,
  PRIMARY KEY (ID_Cart)
)

--
-- Create foreign key
--
ALTER TABLE shopping_cart 
  ADD CONSTRAINT FK_shopping_cart_ID_Book FOREIGN KEY (ID_Receipt)
    REFERENCES receipts(ID_Receipt) ON DELETE NO ACTION;

--
-- Create foreign key
--
ALTER TABLE shopping_cart 
  ADD CONSTRAINT FK_shopping_cart_ID_Order FOREIGN KEY (ID_Order)
    REFERENCES orders(ID_Order) ON DELETE NO ACTION;

 

--
-- Create procedure "user_orders"
--
 GO
CREATE PROCEDURE user_orders(@usr VARCHAR(255))
AS
Begin
SELECT
  orders.ID_Order,
  orders.Order_Date,
  shopping_cart.Amount,
  Book_Name,
  Author_Name,
  Genre_Name,
  Publisher_name,
  Publication_Year
FROM shopping_cart
  JOIN orders ON (shopping_cart.ID_Order=orders.ID_Order)
  JOIN receipts ON (shopping_cart.ID_Receipt=receipts.ID_Receipt)
  JOIN book ON (book.ID_Book=receipts.ID_Book)
  JOIN authors ON (book.ID_Author=authors.ID_Author)
  JOIN genres ON (book.ID_Genre=genres.ID_Genre)
  JOIN publishers ON (book.ID_Publisher=publishers.ID_Publisher)
  JOIN registry ON (registry.ID_User=orders.ID_User)
WHERE registry.login = @usr
ORDER BY Order_Date;
END
GO
--
-- Create procedure "InsShop"
--
 GO
CREATE PROCEDURE InsShop(@quan VARCHAR(255),@bok VARCHAR(255))
AS
BEGIN
INSERT INTO "base-islamov".shopping_cart (ID_Order, ID_Receipt, Amount)
  (SELECT
      idord,
      idrecipe,
      @quan
    FROM (SELECT
            TOP 1 ID_Receipt idrecipe
           FROM book
             JOIN receipts ON (book.ID_Book=receipts.ID_Book)
           WHERE book_name = @bok) "tab1",
         (SELECT
             MAX(id_order) idord
           FROM orders) "tab2");
END
GO
-- T-sql special
--SET IDENTITY_INSERT dbo.authors OFF;
SET IDENTITY_INSERT dbo.book ON;
-- SET IDENTITY_INSERT dbo.branch Off;
-- SET IDENTITY_INSERT dbo.cities OFF;
-- SET IDENTITY_INSERT dbo.genres Off;
SET IDENTITY_INSERT dbo.orders ON;
-- SET IDENTITY_INSERT dbo.publishers Off;
SET IDENTITY_INSERT dbo.receipts ON;
SET IDENTITY_INSERT dbo.registry ON;
SET IDENTITY_INSERT dbo.shopping_cart ON;
-- 
-- Dumping data for table cities
--
INSERT INTO dbo.cities (ID_City,City_Name)
VALUES
(1, 'Saint-Petersburg'),
(2, 'Munich'),
(3, 'Moscow');

-- 
-- Dumping data for table publishers
--
INSERT INTO dbo.publishers (ID_Publisher,Publisher_name)
VALUES
(1, 'Piter'),
(2, 'Roga i Kopita'),
(3, 'Reclam');

-- 
-- Dumping data for table genres
--
INSERT INTO dbo.genres (ID_Genre,Genre_Name)
VALUES
(1, 'Science Fiction'),
(2, 'Dystopia'),
(3, 'Thriller');

-- 
-- Dumping data for table authors
--
INSERT INTO dbo.authors (ID_Author,Author_Name)
VALUES
(1, 'MacNilson'),
(2, 'Chernishow'),
(3, 'Kurtz');

-- 
-- Dumping data for table branch
--
INSERT INTO dbo.branch (ID_Branch,branch.Address,ID_City)
VALUES
(1, 'Nevskij Prospect 11', 1),
(2, 'Lenina 86', 3),
(3, 'Forstenrieder Allee 251', 2),
(4, 'Moskovskij prospect', 1);

-- 
-- Dumping data for table book
--
SET IDENTITY_INSERT dbo.book ON;
INSERT INTO dbo.book (ID_Book,Vendor_Code,Publication_Year,Book_Name,ID_Genre,ID_Author,ID_Publisher)
VALUES
(1, '111', 2018, 'Jupiter', 1, 3, 3),
(2, '102', 1998, 'Trash', 3, 2, 1),
(3, '110', 2015, 'Dystopia 101', 2, 1, 3),
(4, '105', 2005, 'Pluto', 1, 3, 1),
(5, '118', 2019, 'Black Hole', 1, 3, 3),
(6, '103', 1999, 'Trash 2: Comeback', 3, 2, 2),
(7, '104', 2000, 'Trash 3: Crawlback', 3, 2, 2),
(8, '107', 2017, 'Love and Dirt', 2, 1, 3);
SET IDENTITY_INSERT dbo.book Off;
-- 
-- Dumping data for table registry
--
SET IDENTITY_INSERT dbo.registry ON;
INSERT INTO dbo.registry (ID_User,registry.Login,registry.Password,registry.User_Name)
VALUES
(1, 'vasya', '12345qwerty', 'MegaVasya'),
(2, 'FreiCorp', 'Frei101Co45', 'Frei Corporation'),
(3, 'Drofa', 'Drofa98Piter', 'Drofa Company'),
(4, 'alexander.is@mail.ru', 'Al45$der03', 'Alexander'),
(5, 'admin', 'admin', 'admin');
SET IDENTITY_INSERT dbo.registry Off;
-- 
-- Dumping data for table receipts
--
SET IDENTITY_INSERT dbo.receipts ON;
INSERT INTO dbo.receipts (ID_Receipt,Receipt_Amount,Receipt_Date,ID_Branch,ID_Book)
VALUES
(1, 2000, '2018-04-17', 1, 1),
(2, 5000, '2018-03-10', 3, 1),
(3, 1500, '2018-09-01', 2, 1),
(4, 100, '2000-04-01', 2, 2),
(5, 50, '2001-04-01', 2, 6),
(6, 25, '2022-04-01', 2, 7),
(7, 600, '2006-03-03', 4, 4),
(8, 850, '2017-12-31', 1, 8),
(9, 600, '2019-05-01', 3, 3),
(10, 800, '2019-05-02', 1, 5);
SET IDENTITY_INSERT dbo.receipts Off;
-- 
-- Dumping data for table orders
--
SET IDENTITY_INSERT dbo.orders ON;
INSERT INTO dbo.orders (ID_Order,Order_Date,orders.Status,ID_User) VALUES
(1, '2015-04-01', 'Shipped', 4),
(3, '2019-04-10', 'Paid', 1),
(4, '2019-04-11', 'Picked', 1),
(5, '2019-03-07', 'Shipped', 2),
(6, '2018-09-01', 'Package Missing', 3),
(7, '2018-09-01', 'Shipped', 2),
(8, '2019-04-15', 'Paid', 4),
(13, '2019-05-30', 'Order Formed', 2),
(14, '2019-05-30', 'Order Formed', 5),
(15, '2019-05-30', 'Order Formed', 5),
(21, '2019-05-31', 'Order Formed', 5),
(22, '2019-05-31', 'Order Formed', 5),
(23, '2019-06-03', 'Order Formed', 5),
(24, '2019-06-03', 'Order Formed', 5),
(25, '2019-06-03', 'Order Formed', 5),
(26, '2019-06-03', 'Order Formed', 5),
(27, '2019-06-03', 'Order Formed', 5),
(28, '2019-06-03', 'Order Formed', 5);
SET IDENTITY_INSERT dbo.orders Off;
-- 
-- Dumping data for table shopping_cart
--
SET IDENTITY_INSERT dbo.shopping_cart ON;
INSERT INTO dbo.shopping_cart (ID_Cart,ID_Order,ID_Receipt,Amount) VALUES
(1, 3, 4, 1),
(2, 4, 5, 2),
(3, 1, 8, 1),
(4, 5, 2, 100),
(5, 6, 6, 10),
(6, 8, 7, 3),
(7, 7, 1, 5),
(8, 5, 8, 50),
(10, 13, 8, 2),
(11, 14, 1, 100),
(12, 15, 6, 2),
(13, 21, 10, 6),
(14, 22, 7, 10),
(15, 23, 9, 800),
(16, 24, 8, 800),
(17, 25, 8, 800),
(18, 26, 6, 1),
(19, 27, 6, 1),
(20, 28, 6, 1);
SET IDENTITY_INSERT dbo.shopping_cart Off;
-- 
-- Restore previous SQL mode
-- 
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

-- 
-- Enable foreign keys
-- 