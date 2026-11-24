-- Read-only database verification and seeded-data tests.
-- Run after scripts/DDL.sql and scripts/seed.sql have completed.
-- This script does not insert, update, delete, or rebuild data.

USE NCD_Risk_Identification_System;

-- =========================================================================
-- 1. DATABASE AND TABLE VERIFICATION
-- =========================================================================
SELECT DATABASE() AS Current_Database;

SHOW TABLES;

SELECT COUNT(*) AS Total_Tables
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_TYPE = 'BASE TABLE';
-- Expected: 25

-- =========================================================================
-- 2. SEED DATA COUNTS
-- =========================================================================
SELECT 'Facilities' AS Table_Name, COUNT(*) AS Total FROM Facilities
UNION ALL SELECT 'Departments', COUNT(*) FROM Departments
UNION ALL SELECT 'Rooms', COUNT(*) FROM Rooms
UNION ALL SELECT 'Users', COUNT(*) FROM Users
UNION ALL SELECT 'Patients', COUNT(*) FROM Patients
UNION ALL SELECT 'Patient_Emergency_Contacts', COUNT(*) FROM Patient_Emergency_Contacts
UNION ALL SELECT 'Health_Professionals', COUNT(*) FROM Health_Professionals
UNION ALL SELECT 'Doctors', COUNT(*) FROM Doctors
UNION ALL SELECT 'Lab_Assistants', COUNT(*) FROM Lab_Assistants
UNION ALL SELECT 'Admins', COUNT(*) FROM Admins
UNION ALL SELECT 'Appointments', COUNT(*) FROM Appointments
UNION ALL SELECT 'Treatment_Types', COUNT(*) FROM Treatment_Types
UNION ALL SELECT 'Appointment_Treatments', COUNT(*) FROM Appointment_Treatments
UNION ALL SELECT 'Medications', COUNT(*) FROM Medications
UNION ALL SELECT 'Appointment_Prescriptions', COUNT(*) FROM Appointment_Prescriptions
UNION ALL SELECT 'Test_Types', COUNT(*) FROM Test_Types
UNION ALL SELECT 'Lab_Tests', COUNT(*) FROM Lab_Tests
UNION ALL SELECT 'Medical_Conditions', COUNT(*) FROM Medical_Conditions
UNION ALL SELECT 'Patient_Diagnoses', COUNT(*) FROM Patient_Diagnoses
UNION ALL SELECT 'Test_Threshold_Rules', COUNT(*) FROM Test_Threshold_Rules
UNION ALL SELECT 'Risk_Models', COUNT(*) FROM Risk_Models
UNION ALL SELECT 'Risk_Thresholds', COUNT(*) FROM Risk_Thresholds
UNION ALL SELECT 'Risk_Model_Evaluations', COUNT(*) FROM Risk_Model_Evaluations
UNION ALL SELECT 'Risk_Assessments', COUNT(*) FROM Risk_Assessments
UNION ALL SELECT 'Notifications', COUNT(*) FROM Notifications;

-- =========================================================================
-- 3. PATIENT, APPOINTMENT, AND RISK ASSESSMENT QUERIES
-- =========================================================================

-- Test 1: Patients with their user information.
SELECT
    u.SSN,
    u.First_Name,
    u.Last_Name,
    p.Healthcare_Number,
    p.Blood_Type
FROM Users u
JOIN Patients p ON u.SSN = p.SSN;

-- Test 2: Appointments with patient and doctor details.
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

-- Test 3: Risk assessment results, ordered by score.
SELECT
    Assessment_Number,
    Patient_SSN,
    Score,
    Risk_Level,
    Assessment_Date,
    NCD_Name
FROM Risk_Assessments
ORDER BY Score DESC;

-- Test 4: Distinct patient count by risk level.
SELECT
    Risk_Level,
    COUNT(DISTINCT Patient_SSN) AS Patient_Count
FROM Risk_Assessments
GROUP BY Risk_Level;

-- Test 5: High-risk assessments and any associated notifications.
SELECT
    r.Patient_SSN,
    r.Score,
    r.Risk_Level,
    r.Assessment_Number,
    n.Date_Notified,
    n.Message
FROM Risk_Assessments r
LEFT JOIN Notifications n ON r.Assessment_Number = n.Assessment_Number
WHERE r.Risk_Level = 'High';

-- Test 6: Patients without matching user records. Expected: 0 rows.
SELECT p.SSN
FROM Patients p
LEFT JOIN Users u ON p.SSN = u.SSN
WHERE u.SSN IS NULL;

-- Test 7: Appointments without valid patients. Expected: 0 rows.
SELECT a.*
FROM Appointments a
LEFT JOIN Patients p ON a.Patient_SSN = p.SSN
WHERE p.SSN IS NULL;

-- Test 8: Appointments without valid doctors. Expected: 0 rows.
SELECT a.*
FROM Appointments a
LEFT JOIN Doctors d ON a.Doctor_SSN = d.SSN
WHERE d.SSN IS NULL;

-- Test 9: Duplicate user email addresses. Expected: 0 rows.
SELECT Email, COUNT(*) AS Total
FROM Users
GROUP BY Email
HAVING COUNT(*) > 1;

-- Test 10: Notifications without valid risk assessments. Expected: 0 rows.
SELECT n.*
FROM Notifications n
LEFT JOIN Risk_Assessments r ON n.Assessment_Number = r.Assessment_Number
WHERE r.Assessment_Number IS NULL;

-- Additional risk-threshold consistency check. Expected: 0 rows.
-- Finds assessments whose score or risk level does not match a model threshold.
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
-- 4. CLINICAL DATA RELATIONSHIP QUERIES
-- =========================================================================

-- Test 11: Patients with their diagnoses.
SELECT
    p.SSN,
    u.First_Name,
    u.Last_Name,
    mc.Condition_Name,
    pd.Diagnosis_Date,
    pd.Status
FROM Patients p
JOIN Users u ON p.SSN = u.SSN
JOIN Patient_Diagnoses pd ON p.SSN = pd.Patient_SSN
JOIN Medical_Conditions mc ON pd.ICD_Code = mc.ICD_Code;

-- Test 12: Lab results with test information.
SELECT
    lt.Accession_Number,
    lt.Test_Date,
    tt.Test_Name,
    lt.Test_Result,
    lt.Status
FROM Lab_Tests lt
JOIN Test_Types tt ON lt.Test_Name = tt.Test_Name;

-- Test 13: Prescriptions with medication details.
SELECT
    ap.Appointment_Number,
    m.Generic_Name,
    m.Brand_Name,
    ap.Dose,
    ap.Instruction,
    ap.Status
FROM Appointment_Prescriptions ap
JOIN Medications m ON ap.DIN = m.DIN;

-- Test 14: Treatments associated with appointments.
SELECT
    a.Appointment_Number,
    tt.Treatment_Name,
    apt.Treatment_Date,
    apt.Status
FROM Appointment_Treatments apt
JOIN Appointments a ON apt.Appointment_Number = a.Appointment_Number
JOIN Treatment_Types tt ON apt.Treatment_Code = tt.Treatment_Code;

-- Test 15: Facilities and their departments.
SELECT
    f.Facility_Name,
    f.Facility_Type,
    d.Department_Name,
    d.Location
FROM Facilities f
JOIN Departments d ON f.Facility_Name = d.Facility_Name;
