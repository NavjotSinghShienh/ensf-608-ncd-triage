-- Database verification and transactional DML/constraint tests.
-- Run after scripts/DDL.sql and scripts/seed.sql have completed on MySQL 8.0.16+.
-- Test data changes are rolled back; the session-only results table remains available.

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

-- =========================================================================
-- 5. POSITIVE DML, STORED PROCEDURES, AND CONSTRAINT-REJECTION TESTS
-- =========================================================================

DROP TEMPORARY TABLE IF EXISTS Testing_Results;
CREATE TEMPORARY TABLE Testing_Results (
    Test_ID VARCHAR(30) NOT NULL PRIMARY KEY,
    Category VARCHAR(40) NOT NULL,
    Expected_Outcome VARCHAR(255) NOT NULL,
    Actual_Output VARCHAR(1000) NOT NULL,
    Pass_Fail VARCHAR(4) NOT NULL
);

DROP PROCEDURE IF EXISTS Assert_Expected_Error;
DELIMITER //
CREATE PROCEDURE Assert_Expected_Error(
    IN p_test_id VARCHAR(30),
    IN p_category VARCHAR(40),
    IN p_expected_code INT,
    IN p_sql LONGTEXT
)
BEGIN
    DECLARE v_error_code INT DEFAULT 0;
    DECLARE v_error_message VARCHAR(1000) DEFAULT 'Statement succeeded; expected an error.';

    SET @testing_statement = p_sql;

    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                v_error_code = MYSQL_ERRNO,
                v_error_message = MESSAGE_TEXT;
        END;

        PREPARE expected_test_statement FROM @testing_statement;
        EXECUTE expected_test_statement;
        DEALLOCATE PREPARE expected_test_statement;
    END;

    INSERT INTO Testing_Results (
        Test_ID, Category, Expected_Outcome, Actual_Output, Pass_Fail
    ) VALUES (
        p_test_id,
        p_category,
        CONCAT('MySQL error ', p_expected_code),
        IF(
            v_error_code = 0,
            v_error_message,
            CONCAT('MySQL error ', v_error_code, ': ', v_error_message)
        ),
        IF(v_error_code = p_expected_code, 'PASS', 'FAIL')
    );
END//
DELIMITER ;

START TRANSACTION;

-- Positive INSERT / UPDATE / DELETE tests. The transaction is rolled back below.
INSERT INTO Users (
    SSN, First_Name, Last_Name, DOB, Email, Password, Status
) VALUES (
    '900000001', 'Database', 'Test', '2000-01-01',
    'database.test@example.ca', 'test-only-password', 'Active'
);
INSERT INTO Testing_Results
SELECT
    'DML-INSERT-USER', 'Positive DML', 'One test user is inserted',
    CONCAT('Rows found: ', COUNT(*)),
    IF(COUNT(*) = 1, 'PASS', 'FAIL')
FROM Users
WHERE SSN = '900000001';

INSERT INTO Patients (SSN, Healthcare_Number, Gender, Blood_Type, Status)
VALUES ('900000001', 'TEST-HC-900000001', 'Other', 'O+', 'Active');
INSERT INTO Testing_Results
SELECT
    'DML-INSERT-PATIENT', 'Positive DML', 'One test patient is inserted',
    CONCAT('Rows found: ', COUNT(*)),
    IF(COUNT(*) = 1, 'PASS', 'FAIL')
FROM Patients
WHERE SSN = '900000001';

INSERT INTO Patient_Emergency_Contacts
    (Patient_SSN, Contact_Name, Contact_Phone_Number)
VALUES
    ('900000001', 'Test Contact One', '4035559991'),
    ('900000001', 'Test Contact Two', '4035559992');

UPDATE Users SET Status = 'Suspended' WHERE SSN = '900000001';
INSERT INTO Testing_Results
SELECT
    'DML-UPDATE-USER', 'Positive DML', 'Test user status becomes Suspended',
    CONCAT('Status: ', COALESCE(MAX(Status), 'row not found')),
    IF(COUNT(*) = 1 AND MAX(Status) = 'Suspended', 'PASS', 'FAIL')
