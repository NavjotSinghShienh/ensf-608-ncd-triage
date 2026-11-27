-- ============================================================================
-- Database Operations and Queries (DML / DQL)
-- NCD Risk Identification and Triage System (ENSF 608 - Group 6)
-- Run Order: DDL.sql -> seed.sql -> procedure.sql -> DML.sql
-- ============================================================================

USE NCD_Risk_Identification_System;

-- ============================================================================
-- 1. INSERT OPERATIONS (Minimum Required: 2)
-- ============================================================================
-- Write operations (I1, I2, U1, U2, D1, D2) are wrapped in a transaction so
-- the script can be re-executed cleanly without mutating the seed dataset.

START TRANSACTION;

-- I1: Book follow-up appointments for active High-risk patients with a care gap
-- Purpose: Operationalizes UN SDG 3.4 by scheduling a 2-week follow-up using each
-- care-gap patient's most recent completed appointment details.
INSERT INTO Appointments (
    Appointment_Date,
    Appointment_Type,
    Patient_SSN,
    Doctor_SSN,
    Admin_SSN,
    Department_Name,
    Room_Number
)
WITH latest_assessments AS (
    SELECT
        ra.Patient_SSN,
        ra.NCD_Name,
        ra.Assessment_Date,
        ra.Risk_Level,
        ROW_NUMBER() OVER (
            PARTITION BY ra.Patient_SSN, ra.NCD_Name
            ORDER BY ra.Assessment_Date DESC, ra.Assessment_Number DESC
        ) AS rn
    FROM Risk_Assessments ra
),
patients_with_care_gap AS (
    SELECT DISTINCT p.SSN
    FROM latest_assessments la
    JOIN Patients p ON la.Patient_SSN = p.SSN
    LEFT JOIN Appointments a
        ON la.Patient_SSN = a.Patient_SSN
       AND a.Status = 'Scheduled'
       AND a.Appointment_Date >= CURDATE()
    WHERE la.rn = 1
      AND p.Status = 'Active'
      AND la.Risk_Level = 'High'
      AND la.Assessment_Date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
      AND a.Appointment_Number IS NULL
),
latest_completed_appt AS (
    SELECT
        a.Patient_SSN,
        a.Doctor_SSN,
        a.Admin_SSN,
        a.Department_Name,
        a.Room_Number,
        ROW_NUMBER() OVER (
            PARTITION BY a.Patient_SSN
            ORDER BY a.Appointment_Date DESC, a.Appointment_Number DESC
        ) AS rn
    FROM Appointments a
    JOIN patients_with_care_gap pwcg ON a.Patient_SSN = pwcg.SSN
    WHERE a.Status = 'Completed'
)
SELECT
    DATE_ADD(CURRENT_DATE(), INTERVAL 2 WEEK),
    'Follow-Up',
    Patient_SSN,
    Doctor_SSN,
    Admin_SSN,
    Department_Name,
    Room_Number
FROM latest_completed_appt
WHERE rn = 1;

SELECT * FROM Appointments WHERE Appointment_Number >= LAST_INSERT_ID();

-- I2: Publish a new versioned Cancer risk model with thresholds and condition weights
-- Purpose: Demonstrates composite-key model versioning (NCD_Name, Effective_Date) across
-- Risk_Models, Risk_Thresholds, and Risk_Model_Evaluations.
SET @v_effective_date = CURRENT_DATE();

INSERT INTO Risk_Models (
    NCD_Name,
    Effective_Date,
    Description,
    Admin_SSN
)
VALUES (
    'Cancer',
    @v_effective_date,
    'Cancer risk scoring V2',
    (SELECT SSN FROM Admins WHERE Role = 'Clinical Admin' AND IsActive = TRUE LIMIT 1)
);

SELECT * FROM Risk_Models WHERE NCD_Name = 'Cancer' AND Effective_Date = @v_effective_date;

INSERT INTO Risk_Thresholds (
    NCD_Name,
    Effective_Date,
    Risk_Tier,
    Min_Score,
    Max_Score
)
VALUES
('Cancer', @v_effective_date, 'High',   70.00, 100.00),
('Cancer', @v_effective_date, 'Medium', 40.00,  69.99),
('Cancer', @v_effective_date, 'Low',     0.00,  39.99);

SELECT * FROM Risk_Thresholds WHERE NCD_Name = 'Cancer' AND Effective_Date = @v_effective_date;

