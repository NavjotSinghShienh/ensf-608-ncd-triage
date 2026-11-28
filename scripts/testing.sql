-- Database Testing Script
-- Run after scripts/DDL.sql and scripts/seed.sql.
-- Sections 1-2 are read-only checks.
-- Section 3 runs positive DML & cascade tests inside a rolled-back transaction.
-- Section 4 contains negative tests (expected to fail).

USE NCD_Risk_Identification_System;

-- =========================================================================
-- 1. REFERENTIAL INTEGRITY & THRESHOLD CONSISTENCY CHECKS (Expected: 0 rows)
-- =========================================================================

-- Patients without matching User rows
SELECT p.SSN
FROM Patients p
LEFT JOIN Users u ON p.SSN = u.SSN
WHERE u.SSN IS NULL;

-- Appointments without valid Patients
SELECT a.Appointment_Number
FROM Appointments a
LEFT JOIN Patients p ON a.Patient_SSN = p.SSN
WHERE p.SSN IS NULL;

-- Appointments without valid Doctors
SELECT a.Appointment_Number
FROM Appointments a
LEFT JOIN Doctors d ON a.Doctor_SSN = d.SSN
WHERE d.SSN IS NULL;

-- Duplicate User emails
SELECT Email, COUNT(*) AS Total
FROM Users
GROUP BY Email
HAVING COUNT(*) > 1;

-- Notifications without valid Risk_Assessments
SELECT n.Assessment_Number, n.Date_Notified
FROM Notifications n
LEFT JOIN Risk_Assessments r ON n.Assessment_Number = r.Assessment_Number
WHERE r.Assessment_Number IS NULL;

-- Risk assessments whose Score/Risk_Level do not match Risk_Thresholds
SELECT
    r.Assessment_Number,
    r.Patient_SSN,
    r.NCD_Name,
    r.Effective_Date,
    r.Score,
    r.Risk_Level
FROM Risk_Assessments r
WHERE NOT EXISTS (
    SELECT 1
    FROM Risk_Thresholds rt
    WHERE rt.NCD_Name = r.NCD_Name
      AND rt.Effective_Date = r.Effective_Date
      AND rt.Risk_Tier = r.Risk_Level
      AND r.Score BETWEEN rt.Min_Score AND rt.Max_Score
);

-- =========================================================================
-- 2. CLINICAL RELATIONSHIP VERIFICATION QUERIES
-- =========================================================================

-- Patients with User details
SELECT u.SSN, u.First_Name, u.Last_Name, p.Healthcare_Number, p.Blood_Type, p.Status
FROM Users u
JOIN Patients p ON u.SSN = p.SSN;

-- Appointments with Patient and Doctor details
SELECT
    a.Appointment_Number,
    a.Appointment_Date,
    a.Appointment_Type,
    a.Status,
    p.Healthcare_Number,
    u.First_Name AS Doctor_First_Name,
    u.Last_Name AS Doctor_Last_Name
FROM Appointments a
JOIN Patients p ON a.Patient_SSN = p.SSN
JOIN Doctors d ON a.Doctor_SSN = d.SSN
JOIN Users u ON d.SSN = u.SSN;

-- Distinct patient count by risk level
SELECT Risk_Level, COUNT(DISTINCT Patient_SSN) AS Patient_Count
FROM Risk_Assessments
GROUP BY Risk_Level;

-- High-risk assessments and linked notifications
SELECT
    r.Assessment_Number,
    r.Patient_SSN,
    r.Score,
    r.Risk_Level,
    n.Date_Notified,
    n.Message
FROM Risk_Assessments r
LEFT JOIN Notifications n ON r.Assessment_Number = n.Assessment_Number
WHERE r.Risk_Level = 'High';

-- Patients with diagnoses
SELECT p.SSN, u.First_Name, u.Last_Name, mc.Condition_Name, pd.Diagnosis_Date, pd.Status
FROM Patients p
JOIN Users u ON p.SSN = u.SSN
JOIN Patient_Diagnoses pd ON p.SSN = pd.Patient_SSN
JOIN Medical_Conditions mc ON pd.ICD_Code = mc.ICD_Code;

-- Lab results with test reference ranges
SELECT lt.Accession_Number, lt.Test_Date, tt.Test_Name, lt.Test_Result, tt.Min_Range, tt.Max_Range, lt.Status
FROM Lab_Tests lt
JOIN Test_Types tt ON lt.Test_Name = tt.Test_Name;

-- Prescriptions with medication names
SELECT ap.Appointment_Number, m.Generic_Name, m.Brand_Name, ap.Dose, ap.Status
FROM Appointment_Prescriptions ap
JOIN Medications m ON ap.DIN = m.DIN;

-- Treatments with treatment names
SELECT a.Appointment_Number, tt.Treatment_Name, apt.Treatment_Date, apt.Status
FROM Appointment_Treatments apt
JOIN Appointments a ON apt.Appointment_Number = a.Appointment_Number
JOIN Treatment_Types tt ON apt.Treatment_Code = tt.Treatment_Code;

