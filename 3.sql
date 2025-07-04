
-- CUSTOMER Table
CREATE TABLE CUSTOMER (
    CUSTOMER_ID NUMBER(10) PRIMARY KEY,
    NAME VARCHAR(20),
    TRANSACTION_DATE DATE
);

-- ACCOUNT Table
CREATE TABLE ACCOUNT (
    ACCOUNT_NO NUMBER(10) PRIMARY KEY,
    TYPE VARCHAR(20),
    BALANCE NUMBER(10),
    TRANSACTION_DATE DATE
);

-- ADDRESS Table
CREATE TABLE ADDRESS (
    CUSTOMER_ID NUMBER(10),
    STREET VARCHAR(20),
    CITY VARCHAR(20),
    STATE VARCHAR(20),
    PRIMARY KEY (CUSTOMER_ID, STREET),
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID) ON DELETE CASCADE
);

-- CUSTOMER_ACCOUNT Table (many-to-many relationship)
CREATE TABLE CUSTOMER_ACCOUNT (
    CUSTOMER_ID NUMBER(10),
    ACCOUNT_NO NUMBER(10),
    PRIMARY KEY (CUSTOMER_ID, ACCOUNT_NO),
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID) ON DELETE CASCADE,
    FOREIGN KEY (ACCOUNT_NO) REFERENCES ACCOUNT(ACCOUNT_NO) ON DELETE CASCADE
);

-- Insert into CUSTOMER
INSERT INTO CUSTOMER (CUSTOMER_ID, NAME, TRANSACTION_DATE) VALUES
(1, 'Alice', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO CUSTOMER (CUSTOMER_ID, NAME, TRANSACTION_DATE) VALUES
(2, 'Bob', TO_DATE('2024-01-02', 'YYYY-MM-DD'));
INSERT INTO CUSTOMER (CUSTOMER_ID, NAME, TRANSACTION_DATE) VALUES
(3, 'Charlie', TO_DATE('2024-01-03', 'YYYY-MM-DD'));
INSERT INTO CUSTOMER (CUSTOMER_ID, NAME, TRANSACTION_DATE) VALUES
(4, 'David', TO_DATE('2024-01-04', 'YYYY-MM-DD'));
INSERT INTO CUSTOMER (CUSTOMER_ID, NAME, TRANSACTION_DATE) VALUES
(5, 'Eva', TO_DATE('2024-01-05', 'YYYY-MM-DD'));
INSERT INTO CUSTOMER (CUSTOMER_ID, NAME, TRANSACTION_DATE) VALUES
(6, 'Frank', TO_DATE('2024-01-06', 'YYYY-MM-DD'));

-- Insert into ACCOUNT
INSERT INTO ACCOUNT (ACCOUNT_NO, TYPE, BALANCE, TRANSACTION_DATE) VALUES
(101, 'Savings', 5000, TO_DATE('2024-01-10', 'YYYY-MM-DD'));
INSERT INTO ACCOUNT (ACCOUNT_NO, TYPE, BALANCE, TRANSACTION_DATE) VALUES
(102, 'Current', 15000, TO_DATE('2024-01-11', 'YYYY-MM-DD'));
INSERT INTO ACCOUNT (ACCOUNT_NO, TYPE, BALANCE, TRANSACTION_DATE) VALUES
(103, 'Savings', 8000, TO_DATE('2024-01-12', 'YYYY-MM-DD'));

-- Insert into ADDRESS
INSERT INTO ADDRESS (CUSTOMER_ID, STREET, CITY, STATE) VALUES
(1, '1st Street', 'Mumbai', 'MH');
INSERT INTO ADDRESS (CUSTOMER_ID, STREET, CITY, STATE) VALUES
(2, '2nd Street', 'Delhi', 'DL');
INSERT INTO ADDRESS (CUSTOMER_ID, STREET, CITY, STATE) VALUES
(3, '3rd Street', 'Chennai', 'TN');
INSERT INTO ADDRESS (CUSTOMER_ID, STREET, CITY, STATE) VALUES
(4, '4th Street', 'Kolkata', 'WB');
INSERT INTO ADDRESS (CUSTOMER_ID, STREET, CITY, STATE) VALUES
(5, '5th Street', 'Bangalore', 'KA');
INSERT INTO ADDRESS (CUSTOMER_ID, STREET, CITY, STATE) VALUES
(6, '6th Street', 'Hyderabad', 'TS');

-- Insert into CUSTOMER_ACCOUNT (linking 4 customers to account 101)
INSERT INTO CUSTOMER_ACCOUNT (CUSTOMER_ID, ACCOUNT_NO) VALUES (1, 101);
INSERT INTO CUSTOMER_ACCOUNT (CUSTOMER_ID, ACCOUNT_NO) VALUES (2, 101);
INSERT INTO CUSTOMER_ACCOUNT (CUSTOMER_ID, ACCOUNT_NO) VALUES (3, 101);
INSERT INTO CUSTOMER_ACCOUNT (CUSTOMER_ID, ACCOUNT_NO) VALUES (4, 101);
INSERT INTO CUSTOMER_ACCOUNT (CUSTOMER_ID, ACCOUNT_NO) VALUES (5, 102);
INSERT INTO CUSTOMER_ACCOUNT (CUSTOMER_ID, ACCOUNT_NO) VALUES (6, 103);

--b
UPDATE ACCOUNT
SET BALANCE = BALANCE * 1.05
WHERE BALANCE < 10000;

--c
SELECT CA.ACCOUNT_NO, COUNT(CA.CUSTOMER_ID) AS NUM_CUSTOMERS 
FROM CUSTOMER_ACCOUNT CA 
GROUP BY CA.ACCOUNT_NO 
HAVING COUNT(CA.CUSTOMER_ID) > 3;

--d
SELECT C.CUSTOMER_ID, SUM(0.5 * A.BALANCE) AS TOTAL_INTEREST
FROM CUSTOMER C
JOIN CUSTOMER_ACCOUNT CA ON C.CUSTOMER_ID = CA.CUSTOMER_ID
JOIN ACCOUNT A ON A.ACCOUNT_NO = CA.ACCOUNT_NO
GROUP BY C.CUSTOMER_ID;

--E
SELECT C.CUSTOMER_ID, C.NAME
FROM CUSTOMER C
JOIN CUSTOMER_ACCOUNT CA ON C.CUSTOMER_ID = CA.CUSTOMER_ID
JOIN ACCOUNT A ON A.ACCOUNT_NO = CA.ACCOUNT_NO
WHERE A.TRANSACTION_DATE IS NULL;