INSERT INTO Risk_Model_Evaluations (
    NCD_Name,
    Effective_Date,
    ICD_Code,
    Risk_Weight
)
VALUES
('Cancer', @v_effective_date, 'C18.9',  60.00),
('Cancer', @v_effective_date, 'C34.90', 40.00),
('Cancer', @v_effective_date, 'C50.91', 50.00),
('Cancer', @v_effective_date, 'Z72.0',  30.00),
('Cancer', @v_effective_date, 'Z80.9',  50.00),
('Cancer', @v_effective_date, 'E66.9',  10.00);

SELECT * FROM Risk_Model_Evaluations WHERE NCD_Name = 'Cancer' AND Effective_Date = @v_effective_date;

-- ============================================================================
-- 2. UPDATE OPERATIONS (Minimum Required: 2)
-- ============================================================================

-- U1: Mark a patient's smoking risk factor (Z72.0) as Resolved
-- Purpose: Reflects successful smoking cessation intervention so future risk assessments
-- recalculate with a lower score.
SELECT * FROM Patient_Diagnoses
WHERE Patient_SSN = '400000003'
  AND ICD_Code = 'Z72.0'
  AND Status = 'Active';

UPDATE Patient_Diagnoses
SET Status = 'Resolved'
WHERE Patient_SSN = '400000003'
  AND ICD_Code = 'Z72.0'
  AND Status = 'Active';

SELECT * FROM Patient_Diagnoses
WHERE Patient_SSN = '400000003'
  AND ICD_Code = 'Z72.0';

-- U2: Complete an in-progress lab test with its diagnostic result
-- Purpose: Moves a pending HbA1c order (ACC-2026-020) from In Progress to Completed
-- once lab analysis finishes.
SELECT Accession_Number, Status, Test_Result
FROM Lab_Tests
WHERE Status = 'In Progress'
  AND Accession_Number = 'ACC-2026-020';

UPDATE Lab_Tests
SET Test_Result = 5.10, Status = 'Completed'
WHERE Status = 'In Progress'
  AND Accession_Number = 'ACC-2026-020';

SELECT Accession_Number, Status, Test_Result
FROM Lab_Tests
WHERE Status = 'Completed'
  AND Accession_Number = 'ACC-2026-020';

-- ============================================================================
-- 3. DELETE OPERATIONS (Minimum Required: 2)
-- ============================================================================

-- D1: Delete an outdated emergency contact phone number
-- Purpose: Removes a superseded emergency contact number for Arthur Pendleton while
-- preserving his current emergency contact record.
SELECT * FROM Patient_Emergency_Contacts WHERE Contact_Name = 'Mary Pendleton';

DELETE FROM Patient_Emergency_Contacts
WHERE Patient_SSN = '400000001'
  AND Contact_Name = 'Mary Pendleton'
  AND Contact_Phone_Number = '4035558899';

SELECT * FROM Patient_Emergency_Contacts WHERE Contact_Name = 'Mary Pendleton';

-- D2: Delete an unapproved 2027 draft risk model (with cascade on Risk_Thresholds)
-- Purpose: Removes evaluations for the draft Type 2 Diabetes 2027 model and deletes
-- the model itself, demonstrating ON DELETE CASCADE on weak entity Risk_Thresholds.
SELECT * FROM Risk_Models WHERE NCD_Name = 'Type 2 Diabetes' AND Effective_Date = '2027-01-01';
SELECT * FROM Risk_Model_Evaluations WHERE NCD_Name = 'Type 2 Diabetes' AND Effective_Date = '2027-01-01';
SELECT * FROM Risk_Thresholds WHERE NCD_Name = 'Type 2 Diabetes' AND Effective_Date = '2027-01-01';

DELETE FROM Risk_Model_Evaluations WHERE NCD_Name = 'Type 2 Diabetes' AND Effective_Date = '2027-01-01';
DELETE FROM Risk_Models WHERE NCD_Name = 'Type 2 Diabetes' AND Effective_Date = '2027-01-01';

SELECT * FROM Risk_Models WHERE NCD_Name = 'Type 2 Diabetes' AND Effective_Date = '2027-01-01';
SELECT * FROM Risk_Model_Evaluations WHERE NCD_Name = 'Type 2 Diabetes' AND Effective_Date = '2027-01-01';
SELECT * FROM Risk_Thresholds WHERE NCD_Name = 'Type 2 Diabetes' AND Effective_Date = '2027-01-01';

ROLLBACK;

-- ============================================================================
-- 4. BASIC SELECT QUERIES WITH FILTERING (Minimum Required: 4)
-- ============================================================================

