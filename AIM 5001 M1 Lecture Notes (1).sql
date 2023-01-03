-- AIM 5001 Module 1 Lecture Notes: Intro to SQL & PostgreSQL


-- NOTE: All examples shown below make use of the content of the Chinook database.

-- Please be sure to install + verify the installation of the Chinook database before attempting
-- to execute these queries within your own PostgreSQL environment !!

---------------------------------------------------------------------------------------

-- SQL QUERY BASICS

-- How to select data from a table: The SELECT statement

-- General SELECT Syntax:
SELECT <Column List> 
FROM <Table Name> 
WHERE <Search Condition>;

-- **IMPORTANT**: Note that PostgreSQL requires that we enclose any mixed-case table or table attribute names within double quotes (e.g., “YourTableName“) within the context of any SQL statement, and every SQL statement MUST be terminated with a semicolon (;). This syntactical requirement is peculiar to PostgreSQL: Many other relational database systems do not require the use of double quotes when specifying tables or attributes whose names are comprised of a mix of uppercase and lowercase characters.
 
-------------------------------

-- The FROM keyword is used for purposes of specifying the table(s) for which we wish to apply our SELECT statement.

-- An asterisk (*) is used as a "wildcard" search criteria within SQL, and is most often used as a wildcard for the list of columns to which a SQL query should be applied.

-- Example: Write a SELECT statement that returns all of the columns in the Album table 

SELECT * FROM "Album";

-- This query will return the contents of all of the columns contained within the "Album" table.

-- To exit from the query results, simply enter 'q' within the psql shell. This will force a return to the chinook=# prompt

-------------------------------

-- To restrict our search to a specific subset of the columns contained within a table, we specify the names of the columns following the SELECT keyword and prior to the FROM keyword.


-- Example: Write a SELECT statement that returns the content of the "AlbumId" column within the "Album" table:

SELECT “AlbumId” FROM “Album”;

-- Example: Write a SELECT statement that returns the content of the "AlbumId" and "Title" columns within the "Album" table:

SELECT “AlbumId”, "Title" FROM “Album”;
------------------------------- 

-- The COUNT() function can be used for purposes of summing the number of items that satisfy the specified search criteria.

-- Example: Write a SELECT statement that returns a count of the number of items contained within the Album table 

SELECT COUNT(*) FROM "Album";

-------------------------------

-- We use the WHERE keyword for purposes of imposing our own search-limiting criteria on a query

-- Example: Write a SELECT statement that returns a list containing the first name and last name of all Chinook customers who live in Brazil

SELECT "FirstName",
"LastName"
FROM "Customer"
WHERE "Country" = 'Brazil';

------------------------------

-- Boolean operators (e.g., "AND", "OR") and logic operators (e.g., ">", "<", "<>" (i.e, "not equal"), etc.) can be included in our WHERE clauses to provide greater specificity.

-- EXAMPLE: Write a SELECT statement that returns a list containing the first name, last name, and country name for all Chinook customers living in either Brazil or Spain:

SELECT "FirstName",
"LastName",
"Country"
FROM "Customer"
WHERE "Country" = 'Brazil'
OR "Country" = 'Spain';

-- EXAMPLE: Write a SELECT statement that returns a list containing the first name, last name, and country name for all Chinook customers living who DO NOT live in Brazil:

SELECT "FirstName",
"LastName",
"Country"
FROM "Customer"
WHERE "Country" <> 'Brazil';

-----------------------------------

-- SORTING QUERY RESULTS: We can use the ORDER BY keyword to automatically sort our query results.

-- EXAMPLE: Write a SELECT statement that returns a list containing the first name, last name, and country name for all Chinook customers living in either Brazil or Spain, ordered by last name:

SELECT "FirstName",
"LastName",
"Country"
FROM "Customer"
WHERE "Country" = 'Brazil'
OR "Country" = 'Spain'
ORDER BY "LastName";

-- EXAMPLE: Write a SELECT statement that returns a list containing the first name, last name, and country name for all Chinook customers living in either Brazil or Spain, ordered by last name AND country. This query forces every customer pertaining to a country to be listed together:

SELECT "FirstName",
"LastName",
"Country"
FROM "Customer"
WHERE "Country" = 'Brazil'
OR "Country" = 'Spain'
ORDER BY "Country", "LastName";

