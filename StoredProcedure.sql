USE Sales;
#StoredProcedure
#Step1 Write a query for US customers. Find the total number of customers and the average score

SELECT  
	COUNT(*) TotalCustomers,
    avg(score) AvgScore
from customers
WHERE Country='USA';


#Step2 Turn the query into a StoredProcedure
DELIMITER $$

CREATE PROCEDURE GetCustomerSummary() #This is peculiar to MySQLWorkBench
BEGIN
    SELECT  
		country,
        COUNT(*) AS TotalCustomers,
        AVG(score) AS AvgScore
    FROM customers
    WHERE Country = 'USA';
END$$

DELIMITER ;

CALL GetCustomerSummary(); #This is peculiar to MySQLWorkBench

DROP PROCEDURE IF EXISTS GetCustomerSummary;


#Step3 Create a parameters for the stored procedure
DELIMITER $$
CREATE PROCEDURE GetCustomerSummary(IN countryName VARCHAR(50)) #This is peculiar to MySQLWorkBench
BEGIN
    SELECT  
        COUNT(*) AS TotalCustomers,
        AVG(score) AS AvgScore
    FROM customers
    WHERE Country = countryName;
END$$
DELIMITER ;



CALL GetCustomerSummary('Germany'); #This is peculiar to MySQLWorkBench


#Find the total number of orders and total sales
SELECT COUNT(order_id), SUM(sales) from orders as o
JOIN customers as c
ON o.customer_id = c.customer_id



#Put multiple queries in StoredProcedure
DELIMITER $$
CREATE PROCEDURE GetCustomerSummary(IN countryName VARCHAR(50)) #This is peculiar to MySQLWorkBench
BEGIN
    SELECT  
        COUNT(*) AS TotalCustomers,
        AVG(score) AS AvgScore
    FROM customers
    WHERE Country = countryName;
    
    SELECT COUNT(order_id) TotalCustomers, 
    SUM(sales) TotalSales from orders as o
	JOIN customers as c
	ON o.customer_id = c.customer_id
	WHERE Country = countryName;

END$$
DELIMITER ;

CALL GetCustomerSummary('USA');


#Declare variables in StoredProcedure

DROP PROCEDURE IF EXISTS GetCustomerSummary;

DELIMITER $$

CREATE PROCEDURE GetCustomerSummary(IN countryName VARCHAR(50))
BEGIN
    -- Declare local variables
    DECLARE TotalCustomers INT;
    DECLARE AvgScore DECIMAL(10,2);

    -- Assign values to variables
    SELECT  
        COUNT(*), 
        AVG(score)
    INTO TotalCustomers, AvgScore
    FROM customers
    WHERE Country = countryName;
    
-- Display messages
    SELECT CONCAT('Total number of customers in ', countryName, ': ', TotalCustomers) AS Message1;
    SELECT CONCAT('Average Scores from ', countryName, ': ', AvgScore) AS Message2;

    -- Output the variables
    SELECT TotalCustomers AS TotalCustomers, AvgScore AS AvgScore;
END$$

DELIMITER ;

CALL GetCustomerSummary('USA');



#Handling Null values before aggregation
DROP PROCEDURE IF EXISTS GetCustomerSummary;

DELIMITER $$

CREATE PROCEDURE GetCustomerSummary(IN countryName VARCHAR(50))
BEGIN
    -- Declare variables
    DECLARE TotalCustomers INT;
    DECLARE AvgScore DECIMAL(10,2);
    DECLARE null_count INT;

    -- Check for NULL scores
    SELECT COUNT(*) INTO null_count 
    FROM customers 
    WHERE score IS NULL AND Country = countryName;

    IF null_count > 0 THEN
        -- Update NULL scores to 0
        UPDATE customers
        SET score = 0
        WHERE score IS NULL AND Country = countryName;
    ELSE
        -- Show message when no null score is found
        SELECT CONCAT('No null score found for ', countryName) AS Message;
    END IF;

    -- Calculate totals after possible update
    SELECT  
        COUNT(*), 
        AVG(score)
    INTO TotalCustomers, AvgScore
    FROM customers
    WHERE Country = countryName;

    -- Display results
    SELECT CONCAT('Total number of customers in ', countryName, ': ', TotalCustomers) AS Message1,
           CONCAT('Average Scores from ', countryName, ': ', AvgScore) AS Message2;
END$$

DELIMITER ;

CALL GetCustomerSummary('USA');
