DROP DATABASE IF EXISTS NCD_Risk_Identification_System;
CREATE DATABASE NCD_Risk_Identification_System;

USE NCD_Risk_Identification_System;

-- =========================================================================
-- DROP TABLES
-- =========================================================================
DROP TABLE IF EXISTS Notifications;
DROP TABLE IF EXISTS Risk_Assessments;
DROP TABLE IF EXISTS Risk_Model_Evaluations;
DROP TABLE IF EXISTS Risk_Thresholds;
DROP TABLE IF EXISTS Risk_Models;
DROP TABLE IF EXISTS Test_Threshold_Rules;
DROP TABLE IF EXISTS Patient_Diagnoses;
DROP TABLE IF EXISTS Medical_Conditions;
DROP TABLE IF EXISTS Lab_Tests;
DROP TABLE IF EXISTS Test_Types;
DROP TABLE IF EXISTS Appointment_Prescriptions;
DROP TABLE IF EXISTS Medications;
DROP TABLE IF EXISTS Appointment_Treatments;
DROP TABLE IF EXISTS Treatment_Types;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Admins;
DROP TABLE IF EXISTS Lab_Assistants;
DROP TABLE IF EXISTS Doctors;
DROP TABLE IF EXISTS Health_Professionals;
DROP TABLE IF EXISTS Patient_Emergency_Contacts;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Rooms;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Facilities;

-- =========================================================================
-- CREATE TABLES
-- =========================================================================

-- 1. Facilities
CREATE TABLE Facilities (
    Facility_Name VARCHAR(100) NOT NULL,
    Facility_Type VARCHAR(50) NOT NULL,
    Address_Line1 VARCHAR(100) NOT NULL,
    Address_Line2 VARCHAR(100),
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Facilities PRIMARY KEY (Facility_Name),
    CONSTRAINT CK_Facilities_Type CHECK (
        Facility_Type IN ('Hospital', 'Clinic', 'Diagnostic Center')
    )
);

-- 2. Departments
CREATE TABLE Departments (
    Department_Name VARCHAR(100) NOT NULL,
    Location VARCHAR(100),
    Facility_Name VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Departments PRIMARY KEY (Department_Name),
    CONSTRAINT FK_Departments_Facilities FOREIGN KEY (Facility_Name)
        REFERENCES Facilities(Facility_Name)
        ON UPDATE CASCADE
);

-- 3. Rooms
CREATE TABLE Rooms (
    Department_Name VARCHAR(100) NOT NULL,
    Room_Number VARCHAR(10) NOT NULL,
    Room_Type VARCHAR(50),
    CONSTRAINT PK_Rooms PRIMARY KEY (Department_Name, Room_Number),
    CONSTRAINT FK_Rooms_Departments FOREIGN KEY (Department_Name)
        REFERENCES Departments(Department_Name)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT CK_Rooms_Type CHECK (
        Room_Type IN ('Consultation', 'Lab', 'Procedure')
    )
);

-- 4. Users
CREATE TABLE Users (
    SSN CHAR(9) NOT NULL,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    Address VARCHAR(150),
    Email VARCHAR(100) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Phone_Number VARCHAR(15),
    Status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT PK_Users PRIMARY KEY (SSN),
    CONSTRAINT UQ_Users_Email UNIQUE (Email),
    CONSTRAINT UQ_Users_Phone UNIQUE (Phone_Number),
    CONSTRAINT CK_Users_SSN CHECK (SSN REGEXP '^[0-9]{9}$'),
    CONSTRAINT CK_Users_Status CHECK (Status IN ('Active', 'Inactive', 'Suspended'))
);

-- 5. Patients
CREATE TABLE Patients (
    SSN CHAR(9) NOT NULL,
    Healthcare_Number VARCHAR(20) NOT NULL,
    Gender VARCHAR(20),
    Blood_Type VARCHAR(3),
    Status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT PK_Patients PRIMARY KEY (SSN),
    CONSTRAINT UQ_Patients_Healthcare_Number UNIQUE (Healthcare_Number),
    CONSTRAINT FK_Patients_Users FOREIGN KEY (SSN)
        REFERENCES Users(SSN)
        ON UPDATE CASCADE,
    CONSTRAINT CK_Patients_Blood_Type CHECK (
        Blood_Type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')
    ),
    CONSTRAINT CK_Patients_Status CHECK (
        Status IN ('Active', 'Inactive', 'Deceased')
    )
);

