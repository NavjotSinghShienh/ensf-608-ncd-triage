
USE NCD_Risk_Identification_System;

-- ============================================================================
-- 11. STORED PROCEDURES (Minimum Required: 2, including >= 1 with IN parameter)
-- ============================================================================

-- P1: Automated High-Risk & Care-Gap Notification Procedure
-- Purpose: Sends a standardized HIGH RISK or FOLLOW-UP alert to the patient's most recent
-- active doctor (falling back to an active Receptionist) and a CARE GAP NOTICE if no future
-- Scheduled appointment exists.

DROP PROCEDURE IF EXISTS sp_Notify;

DELIMITER //

CREATE PROCEDURE sp_Notify(IN p_assessment_number INT)
BEGIN
    DECLARE patient_ssn_label CHAR(9) DEFAULT NULL;
    DECLARE ncd_name_label VARCHAR(100) DEFAULT NULL;
    DECLARE calculated_score DECIMAL(5,2) DEFAULT NULL;
    DECLARE calculated_risk_level VARCHAR(20) DEFAULT NULL;
    DECLARE prev_score DECIMAL(5,2) DEFAULT NULL;
    DECLARE patient_label VARCHAR(150) DEFAULT NULL;
    DECLARE doctor_ssn_label CHAR(9) DEFAULT NULL;
    DECLARE admin_ssn_label CHAR(9) DEFAULT NULL;
    DECLARE notification_date DATETIME;

    SET notification_date = NOW();

    SELECT Patient_SSN, NCD_Name, Score, Risk_Level
    INTO patient_ssn_label, ncd_name_label, calculated_score, calculated_risk_level
    FROM Risk_Assessments
    WHERE Assessment_Number = p_assessment_number;

    IF calculated_risk_level = 'High' THEN

        SELECT CONCAT(u.First_Name, ' ', u.Last_Name, ' (', p.Healthcare_Number, ')')
        INTO patient_label
        FROM Patients p
        JOIN Users u ON p.SSN = u.SSN
        WHERE p.SSN = patient_ssn_label;

        SELECT Score
        INTO prev_score
        FROM Risk_Assessments
        WHERE Patient_SSN = patient_ssn_label
          AND NCD_Name = ncd_name_label
          AND Assessment_Number <> p_assessment_number
        ORDER BY Assessment_Date DESC, Assessment_Number DESC
        LIMIT 1;

        SELECT a.Doctor_SSN
        INTO doctor_ssn_label
        FROM Appointments a
        JOIN Health_Professionals hp ON a.Doctor_SSN = hp.SSN
        WHERE a.Patient_SSN = patient_ssn_label
          AND a.Status IN ('Completed', 'Scheduled')
          AND hp.Status = 'Active'
        ORDER BY a.Appointment_Date DESC
        LIMIT 1;

        -- Find an active Receptionist (used for care-gap notice & fallback)
        SELECT SSN
        INTO admin_ssn_label
        FROM Admins
        WHERE Role = 'Receptionist'
          AND IsActive = TRUE
        LIMIT 1;

        INSERT INTO Notifications (Assessment_Number, Date_Notified, Recipient_User_SSN, Message)
        VALUES (
            p_assessment_number,
            notification_date,
            COALESCE(doctor_ssn_label, admin_ssn_label),
            IF(
                prev_score IS NULL,
                CONCAT('HIGH RISK ALERT: Patient ', patient_label, ' scored ', calculated_score, ' (High Risk) for ', ncd_name_label, '.'),
                CONCAT('FOLLOW-UP ALERT: Patient ', patient_label, ' scored ', calculated_score, ' (previous: ', prev_score, ', still High Risk) for ', ncd_name_label, '.')
            )
        );

        IF admin_ssn_label IS NOT NULL AND NOT EXISTS (
            SELECT 1
            FROM Appointments
            WHERE Patient_SSN = patient_ssn_label
              AND Status = 'Scheduled'
              AND Appointment_Date >= NOW()
        ) THEN
            INSERT INTO Notifications (Assessment_Number, Date_Notified, Recipient_User_SSN, Message)
            VALUES (
                p_assessment_number,
                DATE_ADD(notification_date, INTERVAL 1 MINUTE),
                admin_ssn_label,
                CONCAT('CARE GAP NOTICE: Patient ', patient_label, ' flagged High Risk (', calculated_score, ') for ', ncd_name_label, ' with NO upcoming appointment scheduled.')
            );
        END IF;
    END IF;
END //

DELIMITER ;