-- NOTE that the ORDER BY keyword by default will sort the results in ASCENDING order. If we'd prefer to specify the sort order, we can use the ASC (for "ascending") and DESC (for "descending") keywords to force the results to be ordered in the manner of our own choosing.

-- EXAMPLE: Write a SELECT statement that returns a list containing concatenated first name and last name, and country name for all Chinook customers living in either Brazil or Spain, ordered by last names in descending order:


SELECT
"LastName" || ',' || "FirstName" AS "Name",
"Country"
FROM "Customer"
WHERE "Country" = 'Brazil'
OR "Country" = 'Spain'
ORDER BY "Name" DESC;

-- Note in this example we have retrieved the LastName and FirstName columns from the Customer table and combined them into a new temporary variable "Name". This is an example of deriving a "Calculated Field" (i.e., combining the LastName and FirstName columns) and using an "alias" (i.e., the "Name" identifier) as the name of the result of our calculation. This temporary "alias" field will exist ONLY during the execution of the query: It is not stored within the Customer table or anywhere else within the database.

---------------------------------------------------------------------------------------

-- AGGREGATING & SUMMARIZING DATA (GROUP BY)
-- the use of the GROUP BY statement in conjunction with one or more “aggregating” functions (e.g., MAX, MIN, AVG, etc.) allows us to automate the process of aggregating and grouping data based on criteria that we specify.

-- General Aggregating + Grouping Syntax:

SELECT <Column List>, 
<Aggregate Function>(<Column Name>) 
FROM <Table Name> 
WHERE <Search Condition> 
GROUP BY <Column List>

-- EXAMPLE: Write a query that calculates the sum total of invoice amounts for each unique customer

SELECT "CustomerId", SUM("Total") FROM "Invoice" GROUP BY "CustomerId";


-- EXAMPLE: Write a query that calculates the sum total of invoice amounts for each unique customer and displays the results in descending order of the sum totals

SELECT "CustomerId", SUM("Total") FROM "Invoice" GROUP BY "CustomerId" ORDER BY SUM("Total") DESC;



-- EXAMPLE: Write a query that identifies the largest invoice amount for each customer.

SELECT "CustomerId", MAX("Total") FROM "Invoice" GROUP BY "CustomerId";


-- EXAMPLE: Write a query that identifies the largest invoice amount for each customer and displays the results in descending order of the invoice amounts

SELECT "CustomerId", MAX("Total") FROM "Invoice" GROUP BY "CustomerId" ORDER BY MAX("Total") DESC;


-- EXAMPLE: Write a query that calculates the number of Chinook employees per PostalCode

SELECT "PostalCode", COUNT(*) FROM "Employee" GROUP BY "PostalCode";

---------------------------------------------------------------------------------------

-- CREATING TABLES + PRIMARY & FOREIGN KEYS

-- When creating a table, consider the need for unique identifiers for every item to be stored within the table as well as whether we should include references to data contained within other tables residing within the same database.

-- General Table Creation Syntax:

CREATE TABLE <Table Name> ( Column1 DataType, Column2 DataType, Column3 DataType, …. )

---------------------------------------------------

-- EXAMPLE: Create the Chinook "Album" table 
-- Note the use of the PRIMARY KEY keyword: In this example, we are establishing "AlbumId" as a unique identifier for all items to be stored within the table. We are also specifying via the NOT NULL keyword that for every item stored within the table, the "AlbumId", "Title", and "ArtistId" columns are not permitted to be devoid of a data value.

-- NOTE: DO NOT RUN THESE EXAMPLE QUERIES: THESE TABLES ALREADY EXIST WITHIN THE CHINOOK DATABASE

CREATE TABLE "Album"
(
    "AlbumId" INT NOT NULL,
    "Title" VARCHAR(160) NOT NULL,
    "ArtistId" INT NOT NULL,
    CONSTRAINT "PK_Album" PRIMARY KEY  ("AlbumId")
);

-----------------------------------------------------

-- FOREIGN KEYS: How to explicitly link two or more tables together + ensure data integrity is maintained across all affected tables.