-- 6. Patient_Emergency_Contacts
CREATE TABLE Patient_Emergency_Contacts (
    Patient_SSN CHAR(9) NOT NULL,
    Contact_Name VARCHAR(100) NOT NULL,
    Contact_Phone_Number VARCHAR(15) NOT NULL,
    CONSTRAINT PK_Patient_Emergency_Contacts PRIMARY KEY (Patient_SSN, Contact_Name, Contact_Phone_Number),
    CONSTRAINT FK_Emergency_Contacts_Patients FOREIGN KEY (Patient_SSN)
        REFERENCES Patients(SSN)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- 7. Health_Professionals
CREATE TABLE Health_Professionals (
    SSN CHAR(9) NOT NULL,
    Employee_Number VARCHAR(20) NOT NULL,
    Employment_Date DATE NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Active',
    Department_Name VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Health_Professionals PRIMARY KEY (SSN),
    CONSTRAINT UQ_Health_Professionals_Emp_No UNIQUE (Employee_Number),
    CONSTRAINT FK_Health_Professionals_Users FOREIGN KEY (SSN)
        REFERENCES Users(SSN)
        ON UPDATE CASCADE,
    CONSTRAINT FK_Health_Professionals_Departments FOREIGN KEY (Department_Name)
        REFERENCES Departments(Department_Name)
        ON UPDATE CASCADE,
    CONSTRAINT CK_Health_Professionals_Status CHECK (Status IN ('Active', 'On Leave', 'Terminated'))
);

-- 8. Doctors
CREATE TABLE Doctors (
    SSN CHAR(9) NOT NULL,
    License_Number VARCHAR(30) NOT NULL,
    Speciality VARCHAR(100),
    Qualification VARCHAR(150),
    CONSTRAINT PK_Doctors PRIMARY KEY (SSN),
    CONSTRAINT UQ_Doctors_License UNIQUE (License_Number),
    CONSTRAINT FK_Doctors_Health_Professionals FOREIGN KEY (SSN)
        REFERENCES Health_Professionals(SSN)
        ON UPDATE CASCADE
);

-- 9. Lab_Assistants
CREATE TABLE Lab_Assistants (
    SSN CHAR(9) NOT NULL,
    Certification_Number VARCHAR(30) NOT NULL,
    Certification_Type VARCHAR(100),
    Lab_Specialization VARCHAR(100),
    CONSTRAINT PK_Lab_Assistants PRIMARY KEY (SSN),
    CONSTRAINT UQ_Lab_Assistants_Cert_No UNIQUE (Certification_Number),
    CONSTRAINT FK_Lab_Assistants_Health_Professionals FOREIGN KEY (SSN)
        REFERENCES Health_Professionals(SSN)
        ON UPDATE CASCADE
);

-- 10. Admins
CREATE TABLE Admins (
    SSN CHAR(9) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    IsActive BOOLEAN NOT NULL DEFAULT TRUE,
    Department_Name VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Admins PRIMARY KEY (SSN),
    CONSTRAINT FK_Admins_Users FOREIGN KEY (SSN)
        REFERENCES Users(SSN)
        ON UPDATE CASCADE,
    CONSTRAINT FK_Admins_Departments FOREIGN KEY (Department_Name)
        REFERENCES Departments(Department_Name)
        ON UPDATE CASCADE,
    CONSTRAINT CK_Admins_Role CHECK (
        Role IN ('Receptionist', 'Clinical Admin', 'System Admin', 'Security Admin')
    )
);

-- 11. Appointments
CREATE TABLE Appointments (
    Appointment_Number INT AUTO_INCREMENT NOT NULL,
    Appointment_Date DATETIME NOT NULL,
    Appointment_Type VARCHAR(50) NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    Patient_SSN CHAR(9) NOT NULL,
    Doctor_SSN CHAR(9) NOT NULL,
    Admin_SSN CHAR(9) NOT NULL,
    Department_Name VARCHAR(100) NOT NULL,
    Room_Number VARCHAR(10) NOT NULL,
    CONSTRAINT PK_Appointments PRIMARY KEY (Appointment_Number),
    CONSTRAINT FK_Appointments_Patients FOREIGN KEY (Patient_SSN)
        REFERENCES Patients(SSN)
        ON UPDATE CASCADE,
    CONSTRAINT FK_Appointments_Doctors FOREIGN KEY (Doctor_SSN)
        REFERENCES Doctors(SSN)
        ON UPDATE CASCADE,
    CONSTRAINT FK_Appointments_Admins FOREIGN KEY (Admin_SSN)
        REFERENCES Admins(SSN)
        ON UPDATE CASCADE,
    CONSTRAINT FK_Appointments_Rooms FOREIGN KEY (Department_Name, Room_Number)
        REFERENCES Rooms(Department_Name, Room_Number)
        ON UPDATE CASCADE,
    CONSTRAINT CK_Appointments_Status CHECK (
        Status IN ('Scheduled', 'Completed', 'Cancelled', 'No-Show')
    ),
    CONSTRAINT CK_Appointments_Type CHECK (
        Appointment_Type IN ('Initial Consultation', 'Follow-Up', 'Routine Checkup', 'Emergency')
    )
);

-- 12. Treatment_Types
CREATE TABLE Treatment_Types (
    Treatment_Code VARCHAR(20) NOT NULL,
    Treatment_Name VARCHAR(100) NOT NULL,
    Treatment_Category VARCHAR(50),
    CONSTRAINT PK_Treatment_Types PRIMARY KEY (Treatment_Code),
    CONSTRAINT CK_Treatment_Types_Category CHECK (
        Treatment_Category IN (
            'Lifestyle Intervention',
            'Surgical',
            'Dialysis',
            'Therapy',
            'Monitoring'
        )
    )
);

-- 13. Appointment_Treatments
CREATE TABLE Appointment_Treatments (
    Appointment_Number INT NOT NULL,
    Treatment_Code VARCHAR(20) NOT NULL,
    Treatment_Date DATE NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Recommended',
    CONSTRAINT PK_Appointment_Treatments PRIMARY KEY (Appointment_Number, Treatment_Code),
    CONSTRAINT FK_Appt_Treatments_Appointments FOREIGN KEY (Appointment_Number)
        REFERENCES Appointments(Appointment_Number)
        ON UPDATE CASCADE,
    CONSTRAINT FK_Appt_Treatments_Types FOREIGN KEY (Treatment_Code)
        REFERENCES Treatment_Types(Treatment_Code)
        ON UPDATE CASCADE,
    CONSTRAINT CK_Appt_Treatments_Status CHECK (
        Status IN ('Recommended', 'In Progress', 'Completed', 'Cancelled')
    )
);

-- 14. Medications
CREATE TABLE Medications (
    DIN CHAR(8) NOT NULL,
    Generic_Name VARCHAR(100) NOT NULL,
    Brand_Name VARCHAR(100),
    CONSTRAINT PK_Medications PRIMARY KEY (DIN),
    CONSTRAINT CK_Medications_DIN CHECK (DIN REGEXP '^[0-9]{8}$')
);

-- 15. Appointment_Prescriptions
CREATE TABLE Appointment_Prescriptions (
    Appointment_Number INT NOT NULL,
    DIN CHAR(8) NOT NULL,
    Dose VARCHAR(50) NOT NULL,
    Instruction VARCHAR(255),
    Status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT PK_Appointment_Prescriptions PRIMARY KEY (Appointment_Number, DIN),
    CONSTRAINT FK_Appt_Prescriptions_Appointments FOREIGN KEY (Appointment_Number)
        REFERENCES Appointments(Appointment_Number)
        ON UPDATE CASCADE,
    CONSTRAINT FK_Appt_Prescriptions_Medications FOREIGN KEY (DIN)
        REFERENCES Medications(DIN)
        ON UPDATE CASCADE,
    CONSTRAINT CK_Appt_Prescriptions_Status CHECK (
        Status IN ('Active', 'Completed', 'Discontinued')
    )
);

-- 16. Test_Types
CREATE TABLE Test_Types (
    Test_Name VARCHAR(100) NOT NULL,
    Min_Range DECIMAL(10,2),
    Max_Range DECIMAL(10,2),
    Admin_SSN CHAR(9) NOT NULL,
    CONSTRAINT PK_Test_Types PRIMARY KEY (Test_Name),
    CONSTRAINT FK_Test_Types_Admins FOREIGN KEY (Admin_SSN)
        REFERENCES Admins(SSN)
        ON UPDATE CASCADE,
    CONSTRAINT CK_Test_Types_Range CHECK (Max_Range >= Min_Range)
);

-- 17. Lab_Tests
CREATE TABLE Lab_Tests (
    Accession_Number VARCHAR(20) NOT NULL,
    Test_Date DATE NOT NULL,
    Test_Result DECIMAL(10,2),
    Status VARCHAR(20) NOT NULL DEFAULT 'Ordered',
    Appointment_Number INT NOT NULL,
    Lab_Assistant_SSN CHAR(9) NOT NULL,
    Test_Name VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Lab_Tests PRIMARY KEY (Accession_Number),
    CONSTRAINT FK_Lab_Tests_Appointments FOREIGN KEY (Appointment_Number)
        REFERENCES Appointments(Appointment_Number)
        ON UPDATE CASCADE,
    CONSTRAINT FK_Lab_Tests_Lab_Assistants FOREIGN KEY (Lab_Assistant_SSN)
        REFERENCES Lab_Assistants(SSN)
        ON UPDATE CASCADE,
    CONSTRAINT FK_Lab_Tests_Test_Types FOREIGN KEY (Test_Name)
        REFERENCES Test_Types(Test_Name)
        ON UPDATE CASCADE,
    CONSTRAINT CK_Lab_Tests_Status CHECK (
        Status IN ('Ordered', 'In Progress', 'Completed', 'Cancelled')
    )
);

-- 18. Medical_Conditions
CREATE TABLE Medical_Conditions (
    ICD_Code VARCHAR(10) NOT NULL,
    Condition_Name VARCHAR(150) NOT NULL,
    Category VARCHAR(50),
    CONSTRAINT PK_Medical_Conditions PRIMARY KEY (ICD_Code),
    CONSTRAINT UQ_Medical_Conditions_Name UNIQUE (Condition_Name),
    CONSTRAINT CK_Medical_Conditions_Category CHECK (
        Category IN (
            'Cardiovascular',
            'Oncological',
            'Metabolic',
            'Respiratory',
            'Lifestyle',
            'Family History'
        )
    )
);

-- 19. Patient_Diagnoses
CREATE TABLE Patient_Diagnoses (
    Patient_SSN CHAR(9) NOT NULL,
    ICD_Code VARCHAR(10) NOT NULL,
    Diagnosis_Date DATE NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT PK_Patient_Diagnoses PRIMARY KEY (Patient_SSN, ICD_Code),
    CONSTRAINT FK_Patient_Diagnoses_Patients FOREIGN KEY (Patient_SSN)
        REFERENCES Patients(SSN)
        ON UPDATE CASCADE,
    CONSTRAINT FK_Patient_Diagnoses_Conditions FOREIGN KEY (ICD_Code)
        REFERENCES Medical_Conditions(ICD_Code)
        ON UPDATE CASCADE,
    CONSTRAINT CK_Patient_Diagnoses_Status CHECK (
        Status IN ('Active', 'Resolved', 'Chronic')
    )
);

-- 20. Test_Threshold_Rules
CREATE TABLE Test_Threshold_Rules (
    Test_Name VARCHAR(100) NOT NULL,
    ICD_Code VARCHAR(10) NOT NULL,
    Abnormality_Threshold DECIMAL(10,2) NOT NULL,
    Operator VARCHAR(2) NOT NULL,
    CONSTRAINT PK_Test_Threshold_Rules PRIMARY KEY (Test_Name, ICD_Code),
    CONSTRAINT FK_Threshold_Rules_Test_Types FOREIGN KEY (Test_Name)
        REFERENCES Test_Types(Test_Name)
        ON UPDATE CASCADE,
    CONSTRAINT FK_Threshold_Rules_Conditions FOREIGN KEY (ICD_Code)
        REFERENCES Medical_Conditions(ICD_Code)
        ON UPDATE CASCADE,
    CONSTRAINT CK_Threshold_Rules_Operator CHECK (
        Operator IN ('<', '<=', '>', '>=', '=')
    )
);

-- 21. Risk_Models
CREATE TABLE Risk_Models (
    NCD_Name VARCHAR(100) NOT NULL,
    Effective_Date DATE NOT NULL,
    Description VARCHAR(255),
    Admin_SSN CHAR(9) NOT NULL,
    CONSTRAINT PK_Risk_Models PRIMARY KEY (NCD_Name, Effective_Date),
    CONSTRAINT FK_Risk_Models_Admins FOREIGN KEY (Admin_SSN)
        REFERENCES Admins(SSN)
        ON UPDATE CASCADE
);

-- 22. Risk_Thresholds
CREATE TABLE Risk_Thresholds (
    NCD_Name VARCHAR(100) NOT NULL,
    Effective_Date DATE NOT NULL,
    Risk_Tier VARCHAR(10) NOT NULL,
    Min_Score DECIMAL(5,2) NOT NULL,
    Max_Score DECIMAL(5,2) NOT NULL,
    CONSTRAINT PK_Risk_Thresholds PRIMARY KEY (NCD_Name, Effective_Date, Risk_Tier),
    CONSTRAINT FK_Risk_Thresholds_Models FOREIGN KEY (NCD_Name, Effective_Date)
        REFERENCES Risk_Models(NCD_Name, Effective_Date)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT CK_Risk_Thresholds_Tier CHECK (
        Risk_Tier IN ('Low', 'Medium', 'High')
    ),
    CONSTRAINT CK_Risk_Thresholds_Min_Score CHECK (Min_Score >= 0),
    CONSTRAINT CK_Risk_Thresholds_Max_Score CHECK (Max_Score >= Min_Score)
);

-- 23. Risk_Model_Evaluations
CREATE TABLE Risk_Model_Evaluations (
    NCD_Name VARCHAR(100) NOT NULL,
    Effective_Date DATE NOT NULL,
    ICD_Code VARCHAR(10) NOT NULL,
    Risk_Weight DECIMAL(5,2) NOT NULL,
    CONSTRAINT PK_Risk_Model_Evaluations PRIMARY KEY (NCD_Name, Effective_Date, ICD_Code),
    CONSTRAINT FK_Model_Evaluations_Models FOREIGN KEY (NCD_Name, Effective_Date)
        REFERENCES Risk_Models(NCD_Name, Effective_Date)
        ON UPDATE CASCADE,
    CONSTRAINT FK_Model_Evaluations_Conditions FOREIGN KEY (ICD_Code)
        REFERENCES Medical_Conditions(ICD_Code)
        ON UPDATE CASCADE,
    CONSTRAINT CK_Model_Evaluations_Weight CHECK (Risk_Weight >= 0)
);

-- 24. Risk_Assessments
CREATE TABLE Risk_Assessments (
    Assessment_Number INT AUTO_INCREMENT NOT NULL,
    Assessment_Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Score DECIMAL(5,2) NOT NULL,
    Risk_Level VARCHAR(10) NOT NULL,
    Patient_SSN CHAR(9) NOT NULL,
    NCD_Name VARCHAR(100) NOT NULL,
    Effective_Date DATE NOT NULL,
    CONSTRAINT PK_Risk_Assessments PRIMARY KEY (Assessment_Number),
    CONSTRAINT FK_Risk_Assessments_Patients FOREIGN KEY (Patient_SSN)
        REFERENCES Patients(SSN)
        ON UPDATE CASCADE,
    CONSTRAINT FK_Risk_Assessments_Models FOREIGN KEY (NCD_Name, Effective_Date)
        REFERENCES Risk_Models(NCD_Name, Effective_Date)
        ON UPDATE CASCADE,
    CONSTRAINT CK_Risk_Assessments_Score CHECK (Score >= 0),
    CONSTRAINT CK_Risk_Assessments_Level CHECK (
        Risk_Level IN ('Low', 'Medium', 'High')
    )
);

-- 25. Notifications
CREATE TABLE Notifications (
    Assessment_Number INT NOT NULL,
    Date_Notified DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Recipient_User_SSN CHAR(9) NOT NULL,
    Message VARCHAR(500) NOT NULL,
    CONSTRAINT PK_Notifications PRIMARY KEY (Assessment_Number, Date_Notified),
    CONSTRAINT FK_Notifications_Assessments FOREIGN KEY (Assessment_Number)
        REFERENCES Risk_Assessments(Assessment_Number)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT FK_Notifications_Users FOREIGN KEY (Recipient_User_SSN)
        REFERENCES Users(SSN)
        ON UPDATE CASCADE
);
