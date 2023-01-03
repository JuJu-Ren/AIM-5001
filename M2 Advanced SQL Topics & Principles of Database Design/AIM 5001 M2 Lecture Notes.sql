-- AIM 5001 Module 2 Lecture Notes: Advanced SQL Topics & Principles of Database Design


-- NOTE: All examples shown below make use of the content of the Chinook database.

-- Please be sure to install + verify the installation of the Chinook database before attempting
-- to execute these queries within your own PostgreSQL environment !!

---------------------------------------------------------------------------------------

-- Data Aggregation & Grouping via SQL JOINs

-- We use JOINs to combine data from separate tables that share one or more data values or unique identifiers.

-- There are several different types of JOIN methods in SQL: Inner, Outer, Left, Right, Full, Self, and Cross

-- Refer to the "SQL Joins Cheat Sheet" provided within Canvas (see page M2 A.1)


-- See also this PostgreSQL tutorial on Joins: https://www.postgresqltutorial.com/postgresql-joins/

----------------------------------------------------------------------------------------

-- INNER JOINs

-- https://www.diffen.com/difference/Inner_Join_vs_Outer_Join

-- An inner join focuses on the commonality between two tables. When using an inner join, there must be at least some matching data between two (or more) tables that are being compared.

--         Basic Syntax

           SELECT <column list>
		   FROM TableA A
		   INNER JOIN TableB B
		   ON A.key = B.key
		  
---------

-- EXAMPLE: Write a query that returns a list of distinct customer ID's along with each customer's Sales Support Agent's EmployeeId, LastName, FirstName, and job title:

SELECT a."EmployeeId", a."LastName", a."FirstName", a."Title", b."CustomerId"
FROM "Employee" a
INNER JOIN "Customer" b
ON a."EmployeeId" = b."SupportRepId";

---------

-- EXAMPLE: Refine the results of the above query so that they are listed according to the the EmployeeId of each sales support agent

SELECT a."EmployeeId", a."LastName", a."FirstName", a."Title", b."CustomerId"
FROM "Employee" a
INNER JOIN "Customer" b
ON a."EmployeeId" = b."SupportRepId"
ORDER BY a."EmployeeId";
------------------------------------------------------------------------------------------

-- OUTER JOINs

-- -- https://www.diffen.com/difference/Inner_Join_vs_Outer_Join

-- An outer join returns a set of records (or rows) that include what an inner join would return but also includes other rows for which no corresponding match is found in the other table.

-- There are three types of outer joins:

-------------

--         Left Outer Join (or Left Join): 

--         Basic Syntax

           SELECT <column list>
		   FROM TableA A
		   LEFT JOIN TableB B
		   ON A.key = B.key

--         Returns entire content of 1st table in JOIN statement but only overlapping / common data from 2nd table

-- EXAMPLE: Write a query that calculates how many customers are supported by every Chinook employee, regardless of whether or not they work as a Sales Support Agent, and order the results by EmployeeId and including each employee's first name, last name, and title::

SELECT a."EmployeeId", a."FirstName", a."LastName", a."Title", COUNT(b."CustomerId")
FROM "Employee" a
LEFT JOIN "Customer" b
ON a."EmployeeId" = b."SupportRepId"
GROUP BY a."EmployeeId"
ORDER BY a."EmployeeId";

-----------------------------------------------------------------------

--         Right Outer Join (or Right Join)

--         Basic Syntax

           SELECT <column list>
		   FROM TableA A
		   RIGHT JOIN TableB B
		   ON A.key = B.key

		   
-- EXAMPLE: Write a query that calculates how many customers are supported by every Chinook Sales Support Agent, ordered by EmployeeId and including the Sales Support Agent's first name, last name, and title:

SELECT a."EmployeeId", a."FirstName", a."LastName", a."Title", COUNT(b."CustomerId")
FROM "Employee" a
RIGHT JOIN "Customer" b
ON a."EmployeeId" = b."SupportRepId"
GROUP BY a."EmployeeId"
ORDER BY a."EmployeeId";

------------------------------------------------------------------------------------

--         Full Outer Join (or Full Join)

--         Basic Syntax

           SELECT <column list>
		   FROM TableA A
		   FULL OUTER JOIN TableB B
		   ON A.key = B.key
		   