-- S1: Pending lab worklist using IN
-- Purpose: Lists all lab orders currently Ordered or In Progress for lab assistants.
SELECT Accession_Number, Test_Name, Test_Date, Status, Appointment_Number
FROM Lab_Tests
WHERE Status IN ('Ordered', 'In Progress');

-- S2: Audit of care-gap notifications using LIKE
-- Purpose: Retrieves all automated notifications flagging follow-up care gaps.
SELECT Assessment_Number, Date_Notified, Recipient_User_SSN, Message
FROM Notifications
WHERE Message LIKE '%CARE GAP%';

-- S3: Active modifiable lifestyle/behavioral risk factors for preventive outreach
-- Purpose: Supports the prevention pillar of UN SDG 3.4 by finding active Lifestyle
-- risk factors (smoking, inactivity, poor diet) for early counseling.
SELECT pd.Patient_SSN, pd.ICD_Code, mc.Condition_Name, pd.Diagnosis_Date, pd.Status
FROM Patient_Diagnoses pd
INNER JOIN Medical_Conditions mc ON pd.ICD_Code = mc.ICD_Code
WHERE pd.Status = 'Active'
  AND mc.Category = 'Lifestyle'
ORDER BY pd.Diagnosis_Date;

-- S4: High-risk SDG 3.4.1 assessments during the Q3/Q4 2026 reporting window using BETWEEN
-- Purpose: Identifies urgent High-risk assessments (Score >= 70.00) between Sept and Oct 2026
-- for clinical triage prioritization.
SELECT Assessment_Number, Patient_SSN, NCD_Name, Score, Risk_Level, Assessment_Date
FROM Risk_Assessments
WHERE Risk_Level = 'High'
  AND Score >= 70.00
  AND Assessment_Date BETWEEN '2026-09-01' AND '2026-11-01'
ORDER BY Score DESC, Assessment_Date DESC;

-- ============================================================================
-- 5. SELECT QUERIES USING ORDER BY, DISTINCT, OR LIMIT (Minimum Required: 2)
-- ============================================================================

-- O1: Top 5 highest-scoring risk assessments
-- Purpose: Surfaces the highest-priority risk assessments for immediate clinical review.
SELECT *
FROM Risk_Assessments
ORDER BY Score DESC, Assessment_Date DESC
LIMIT 5;

-- O2: Distinct medical conditions diagnosed across the clinic
-- Purpose: Identifies the unique set of ICD-10 codes actively represented in patient histories.
SELECT DISTINCT ICD_Code
FROM Patient_Diagnoses
ORDER BY ICD_Code;

-- ============================================================================
-- 6. SELECT QUERIES USING AGGREGATE FUNCTIONS (Minimum Required: 3)
-- ============================================================================

-- A1: Overall population risk score summary (MAX, MIN, AVG)
-- Purpose: Summarizes the spread and central tendency of calculated patient risk scores.
SELECT
    MAX(Score) AS Maximum_Score,
    MIN(Score) AS Minimum_Score,
    ROUND(AVG(Score), 2) AS Average_Score
FROM Risk_Assessments;

-- A2: Diabetes glycemic control summary across completed HbA1c lab tests (COUNT, AVG, MIN, MAX)
-- Purpose: Evaluates clinic-wide Hemoglobin A1c (HbA1c) levels to monitor Type 2 Diabetes
-- control in support of UN SDG 3.4.
SELECT
    COUNT(*) AS Completed_HbA1c_Tests,
    ROUND(AVG(Test_Result), 2) AS Average_HbA1c,
    MIN(Test_Result) AS Lowest_HbA1c,
    MAX(Test_Result) AS Highest_HbA1c
FROM Lab_Tests
WHERE Test_Name = 'Hemoglobin A1c (HbA1c)'
  AND Status = 'Completed'
  AND Test_Result IS NOT NULL;