FROM Users
WHERE SSN = '900000001';

UPDATE Patients SET Status = 'Inactive' WHERE SSN = '900000001';
INSERT INTO Testing_Results
SELECT
    'DML-UPDATE-PATIENT', 'Positive DML', 'Test patient status becomes Inactive',
    CONCAT('Status: ', COALESCE(MAX(Status), 'row not found')),
    IF(COUNT(*) = 1 AND MAX(Status) = 'Inactive', 'PASS', 'FAIL')
FROM Patients
WHERE SSN = '900000001';

DELETE FROM Patient_Emergency_Contacts
WHERE Patient_SSN = '900000001'
  AND Contact_Name = 'Test Contact One';
INSERT INTO Testing_Results
SELECT
    'DML-DELETE-CONTACT', 'Positive DML', 'One contact is deleted; one remains',
    CONCAT('Remaining test contacts: ', COUNT(*)),
    IF(COUNT(*) = 1, 'PASS', 'FAIL')
FROM Patient_Emergency_Contacts
WHERE Patient_SSN = '900000001';

DELETE FROM Patients WHERE SSN = '900000001';
INSERT INTO Testing_Results
SELECT
    'DML-DELETE-PATIENT', 'Positive DML', 'Patient and dependent contacts are deleted',
    CONCAT(
        'Patients: ', (SELECT COUNT(*) FROM Patients WHERE SSN = '900000001'),
        '; contacts: ', (SELECT COUNT(*) FROM Patient_Emergency_Contacts WHERE Patient_SSN = '900000001')
    ),
    IF(
        (SELECT COUNT(*) FROM Patients WHERE SSN = '900000001') = 0
        AND (SELECT COUNT(*) FROM Patient_Emergency_Contacts WHERE Patient_SSN = '900000001') = 0,
        'PASS',
        'FAIL'
    );

-- Stored procedure tests emit their result sets; these result rows record the
-- seeded-data expectations so they can be compared with the CALL output.
INSERT INTO Testing_Results
SELECT
    'PROC-PATIENT-RISK', 'Stored procedure',
    'GetPatientRiskAssessments returns assessment 501 for patient 400000001',
    CONCAT('Matching seeded assessments: ', COUNT(*)),
    IF(COUNT(*) = 1, 'PASS', 'FAIL')
FROM Risk_Assessments
WHERE Patient_SSN = '400000001';
CALL GetPatientRiskAssessments('400000001');

INSERT INTO Testing_Results
SELECT
    'PROC-HIGH-RISK', 'Stored procedure',
    'GetHighRiskAssessments returns the six seeded High assessments',
    CONCAT('Matching seeded High assessments: ', COUNT(*)),
    IF(COUNT(*) = 6, 'PASS', 'FAIL')
FROM Risk_Assessments
WHERE Risk_Level = 'High';
CALL GetHighRiskAssessments();

-- PK and UNIQUE rejection: expected MySQL error 1062.
CALL Assert_Expected_Error(
    'NEG-DUP-SSN', 'PK / UNIQUE', 1062,
    'INSERT INTO Users (SSN, First_Name, Last_Name, DOB, Email, Password) VALUES (''400000001'', ''Duplicate'', ''SSN'', ''2000-01-01'', ''duplicate.ssn@example.ca'', ''test'')'
);
CALL Assert_Expected_Error(
    'NEG-DUP-EMAIL', 'PK / UNIQUE', 1062,
    'INSERT INTO Users (SSN, First_Name, Last_Name, DOB, Email, Password) VALUES (''900000002'', ''Duplicate'', ''Email'', ''2000-01-01'', ''james.wilson@patients.ab.ca'', ''test'')'
);
CALL Assert_Expected_Error(
    'NEG-DUP-HEALTHCARE', 'PK / UNIQUE', 1062,
    'INSERT INTO Patients (SSN, Healthcare_Number, Blood_Type) VALUES (''200000001'', ''AB-908123401'', ''O+'')'
);
CALL Assert_Expected_Error(
    'NEG-DUP-LICENSE', 'PK / UNIQUE', 1062,
    'INSERT INTO Doctors (SSN, License_Number) VALUES (''300000001'', ''CPSA-MD-78101'')'
);
CALL Assert_Expected_Error(
    'NEG-DUP-EMPLOYEE-NUMBER', 'PK / UNIQUE', 1062,
    'INSERT INTO Health_Professionals (SSN, Employee_Number, Employment_Date, Department_Name) VALUES (''100000001'', ''EMP-DOC-001'', ''2026-01-01'', ''Cardiology'')'
);
CALL Assert_Expected_Error(
    'NEG-DUP-CERTIFICATION', 'PK / UNIQUE', 1062,
    'INSERT INTO Lab_Assistants (SSN, Certification_Number) VALUES (''200000001'', ''CSMLS-MLT-4101'')'
);

