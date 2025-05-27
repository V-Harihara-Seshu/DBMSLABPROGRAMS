-- Teacher table
CREATE TABLE Teacher ( 
    TeacherID INT PRIMARY KEY, 
    TeacherName VARCHAR2(100) 
);

-- Subject table
CREATE TABLE Subject ( 
    SubjectCode VARCHAR2(10) PRIMARY KEY, 
    Title VARCHAR2(100), 
    CreditValue INT, 
    ModuleLeader VARCHAR2(100), 
    Department VARCHAR2(50), 
    PrerequisiteCourse VARCHAR2(100), 
    TeacherID INT, 
    FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID) ON DELETE CASCADE 
);

-- Teaches table
CREATE TABLE Teaches ( 
    TeacherID INT, 
    SubjectCode VARCHAR2(10), 
    PRIMARY KEY (TeacherID, SubjectCode), 
    FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID), 
    FOREIGN KEY (SubjectCode) REFERENCES Subject(SubjectCode) 
);

-- Student table
CREATE TABLE Student ( 
    SerialNumber INT PRIMARY KEY, 
    Name VARCHAR2(100), 
    Address VARCHAR2(200) 
);

-- StudentProgress table
CREATE TABLE StudentProgress ( 
    SerialNumber INT, 
    SubjectCode VARCHAR2(10), 
    FinalIA INT, 
    PRIMARY KEY (SerialNumber, SubjectCode), 
    FOREIGN KEY (SerialNumber) REFERENCES Student(SerialNumber), 
    FOREIGN KEY (SubjectCode) REFERENCES Subject(SubjectCode) 
);

-- Insert into Teacher
INSERT INTO Teacher VALUES (1, 'Dr. A. Kumar');
INSERT INTO Teacher VALUES (2, 'Prof. S. Mehta');
INSERT INTO Teacher VALUES (3, 'Dr. R. Nair');

-- Insert into Subject
INSERT INTO Subject VALUES ('CS101', 'Data Structures', 4, 'Dr. A. Kumar', 'Computer Science', NULL, 1);
INSERT INTO Subject VALUES ('CS102', 'Operating Systems', 4, 'Prof. S. Mehta', 'Computer Science', 'CS101', 2);
INSERT INTO Subject VALUES ('CS103', 'Databases', 3, 'Dr. R. Nair', 'Computer Science', 'CS101', 3);

-- Insert into Teaches
INSERT INTO Teaches VALUES (1, 'CS101');
INSERT INTO Teaches VALUES (2, 'CS102');
INSERT INTO Teaches VALUES (3, 'CS103');

-- Insert into Student
INSERT INTO Student VALUES (1001, 'Rahul Sharma', 'Bangalore');
INSERT INTO Student VALUES (1002, 'Anjali Verma', 'Hyderabad');
INSERT INTO Student VALUES (1003, 'Karan Patel', 'Mumbai');

-- Insert into StudentProgress
INSERT INTO StudentProgress VALUES (1001, 'CS101', 85);
INSERT INTO StudentProgress VALUES (1002, 'CS102', 78);
INSERT INTO StudentProgress VALUES (1003, 'CS103', 91);

-- a) Retrieve the Teacher names who are NOT Module leaders
SELECT TeacherName 
FROM Teacher 
WHERE TeacherID NOT IN ( 
    SELECT DISTINCT TeacherD 
    FROM Subject 
);

-- b) Display the department which offers the subject “Database Management System”
SELECT DISTINCT Department 
FROM Subject 
WHERE Title = 'Database Management System';

-- c) Display the number of Subjects taught by each Teacher
SELECT T.TeacherName, COUNT(*) AS NumberOfSubjects 
FROM Teacher T 
JOIN Teaches Te ON T.TeacherID = Te.TeacherID 
GROUP BY T.TeacherName;

-- d) Categorize students based on their Subject Examination Marks
SELECT S.SerialNumber, S.Name, SP.SubjectCode,
    CASE 
        WHEN FinallA BETWEEN 70 AND 100 THEN 'Outstanding'
        WHEN FinallA BETWEEN 40 AND 69 THEN 'Average'
        ELSE 'Weak'
    END AS Category
FROM StudentProgress SP 
JOIN Student S ON SP.SerialNumber = S.SerialNumber;