-- A3: Count of active High-risk patients by age group (COUNT)
-- Purpose: Profiles high-risk NCD burden across demographic age brackets using derived DOB age.
WITH patient_latest_risk_assessment AS (
    SELECT
        p.SSN,
        ra.Risk_Level,
        ROW_NUMBER() OVER (
            PARTITION BY ra.Patient_SSN, ra.NCD_Name
            ORDER BY ra.Assessment_Date DESC, ra.Assessment_Number DESC
        ) AS row_num
    FROM Patients p
    INNER JOIN Risk_Assessments ra ON p.SSN = ra.Patient_SSN
    WHERE p.Status = 'Active'
      AND ra.Effective_Date <= CURRENT_DATE()
),
high_risk_patients AS (
    SELECT DISTINCT SSN
    FROM patient_latest_risk_assessment
    WHERE row_num = 1
      AND Risk_Level = 'High'
),
age_groups AS (
    SELECT
        CASE
            WHEN TIMESTAMPDIFF(YEAR, u.DOB, CURRENT_DATE()) <= 12 THEN 'Child'
            WHEN TIMESTAMPDIFF(YEAR, u.DOB, CURRENT_DATE()) <= 19 THEN 'Adolescent'
            WHEN TIMESTAMPDIFF(YEAR, u.DOB, CURRENT_DATE()) <= 64 THEN 'Adult'
            ELSE 'Senior Adult'
        END AS Age_Group
    FROM high_risk_patients hrp
    INNER JOIN Users u ON hrp.SSN = u.SSN
)
SELECT Age_Group, COUNT(*) AS High_Risk_Patients
FROM age_groups
GROUP BY Age_Group;

-- ============================================================================
-- 7. SELECT QUERIES USING GROUP BY AND HAVING (Minimum Required: 2, >= 1 HAVING)
-- ============================================================================

-- G1: Risk stratification across Low, Medium, and High tiers (Proposal Q1)
-- Purpose: Counts total assessments in each triage tier to gauge overall clinic risk distribution.
SELECT Risk_Level, COUNT(*) AS Number_of_Assessments
FROM Risk_Assessments
GROUP BY Risk_Level;

-- G2: Most prevalent conditions diagnosed in 2 or more patients (GROUP BY + HAVING)
-- Purpose: Highlights recurring chronic conditions/risk factors affecting multiple patients.
SELECT ICD_Code, COUNT(DISTINCT Patient_SSN) AS Number_of_Patients_Affected
FROM Patient_Diagnoses
GROUP BY ICD_Code
HAVING COUNT(DISTINCT Patient_SSN) >= 2
ORDER BY Number_of_Patients_Affected DESC;

-- ============================================================================
-- 8. SELECT QUERIES USING INNER JOIN (Minimum Required: 3, >= 1 with 3+ tables)
-- ============================================================================

-- J1: Full appointment schedule directory (6-table INNER JOIN)
-- Purpose: Displays appointment details with both patient and doctor names, department,
-- facility, and room assignment.
SELECT
    A.Appointment_Number,
    A.Appointment_Date,
    A.Appointment_Type,
    A.Status,
    CONCAT(PU.First_Name, ' ', PU.Last_Name) AS Patient_Name,
    CONCAT(DU.First_Name, ' ', DU.Last_Name) AS Doctor_Name,
    Dep.Facility_Name,
    Dep.Department_Name,
    A.Room_Number
FROM Appointments A
INNER JOIN Patients P ON A.Patient_SSN = P.SSN
INNER JOIN Users PU ON P.SSN = PU.SSN
INNER JOIN Doctors D ON A.Doctor_SSN = D.SSN
INNER JOIN Users DU ON D.SSN = DU.SSN
INNER JOIN Departments Dep ON A.Department_Name = Dep.Department_Name
ORDER BY A.Status, A.Appointment_Date;

-- J2: Automated lab abnormality screening against clinical threshold rules
-- Purpose: Evaluates completed lab results against Test_Threshold_Rules operators to flag
-- abnormal biomarkers automatically.
SELECT
    lt.Accession_Number,
    lt.Test_Name,
    lt.Test_Result,
    ttr.Abnormality_Threshold,
    ttr.Operator,
    CASE
        WHEN ttr.Operator = '>=' THEN CASE WHEN lt.Test_Result >= ttr.Abnormality_Threshold THEN 1 ELSE 0 END
        WHEN ttr.Operator = '<=' THEN CASE WHEN lt.Test_Result <= ttr.Abnormality_Threshold THEN 1 ELSE 0 END
        WHEN ttr.Operator = '>'  THEN CASE WHEN lt.Test_Result >  ttr.Abnormality_Threshold THEN 1 ELSE 0 END
        WHEN ttr.Operator = '<'  THEN CASE WHEN lt.Test_Result <  ttr.Abnormality_Threshold THEN 1 ELSE 0 END
        WHEN ttr.Operator = '='  THEN CASE WHEN lt.Test_Result =  ttr.Abnormality_Threshold THEN 1 ELSE 0 END
    END AS IsAbnormal