-- FK rejection: expected MySQL error 1452.
CALL Assert_Expected_Error(
    'NEG-FK-ASSISTANT-DOCTOR', 'Foreign key', 1452,
    'INSERT INTO Appointments (Appointment_Date, Appointment_Type, Patient_SSN, Doctor_SSN, Admin_SSN, Department_Name, Room_Number) VALUES (''2026-12-01 09:00:00'', ''Follow-Up'', ''400000001'', ''300000001'', ''100000001'', ''Cardiology'', ''A301'')'
);
CALL Assert_Expected_Error(
    'NEG-FK-ROOM', 'Foreign key', 1452,
    'INSERT INTO Appointments (Appointment_Date, Appointment_Type, Patient_SSN, Doctor_SSN, Admin_SSN, Department_Name, Room_Number) VALUES (''2026-12-01 09:00:00'', ''Follow-Up'', ''400000001'', ''200000001'', ''100000001'', ''Cardiology'', ''ZZ99'')'
);

-- CHECK rejection: expected MySQL error 3819.
CALL Assert_Expected_Error(
    'NEG-CHECK-SSN', 'CHECK', 3819,
    'INSERT INTO Users (SSN, First_Name, Last_Name, DOB, Email, Password) VALUES (''12345678'', ''Invalid'', ''SSN'', ''2000-01-01'', ''invalid.ssn@example.ca'', ''test'')'
);
CALL Assert_Expected_Error(
    'NEG-CHECK-DIN', 'CHECK', 3819,
    'INSERT INTO Medications (DIN, Generic_Name) VALUES (''1234567'', ''Invalid DIN'')'
);
CALL Assert_Expected_Error(
    'NEG-CHECK-BLOOD-TYPE', 'CHECK', 3819,
    'INSERT INTO Patients (SSN, Healthcare_Number, Blood_Type) VALUES (''200000001'', ''BAD-BLOOD'', ''X+'')'
);
CALL Assert_Expected_Error(
    'NEG-CHECK-RANGE', 'CHECK', 3819,
    'INSERT INTO Test_Types (Test_Name, Min_Range, Max_Range, Admin_SSN) VALUES (''Invalid range test'', 10.00, 5.00, ''100000001'')'
);
CALL Assert_Expected_Error(
    'NEG-CHECK-NEGATIVE-SCORE', 'CHECK', 3819,
    'INSERT INTO Risk_Assessments (Assessment_Date, Score, Risk_Level, Patient_SSN, NCD_Name, Effective_Date) VALUES (''2026-12-01 09:00:00'', -1.00, ''Low'', ''400000001'', ''Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)'', ''2026-01-01'')'
);
CALL Assert_Expected_Error(
    'NEG-CHECK-STATUS', 'CHECK', 3819,
    'INSERT INTO Appointments (Appointment_Date, Appointment_Type, Status, Patient_SSN, Doctor_SSN, Admin_SSN, Department_Name, Room_Number) VALUES (''2026-12-01 09:00:00'', ''Follow-Up'', ''Booked'', ''400000001'', ''200000001'', ''100000001'', ''Cardiology'', ''A301'')'
);

