CREATE TABLE EMPLOYEE (
    SSN INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(255),
    Gender CHAR(1),
    Salary DECIMAL(10,2),
    SuperSSN INT,
    DNo INT
);

-- Create DEPARTMENT table
CREATE TABLE DEPARTMENT (
    DNo INT PRIMARY KEY,
    DName VARCHAR(100),
    MgrSSN INT,
    MgrStartDate DATE
);

-- Create DLOCATION table
CREATE TABLE DLOCATION (
    DNo INT,
    DLoc VARCHAR(100),
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo)
);

-- Create PROJECT table
CREATE TABLE PROJECT (
    PNo INT PRIMARY KEY,
    PName VARCHAR(100),
    PLocation VARCHAR(100),
    DNo INT,
    FOREIGN KEY (DNo) REFERENCES DEPARTMENT(DNo)
);

-- Create WORKS_ON table
CREATE TABLE WORKS_ON (
    SSN INT,
    PNo INT,
    Hours DECIMAL(5,2),
    FOREIGN KEY (SSN) REFERENCES EMPLOYEE(SSN),
    FOREIGN KEY (PNo) REFERENCES PROJECT(PNo)
);
-- Departments
INSERT INTO DEPARTMENT VALUES 
(1, 'Accounts', 1001, '2018-01-01'),
(5, 'Research', 1002, '2019-03-15');

-- Employees
INSERT INTO EMPLOYEE VALUES 
(1001, 'Michael Scott', 'Scranton', 'M', 70000, NULL, 1),
(1002, 'Jim Halpert', 'Scranton', 'M', 50000, 1001, 5),
(1003, 'Pam Beesly', 'Scranton', 'F', 45000, 1002, 5),
(1004, 'Dwight Schrute', 'Scranton', 'M', 60000, 1001, 5);

-- Projects
INSERT INTO PROJECT VALUES 
(101, 'Inventory', 'Scranton', 1),
(102, 'loT', 'Stamford', 5),
(103, 'Security', 'Scranton', 5);

-- Work assignments
INSERT INTO WORKS_ON VALUES 
(1002, 102, 20),
(1003, 102, 15),
(1004, 102, 30),
(1003, 103, 10),
(1004, 103, 15);

--a
CREATE OR REPLACE TRIGGER trg_uppercase_name
BEFORE INSERT OR UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
  :NEW.Name := UPPER(:NEW.Name);
END;
/

-- As Worker or Manager
SELECT DISTINCT P.PNo
FROM PROJECT P
JOIN DEPARTMENT D ON P.DNo = D.DNo
LEFT JOIN EMPLOYEE MGR ON D.MgrSSN = MGR.SSN
LEFT JOIN WORKS_ON W ON P.PNo = W.PNo
LEFT JOIN EMPLOYEE E ON W.SSN = E.SSN
WHERE 
    MGR.Name LIKE '%SCOTT%' OR 
    E.Name LIKE '%SCOTT%';




SELECT 
    E.SSN,
    E.Name,
    E.Salary AS Original_Salary,
    ROUND(E.Salary * 1.10, 2) AS New_Salary
FROM 
    EMPLOYEE E
WHERE 
    E.SSN IN (
        SELECT W.SSN
        FROM WORKS_ON W
        JOIN PROJECT P ON W.PNo = P.PNo
        WHERE P.PName = 'loT'
    );

SELECT 
    SUM(E.Salary) AS Total_Salary,
    MAX(E.Salary) AS Max_Salary,
    MIN(E.Salary) AS Min_Salary,
    AVG(E.Salary) AS Avg_Salary
FROM 
    EMPLOYEE E
JOIN DEPARTMENT D ON E.DNo = D.DNo
WHERE 
    D.DName = 'Accounts';

SELECT E.Name
FROM EMPLOYEE E
WHERE NOT EXISTS (
    SELECT P.PNo
    FROM PROJECT P
    WHERE P.DNo = 5
    AND NOT EXISTS (
        SELECT * FROM WORKS_ON W
        WHERE W.PNo = P.PNo AND W.SSN = E.SSN
    )
);