FROM Lab_Tests lt
INNER JOIN Test_Threshold_Rules ttr ON lt.Test_Name = ttr.Test_Name
WHERE lt.Status = 'Completed'
  AND lt.Test_Result IS NOT NULL;

-- J3: Active prescriptions per active patient (5-table INNER JOIN)
-- Purpose: Provides clinicians with a medication review list showing drug names, doses,
-- and instructions for currently active prescriptions.
SELECT
    CONCAT(u.First_Name, ' ', u.Last_Name) AS Patient_Name,
    a.Appointment_Number,
    m.Generic_Name AS Medicine_Name,
    m.Brand_Name AS Medicine_Brand,
    ap.Dose,
    ap.Instruction
FROM Users u
INNER JOIN Patients p ON u.SSN = p.SSN
INNER JOIN Appointments a ON p.SSN = a.Patient_SSN
INNER JOIN Appointment_Prescriptions ap ON a.Appointment_Number = ap.Appointment_Number
INNER JOIN Medications m ON ap.DIN = m.DIN
WHERE u.Status = 'Active'
  AND p.Status = 'Active'
  AND ap.Status = 'Active';

-- ============================================================================
-- 9. SELECT QUERIES USING LEFT JOIN OR RIGHT JOIN (Minimum Required: 2)
-- ============================================================================

-- L1: High-risk care-gap detection (Proposal Q2 / UN SDG 3.4)
-- Purpose: Identifies active patients whose latest assessment per NCD is High risk within
-- the last 6 months and who have no future Scheduled follow-up appointment.
WITH latest_assessments AS (
    SELECT
        ra.Patient_SSN,
        ra.NCD_Name,
        ra.Assessment_Date,
        ra.Score,
        ra.Risk_Level,
        ROW_NUMBER() OVER (
            PARTITION BY ra.Patient_SSN, ra.NCD_Name
            ORDER BY ra.Assessment_Date DESC, ra.Assessment_Number DESC
        ) AS rn
    FROM Risk_Assessments ra
)
SELECT
    CONCAT(u.First_Name, ' ', u.Last_Name) AS Patient_Name,
    la.NCD_Name,
    la.Assessment_Date,
    la.Score,
    la.Risk_Level
FROM latest_assessments la
JOIN Patients p ON la.Patient_SSN = p.SSN
JOIN Users u ON p.SSN = u.SSN
LEFT JOIN Appointments a
    ON la.Patient_SSN = a.Patient_SSN
   AND a.Status = 'Scheduled'
   AND a.Appointment_Date >= NOW()
WHERE la.rn = 1
  AND p.Status = 'Active'
  AND la.Risk_Level = 'High'
  AND la.Assessment_Date >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
  AND a.Appointment_Number IS NULL;

-- L2: Unassessed patients missing from risk screening
-- Purpose: Detects registered patients who have never received an NCD risk assessment.
SELECT
    CONCAT(u.First_Name, ' ', u.Last_Name) AS Patient_Name
FROM Patients p
INNER JOIN Users u ON p.SSN = u.SSN
LEFT JOIN Risk_Assessments ra ON p.SSN = ra.Patient_SSN
WHERE ra.Assessment_Number IS NULL;

-- ============================================================================
-- 10. COMPLEX SELECT QUERIES (Minimum Required: 1)
-- ============================================================================

-- C1: Facility-level high-risk patient workload (Proposal Q3)
-- Purpose: Counts distinct active patients whose latest assessment is High risk at each
-- facility and computes their average risk score (for facilities with > 1 High-risk patient).
WITH patient_latest_ncd_assessments AS (
    SELECT
        p.SSN,
        ra.NCD_Name,
        ra.Score,
        ra.Risk_Level,
        ROW_NUMBER() OVER (
            PARTITION BY p.SSN, ra.NCD_Name
            ORDER BY ra.Assessment_Date DESC, ra.Assessment_Number DESC
        ) AS row_num
    FROM Patients p
    INNER JOIN Risk_Assessments ra ON p.SSN = ra.Patient_SSN
    WHERE p.Status = 'Active'
),
high_risk_patients AS (
    SELECT
        SSN,
        MAX(Score) AS Max_High_Score
    FROM patient_latest_ncd_assessments
    WHERE row_num = 1
      AND Risk_Level = 'High'
    GROUP BY SSN
),
patient_appointment_facilities AS (
    SELECT
        f.Facility_Name,
        a.Patient_SSN,
        hr.Max_High_Score AS Score
    FROM Facilities f
    INNER JOIN Departments d ON f.Facility_Name = d.Facility_Name
    INNER JOIN Appointments a ON d.Department_Name = a.Department_Name
    INNER JOIN high_risk_patients hr ON a.Patient_SSN = hr.SSN
    WHERE a.Status = 'Completed'
    GROUP BY f.Facility_Name, hr.Max_High_Score, a.Patient_SSN
)
SELECT
    Facility_Name,
    COUNT(Patient_SSN) AS Number_of_Patients,
    ROUND(AVG(Score), 2) AS Average_Risk_Score