-- EXAMPLE: Write a query that, for each invoice, lists the customer ID, first name,last name, state, country of residence, invoice date, and invoice amount:

SELECT a."CustomerId", a."FirstName", a."LastName", a."State", a."Country", b."InvoiceDate", b."Total"
FROM "Customer" a
FULL OUTER JOIN "Invoice" b
ON a."CustomerId" = b."CustomerId";

---------------

-- EXAMPLE: Write a query that calculates how many customers the total amount spent by each customer to date, including the customer ID, first name,last name, state, country of residence, and the total amount of all invoices for each customer, ordered by the total amount invoices in descending order:

SELECT a."CustomerId", a."FirstName", a."LastName", a."State", a."Country", SUM(b."Total")
FROM "Customer" a
FULL OUTER JOIN "Invoice" b
ON a."CustomerId" = b."CustomerId"
GROUP BY a."CustomerId"
ORDER BY SUM(b."Total") DESC;

------------------------------------------------------------------------

-- Self Joins

-- A self join is basically a LEFT JOIN that acts upon only one table for purposes of matching records contained within a table to each other, e.g., if we want to compare or match one attribute within a given record to another attribute within the same record. For example, in the Chinook database we have a single table containing information on Employees. Within that table we are provided with a unique EmployeeId as well as a "ReportsTo" identifier that is itself comprised of EmployeeIds: The "ReportsTo" attribute is the EmployeeId of the person who has management / supervisory oversight over any given employee. Imagine we'd like to create a report showing a list of employee's and their supervisors. How might we accomplish this given that all of the relevant data are contained within a single table? The answer: A SELF JOIN !!


--         Basic Syntax

           SELECT <column list>
		   FROM TableA A
		   LEFT JOIN TableA B
		   ON A.key = B.otherkey
		   
-- EXAMPLE: Write a query that retrieves each employee, their job title, and their manager's name

SELECT emp."FirstName" || ' ' || emp."LastName" AS "Employee Name",
emp."Title" AS "Title",
sup."FirstName" || ' ' || sup."LastName" AS "Manager Name"
FROM "Employee" AS emp
LEFT JOIN "Employee" AS sup
ON emp."ReportsTo" = sup."EmployeeId"
ORDER BY emp."EmployeeId";

------------------------------------------------------------------------------

-- Cross Joins

-- A Cross Join retrieves the Cartesian product of both tables (i.e.,the combination of all records from both tables). Cross joins are not commonly used, but you should be aware of them.

--         Basic Syntax
           SELECT *
           FROM table1
		   CROSS JOIN table2;
		   
-- EXAMPLE: Write a query that provides the Cartesian Product of the Chinook database's Genre and MediaType tables.

SELECT *
FROM "Genre"
CROSS JOIN "MediaType";

------------------------------------------------------------------------------------

-- SUBQUERIES

-- A subquery can be described as a query embedded within another query: The results of an initial query (the subquery) are used as the data set to be searched by a second (or “parent”) query.

--         Basic Syntax

           SELECT <column list>
		   FROM TableA
		   WHERE <column from initial column list> IN (or use a boolean test instead of an IN keyword)
				(SELECT <column list> FROM  Table WHERE ...)
				
-- Example: Write a query that returns the customer ID, first name and last name of the customer who had the largest single invoice.

SELECT "CustomerId", "FirstName", "LastName"
FROM "Customer"
WHERE "CustomerId" IN
(SELECT "CustomerId"
FROM "Invoice"
WHERE "Total" >= (SELECT MAX("Total") FROM "Invoice") );
		   

------------------------------------------------------------------------------------

-- PRINCIPLES OF DATBASE DESIGN

-- Data Normalization: https://docs.microsoft.com/en-us/office/troubleshoot/access/database-normalization-description

-- Two primary goals: 

-- 1. ELIMINATE REDUNDANT DATA

-- One of the key goals of data normalization is to completely eliminate the duplication of data (with the exception of appropriate unique indentifiers). All "alterable" data values are to be stored in no more than one record within the database, and all tables that need to refer to such values should do so via the use of unique identifiers that have been appropriate instantiated as Foreign Keys within the database.

-- 2. ELIMINATE THE POTENTIAL FOR INSERT/UPDATE/DELETE ANAMOLIES