-- =========================================================================
-- 3. POSITIVE DML & CASCADE TESTS (Rolled back so seed data stays clean)
-- =========================================================================
START TRANSACTION;

-- DML-INSERT-USER & DML-INSERT-PATIENT
INSERT INTO Users (SSN, First_Name, Last_Name, DOB, Email, Password, Status)
VALUES ('900000001', 'Database', 'Test', '2000-01-01', 'database.test@example.ca', 'test-only-password', 'Active');

INSERT INTO Patients (SSN, Healthcare_Number, Gender, Blood_Type, Status)
VALUES ('900000001', 'TEST-HC-900000001', 'Other', 'O+', 'Active');

INSERT INTO Patient_Emergency_Contacts (Patient_SSN, Contact_Name, Contact_Phone_Number)
VALUES
    ('900000001', 'Test Contact One', '4035559991'),
    ('900000001', 'Test Contact Two', '4035559992');

SELECT SSN, First_Name, Last_Name, Status FROM Users WHERE SSN = '900000001';
SELECT SSN, Healthcare_Number, Status FROM Patients WHERE SSN = '900000001';
SELECT Patient_SSN, Contact_Name, Contact_Phone_Number FROM Patient_Emergency_Contacts WHERE Patient_SSN = '900000001';

-- DML-UPDATE-USER & DML-UPDATE-PATIENT
UPDATE Users SET Status = 'Suspended' WHERE SSN = '900000001';
UPDATE Patients SET Status = 'Inactive' WHERE SSN = '900000001';

SELECT u.SSN, u.Status AS User_Status, p.Status AS Patient_Status
FROM Users u
JOIN Patients p ON u.SSN = p.SSN
WHERE u.SSN = '900000001';
-- Expected: User_Status = 'Suspended', Patient_Status = 'Inactive'

-- DML-DELETE-CONTACT
DELETE FROM Patient_Emergency_Contacts
WHERE Patient_SSN = '900000001'
  AND Contact_Name = 'Test Contact One';

SELECT COUNT(*) AS Remaining_Contacts
FROM Patient_Emergency_Contacts
WHERE Patient_SSN = '900000001';
-- Expected: 1

-- DML-DELETE-PATIENT (also cascades to remaining emergency contact)
DELETE FROM Patients WHERE SSN = '900000001';

SELECT
    (SELECT COUNT(*) FROM Patients WHERE SSN = '900000001') AS Remaining_Patients,
    (SELECT COUNT(*) FROM Patient_Emergency_Contacts WHERE Patient_SSN = '900000001') AS Remaining_Contacts;
-- Expected: 0, 0

-- DELETE-CASCADE-THRESHOLD: Deleting a Risk_Model cascades to Risk_Thresholds
INSERT INTO Risk_Models (NCD_Name, Effective_Date, Description, Admin_SSN)
VALUES ('Database Testing Cascade Model', '2026-01-01', 'Temporary cascade test', '100000001');

INSERT INTO Risk_Thresholds (NCD_Name, Effective_Date, Risk_Tier, Min_Score, Max_Score)
VALUES ('Database Testing Cascade Model', '2026-01-01', 'Low', 0.00, 100.00);

DELETE FROM Risk_Models
WHERE NCD_Name = 'Database Testing Cascade Model'
  AND Effective_Date = '2026-01-01';

SELECT
    (SELECT COUNT(*) FROM Risk_Models WHERE NCD_Name = 'Database Testing Cascade Model') AS Remaining_Models,
    (SELECT COUNT(*) FROM Risk_Thresholds WHERE NCD_Name = 'Database Testing Cascade Model') AS Remaining_Thresholds;
-- Expected: 0, 0

ROLLBACK;

-- =========================================================================
-- 4. NEGATIVE CONSTRAINT-REJECTION TESTS
--    Run each statement individually and verify
--    that MySQL rejects it with the expected error code.
-- =========================================================================

-- PK & UNIQUE violations (Expected: Error 1062 Duplicate entry)

-- Test 1: Reject inserting a User with a duplicate primary-key SSN ('400000001')
INSERT INTO Users (SSN, First_Name, Last_Name, DOB, Email, Password)
VALUES ('400000001', 'Duplicate', 'SSN', '2000-01-01', 'duplicate.ssn@example.ca', 'test');

-- Test 2: Reject inserting a User with an already registered Email address
INSERT INTO Users (SSN, First_Name, Last_Name, DOB, Email, Password)
VALUES ('900000002', 'Duplicate', 'Email', '2000-01-01', 'arthur.pendleton@shaw.ca', 'test');

-- Test 3: Reject inserting a Patient with a duplicate provincial Healthcare_Number
INSERT INTO Patients (SSN, Healthcare_Number, Blood_Type)
VALUES ('200000001', 'AB-904812301', 'O+');

-- Test 4: Reject inserting a Doctor with a duplicate medical License_Number
INSERT INTO Doctors (SSN, License_Number)
VALUES ('300000001', 'CPSA-MD-11820');