-- Omitting mandatory columns is error 1364 in MySQL strict mode.
CALL Assert_Expected_Error(
    'NEG-MISSING-EMAIL', 'NOT NULL omission', 1364,
    'INSERT INTO Users (SSN, First_Name, Last_Name, DOB, Password) VALUES (''900000003'', ''Missing'', ''Email'', ''2000-01-01'', ''test'')'
);
CALL Assert_Expected_Error(
    'NEG-MISSING-PATIENT', 'NOT NULL omission', 1364,
    'INSERT INTO Appointments (Appointment_Date, Appointment_Type, Doctor_SSN, Admin_SSN, Department_Name, Room_Number) VALUES (''2026-12-01 09:00:00'', ''Follow-Up'', ''200000001'', ''100000001'', ''Cardiology'', ''A301'')'
);
CALL Assert_Expected_Error(
    'NEG-NULL-EMAIL', 'NOT NULL', 1048,
    'INSERT INTO Users (SSN, First_Name, Last_Name, DOB, Email, Password) VALUES (''900000003'', ''Null'', ''Email'', ''2000-01-01'', NULL, ''test'')'
);
CALL Assert_Expected_Error(
    'NEG-NULL-PATIENT', 'NOT NULL', 1048,
    'INSERT INTO Appointments (Appointment_Date, Appointment_Type, Patient_SSN, Doctor_SSN, Admin_SSN, Department_Name, Room_Number) VALUES (''2026-12-01 09:00:00'', ''Follow-Up'', NULL, ''200000001'', ''100000001'', ''Cardiology'', ''A301'')'
);

-- ON DELETE rules: a risk-model delete cascades (recorded below), while a
-- doctor referenced by appointments is rejected with MySQL error 1451.
INSERT INTO Risk_Models (NCD_Name, Effective_Date, Description, Admin_SSN)
VALUES ('Database Testing Cascade Model', '2026-01-01', 'Temporary cascade test', '100000001');
INSERT INTO Risk_Thresholds (NCD_Name, Effective_Date, Risk_Tier, Min_Score, Max_Score)
VALUES ('Database Testing Cascade Model', '2026-01-01', 'Low', 0.00, 100.00);
DELETE FROM Risk_Models
WHERE NCD_Name = 'Database Testing Cascade Model'
  AND Effective_Date = '2026-01-01';
INSERT INTO Testing_Results
SELECT
    'DELETE-CASCADE-THRESHOLD', 'ON DELETE',
    'Deleting a Risk_Model cascades to its Risk_Thresholds',
    CONCAT('Remaining model rows: ', (SELECT COUNT(*) FROM Risk_Models WHERE NCD_Name = 'Database Testing Cascade Model'),
           '; threshold rows: ', (SELECT COUNT(*) FROM Risk_Thresholds WHERE NCD_Name = 'Database Testing Cascade Model')),
    IF(
        (SELECT COUNT(*) FROM Risk_Models WHERE NCD_Name = 'Database Testing Cascade Model') = 0
        AND (SELECT COUNT(*) FROM Risk_Thresholds WHERE NCD_Name = 'Database Testing Cascade Model') = 0,
        'PASS',
        'FAIL'
    );

CALL Assert_Expected_Error(
    'NEG-DELETE-DOCTOR', 'ON DELETE', 1451,
    'DELETE FROM Doctors WHERE SSN = ''200000001'''
);

-- Capture the result sets before rollback; the temporary InnoDB table is
-- transactional, so its rows disappear along with the test data afterward.
SELECT Test_ID, Category, Expected_Outcome, Actual_Output, Pass_Fail
FROM Testing_Results
ORDER BY Test_ID;

SELECT
    COUNT(*) AS Total_Tests,
    SUM(Pass_Fail = 'PASS') AS Passed,
    SUM(Pass_Fail = 'FAIL') AS Failed
FROM Testing_Results;

ROLLBACK;

DROP PROCEDURE IF EXISTS Assert_Expected_Error;