-- EXAMPLE: In the Chinook database, the "Track" table contains references to items contained within the "Album", "MediaType", and "Genre" tables. We formalize these relationships via the use of the FOREIGN KEY keyword. Note how in PostgreSQL, instantiation of a foreign key is a two-step process: First, we use the "ALTER TABLE" command to restrict the content of the indicated table column to valid values contained within the foreign table; Then, we impose a secondary restriction on the foreign table via the CREATE INDEX command that binds the FOREIGN KEY values within the specified foreign table to the new FOREIGN KEY we've instantiated within our primary table. Once two or more tables have been linked in this way, we cannot delete an item from the foreign table without necessarily deleting all related items from the primary table. Failure to do so would leave us with data values within our primary table that can no longer be referenced within the foreign table.

-- Create the "Genre" table

CREATE TABLE "Genre"
(
    "GenreId" INT NOT NULL,
    "Name" VARCHAR(120),
    CONSTRAINT "PK_Genre" PRIMARY KEY  ("GenreId")
);

-- Create the "MediaType" table

CREATE TABLE "MediaType"
(
    "MediaTypeId" INT NOT NULL,
    "Name" VARCHAR(120),
    CONSTRAINT "PK_MediaType" PRIMARY KEY  ("MediaTypeId")
);

-- Create the "Track" table

CREATE TABLE "Track"
(
    "TrackId" INT NOT NULL,
    "Name" VARCHAR(200) NOT NULL,
    "AlbumId" INT,
    "MediaTypeId" INT NOT NULL,
    "GenreId" INT,
    "Composer" VARCHAR(220),
    "Milliseconds" INT NOT NULL,
    "Bytes" INT,
    "UnitPrice" NUMERIC(10,2) NOT NULL,
    CONSTRAINT "PK_Track" PRIMARY KEY  ("TrackId")
);

-- Add a FOREIGN KEY constraint on the "GenreId" field within the "Track" table
ALTER TABLE "Track" ADD CONSTRAINT "FK_TrackGenreId"
    FOREIGN KEY ("GenreId") REFERENCES "Genre" ("GenreId") ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX "IFK_TrackGenreId" ON "Track" ("GenreId");

-- Add a FOREIGN KEY constraint on the "AlbumId" field within the "Track" table
ALTER TABLE "Track" ADD CONSTRAINT "FK_TrackAlbumId"
    FOREIGN KEY ("AlbumId") REFERENCES "Album" ("AlbumId") ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX "IFK_TrackAlbumId" ON "Track" ("AlbumId");

-- Add a FOREIGN KEY constraint on the "MediaTypeId" field within the "Track" table
ALTER TABLE "Track" ADD CONSTRAINT "FK_TrackMediaTypeId"
    FOREIGN KEY ("MediaTypeId") REFERENCES "MediaType" ("MediaTypeId") ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX "IFK_TrackMediaTypeId" ON "Track" ("MediaTypeId");

---------------------------------------------------------------------------------------

-- INSERT, DELETE, & MODIFY DATA WITHIN SQL TABLES

---------------------------------------

-- How to INSERT data into a table: In this example, we are adding a new genre name to the "Genre" table. Note the use of the N prefix prior to the new data value. The N prefix tells PostgreSQL to store the new data value as an NVARCHAR item within the VARCHAR "Name" column. The use of NVARCHAR format within the VARCHAR variable forces PostgreSQL to store the new value in UNICODE format as opposed to ASCII. However, if your own work requires the strict use of ASCII, you should not use the N prefix on your insert statements. For our Chinook database, all data is stored in UNICODE format.


-- General INSERT Syntax:

INSERT INTO <Table Name> (<Column List>) VALUES (<Values>)

INSERT INTO "Genre" ("GenreId", "Name") VALUES (26, N'Fusion');

-- Check results

SELECT * FROM "Genre";

---------------------------------------

-- How to UPDATE data in a table

-- General UPDATE Syntax:

UPDATE <Table Name> SET <Column1> = <Value1>, <Column2> = <Value2>, … WHERE <Search Condition>

UPDATE "Genre" SET "Name" = 'Progressive' WHERE "Name" = 'Fusion';

-- Check results

SELECT * FROM "Genre";

---------------------------------------

-- How to DELETE data from a table

-- General DELETE Syntax:

DELETE FROM <Table Name> WHERE <Search Condition>

DELETE FROM "Genre" WHERE "Name" = 'Progressive';

-- Check results

SELECT * FROM "Genre";