FROM patient_appointment_facilities
GROUP BY Facility_Name
HAVING COUNT(Patient_SSN) > 1
ORDER BY Number_of_Patients DESC;

-- C2: Doctor upcoming-appointment dashboard (Proposal Q4)
-- Purpose: Summarizes a specific doctor's upcoming Scheduled appointments alongside each
-- patient's latest risk scores across NCDs and counts of active prescriptions/treatments.
SET @Doctor_SSN = '200000003';

WITH doctor_appointments AS (
    SELECT
        Doctor_SSN,
        a.Appointment_Number,
        a.Appointment_Date,
        a.Appointment_Type,
        Patient_SSN
    FROM Appointments a
    WHERE Appointment_Date > NOW()
      AND a.Status IN ('Scheduled')
      AND Doctor_SSN = @Doctor_SSN
),
patient_latest_risk_score AS (
    SELECT
        da.*,
        ra.Score,
        ra.Risk_Level,
        ra.NCD_Name,
        ROW_NUMBER() OVER (
            PARTITION BY ra.Patient_SSN, ra.NCD_Name
            ORDER BY ra.Assessment_Date DESC, ra.Assessment_Number DESC
        ) AS rownumber
    FROM doctor_appointments da
    INNER JOIN Risk_Assessments ra ON da.Patient_SSN = ra.Patient_SSN
),
patient_risk_summary AS (
    SELECT
        Doctor_SSN,
        Appointment_Number,
        Appointment_Date,
        Appointment_Type,
        Patient_SSN,
        GROUP_CONCAT(
            CONCAT(NCD_Name, ' : ', Score, ' (', Risk_Level, ')')
            ORDER BY Score DESC
            SEPARATOR '; '
        ) AS Patient_Risk_Summary
    FROM patient_latest_risk_score
    WHERE rownumber = 1
    GROUP BY
        Doctor_SSN,
        Appointment_Number,
        Appointment_Date,
        Appointment_Type,
        Patient_SSN
)
SELECT
    pr.Doctor_SSN,
    pr.Appointment_Number,
    pr.Appointment_Date,
    pr.Appointment_Type,
    pr.Patient_SSN,
    pr.Patient_Risk_Summary,
    COUNT(DISTINCT ap.DIN) AS Number_of_Active_Prescriptions,
    COUNT(DISTINCT atr.Treatment_Code) AS Number_of_Active_Treatments
FROM patient_risk_summary pr
LEFT JOIN Appointments a
    ON pr.Patient_SSN = a.Patient_SSN
   AND a.Status = 'Completed'
LEFT JOIN Appointment_Prescriptions ap
    ON a.Appointment_Number = ap.Appointment_Number
   AND ap.Status = 'Active'
LEFT JOIN Appointment_Treatments atr
    ON a.Appointment_Number = atr.Appointment_Number
   AND atr.Status = 'In Progress'
GROUP BY
    pr.Doctor_SSN,
    pr.Appointment_Number,
    pr.Appointment_Date,
    pr.Appointment_Type,
    pr.Patient_SSN,
    pr.Patient_Risk_Summary;