-- P2: Calculate Risk Assessment & Trigger Notification
-- Purpose: Selects the latest active Risk_Model, sums
-- Active/Chronic diagnosis weights (capped at 100.00), determines the Risk_Tier, inserts a
-- new Risk_Assessments record, and calls sp_Notify for High-risk outcomes.

DROP PROCEDURE IF EXISTS sp_CalculateRiskAssessment;

DELIMITER //

CREATE PROCEDURE sp_CalculateRiskAssessment(IN p_patient_ssn CHAR(9), IN p_ncd_name VARCHAR(100))
BEGIN
    DECLARE inserted_risk_assessment_id INT DEFAULT NULL;

    INSERT INTO Risk_Assessments (Score, Risk_Level, Patient_SSN, NCD_Name, Effective_Date)
    WITH latest_risk_model AS (
        SELECT NCD_Name, Effective_Date
        FROM Risk_Models
        WHERE NCD_Name = p_ncd_name
          AND Effective_Date <= CURRENT_DATE()
        ORDER BY Effective_Date DESC
        LIMIT 1
    ),
    calculated_total_risk AS (
        SELECT
            pd.Patient_SSN,
            lr.NCD_Name,
            lr.Effective_Date,
            LEAST(SUM(rm.Risk_Weight), 100.00) AS Calculated_Risk_Score
        FROM Patient_Diagnoses pd
        INNER JOIN Risk_Model_Evaluations rm ON pd.ICD_Code = rm.ICD_Code
        INNER JOIN latest_risk_model lr
            ON rm.NCD_Name = lr.NCD_Name
           AND rm.Effective_Date = lr.Effective_Date
        WHERE pd.Patient_SSN = p_patient_ssn
          AND pd.Status IN ('Active', 'Chronic')
        GROUP BY pd.Patient_SSN, lr.NCD_Name, lr.Effective_Date
    ),
    computed_risk_assessment AS (
        SELECT
            ctr.Patient_SSN,
            ctr.NCD_Name,
            ctr.Effective_Date,
            ctr.Calculated_Risk_Score,
            rt.Risk_Tier
        FROM calculated_total_risk ctr
        INNER JOIN Risk_Thresholds rt
            ON ctr.NCD_Name = rt.NCD_Name
           AND ctr.Effective_Date = rt.Effective_Date
        WHERE ctr.Calculated_Risk_Score BETWEEN rt.Min_Score AND rt.Max_Score
    )
    SELECT Calculated_Risk_Score, Risk_Tier, Patient_SSN, NCD_Name, Effective_Date
    FROM computed_risk_assessment;

    IF ROW_COUNT() > 0 THEN
        SET inserted_risk_assessment_id = LAST_INSERT_ID();
        CALL sp_Notify(inserted_risk_assessment_id);
    END IF;
END //

DELIMITER ;

-- Verification calls covering all scenarios (wrapped in a transaction to keep seed data clean)
START TRANSACTION;

SET @test_start = NOW();

-- Scenario 1: High Risk + Follow-Up Alert (patient has prior assessment & upcoming Scheduled appt)
-- Expected: Inserts Score 75.00 (High) using 2026-01-01 model; sends FOLLOW-UP ALERT to Doctor 200000001; NO care-gap notice.
CALL sp_CalculateRiskAssessment('400000001', 'Cardiovascular Disease');

-- Scenario 2: High Risk + Follow-Up Alert + Care-Gap Notice (NO upcoming Scheduled appt)
-- Expected: Inserts Score 80.00 (High); sends FOLLOW-UP ALERT to Doctor 200000001 AND CARE GAP NOTICE to Receptionist 100000002.
CALL sp_CalculateRiskAssessment('400000005', 'Cardiovascular Disease');

-- Scenario 3: Medium Risk (below High threshold)
-- Expected: Inserts Score 40.00 (Medium); triggers NO notifications.
CALL sp_CalculateRiskAssessment('400000008', 'Type 2 Diabetes');

-- Scenario 4: Standalone sp_Notify call for an Initial High-Risk Alert (no prior assessment for Cancer)
-- Expected: Sends HIGH RISK ALERT to Oncologist 200000003 for assessment 5011 (Devon Blackwood).
CALL sp_Notify(5011);

SELECT * FROM Risk_Assessments
WHERE Assessment_Date >= @test_start
ORDER BY Assessment_Number;

SELECT * FROM Notifications
WHERE Date_Notified >= @test_start
ORDER BY Date_Notified;

ROLLBACK;