-- Test 5: Reject inserting a Health_Professional with a duplicate Employee_Number
INSERT INTO Health_Professionals (SSN, Employee_Number, Employment_Date, Department_Name)
VALUES ('100000001', 'EMP-CARD-001', '2026-01-01', 'Foothills Cardiology');

-- Test 6: Reject inserting a Lab_Assistant with a duplicate Certification_Number
INSERT INTO Lab_Assistants (SSN, Certification_Number)
VALUES ('200000001', 'CSMLS-MLT-88201');

-- Foreign Key violations (Expected: Error 1452 Cannot add or update a child row)

-- Test 7: Reject booking a Lab Assistant ('300000001') as an Appointment Doctor
INSERT INTO Appointments (Appointment_Date, Appointment_Type, Patient_SSN, Doctor_SSN, Admin_SSN, Department_Name, Room_Number)
VALUES ('2026-12-01 09:00:00', 'Follow-Up', '400000001', '300000001', '100000002', 'Foothills Cardiology', 'CARD-101');

-- Test 8: Reject booking an Appointment in a non-existent Department/Room pair ('ZZ99')
INSERT INTO Appointments (Appointment_Date, Appointment_Type, Patient_SSN, Doctor_SSN, Admin_SSN, Department_Name, Room_Number)
VALUES ('2026-12-01 09:00:00', 'Follow-Up', '400000001', '200000001', '100000002', 'Foothills Cardiology', 'ZZ99');

-- CHECK constraint violations (Expected: Error 3819 Check constraint is violated)

-- Test 9: Reject a User whose SSN is 8 digits instead of the required 9-digit format
INSERT INTO Users (SSN, First_Name, Last_Name, DOB, Email, Password)
VALUES ('12345678', 'Invalid', 'SSN', '2000-01-01', 'invalid.ssn@example.ca', 'test');

-- Test 10: Reject a 8-character alphanumeric DIN instead of digits
INSERT INTO Medications (DIN, Generic_Name)
VALUES ('1234567a', 'Invalid DIN');

-- Test 11: Reject a Patient with an invalid Blood_Type ('X+') outside the allowed ABO/Rh domain
INSERT INTO Patients (SSN, Healthcare_Number, Blood_Type)
VALUES ('200000001', 'BAD-BLOOD', 'X+');

-- Test 12: Reject a Test_Type whose Max_Range (5.00) is less than its Min_Range (10.00)
INSERT INTO Test_Types (Test_Name, Min_Range, Max_Range, Admin_SSN)
VALUES ('Invalid range test', 10.00, 5.00, '100000001');

-- Test 13: Reject a Risk_Assessment with a negative Score (-1.00)
INSERT INTO Risk_Assessments (Assessment_Date, Score, Risk_Level, Patient_SSN, NCD_Name, Effective_Date)
VALUES ('2026-12-01 09:00:00', -1.00, 'Low', '400000001', 'Cardiovascular Disease', '2026-01-01');

-- Test 14: Reject an Appointment with an invalid Status ('Booked') outside allowed enum values
INSERT INTO Appointments (Appointment_Date, Appointment_Type, Status, Patient_SSN, Doctor_SSN, Admin_SSN, Department_Name, Room_Number)
VALUES ('2026-12-01 09:00:00', 'Follow-Up', 'Booked', '400000001', '200000001', '100000002', 'Foothills Cardiology', 'CARD-101');

-- NOT NULL violations (Expected: Error 1364 on omission, Error 1048 on explicit NULL)

-- Test 15: Reject inserting a User when mandatory Email column is omitted
INSERT INTO Users (SSN, First_Name, Last_Name, DOB, Password)
VALUES ('900000003', 'Missing', 'Email', '2000-01-01', 'test');

-- Test 16: Reject inserting an Appointment when mandatory Patient_SSN column is omitted
INSERT INTO Appointments (Appointment_Date, Appointment_Type, Doctor_SSN, Admin_SSN, Department_Name, Room_Number)
VALUES ('2026-12-01 09:00:00', 'Follow-Up', '200000001', '100000002', 'Foothills Cardiology', 'CARD-101');

-- Test 17: Reject inserting a User with an explicit NULL Email value
INSERT INTO Users (SSN, First_Name, Last_Name, DOB, Email, Password)
VALUES ('900000003', 'Null', 'Email', '2000-01-01', NULL, 'test');

-- Test 18: Reject inserting an Appointment with an explicit NULL Patient_SSN value
INSERT INTO Appointments (Appointment_Date, Appointment_Type, Patient_SSN, Doctor_SSN, Admin_SSN, Department_Name, Room_Number)
VALUES ('2026-12-01 09:00:00', 'Follow-Up', NULL, '200000001', '100000002', 'Foothills Cardiology', 'CARD-101');

-- ON DELETE restriction (Expected: Error 1451 Cannot delete or update a parent row)

-- Test 19: Reject deleting a Doctor ('200000001') who is still referenced by existing Appointments
DELETE FROM Doctors WHERE SSN = '200000001';