-- C3: Medication-only vs. non-drug Treatment lab outcome comparison (Proposal Q5)
-- Purpose: Compares average lab results across shared test types between patients exclusively
-- receiving prescriptions versus patients exclusively receiving non-pharmacological treatments.
WITH prescription_patients AS (
    SELECT DISTINCT a.Patient_SSN
    FROM Appointments a
    JOIN Appointment_Prescriptions ap ON a.Appointment_Number = ap.Appointment_Number
    WHERE ap.Status IN ('Active', 'Completed')
),
treatment_patients AS (
    SELECT DISTINCT a.Patient_SSN
    FROM Appointments a
    JOIN Appointment_Treatments at ON a.Appointment_Number = at.Appointment_Number
    WHERE at.Status IN ('In Progress', 'Completed')
),
patient_groups AS (
    SELECT p.Patient_SSN, 'Medication' AS Care_Group
    FROM prescription_patients p
    LEFT JOIN treatment_patients t ON p.Patient_SSN = t.Patient_SSN
    WHERE t.Patient_SSN IS NULL

    UNION ALL

    SELECT t.Patient_SSN, 'Treatment' AS Care_Group
    FROM treatment_patients t
    LEFT JOIN prescription_patients p ON t.Patient_SSN = p.Patient_SSN
    WHERE p.Patient_SSN IS NULL
),
medication_patient_lab_result AS (
    SELECT pg.Care_Group, lt.Test_Name, ROUND(AVG(lt.Test_Result), 2) AS Medication_Avg_Result
    FROM patient_groups pg
    INNER JOIN Appointments a ON pg.Patient_SSN = a.Patient_SSN
    INNER JOIN Lab_Tests lt ON a.Appointment_Number = lt.Appointment_Number
    WHERE pg.Care_Group = 'Medication'
      AND lt.Test_Result IS NOT NULL
    GROUP BY pg.Care_Group, lt.Test_Name
),
treatment_patient_lab_result AS (
    SELECT pg.Care_Group, lt.Test_Name, ROUND(AVG(lt.Test_Result), 2) AS Treatment_Avg_Result
    FROM patient_groups pg
    INNER JOIN Appointments a ON pg.Patient_SSN = a.Patient_SSN
    INNER JOIN Lab_Tests lt ON a.Appointment_Number = lt.Appointment_Number
    WHERE pg.Care_Group = 'Treatment'
      AND lt.Test_Result IS NOT NULL
    GROUP BY pg.Care_Group, lt.Test_Name
)
SELECT
    m.Test_Name,
    m.Medication_Avg_Result,
    t.Treatment_Avg_Result
FROM medication_patient_lab_result m
INNER JOIN treatment_patient_lab_result t ON m.Test_Name = t.Test_Name;

-- C4: Most impactful medical condition per NCD by total population risk burden
-- Purpose: Identifies which condition drives the largest combined risk burden (affected active
-- patients x model weight) for each NCD under the latest active risk model.
WITH latest_models AS (
    SELECT NCD_Name, MAX(Effective_Date) AS Latest_Effective_Date
    FROM Risk_Models
    WHERE Effective_Date <= CURRENT_DATE()
    GROUP BY NCD_Name
),
condition_burden AS (
    SELECT
        rme.NCD_Name,
        mc.ICD_Code,
        mc.Condition_Name,
        COUNT(DISTINCT pd.Patient_SSN) AS Affected_Patients,
        rme.Risk_Weight,
        SUM(rme.Risk_Weight) AS Total_Risk_Burden,
        DENSE_RANK() OVER (
            PARTITION BY rme.NCD_Name
            ORDER BY SUM(rme.Risk_Weight) DESC
        ) AS rnk
    FROM Patient_Diagnoses pd
    INNER JOIN Patients p ON pd.Patient_SSN = p.SSN
    INNER JOIN Risk_Model_Evaluations rme ON pd.ICD_Code = rme.ICD_Code
    INNER JOIN latest_models lm
        ON rme.NCD_Name = lm.NCD_Name
       AND rme.Effective_Date = lm.Latest_Effective_Date
    INNER JOIN Medical_Conditions mc ON rme.ICD_Code = mc.ICD_Code
    WHERE p.Status = 'Active'
      AND pd.Status IN ('Active', 'Chronic')
    GROUP BY rme.NCD_Name, mc.ICD_Code, mc.Condition_Name, rme.Risk_Weight
)
SELECT NCD_Name, ICD_Code, Condition_Name, Affected_Patients, Risk_Weight, Total_Risk_Burden
FROM condition_burden
WHERE rnk = 1
ORDER BY Total_Risk_Burden DESC;

-- C5: Longitudinal risk score progression per patient and NCD
-- Purpose: Tracks whether patients' NCD risk scores Improved, Worsened, or remained Unchanged
-- between consecutive assessments to measure SDG 3.4 intervention effectiveness.
WITH assessment_trend AS (
    SELECT
        ra.Patient_SSN,
        CONCAT(u.First_Name, ' ', u.Last_Name) AS Patient_Name,
        ra.NCD_Name,
        ra.Assessment_Date,
        LAG(ra.Score) OVER (
            PARTITION BY ra.Patient_SSN, ra.NCD_Name
            ORDER BY ra.Assessment_Date, ra.Assessment_Number
        ) AS Previous_Score,
        ra.Score AS Current_Score,
        ra.Risk_Level
    FROM Risk_Assessments ra
    INNER JOIN Users u ON ra.Patient_SSN = u.SSN
)
SELECT
    Patient_Name,
    NCD_Name,
    Assessment_Date,
    Previous_Score,
    Current_Score,
    (Current_Score - Previous_Score) AS Score_Change,
    CASE
        WHEN Current_Score < Previous_Score THEN 'Improved'
        WHEN Current_Score > Previous_Score THEN 'Worsened'
        ELSE 'Unchanged'
    END AS Trend
