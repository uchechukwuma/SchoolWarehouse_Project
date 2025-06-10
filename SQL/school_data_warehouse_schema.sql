
-- School Data Warehouse Schema (Enhanced)
-- Includes: Constraints, Indexes, Composite Splits

-- =========================
-- Dimension Tables
-- =========================

-- DimEmployee
CREATE TABLE DimEmployee (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Department VARCHAR(50),
    PhoneNo VARCHAR(20),
    Address TEXT,
    HireDate DATE NOT NULL,
    SupervisorID INT,
    FOREIGN KEY (SupervisorID) REFERENCES DimEmployee(EmployeeID)
);

-- DimClass
CREATE TABLE DimClass (
    ClassID INT PRIMARY KEY,
    ClassName VARCHAR(50) NOT NULL,
    ClassTeacherID INT,
    FOREIGN KEY (ClassTeacherID) REFERENCES DimEmployee(EmployeeID)
);

-- DimStudent
CREATE TABLE DimStudent (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Gender VARCHAR(10) NOT NULL CHECK (Gender IN ('Male', 'Female', 'Other')),
    DateOfBirth DATE NOT NULL,
    ClassID INT NOT NULL,
    EnrollmentDate DATE NOT NULL,
    GraduationDate DATE,
    FOREIGN KEY (ClassID) REFERENCES DimClass(ClassID)
);

-- DimSubject
CREATE TABLE DimSubject (
    SubjectID INT PRIMARY KEY,
    SubjectName VARCHAR(100) NOT NULL,
    CreditUnit INT NOT NULL
);

-- DimTerm
CREATE TABLE DimTerm (
    TermID INT PRIMARY KEY,
    TermName VARCHAR(50) NOT NULL,
    AcademicYear VARCHAR(10) NOT NULL
);

-- DimGradingScale
CREATE TABLE DimGradingScale (
    GradeID INT PRIMARY KEY,
    MinScore DECIMAL(5,2) NOT NULL,
    MaxScore DECIMAL(5,2) NOT NULL,
    GradeLetter CHAR(2) NOT NULL,
    GradePoint DECIMAL(3,2) NOT NULL
);

-- =========================
-- Fact Tables
-- =========================

-- FactStudentPerformance
CREATE TABLE FactStudentPerformance (
    PerformanceID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    SubjectID INT NOT NULL,
    TermID INT NOT NULL,
    GradeID INT NOT NULL,
    ScoreObtained DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES DimStudent(StudentID),
    FOREIGN KEY (SubjectID) REFERENCES DimSubject(SubjectID),
    FOREIGN KEY (TermID) REFERENCES DimTerm(TermID),
    FOREIGN KEY (GradeID) REFERENCES DimGradingScale(GradeID)
);

-- FactAttendance
CREATE TABLE FactAttendance (
    AttendanceID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    ClassID INT NOT NULL,
    TermID INT NOT NULL,
    Date DATE NOT NULL,
    AttendanceStatus VARCHAR(10) NOT NULL CHECK (AttendanceStatus IN ('Present', 'Absent', 'Late')),
    FOREIGN KEY (StudentID) REFERENCES DimStudent(StudentID),
    FOREIGN KEY (ClassID) REFERENCES DimClass(ClassID),
    FOREIGN KEY (TermID) REFERENCES DimTerm(TermID)
);

-- FactPayment
CREATE TABLE FactPayment (
    PaymentID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    TermID INT NOT NULL,
    AmountPaid DECIMAL(10,2) NOT NULL,
    PaymentStatus VARCHAR(20) NOT NULL CHECK (PaymentStatus IN ('Paid', 'Unpaid', 'Partial')),
    PaymentDate DATE NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES DimStudent(StudentID),
    FOREIGN KEY (TermID) REFERENCES DimTerm(TermID)
);

-- TaughtBy Bridge Table
CREATE TABLE TaughtBy (
    EmployeeID INT NOT NULL,
    ClassID INT NOT NULL,
    SubjectID INT NOT NULL,
    PRIMARY KEY (EmployeeID, ClassID, SubjectID),
    FOREIGN KEY (EmployeeID) REFERENCES DimEmployee(EmployeeID),
    FOREIGN KEY (ClassID) REFERENCES DimClass(ClassID),
    FOREIGN KEY (SubjectID) REFERENCES DimSubject(SubjectID)
);

-- =========================
-- Indexes for Foreign Keys
-- =========================

CREATE INDEX idx_student_class ON DimStudent(ClassID);
CREATE INDEX idx_class_teacher ON DimClass(ClassTeacherID);
CREATE INDEX idx_employee_reports_to ON DimEmployee(SupervisorID);

CREATE INDEX idx_perf_student ON FactStudentPerformance(StudentID);
CREATE INDEX idx_perf_subject ON FactStudentPerformance(SubjectID);
CREATE INDEX idx_perf_term ON FactStudentPerformance(TermID);
CREATE INDEX idx_perf_grade ON FactStudentPerformance(GradeID);

CREATE INDEX idx_attend_student ON FactAttendance(StudentID);
CREATE INDEX idx_attend_class ON FactAttendance(ClassID);
CREATE INDEX idx_attend_term ON FactAttendance(TermID);

CREATE INDEX idx_payment_student ON FactPayment(StudentID);
CREATE INDEX idx_payment_term ON FactPayment(TermID);

CREATE INDEX idx_taughtby_employee ON TaughtBy(EmployeeID);
CREATE INDEX idx_taughtby_class ON TaughtBy(ClassID);
CREATE INDEX idx_taughtby_subject ON TaughtBy(SubjectID);
CREATE INDEX idx_taughtby_all ON TaughtBy(ClassID, SubjectID, EmployeeID);
