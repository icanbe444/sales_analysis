CREATE TABLE Sales.EmployeeLogs(
	LogID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT,
    LogMessage VARCHAR(255),
    LogDate DATE
)

-- SQL Server (T-SQL) syntax --
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGING
	INSERT INTO Sales.EmployeeLogs(EmployeeID,LogMessage,LogDate)
    SELECT 
		EmployeeID,
        "New Emmployee Added = " + CAST(EmployeeID AS VARCHAR),
        GETDATE()
	FROM INSERTED
END

-- MySql Version --
DELIMITER $$

CREATE TRIGGER trg_AfterInsertEmployee
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO EmployeeLogs (EmployeeID, LogMessage, LogDate)
    VALUES (
        NEW.employee_id,
        CONCAT('New Employee Added = ', NEW.employee_id),
        NOW()
    );
END$$

DELIMITER ;

select * from employeeLogs;
select * from employees;


-- Inserting Message into the Employees Table

INSERT INTO Employees() 
Values(6, 'Maria', 'Doe', 'HR', '1988-01-12', 'Female', 80000, 3)