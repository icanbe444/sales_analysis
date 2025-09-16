CREATE TABLE dbcustomers AS
SELECT *
FROM Sales.customers;

CREATE INDEX idx_DBCustomers_Customer_ID
ON Sales.dbcustomers (customer_id);

CREATE INDEX idx_DBCustomers_First_Name
ON Sales.dbcustomers (first_name);


CREATE INDEX idx_DBcustomer_CountryScore
ON dbcustomers (country, score);


CREATE INDEX idx_DBcustomer_CustomerCountry
ON dbcustomers (country)
WHERE country = 'USA'


CREATE INDEX idx_DBcustomer_CustomerCountry
ON dbcustomers (country)


-- Maintaining indexes in a project
-- Firstly, check all the indexes on a specific table

sp_helpindex 'Sales.dbcustomers'

SHOW INDEXES FROM dbcustomers;

-- Monitoring index usage

 SELECT 
    INDEX_NAME, 
    COLUMN_NAME, 
    NON_UNIQUE, 
    SEQ_IN_INDEX
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'Sales'
  AND TABLE_NAME = 'dbcustomers';


-- Selecting recommended missing indexes 

SELECT * FROM sys.dm.db_missing_index_details