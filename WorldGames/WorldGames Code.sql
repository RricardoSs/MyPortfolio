/* ==========================================================================================================================

													CREATION OF SCHEMA & TABLES
	
========================================================================================================================== */ 

-- SCHEMA
CREATE DATABASE IF NOT EXISTS WORLD_GAMES;
USE WORLD_GAMES;

-- COUNTRY TABLE
CREATE TABLE Country (
   CountryID VARCHAR(2) PRIMARY KEY,
   CountryName VARCHAR(50)
);

-- CITY TABLE
CREATE TABLE City (
   CityID INT PRIMARY KEY,
   CityName VARCHAR(50),
   CountryID VARCHAR(2),
   FOREIGN KEY (CountryID) REFERENCES Country(CountryID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ADDRESS TABLE
CREATE TABLE Address (
   AddressID INT PRIMARY KEY,
   StreetAddress VARCHAR(100), 
   CityID INT,
   PostalCode VARCHAR(15),
   FOREIGN KEY (CityID) REFERENCES City(CityID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- STORE INFO TABLE
CREATE TABLE Store (
   StoreID INT PRIMARY KEY,
   StoreName VARCHAR(50),
   AddressID INT,
   FOREIGN KEY (AddressID) REFERENCES Address(AddressID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CUSTOMER INFO TABLE
CREATE TABLE Customer (
   CustomerID INT PRIMARY KEY,
   FirstName VARCHAR(50),
   LastName VARCHAR(50),
   FiscalNumber VARCHAR(20),
   AddressID INT,
   PhoneNumber VARCHAR(20), # +351 999 999 999
   Email VARCHAR(50),
   FOREIGN KEY (AddressID) REFERENCES Address(AddressID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- (GAME) GENRES TABLE
CREATE TABLE Genre (
   GenreID INT PRIMARY KEY,
   GenreName VARCHAR(50) NOT NULL
);

-- GAMES TABLE
CREATE TABLE Game (
   GameID INT PRIMARY KEY,
   Title VARCHAR(50) NOT NULL,
   GenreID INT,
   ReleaseDate DATE,
   FOREIGN KEY (GenreID) REFERENCES Genre(GenreID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- (GAME) PLATFORM TABLE
CREATE TABLE Platform (
   PlatformID INT PRIMARY KEY,
   PlatformName VARCHAR(50) NOT NULL
);

-- GAME & PLATFORM CONNECTION TABLE
CREATE TABLE GamePlatform (
   GamePlatformID INT PRIMARY KEY,
   GameID INT,
   PlatformID INT,
   Price DECIMAL(10, 2),
   FOREIGN KEY (GameID) REFERENCES Game(GameID) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY (PlatformID) REFERENCES Platform(PlatformID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- INVENTORY/STOCK TABLE
CREATE TABLE Inventory (
   InventoryID INT PRIMARY KEY,
   StoreID INT,
   GamePlatformID INT,
   QuantityInStock INT,
   FOREIGN KEY (StoreID) REFERENCES Store(StoreID) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY (GamePlatformID) REFERENCES GamePlatform(GamePlatformID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- EMPLOYEE INFO TABLE
CREATE TABLE Employee (
   EmployeeID INT PRIMARY KEY,
   StoreID INT,
   FirstName VARCHAR(50),
   LastName VARCHAR(50),
   PhoneNumber VARCHAR(20), # +351 999 999 999
   Email VARCHAR(50),
   FiscalNumber VARCHAR(20),
   FOREIGN KEY (StoreID) REFERENCES Store(StoreID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- TRANSACTIONS INFO TABLE
CREATE TABLE TransactionRecord (
   TransactionID INT PRIMARY KEY,
   CustomerID INT,
   StoreID INT,
   EmployeeID INT,
   TransactionDate DATE,
   SubTotal DECIMAL(10, 2),
   SalesChannel VARCHAR(50), # Online or Physical
   Discount INT,
   TaxAmount INT,
   Total DECIMAL(10,2),
   FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY (StoreID) REFERENCES Store(StoreID) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- TRANSACTION DETAILS TABLE
CREATE TABLE TransactionDetails (
   TransactionDetailID INT PRIMARY KEY,
   TransactionID INT,
   GamePlatformID INT,
   Quantity INT,
   FOREIGN KEY (TransactionID) REFERENCES TransactionRecord(TransactionID) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY (GamePlatformID) REFERENCES GamePlatform(GamePlatformID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- SUPPLIER TABLE
CREATE TABLE Supplier (
   SupplierID INT PRIMARY KEY,
   SupplierName VARCHAR(50),
   Email VARCHAR(50),
   PhoneNumber VARCHAR(50),
   AddressID INT,
   FOREIGN KEY (AddressID) REFERENCES Address(AddressID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- SUPPLY TALBE
CREATE TABLE Supply (
   SupplyID INT PRIMARY KEY,
   SupplierID INT,
   GamePlatformID INT,
   Quantity INT,
   Cost DECIMAL(10, 2),
   FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY (GamePlatformID) REFERENCES GamePlatform(GamePlatformID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RATING TABLE
CREATE TABLE Rating (
   RatingID INT PRIMARY KEY,
   CustomerID INT,
   GamePlatformID INT,
   RatingValue DECIMAL(2, 1) CHECK (RatingValue >= 0 AND RatingValue <= 5),
   Comment TEXT,
   RatingDate DATE,
   FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY (GamePlatformID) REFERENCES GamePlatform(GamePlatformID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- LOG TABLE
CREATE TABLE Log (
   LogID INT AUTO_INCREMENT PRIMARY KEY,
   RecordID INT,
   ActionType VARCHAR(10) NOT NULL, -- Values: 'INSERT', 'UPDATE', 'DELETE'
   ActionDate DATETIME
);

/* ==========================================================================================================================

													TRIGGER INSERT LOG
	
========================================================================================================================== */ 

-- TRIGGER 2 -> INSERT LOG
DELIMITER //

CREATE TRIGGER LogInsertTrigger
AFTER INSERT ON TransactionRecord
FOR EACH ROW
BEGIN
    -- Insert into the Log table
    INSERT INTO Log (RecordID, ActionType, ActionDate)
    VALUES (NEW.TransactionID, 'INSERT', NOW());
END //

DELIMITER ;

/* ==========================================================================================================================

														DATA INSERTION
	
========================================================================================================================== */ 

-- Countries
INSERT INTO Country (CountryID, CountryName) VALUES
('US', 'United States'),
('UK', 'United Kingdom'),
('DE', 'Germany'),
('FR', 'France'),
('JP', 'Japan'),
('CA', 'Canada'),
('AU', 'Australia'),
('BR', 'Brazil'),
('PT', 'Portugal'),
('MX', 'Mexico')
;

-- Cities
INSERT INTO City (CityID, CityName, CountryID) VALUES
(10, 'New York', 'US'),
(11, 'Los Angeles', 'US'),
(20, 'London', 'UK'),
(21, 'Manchester', 'UK'),
(22, 'Birmingham', 'UK'),
(30, 'Berlin', 'DE'),
(31, 'Hamburg', 'DE'),
(40, 'Paris', 'FR'),
(41, 'Marseille', 'FR'),
(42, 'Lyon', 'FR'),
(50, 'Tokyo', 'JP'),
(60, 'Toronto', 'CA'),
(61, 'Vancouver', 'CA'),
(62, 'Montreal', 'CA'),
(70, 'Sydney', 'AU'),
(80, 'Sao Paulo', 'BR'),
(81, 'Rio de Janeiro', 'BR'),
(82, 'Brasilia', 'BR'),
(90, 'Lisbon', 'PT'),
(91, 'Porto', 'PT'),
(92, 'Faro', 'PT'),
(93, 'Coimbra', 'PT'),
(100, 'Mexico City', 'MX'),
(101, 'Guadalajara', 'MX')
;


-- Addresses
INSERT INTO Address (AddressID, StreetAddress, CityID, PostalCode) VALUES
(101, '123 Main St', 10, '10001'),
(102, '456 Oak Ave', 11, '90001'),
(103, '789 High St', 20, 'SW1A 1AA'),
(104, '101 Market Lane', 21, 'M1 1AA'),
(105, '400 Broad St', 22, 'B1 1AA'),
(106, '500 Skyline Rd', 30, '10115'),
(107, '600 Park Blvd', 31, '80333'),
(108, '700 Lake St', 40, '75001'),
(109, '800 River Ave', 41, '13001'),
(110, '900 Sea Dr', 42, '69001'),
(111, '100 Hillside Rd', 50, '100-8111'),
(112, '200 Meadow Lane', 60, 'M5J 2Y5'),
(113, '300 Valley View', 61, 'V6C 1G1'),
(114, '400 Mountain Rd', 62, 'H2X 1L7'),
(115, '500 Forest Ave', 70, '2000'),
(116, 'Rua Ocean Blvd', 80, '04023-902'),
(117, 'Avenida River Rd', 81, 'H2X 1L7'),
(118, 'Travessa Sunset', 82, '04023-902'),
(119, 'Rua Estrela', 90, '04023-902'),
(120, 'Avenida Floresta da Chuva', 91, '20001'),
(121, 'Praça Copacabana', 92, '04001-001'),
(122, 'Estrada Carnival St', 93, '8000-081'),
(125, 'Avenida Portside 600', 100, '11560'),
(126, 'Calle Beachfront 700', 101, '44100'),
(127, 'Rua de São Vicente, 12', 90, '1000-036'),
(128, 'Avenida Ribeira, 23', 91, '1200-037'),
(129, 'Travessa dos Laranjais, 14', 92, '1500-038'),
(130, 'Praça do Comércio, 31', 93, '1700-039'),
(131, 'Avenida Almirante Reis, 42', 90, '1000-040'),
(132, 'Rua da Oliveira, 19', 91, '1200-041'),
(133, 'Largo da Graça, 8', 92, '1500-042'),
(134, 'Avenida Fontes Pereira de Melo, 34', 93, '1700-043'),
(135, 'Travessa dos Cedros, 25', 90, '1000-044'),
(136, 'Rua Dom Manuel II, 16', 91, '1200-045'),
(137, 'Praça da Alegria, 27', 92, '1500-046'),
(138, 'Avenida da República, 40', 93, '1700-047'),
(139, 'Rua da Conceição, 14', 90, '1000-048'),
(140, 'Travessa do Carmo, 28', 91, '1200-049'),
(141, 'Praça dos Restauradores, 9', 92, '1500-050'),
(142, 'Avenida 5 de Outubro, 20', 93, '1700-051'),
(143, 'Largo da Sé, 11', 90, '1000-052'),
(144, 'Rua da Madalena, 22', 91, '1200-053'),
(145, 'Travessa do Regedor, 33', 92, '1500-054'),
(146, 'Avenida Elias Garcia, 45', 93, '1700-055'),
(147, 'Rua de São Bento, 16', 90, '1000-056'),
(148, 'Avenida António Augusto de Aguiar, 27', 91, '1200-057'),
(149, 'Praça do Príncipe Real, 38', 92, '1500-058'),
(150, 'Travessa dos Lírios, 19', 93, '1700-059'),
(151, 'Avenida dos Aliados, 40', 90, '1000-060'),
(152, 'Rua de Mouzinho da Silveira, 31', 91, '1200-061'),
(153, 'Largo do Chiado, 22', 92, '1500-062'),
(154, 'Avenida Infante Santo, 33', 93, '1700-063'),
(155, 'Travessa da Boavista, 44', 90, '1000-064'),
(156, 'Rua Dom Pedro V, 25', 91, '1200-065'),
(157, 'Praça Luís de Camões, 36', 92, '1500-066'),
(158, 'Avenida da Liberdade, 47', 93, '1700-067'),
(159, 'Rua do Ouro, 30', 90, '1000-068'),
(160, 'Travessa do Alecrim, 41', 91, '1200-069')
;

-- Stores
INSERT INTO Store (StoreID, StoreName, AddressID) VALUES
(10, 'Game Haven', 101),
(20, 'Pixel Palace', 102),
(30, 'Quest Quarters', 103),
(40, 'Level Up Lane', 104),
(50, 'Adventure Arcade', 115),
(60, 'Pixel Plaza', 116),
(70, 'Gamestream Gateway', 117),
(80, 'Quest Quarter', 118),
(90, 'Starship Store', 119),
(100, 'Fantasy Fable Shop', 120),
(110, 'Cosmic Castle', 121),
(120, 'Carnival Console', 122)
;

-- Customers
INSERT INTO Customer (CustomerID, FirstName, LastName, FiscalNumber, AddressID, PhoneNumber, Email) VALUES
(1000, 'John', 'Doe', '123456789', 102, '+1 123 456 7890', 'john_doe33@gmail.com'),
(1001, 'Jane', 'Smith', '987654321', 114, '+44 20 1234 5678', 'jane.2000@hotmail.com'),
(1002, 'Max', 'Müller', '111222333', 129, '+49 30 9876 5432', 'max.mueller98@gmail.com'),
(1003, 'Marie', 'Dupont', '555666777', 106, '+33 1 2345 6789', 'marie.dupont@gmail.com'),
(1004, 'Taro', 'Tanaka', '999888777', 109, '+81 3 1234 5678', 't_tanaka@outlook.com'),
(1005, 'Michael', 'Johnson', '777888999', 120, '+1 416 555 7890', 'michael11.johnson@outlook.com'),
(1006, 'Sophie', 'Williams', '222333444', 116, '+61 2 8765 4321', 'sophie33@gmail.com'),
(1007, 'Carlos', 'Silva', '333444555', 111, '+55 11 9876 5432', 'c.silva@hotmail.com'),
(1008, 'Ji-Hoon', 'Kim', '888777666', 105, '+82 2 3456 7890', 'jihoon.kim@gmail.com'),
(1009, 'Olga', 'Ivanova', '666555444', 109, '+7 495 123 4567', 'ivanova@gmail.com'),
(1010, 'Ana', 'Silva', '123456789', 127, '+351 912 345 678', 'silvaana@gmail.com'),
(1011, 'Pedro', 'Santos', '987654321', 128, '+351 933 987 654', 'pedro_santos@outlook.com'),
(1012, 'Marta', 'Ribeiro', '567890123', 129, '+351 965 432 109', 'ribeiro_m@hotmail.com'),
(1013, 'João', 'Oliveira', '321098765', 130, '+351 918 765 432', 'joao.oliveira20@gmail.com'),
(1014, 'Inês', 'Costa', '876543210', 131, '+351 926 543 210', 'ines.costa1999@gmail.com'),
(1015, 'Rui', 'Martins', '234567890', 132, '+351 917 654 321', 'rmartins@gmail.com'),
(1016, 'Sofia', 'Pereira', '890123456', 133, '+351 925 432 109', 'sofipereira@gmail.com'),
(1017, 'Diogo', 'Fernandes', '456789012', 134, '+351 919 876 543', 'diogo.fernandes@gmail.com'),
(1018, 'Catarina', 'Silveira', '012345678', 135, '+351 911 234 567', 'catarina.silveira@gmail.com'),
(1019, 'Hugo', 'Almeida', '654321098', 136, '+351 935 876 543', 'almeida@gmail.com'),
(1020, 'Carolina', 'Gomes', '210987654', 137, '+351 912 345 678', 'carolina.gomes@outlook.com'),
(1021, 'António', 'Pinto', '543210987', 138, '+351 933 987 654', 'antonio.pinto@live.com.pt'),
(1022, 'Mariana', 'Lopes', '789012345', 139, '+351 965 432 109', 'mariana.lopes@gmail.com'),
(1023, 'André', 'Sousa', '234567890', 140, '+351 918 765 432', 'andre.sousa@gmail.com'),
(1024, 'Rita', 'Ferreira', '567890123', 141, '+351 926 543 210', 'rita.ferreira@outlook.com'),
(1025, 'Paulo', 'Mendes', '321098765', 142, '+351 917 654 321', 'paulo.mendes@outlook.com'),
(1026, 'Beatriz', 'Carvalho', '876543210', 143, '+351 925 432 109', 'beatriz.carvalho@live.com.pt'),
(1027, 'Francisco', 'Araújo', '890123456', 144, '+351 919 876 543', 'francisco.araujo@gmail.com'),
(1028, 'Sara', 'Teixeira', '456789012', 145, '+351 911 234 567', 'sara.teixeira@outlook.com'),
(1029, 'Tomás', 'Correia', '012345678', 146, '+351 935 876 543', 'tomas.correia@hotmail.com')
;

-- Genres
INSERT INTO Genre (GenreID, GenreName) VALUES
(1, 'Action'),
(2, 'Adventure'),
(3, 'Strategy'),
(4, 'Simulation'),
(5, 'Role-playing'),
(6, 'Sports'),
(7, 'Racing'),
(8, 'Horror'),
(9, 'Fighting'),
(10, 'Puzzle')
;

-- Games
INSERT INTO Game (GameID, Title, GenreID, ReleaseDate) VALUES
(1, 'Battlefield', 1, '2019-01-15'),
(2, 'The Legend of Zelda', 5, '2023-02-28'),
(3, 'SimCity', 4, '2011-03-10'),
(4, 'Call of Duty', 1, '2020-04-05'),
(5, 'Final Fantasy', 5, '2022-05-20'),
(6, 'FIFA 22', 6, '2021-07-15'),
(7, 'Need for Speed', 7, '2020-08-28'),
(8, 'Resident Evil', 8, '2019-09-10'),
(9, 'Street Fighter V', 9, '2017-10-05'),
(10, 'Tetris', 10, '1999-11-20'),
(11, 'Assassin''s Creed Valhalla', 1, '2021-11-10'),
(12, 'Uncharted 4: A Thief''s End', 2, '2016-05-10'),
(13, 'Civilization VI', 3, '2016-10-21'),
(14, 'The Sims 4', 4, '2014-09-02'),
(15, 'Cyberpunk 2077', 5, '2020-12-10'),
(16, 'NBA 2K22', 6, '2021-09-10'),
(17, 'Gran Turismo 7', 7, '2022-03-04'),
(18, 'Dead by Daylight', 8, '2016-06-14'),
(19, 'Mortal Kombat 11', 9, '2019-04-23'),
(20, 'Portal 2', 10, '2011-04-18'),
(21, 'Red Dead Redemption 2', 1, '2018-10-26'),
(22, 'God of War', 2, '2018-04-20'),
(23, 'Stellaris', 3, '2016-05-09'),
(24, 'Cities: Skylines', 4, '2015-03-10'),
(25, 'The Witcher 3: Wild Hunt', 5, '2015-05-19'),
(26, 'Pro Evolution Soccer 2022', 6, '2021-09-21'),
(27, 'Forza Horizon 5', 7, '2021-11-09'),
(28, 'Silent Hill', 8, '2012-09-27'),
(29, 'Super Smash Bros. Ultimate', 9, '2018-12-07'),
(30, 'Minecraft', 10, '2011-11-18');

-- Platforms
INSERT INTO Platform (PlatformID, PlatformName) VALUES
(1, 'PlayStation'),
(2, 'Xbox'),
(3, 'Nintendo Switch'),
(4, 'PC'),
(5, 'Mobile'),
(6, 'PlayStation VR'),
(7, 'Nintendo 3DS'),
(8, 'Mac'),
(9, 'Android'),
(10, 'Xbox Series X');

-- Game Platforms
INSERT INTO GamePlatform (GamePlatformID, GameID, PlatformID, Price) VALUES
(1000, 1, 1, 59.99),   -- Battlefield on PC
(1010, 1, 2, 59.99),   -- Battlefield on PlayStation
(1020, 2, 2, 49.99),   -- The Legend of Zelda on PlayStation
(1030, 3, 1, 29.99),  -- SimCity on PC
(1040, 4, 1, 69.99),   -- Call of Duty on PC
(1050, 5, 2, 59.99),   -- Final Fantasy on PlayStation
(1060, 6, 3, 49.99),   -- FIFA 22 on Xbox
(1070, 7, 3, 39.99),   -- Need for Speed on Xbox
(1080, 8, 2, 59.99),   -- Resident Evil on PlayStation
(1090, 9, 1, 29.99),   -- Street Fighter V on PC
(1100, 10, 3, 19.99),  -- Tetris on Xbox
(1110, 11, 1, 49.99),  -- Assassin's Creed Valhalla on PC
(1120, 11, 2, 49.99),  -- Assassin's Creed Valhalla on PlayStation
(1130, 12, 2, 39.99),  -- Uncharted 4 on PlayStation
(1140, 13, 1, 29.99),  -- Civilization VI on PC
(1150, 14, 1, 39.99),  -- The Sims 4 on PC
(1160, 15, 2, 69.99),  -- Cyberpunk 2077 on PlayStation
(1170, 16, 3, 59.99), -- NBA 2K22 on Xbox
(1180, 17, 3, 49.99),  -- Gran Turismo 7 on Xbox
(1190, 18, 1, 29.99),  -- Dead by Daylight on PC
(1200, 19, 2, 39.99),  -- Mortal Kombat 11 on PlayStation
(1210, 20, 3, 19.99), -- Portal 2 on Xbox
(1220, 21, 1, 59.99),  -- Red Dead Redemption 2 on PC
(1230, 21, 2, 59.99),  -- Red Dead Redemption 2 on PlayStation
(1240, 22, 2, 49.99),  -- God of War on PlayStation
(1250, 23, 1, 29.99), -- Stellaris on PC
(1260, 24, 1, 39.99),  -- Cities: Skylines on PC
(1270, 25, 2, 59.99),  -- The Witcher 3 on PlayStation
(1280, 26, 3, 49.99),  -- PES 2022 on Xbox
(1290, 27, 3, 59.99),  -- Forza Horizon 5 on Xbox
(1300, 28, 2, 29.99),  -- Silent Hill on PlayStation
(1310, 29, 1, 39.99),  -- Smash Bros. Ultimate on PC
(1320, 30, 3, 19.99); -- Minecraft on Xbox

-- Inventory
INSERT INTO Inventory (InventoryID, StoreID, GamePlatformID, QuantityInStock) VALUES
(100, 10, 1000, 5),
(110, 10, 1010, 30),
(120, 20, 1020, 4),
(130, 20, 1030, 20),
(140, 30, 1040, 25),
(150, 30, 1050, 35),
(160, 40, 1060, 15),
(170, 40, 1070, 25),
(180, 50, 1080, 30),
(190, 50, 1090, 10),
(200, 60, 1100, 20),
(210, 60, 1110, 40),
(220, 70, 1120, 25),
(230, 70, 1130, 35),
(240, 80, 1140, 15),
(250, 80, 1150, 30),
(260, 90, 1160, 20),
(270, 70, 1170, 25),
(280, 100, 1180, 30),
(290, 100, 1190, 10),
(300, 110, 1200, 1),
(310, 110, 1210, 5),
(320, 120, 1220, 25),
(330, 120, 1230, 2),
(340, 10, 1240, 20),
(350, 20, 1250, 3),
(360, 30, 1260, 2),
(370, 40, 1270, 30),
(380, 50, 1280, 10),
(390, 60, 1290, 20),
(400, 70, 1300, 15),
(410, 80, 1310, 25),
(420, 90, 1320, 30)
;

-- Employees
INSERT INTO Employee (EmployeeID, StoreID, FirstName, LastName, PhoneNumber, Email, FiscalNumber) VALUES
(3000, 10, 'John', 'Doe', '+1 123 456 789', 'john.doe@worldgames.com', '123-45-67890'),
(3010, 10, 'Jane', 'Smith', '+1 987 654 321', 'jane.smith@worldgames.com', '987-65-43210'),
(3020, 20, 'Michael', 'Johnson', '+2 111 222 333', 'michael.johnson@worldgames.com', '222-33-44455'),
(3030, 20, 'Emily', 'Williams', '+2 444 555 666', 'emily.williams@worldgames.com', '555-66-77788'),
(3040, 30, 'Christopher', 'Brown', '+3 333 444 555', 'christopher.brown@worldgames.com', '333-44-55566'),
(3050, 30, 'Olivia', 'Jones', '+3 666 777 888', 'olivia.jones@worldgames.com', '666-77-88899'),
(3060, 40, 'Daniel', 'Garcia', '+4 555 666 777', 'daniel.garcia@worldgames.com', '444-55-66677'),
(3070, 40, 'Sophia', 'Martinez', '+4 888 999 000', 'sophia.martinez@worldgames.com', '888-99-00011'),
(3080, 50, 'Matthew', 'Rodriguez', '+5 777 888 999', 'matthew.rodriguez@worldgames.com', '777-88-99900'),
(3090, 50, 'Ava', 'Hernandez', '+5 000 111 222', 'ava.hernandez@worldgames.com', '000-11-22233'),
(3100, 60, 'Andrew', 'Lopez', '+6 999 000 111', 'andrew.lopez@worldgames.com', '999-00-11122'),
(3110, 60, 'Emma', 'Gomez', '+6 222 333 444', 'emma.gomez@worldgames.com', '222-33-44455'),
(3120, 70, 'Ethan', 'Perez', '+7 111 222 333', 'ethan.perez@worldgames.com', '111-22-33344'),
(3130, 70, 'Isabella', 'Taylor', '+7 444 555 666', 'isabella.taylor@worldgames.com', '444-55-66677'),
(3140, 80, 'Christopher', 'Anderson', '+8 333 444 555', 'christopher.anderson@worldgames.com', '333-44-55566'),
(3150, 80, 'Mia', 'Brown', '+8 666 777 888', 'mia.brown@worldgames.com', '666-77-88899'),
(3160, 90, 'Elijah', 'Harris', '+9 555 666 777', 'elijah.harris@worldgames.com', '555-66-77788'),
(3170, 90, 'Olivia', 'Clark', '+9 888 999 000', 'olivia.clark@worldgames.com', '888-99-00011'),
(3180, 100, 'James', 'King', '+10 777 888 999', 'james.king@worldgames.com', '777-88-99900'),
(3190, 100, 'Ava', 'Wright', '+10 000 111 222', 'ava.wright@worldgames.com', '000-11-22233'),
(3200, 110, 'Logan', 'Scott', '+11 999 000 111', 'logan.scott@worldgames.com', '999-00-11122'),
(3210, 110, 'Sophia', 'Young', '+11 222 333 444', 'sophia.young@worldgames.com', '222-33-44455'),
(3220, 120, 'Benjamin', 'Hall', '+12 111 222 333', 'benjamin.hall@worldgames.com', '111-22-33344'),
(3230, 120, 'Lily', 'White', '+12 444 555 666', 'lily.white@worldgames.com', '444-55-66677')
;


INSERT INTO TransactionRecord (TransactionID, CustomerID, StoreID, EmployeeID, TransactionDate, SubTotal, SalesChannel, Discount, TaxAmount, Total) VALUES
(1, 1001, 10, 3000, '2022-01-01', 269.95, 'Physical', 0, 30, 299.95),
(2, 1002, 20, 3010, '2021-08-20', 119.98, 'Physical', 0, 50, 169.98),
(3, 1003, 30, 3020, '2020-02-03', 49.99, 'Online', 0, 10, 59.99),
(4, 1004, 40, 3030, '2023-05-13', 159.97, 'Physical', 5, 10, 164.97),
(5, 1005, 50, 3040, '2023-01-05', 129.98, 'Online', 20, 20, 129.98),
(6, 1006, 60, 3050, '2023-08-06', 59.99, 'Physical', 15, 30, 74.99),
(7, 1007, 70, 3060, '2023-10-07', 49.99, 'Physical', 5, 5, 49.99),
(8, 1008, 80, 3070, '2023-01-08', 109.97, 'Physical', 10, 20, 119.97),
(9, 1009, 90, 3080, '2023-05-09', 109.98, 'Online', 5, 0, 104.98),
(10, 1010, 100, 3090, '2023-07-10', 89.98, 'Physical', 0, 10, 99.98),
(11, 1011, 110, 3100, '2023-05-11', 59.98, 'Physical', 0, 20, 79.98),
(12, 1012, 120, 3110, '2023-06-12', 69.98, 'Online', 0, 10, 79.98),
(13, 1013, 10, 3000, '2023-08-13', 119.98, 'Physical', 10, 0, 109.98),
(14, 1014, 20, 3010, '2023-09-14', 59.99, 'Physical', 0, 20, 79.99),
(15, 1015, 30, 3020, '2020-11-15', 49.99, 'Online', 15, 25, 59.99),
(16, 1016, 40, 3030, '2023-11-16', 39.98, 'Physical', 10, 10, 39.98),
(17, 1017, 50, 3040, '2022-12-12', 29.99, 'Online', 15, 15, 29.99),
(18, 1018, 60, 3050, '2021-01-08', 39.99, 'Physical', 20, 20, 39.99),
(19, 1019, 70, 3060, '2023-02-19', 29.99, 'Physical', 10, 20, 39.99),
(20, 1020, 80, 3070, '2022-04-20', 49.99, 'Physical', 0, 10, 59.99),
(21, 1021, 90, 3080, '2020-03-01', 119.98, 'Online', 10, 0, 109.98),
(22, 1022, 100, 3090, '2022-03-29', 59.99, 'Physical', 0, 20, 79.99),
(23, 1023, 110, 3100, '2021-02-27', 59.99, 'Physical', 0, 10, 69.99),
(24, 1024, 120, 3110, '2022-02-09', 89.98, 'Online', 10, 20, 99.98),
(25, 1025, 10, 3000, '2020-01-25', 59.99, 'Physical', 0, 10, 69.99),
(26, 1026, 20, 3010, '2020-12-12', 59.99, 'Physical', 0, 10, 69.99),
(27, 1027, 30, 3020, '2023-01-12', 49.99, 'Online', 5, 25, 69.99),
(28, 1028, 40, 3030, '2023-12-25', 29.99, 'Physical', 20, 10, 19.99),
(29, 1029, 50, 3040, '2022-12-23', 69.99, 'Online', 0, 10, 79.99),
(30, 1003, 60, 3050, '2020-11-24', 59.99, 'Physical', 15, 5, 49.99),
(31, 1001, 70, 3060, '2023-01-31', 49.99, 'Physical', 10, 10, 49.99),
(32, 1012, 80, 3070, '2023-06-01', 39.99, 'Physical', 20, 10, 29.99),
(33, 1023, 90, 3080, '2022-04-20', 119.98, 'Online', 50, 0, 69.98),
(34, 1021, 100, 3090, '2023-02-23', 69.99, 'Physical', 20, 20, 69.99),
(35, 1009, 110, 3100, '2020-12-14', 29.99, 'Physical', 10, 20, 39.99),
(36, 1017, 120, 3110, '2020-01-05', 19.99, 'Online', 10, 0, 9.99),
(37, 1022, 10, 3000, '2023-02-06', 59.99, 'Physical', 0, 10, 69.99),
(38, 1011, 20, 3010, '2023-03-04', 59.99, 'Physical', 0, 0, 59.99),
(39, 1022, 30, 3020, '2022-07-20', 59.99, 'Online', 0, 20, 79.99),
(40, 1004, 40, 3030, '2023-07-14', 59.99, 'Physical', 10, 10, 59.99);

-- Transaction Details
INSERT INTO TransactionDetails (TransactionDetailID, TransactionID, GamePlatformID, Quantity) VALUES
(1, 2, 1000, 1),
(2, 1, 1010, 1),
(3, 1, 1020, 3),
(4, 4, 1030, 1),
(5, 4, 1040, 1),
(6, 6, 1050, 1),
(7, 7, 1060, 1),
(8, 8, 1070, 1),
(9, 9, 1080, 1),
(10, 10, 1090, 1),
(11, 11, 1100, 1),
(12, 12, 1110, 1),
(13, 1, 1000, 2),
(14, 2, 1010, 1),
(15, 3, 1020, 1),
(16, 4, 1050, 1),
(17, 5, 1040, 1),
(18, 5, 1050, 1),
(19, 8, 1060, 1),
(20, 8, 1100, 1),
(21, 9, 1180, 1),
(22, 10, 1290, 1),
(23, 11, 1200, 1),
(24, 12, 1210, 1),
(25, 25, 1000, 1),
(26, 26, 1010, 1),
(27, 27, 1020, 1),
(28, 28, 1030, 1),
(29, 29, 1040, 1),
(30, 30, 1050, 1),
(31, 31, 1060, 1),
(32, 32, 1070, 1),
(33, 33, 1080, 2),
(34, 34, 1090, 1),
(35, 35, 1100, 1),
(36, 36, 1110, 1),
(37, 37, 1000, 1),
(38, 38, 1010, 1),
(39, 39, 1020, 1),
(40, 40, 1010, 1),
(41, 13, 1250, 1),
(42, 14, 1320, 1),
(43, 15, 1140, 1),
(44, 16, 1210, 2),
(45, 17, 1130, 1),
(46, 18, 1310, 1),
(47, 19, 1190, 1),
(48, 20, 1180, 1),
(49, 21, 1010, 2),
(50, 22, 1010, 1),
(51, 23, 1150, 1),
(52, 24, 1150, 1), 
(53, 24, 1190, 1)
;

-- Suppliers
INSERT INTO Supplier (SupplierID, SupplierName, Email, PhoneNumber, AddressID) VALUES
(1, 'GameSupplier1', 'supplier1@email.com', '+1 555 123 4567', 102),
(2, 'GameSupplier2', 'supplier2@email.com', '+44 20 9876 5432', 103),
(3, 'GameSupplier3', 'supplier3@email.com', '+49 30 2345 6789', 109),
(4, 'GameSupplier4', 'supplier4@email.com', '+33 1 8765 4321', 106),
(5, 'GameSupplier5', 'supplier5@email.com', '+81 3 4321 8765', 105),
(6, 'GameSupplier6', 'supplier6@email.com', '+1 555 987 6543', 104),
(7, 'GameSupplier7', 'supplier7@email.com', '+44 20 8765 4321', 107),
(8, 'GameSupplier8', 'supplier8@email.com', '+55 11 2345 6789', 108),
(9, 'GameSupplier9', 'supplier9@email.com', '+82 2 9876 5432', 110),
(10, 'GameSupplier10', 'supplier10@email.com', '+7 495 234 5678', 114);

-- Supplies
INSERT INTO Supply (SupplyID, SupplierID, GamePlatformID, Quantity, Cost) VALUES
(1, 1, 1000, 100, 1000.00),
(2, 2, 1200, 50, 500.00),
(3, 3, 1030, 75, 750.00),
(4, 4, 1040, 30, 300.00),
(5, 5, 1150, 120, 1200.00),
(6, 6, 1060, 50, 500.00),
(7, 7, 1170, 20, 200.00),
(8, 8, 1180, 30, 300.00),
(9, 9, 1090, 10, 100.00),
(10, 10, 1010, 40, 400.00),
(11, 1, 1110, 25, 250.00),
(12, 10, 1220, 60, 600.00),
(13, 7, 1110, 45, 450.00),
(14, 6, 1140, 15, 150.00),
(15, 5, 1050, 80, 800.00),
(16, 8, 1160, 25, 250.00),
(17, 3, 1070, 10, 100.00),
(18, 4, 1080, 15, 150.00),
(19, 9, 1190, 5, 50.00),
(20, 2, 1020, 30, 300.00)
;

-- Rating
INSERT INTO Rating (RatingID, CustomerID, GamePlatformID, RatingValue, Comment, RatingDate) VALUES
(1, 1001, 1010, 4.5, 'Great game! Enjoyed the graphics and gameplay.', '2020-01-20'),
(2, 1002, 1000, 3.2, 'Interesting storyline but could use better graphics.', '2022-02-10'),
(3, 1010, 1090, 4.8, 'SimCity is addictive! Spent hours building my city.', '2021-03-15'),
(4, 1005, 1040, 3.7, 'Call of Duty never disappoints, but this one lacked innovation.', '2023-04-01'),
(5, 1006, 1050, 5.0, 'Final Fantasy is a masterpiece! Loved every moment of it.', '2022-05-25'),
(6, 1011, 1100, 4.1, 'FIFA 22 has improved gameplay, but the career mode could be better.', '2023-07-20'),
(7, 1012, 1110, 2.5, 'The graphics could be more realistic.', '2020-08-30'),
(8, 1003, 1020, 4.9, 'Amazing horror experience.', '2021-09-18'),
(9, 1004, 1030, 3.0, ' ', '2020-10-10'),
(10, 1009, 1080, 4.5, 'Still a great puzzle game after all these years.', '2023-11-30')
;

/* ==========================================================================================================================

													TRIGGER UPDATE STOCK
	
========================================================================================================================== */ 

-- trigger 1 -> update stock after insert new transaction
DELIMITER //
CREATE TRIGGER after_sell_update
AFTER INSERT ON TransactionDetails
FOR EACH ROW
BEGIN
    UPDATE Inventory, TransactionRecord
    SET QuantityInStock = QuantityInStock - NEW.Quantity
    WHERE Inventory.GamePlatformID = NEW.GamePlatformID
        AND Inventory.StoreID = (SELECT StoreID FROM TransactionRecord WHERE TransactionID = NEW.TransactionID)
        AND TransactionRecord.TransactionID = NEW.TransactionID;
END;
//
DELIMITER ;

INSERT INTO TransactionRecord (TransactionID, CustomerID, StoreID, EmployeeID, TransactionDate, SubTotal, SalesChannel, Discount, TaxAmount, Total) VALUES
(41, 1029, 70, 3000, '2023-12-13', 109.98, 'Online', 0, 0, 109.98),
(42, 1027, 30, 3010, '2023-12-12', 69.99, 'Physical', 0, 30, 99.99);

INSERT INTO TransactionDetails (TransactionDetailID, TransactionID, GamePlatformID, Quantity) VALUES
(54, 41, 1120, 1), # 25 -> 24
(55, 41, 1170, 1), # 25 -> 24
(56, 42, 1040, 1); # 24 -> 24

select * from log;
/* ==========================================================================================================================

														  QUERIES
	
========================================================================================================================== */ 

-- 1. List all the customer’s names, dates, and products or services used/booked/rented/bought by
-- these customers in a range of two dates

SELECT CONCAT(c.FirstName, " ", c.LastName) as Name, tr.TransactionDate, g.Title as GameName
FROM customer c, transactionrecord tr, transactiondetails td, gameplatform gp, game g
WHERE c.CustomerID = tr.CustomerID 
	and tr.TransactionID = td.TransactionID 
    and td.GamePlatformID = gp.GamePlatformID 
    and gp.GameID = g.GameID 
    and ( tr.TransactionDate > "2023-01-01" and tr.TransactionDate < CURRENT_DATE() )
ORDER BY tr.TransactionDate
;

-- 2 List the best three customers/products/services/places (you are free to define the criteria for what means “best”)
-- we consider the best as the customer that spent the most amount of money

SELECT c.CustomerID, CONCAT(c.FirstName, ' ', c.LastName) as CustomerName, SUM(tr.Total) as TotalSpent
FROM customer c, transactionrecord tr
WHERE c.CustomerID = tr.CustomerID
GROUP BY c.CustomerID, CustomerName
ORDER BY TotalSpent desc
LIMIT 3
;

-- 3 Get the average amount of sales/bookings/rents/deliveries for a period that involves 2 or more 
-- years, as in the following example. This query only returns one record:

SELECT CONCAT( MIN(tr.TransactionDate)," - " ,  MAX(tr.TransactionDate)) as PeriodOfSales,
	CONCAT( SUM(Total), " €") as TotalSales, 
    CONCAT( ROUND( SUM(Total) / COUNT( DISTINCT year(TransactionDate)),2), " €")  as YearlyAverage,
    CONCAT( ROUND( SUM(Total) / COUNT( DISTINCT DATE_FORMAT(TransactionDate, '%Y-%m')), 2), " €")  as MonthlyAverage
FROM transactionrecord tr
;

-- 4 Get the total sales/bookings/rents/deliveries by geographical location (city/country).

-- city
SELECT ci.CityName, SUM(tr.Total) as TotalSales
FROM transactionrecord tr, store s, address a, city ci
WHERE tr.StoreID = s.StoreID 
	and s.AddressID = a.AddressID 
    and a.CityID = ci.CityID
GROUP BY ci.CityName
;

-- country
SELECT co.CountryName, SUM(tr.Total) as TotalSales
FROM transactionrecord tr, store s, address a, city ci, country co
WHERE tr.StoreID = s.StoreID 
	and s.AddressID = a.AddressID 
	and a.CityID = ci.CityID 
    and ci.CountryID = co.CountryID
GROUP BY co.CountryName
;

-- 5 List all the locations where products/services were sold, and the product has customer’s ratings

SELECT s.StoreName, a.StreetAddress, c.CityName
FROM rating r, TransactionDetails td, TransactionRecord tr, Store s, Address a, City c
WHERE r.CustomerID = tr.CustomerID 
	and r.GamePlatformID = td.GamePlatformID
	and td.TransactionID = tr.TransactionID
    and s.StoreID = tr.StoreID
    and s.AddressID = a.AddressID
    and c.CityID = a.CityID
;


/* ==========================================================================================================================

															VIEWS
	
========================================================================================================================== */ 

-- View1 -> Transaction, data, client info, store info, total
CREATE OR REPLACE VIEW header_total_view AS
SELECT distinct tr.TransactionID, tr.TransactionDate, concat(c.FirstName, " ", c.LastName) as Customer_Name, 
	a1.StreetAddress as Customer_Address, ci1.CityName as Customer_City, co1.CountryName as Customer_Country,
    s.StoreName, a2.StreetAddress as Store_Address, ci2.CityName as Store_City, co2.CountryName as Store_Country,
    tr.SubTotal, tr.Discount, ROUND((tr.Discount/tr.SubTotal)*100,2) as Discount_Rate, tr.TaxAmount, 
    ROUND((tr.TaxAmount/tr.SubTotal)*100,2) as Taxt_Rate, (tr.SubTotal - tr.Discount + tr.TaxAmount) as Total
FROM transactionrecord tr, transactiondetails td, Customer c, Store s, Address a1, City ci1, Country co1, -- connection to customer address
	Address a2, City ci2, Country co2 -- connection to store address
WHERE tr.TransactionID = td.TransactionID 
	and tr.CustomerID = c.CustomerID 
	and tr.StoreID = s.StoreID
    and c.AddressID = a1.AddressID 
    and s.AddressID = a2.AddressID
    and a1.CityID = ci1.CityID 
    and ci1.CountryID = co1.CountryID
	and a2.CityID = ci2.CityID 
    and ci2.CountryID = co2.CountryID
ORDER BY tr.TransactionID
;
SELECT * FROM header_total_view;


-- View2 -> transaction details
CREATE OR REPLACE VIEW transaction_detail_view as
SELECT td.TransactionID, g.Title, p.PlatformName, gp.Price, td.Quantity
FROM transactiondetails td, GamePlatform gp, Game g, Platform p 
WHERE td.GamePlatformID = gp.GamePlatformID 
	and gp.GameID = g.GameID 
    and gp.PlatformID = p.PlatformID
ORDER BY td.TransactionID
;

SELECT * FROM transaction_detail_view;