-- Maintaining the integrity of the data contained within a database requires that we prevent data from being altered within a relational database that other tables or records within that database are dependent on (e.g, we can't simply delete a record containing a primary key value if that value is used as a Foreign Key within other tables.)

-- When designing a relational database, we should strive to achieve what is referred to as "Third Normal Form". What are the three primary levels of normality?

-------------------------------
-- First Normal Form:

--			Eliminate repeating groups in individual tables.

--			Create a separate table for each set of related data.

--			Identify each set of related data with a primary key.

--			Do not use multiple fields in a single table to store similar data. For example, to track an inventory item that may come from two possible sources, an inventory record may contain fields for Vendor Code 1 and Vendor Code 2.

-- What happens when you add a third vendor? Adding a field is not the answer; it requires program and table modifications and does not smoothly accommodate a dynamic number of vendors. Instead, place all vendor information in a separate table called Vendors, then link inventory to vendors with an item number key, or vendors to inventory with a vendor code key.

-------------------------------
-- Second Normal Form:

--			Create separate tables for sets of values that apply to multiple records.

--			Relate these tables with a foreign key.


--			Records should not depend on anything other than a table's primary key (a compound key, if necessary). For example, consider a customer's address in an accounting system. The address is needed by the Customers table, but also by the Orders, Shipping, Invoices, Accounts Receivable, and Collections tables. Instead of storing the customer's address as a separate entry in each of these tables, store it in one place, either in the Customers table or in a separate Addresses table.

--------------------------------

-- Third Normal Form:

--			Eliminate fields that do not depend on the key.

--			Values in a record that are not part of that record's key do not belong in the table. In general, anytime the contents of a group of fields may apply to more than a single record in the table, consider placing those fields in a separate table.

--			For example, in an Employee Recruitment table, a candidate's university name and address may be included. But you need a complete list of universities for group mailings. If university information is stored in the Candidates table, there is no way to list universities with no current candidates. Create a separate Universities table and link it to the Candidates table with a university code key.

--------------------------------

-- EXCEPTION: Adhering to the third normal form, while theoretically desirable, is not always practical. If you have a Customers table and you want to eliminate all possible interfield dependencies, you must create separate tables for cities, ZIP codes, sales representatives, customer classes, and any other factor that may be duplicated in multiple records. In theory, normalization is worth pursing. However, many small tables may degrade performance or exceed open file and memory capacities.

-- It may be more feasible to apply third normal form only to data that changes frequently. If some dependent fields remain, design your application to require the user to verify all related fields when any one is changed.

-----------------------------------------------------------------------------------

-- How to interpret ER diagrams

-- https://www.guru99.com/er-diagram-tutorial-dbms.html

-- Entity-Relationship diagrams are analytical tools that help us design our tables and visualize a database. 

-- ER diagrams are comprised of "Entities", "Attributes", and the relationships between them.

-- ENTITY = Person, place, object, event, or concept

-- ATTRIBUTE = A property or characteristic of an Entity, e.g., the color of a car; the name of a person; the date of birth of a person; etc.

-- RELATIONSHIP = An association between one or more entities, e.g., "The blue car belongs to Deliveryman Jake". (HINT: It's often easiest to imagine "relationships" as verbs that relate entities to one another)

---------------

-- Cardinality
--    Defines the numerical attributes of the relationship between two entities or entity sets.

-- 	  Different types of cardinal relationships are:

--			One-to-One Relationships: e.g., one person has a single date of birth

--			One-to-Many Relationships: e.g., Any given artist within the Chinook database may have one or more albumes

--			Many to One Relationships: e.g., place of birth: many people may be born in the same locality

--			Many-to-Many Relationships: e.g., students may enroll in many courses, and each course may contain multiple students

-- To create a RDBMS schematic (ER Diagram), proceed as follows:

--	1. Identify the "entities" that need to be represented within the database

--  2. Specify the "relationships" between entities that need to be represented within the database

--  3. Specify the CARDINALITY of all pertinent relationships between entities

--  4. Specify the attributes that need to be associated with each of your specified entities.

-- When crafting your ER diagram, make sure that each entity appears ONLY ONCE within the diagram (i.e., do not allow duplicate instantiations of any entities!!)

-- Connect entities to each other via relationships. NEVER connect relationships to one another!!\\

-- MOST IMPORTANTLY: make sure that the ER diagram supports all the data you need to store as well as any required data integrity constraints.
