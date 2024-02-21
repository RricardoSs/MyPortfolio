# World Games Database Design Project 🎮
## Context

Imagine a scenario of an Online Marketplace that facilitates the buying and selling of products. This e-commerce platform requires a robust relational database to manage various aspects of its business process.

In alignment with the provided guidelines, we applied these principles to the establishment of "WorldGames," a multinational store specializing in the sale of video games. WorldGames operates in numerous physical locations across the globe and maintains a robust online platform. To efficiently manage the complex dynamics of a global gaming retail business, a sophisticated relational database system is essential. The ERD design, triggers, and analysis will be tailored to WorldGames' intricate business processes, combining the intricacies of online and offline retail operations in the gaming sector.

## Task

In this project, I assumed responsibility for the ERD design and conducted a comprehensive review of the entire project, ensuring alignment with the company's processes and project goals. Our primary emphasis was on achieving all project objectives and gaining a thorough understanding of the essential components of ERD design.

The project encompassed the meticulous design of the ERD, the incorporation of fictional data (assisted by ChatGPT), the integration of two crucial business rules through triggers, and a concise analysis of specific aspects outlined in the project guidelines. We aimed to not only meet but exceed the set objectives, fostering a clear comprehension of the intricacies involved in ERD design and its pivotal role in the broader project framework.

## Outline

- **ERD Design**

To initiate the project, our initial focus was on meticulously defining the Entity Relationship Diagram through code. Each table was crafted by outlining its key columns, specifying their data types, and establishing the relationships with previously created tables. Following a systematic approach, we started by constructing independent tables and gradually interlinking them with subsequent tables. Below is an excerpt exemplifying three tables within the ERD, showcasing the structured evolution of our relational database design:

```mysql
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
```


- **Conceptual Model**

The next step was transforming the database created into the conceptual model having the overview of the whole database and the connections between tables, and making any adjustments.

<img width="1022" alt="DB Design" src="https://github.com/RricardoSs/MyPortfolio/assets/105722848/6f4c5be9-6ae8-4b0d-acf3-00ba745d535b">

- **Triggers / Implementation of Business Rules**

After having the database visually represented our next goal was to create the 2 integration rules necessary as part of the project. At the same time, we implemented some data into the database (fictional data as mentioned), not only for future “analysis” but also to test if the triggers were working correctly.

1. The first trigger was “**for updates (you can choose any updating process)”.** We

```mysql
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
```

This trigger was implemented after the insertion of data, since it was necessary data to update something. 

The trigger updates the “Inventory” table by subtracting the sold quantity (NEW.Quantity) from the corresponding game's stock in the "Inventory" table. It identifies the relevant game and store by matching the "GamePlatformID" and "StoreID" conditions. Additionally, it ensures the update is applied to the correct transaction by referencing the "TransactionID" in both the "Inventory" and "TransactionRecord" tables.

2. The second trigger has the goal of **inserting a row in a “log” table.** We

```mysql
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
```

The designed trigger serves a straightforward purpose by inserting a row in the "Log" table with the type of action undertaken and the corresponding date. Given that every action on the "Transaction" table involves an insertion, we defined the trigger to activate post-insertion. The trigger appends each type of action and the precise date of the insertion moment. This approach enhances the audit trail within the system, providing a transparent record of actions taken on the "Transaction" table.

---

- **Queries & Analysis of Data**

The next step of the project was to create a sequence of queries to retrieve specific information about the fictional store. The following queries made were:

1. A query to list all the customers’ names, dates, and products bought by these customers in a range of two dates, this date was chosen at random. Where the work done was mostly to connect the tables and extract the correct information for each.

```mysql
SELECT CONCAT(c.FirstName, " ", c.LastName) as Name, tr.TransactionDate, g.Title as GameName
FROM customer c, transactionrecord tr, transactiondetails td, gameplatform gp, game g
WHERE c.CustomerID = tr.CustomerID 
		and tr.TransactionID = td.TransactionID 
    and td.GamePlatformID = gp.GamePlatformID 
    and gp.GameID = g.GameID 
    and ( tr.TransactionDate > "2023-01-01" and tr.TransactionDate < CURRENT_DATE() )
ORDER BY tr.TransactionDate
;
```

2. A query to list only the best three customers (we consider the best customers as the ones who spent the most amount of money). Here we order the total spent by each customer (from highest to smallest) and then selected only the first 3.

