
IF OBJECT_ID('sp_EmployeeOperations', 'P') IS NOT NULL
DROP PROCEDURE sp_EmployeeOperations;
GO

IF OBJECT_ID('fn_GetEmployeesAboveSalary', 'IF') IS NOT NULL
DROP FUNCTION fn_GetEmployeesAboveSalary;
GO

IF OBJECT_ID('fn_GetAnnualSalary', 'FN') IS NOT NULL
DROP FUNCTION fn_GetAnnualSalary;
GO

IF OBJECT_ID('Employees', 'U') IS NOT NULL
DROP TABLE Employees;
GO

-- CREATE TABLE
CREATE TABLE Employees (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary DECIMAL(10,2),
    Department VARCHAR(20)
);
GO

-- INSERT INITIAL DATA
INSERT INTO Employees VALUES
(1, 'Giridhar', 50000, 'IT'),
(2, 'Rahul', 40000, 'HR'),
(3, 'Priya', 30000, 'Sales');
GO

-- SHOW INITIAL DATA
SELECT 'Initial Data' AS Stage, * FROM Employees;
GO

-- APPLY BONUS
UPDATE Employees
SET Salary = Salary + 
    CASE 
        WHEN Department = 'IT' THEN Salary * 0.15
        WHEN Department = 'HR' THEN Salary * 0.12
        ELSE Salary * 0.10
    END;
GO

-- SHOW UPDATED DATA
SELECT 'After Bonus Update' AS Stage, * FROM Employees;
GO

-- FUNCTION: Annual Salary
CREATE FUNCTION fn_GetAnnualSalary (@monthlySalary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN (@monthlySalary * 12);
END;
GO

-- FUNCTION: Employees Above Salary
CREATE FUNCTION fn_GetEmployeesAboveSalary (@amount DECIMAL(10,2))
RETURNS TABLE
AS
RETURN
(
    SELECT Name, Salary
    FROM Employees
    WHERE Salary > @amount
);
GO

-- STORED PROCEDURE: INSERT / UPDATE / DELETE
CREATE PROCEDURE sp_EmployeeOperations
    @action VARCHAR(10),
    @id INT,
    @name VARCHAR(50) = NULL,
    @salary DECIMAL(10,2) = NULL,
    @dept VARCHAR(20) = NULL
AS
BEGIN
    IF @action = 'INSERT'
    BEGIN
        INSERT INTO Employees VALUES (@id, @name, @salary, @dept);
    END
    ELSE IF @action = 'UPDATE'
    BEGIN
        UPDATE Employees
        SET Name = @name,
            Salary = @salary,
            Department = @dept
        WHERE Id = @id;
    END
    ELSE IF @action = 'DELETE'
    BEGIN
        DELETE FROM Employees WHERE Id = @id;
    END
END;
GO

-- TEST OUTPUTS

-- Annual Salary
SELECT Name, Salary, dbo.fn_GetAnnualSalary(Salary) AS AnnualSalary
FROM Employees;

-- Employees above 35000
SELECT * FROM dbo.fn_GetEmployeesAboveSalary(35000);

-- Procedure Demo
EXEC sp_EmployeeOperations 'INSERT', 4, 'Riya', 45000, 'IT';
EXEC sp_EmployeeOperations 'UPDATE', 4, 'Riya Sharma', 48000, 'HR';
EXEC sp_EmployeeOperations 'DELETE', 4;

-- Final Table
SELECT 'Final Data' AS Stage, * FROM Employees;