FROM assessment_trend
WHERE Previous_Score IS NOT NULL
ORDER BY Patient_Name, NCD_Name, Assessment_Date;

-- C6: Multi-NCD comorbidity profile
-- Purpose: Flags active patients whose latest assessments place them at Medium or High risk
-- across 2 or more distinct NCDs for coordinated multi-specialty care.
WITH latest_ncd_assessments AS (
    SELECT
        ra.Patient_SSN,
        CONCAT(u.First_Name, ' ', u.Last_Name) AS Patient_Name,
        ra.NCD_Name,
        ra.Score,
        ra.Risk_Level,
        ROW_NUMBER() OVER (
            PARTITION BY ra.Patient_SSN, ra.NCD_Name
            ORDER BY ra.Assessment_Date DESC, ra.Assessment_Number DESC
        ) AS rn
    FROM Risk_Assessments ra
    INNER JOIN Patients p ON ra.Patient_SSN = p.SSN
    INNER JOIN Users u ON p.SSN = u.SSN
    WHERE p.Status = 'Active'
)
SELECT
    Patient_SSN,
    Patient_Name,
    COUNT(DISTINCT NCD_Name) AS Elevated_NCD_Count,
    ROUND(AVG(Score), 2) AS Avg_Elevated_Score,
    GROUP_CONCAT(
        CONCAT(NCD_Name, ' (', Risk_Level, ': ', Score, ')')
        ORDER BY Score DESC
        SEPARATOR '; '
    ) AS Comorbidity_Profile
FROM latest_ncd_assessments
WHERE rn = 1
  AND Risk_Level IN ('Medium', 'High')
GROUP BY Patient_SSN, Patient_Name
HAVING COUNT(DISTINCT NCD_Name) >= 2
ORDER BY Elevated_NCD_Count DESC, Avg_Elevated_Score DESC;

-- C7: Undiagnosed abnormal lab alerts (early screening gap)
-- Purpose: Detects active patients with completed abnormal lab results breaching a
-- Test_Threshold_Rules rule who do not yet have a matching Active/Chronic diagnosis.
SELECT
    a.Patient_SSN,
    CONCAT(u.First_Name, ' ', u.Last_Name) AS Patient_Name,
    lt.Accession_Number,
    lt.Test_Date,
    lt.Test_Name,
    lt.Test_Result,
    CONCAT(ttr.Operator, ' ', ttr.Abnormality_Threshold) AS Threshold_Rule,
    mc.ICD_Code,
    mc.Condition_Name AS Suggested_Condition
FROM Lab_Tests lt
INNER JOIN Appointments a ON lt.Appointment_Number = a.Appointment_Number
INNER JOIN Patients p ON a.Patient_SSN = p.SSN
INNER JOIN Users u ON p.SSN = u.SSN
INNER JOIN Test_Threshold_Rules ttr ON lt.Test_Name = ttr.Test_Name
INNER JOIN Medical_Conditions mc ON ttr.ICD_Code = mc.ICD_Code
LEFT JOIN Patient_Diagnoses pd
    ON a.Patient_SSN = pd.Patient_SSN
   AND ttr.ICD_Code = pd.ICD_Code
   AND pd.Status IN ('Active', 'Chronic')
WHERE p.Status = 'Active'
  AND lt.Status = 'Completed'
  AND lt.Test_Result IS NOT NULL
  AND pd.ICD_Code IS NULL
  AND (
      (ttr.Operator = '>=' AND lt.Test_Result >= ttr.Abnormality_Threshold) OR
      (ttr.Operator = '<=' AND lt.Test_Result <= ttr.Abnormality_Threshold) OR
      (ttr.Operator = '>'  AND lt.Test_Result >  ttr.Abnormality_Threshold) OR
      (ttr.Operator = '<'  AND lt.Test_Result <  ttr.Abnormality_Threshold) OR
      (ttr.Operator = '='  AND lt.Test_Result =  ttr.Abnormality_Threshold)
  )
ORDER BY lt.Test_Date DESC, a.Patient_SSN;