```mysql
SELECT c.CustomerID, CONCAT(c.FirstName, ' ', c.LastName) as CustomerName, SUM(tr.Total) as TotalSpent
FROM customer c, transactionrecord tr
WHERE c.CustomerID = tr.CustomerID
GROUP BY c.CustomerID, CustomerName
ORDER BY TotalSpent desc
LIMIT 3
;
```

3. Get the average amount of sales for a period that involves 2 or more years, as in the following example, and it only returns one example. In this query we used a lot of concat to get the required format of the table, additionally, we used mathematical functions to get the information about the total, and other temporal functions to get information about the total across the time (yearly or monthly).

| PeriodOfSales | TotalSales(€) | YearlyAverage | MonthlyAverage |
| --- | --- | --- | --- |
| 01/2010 - 10/2021 | XXX € | XXX € | XXX € |

```mysql
SELECT CONCAT( MIN(tr.TransactionDate)," - " ,  MAX(tr.TransactionDate)) as PeriodOfSales,
		CONCAT( SUM(Total), " €") as TotalSales, 
    CONCAT( ROUND( SUM(Total) / COUNT( DISTINCT year(TransactionDate)),2), " €")  as YearlyAverage,
    CONCAT( ROUND( SUM(Total) / COUNT( DISTINCT DATE_FORMAT(TransactionDate, '%Y-%m')), 2), " €")  as MonthlyAverage
FROM transactionrecord tr
;
```

4. Get the total sales by city. Similiar to previous queries, we made the connection between tables, and grouped the total sales by city.

```mysql
SELECT ci.CityName, SUM(tr.Total) as TotalSales
FROM transactionrecord tr, store s, address a, city ci
WHERE tr.StoreID = s.StoreID 
		and s.AddressID = a.AddressID 
    and a.CityID = ci.CityID
GROUP BY ci.CityName
;
```

5. List all the stores where products were sold, and the product has customer ratings. The major point of this query was to make the right connection between each table in the model, to extract the store with products with ratings, as an extra we also added the address and the city where that store was located.

```mysql
SELECT s.StoreName, a.StreetAddress, c.CityName
FROM rating r, TransactionDetails td, TransactionRecord tr, Store s, Address a, City c
WHERE r.CustomerID = tr.CustomerID 
		and r.GamePlatformID = td.GamePlatformID
		and td.TransactionID = tr.TransactionID
    and s.StoreID = tr.StoreID
    and s.AddressID = a.AddressID
    and c.CityID = a.CityID
```

---

- **Views**

As a final step of the project, it was asked to define 2 views in the database. The goal of these views is to imitate the output of a receipt after a client buys a game. 

<img width="357" alt="image" src="https://github.com/RricardoSs/MyPortfolio/assets/105722848/427f35ae-70ac-49aa-a806-aa4487342cba">

_Example of receipt given_

So the first view works as the header of information returning the number of transactions/receipts, the customer information, the store information, and the total, discount, and tax. Although confusing, it is again just the connection necessary between tables to make the view possible.

```mysql
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
```

The second view worked as the body of the receipt, returning the product bought in that transaction, and information about that sale, like price of the product and quantity. So each transaction would appear at least one, if in a transaction a customer bought more than one game, each product would have a different row.

```mysql
CREATE OR REPLACE VIEW transaction_detail_view as
SELECT td.TransactionID, g.Title, p.PlatformName, gp.Price, td.Quantity
FROM transactiondetails td, GamePlatform gp, Game g, Platform p 
WHERE td.GamePlatformID = gp.GamePlatformID 
	and gp.GameID = g.GameID 
    and gp.PlatformID = p.PlatformID
ORDER BY td.TransactionID
;
```

## Result

The culmination of our database creation, rule establishment, and analysis was very successful in my point of view. We were able to create a fully functional database, get an overview of the relationships existing on the diagram, create specific business rules, and make a small analysis based on fictional data. Overall it was a great project where we obtained a score of 19 out of 20. 

From my understanding, two things could be improved on this project. 1. the efficiency of the creation of the database, namely the primary key was not automatically generated in each row inserted, and later the long and maybe confusing queries. 2. the repetition made on the transaction table with the Total Sales and the other columns, where the Total Sales is a function of the SubTotal, the discount rate, and the Tax Rate, to fix either Total Sales or SubTotal would be necessary to be removed.

## Reflection

Overall it was a great experience to create an idea for a database based on a fictional business, and I am proud of my team for the great work done on the project, and of myself for the revision and hard work done on reviewing the goals of the project and adjusting major inconsistencies.
