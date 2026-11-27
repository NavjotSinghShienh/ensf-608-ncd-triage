# SQL Operations & Query Execution Results

Execution evidence for all SQL operations, analytical queries, and stored procedures defined in [`scripts/DML.sql`](../scripts/DML.sql) and [`scripts/procedure.sql`](../scripts/procedure.sql), executed against `NCD_Risk_Identification_System` on **MySQL Server 8.4** (after running `DDL.sql` and `seed.sql`).

---

## 1. INSERT Operations

### `I1` — Book Follow-Up Appointments for High-Risk Care-Gap Patients
![I1 Result](screenshots/DML/I1_DML.png)

### `I2` — Publish Versioned Cancer Risk Model (`Risk_Models`, `Risk_Thresholds`, `Risk_Model_Evaluations`)
- **Risk Model Inserted:**
  ![I2 Risk Model](screenshots/DML/I2_1_DML.png)
- **Risk Thresholds Inserted:**
  ![I2 Risk Thresholds](screenshots/DML/I2_2_DML.png)
- **Risk Model Evaluations Inserted:**
  ![I2 Risk Model Evaluations](screenshots/DML/I2_3_DML.png)

---

## 2. UPDATE Operations

### `U1` — Mark Patient Smoking Risk Factor (`Z72.0`) as Resolved
- **Before Update:**
  ![U1 Before](screenshots/DML/U1_1_DML.png)
- **After Update:**
  ![U1 After](screenshots/DML/U1_2_DML.png)

### `U2` — Complete In-Progress HbA1c Lab Order (`ACC-2026-020`)
- **Before Update:**
  ![U2 Before](screenshots/DML/U2_1_DML.png)
- **After Update:**
  ![U2 After](screenshots/DML/U2_2_DML.png)

---

## 3. DELETE Operations

### `D1` — Delete Outdated Emergency Contact Phone Number
- **Before Delete:**
  ![D1 Before](screenshots/DML/D1_1_DML.png)
- **After Delete:**
  ![D1 After](screenshots/DML/D1_2_DML.png)

### `D2` — Delete Draft 2027 Type 2 Diabetes Model (with `ON DELETE CASCADE` on `Risk_Thresholds`)
- **Before Delete (`Risk_Models`, `Risk_Model_Evaluations`, `Risk_Thresholds`):**
  ![D2 Before 1](screenshots/DML/D2_1_DML.png)
  ![D2 Before 2](screenshots/DML/D2_2_DML.png)
  ![D2 Before 3](screenshots/DML/D2_3_DML.png)
- **After Delete (`Risk_Models`, `Risk_Model_Evaluations`, `Risk_Thresholds`):**
  ![D2 After 1](screenshots/DML/D2_4_DML.png)
  ![D2 After 2](screenshots/DML/D2_5_DML.png)
  ![D2 After 3](screenshots/DML/D2_6_DML.png)

---

## 4. Basic SELECT Queries with Filtering

### `S1` — Pending Lab Worklist (`IN`)
![S1 Result](screenshots/DML/S1_DML.png)

### `S2` — Audit of Care-Gap Notifications (`LIKE`)
![S2 Result](screenshots/DML/S2_DML.png)

### `S3` — Active Modifiable Lifestyle Risk Factors (`=`)
![S3 Result](screenshots/DML/S3_DML.png)

### `S4` — High-Risk SDG 3.4.1 Assessments in Q3/Q4 2026 (`BETWEEN`)
![S4 Result](screenshots/DML/S4_DML.png)

---

## 5. SELECT Queries Using `ORDER BY`, `DISTINCT`, or `LIMIT`

### `O1` — Top 5 Highest-Scoring Risk Assessments
![O1 Result](screenshots/DML/O1_DML.png)

### `O2` — Distinct ICD-10 Conditions Diagnosed
![O2 Result](screenshots/DML/O2_DML.png)

---

## 6. SELECT Queries Using Aggregate Functions

### `A1` — Overall Population Risk Score Summary (`MAX`, `MIN`, `AVG`)
![A1 Result](screenshots/DML/A1_DML.png)

### `A2` — Diabetes Glycemic Control Summary Across Completed HbA1c Labs (`COUNT`, `AVG`, `MIN`, `MAX`)
![A2 Result](screenshots/DML/A2_DML.png)

### `A3` — Active High-Risk Patients by Age Group (`COUNT`)
![A3 Result](screenshots/DML/A3_DML.png)

---

## 7. SELECT Queries Using `GROUP BY` and `HAVING`

### `G1` — Risk Stratification Across Low, Medium, and High Tiers (Proposal Q1)
![G1 Result](screenshots/DML/G1_DML.png)

### `G2` — Conditions Diagnosed in 2 or More Patients (`GROUP BY` + `HAVING`)
![G2 Result](screenshots/DML/G2_DML.png)

---

## 8. SELECT Queries Using `INNER JOIN`

### `J1` — Full Appointment Schedule Directory (6-Table `INNER JOIN`)
![J1 Result](screenshots/DML/J1_DML.png)

### `J2` — Automated Lab Abnormality Screening Against Threshold Rules
![J2 Result](screenshots/DML/J2_DML.png)

### `J3` — Active Prescriptions per Active Patient (5-Table `INNER JOIN`)
![J3 Result](screenshots/DML/J3_DML.png)

---

## 9. SELECT Queries Using `LEFT JOIN`

### `L1` — High-Risk Care-Gap Detection (Proposal Q2 / UN SDG 3.4)
![L1 Result](screenshots/DML/L1_DML.png)

### `L2` — Unassessed Patients Missing from Risk Screening
![L2 Result](screenshots/DML/L2_DML.png)

---

## 10. Complex SELECT Queries

### `C1` — Facility-Level High-Risk Patient Workload (Proposal Q3)
![C1 Result](screenshots/DML/C1_DML.png)

### `C2` — Doctor Upcoming-Appointment Dashboard (Proposal Q4)
![C2 Result](screenshots/DML/C2_DML.png)

### `C3` — Medication-Only vs. Non-Drug Treatment Lab Outcome Comparison (Proposal Q5)
![C3 Result](screenshots/DML/C3_DML.png)

### `C4` — Most Impactful Medical Condition per NCD by Population Risk Burden
![C4 Result](screenshots/DML/C4_DML.png)

### `C5` — Longitudinal Risk Score Progression per Patient and NCD
![C5 Result](screenshots/DML/C5_DML.png)

### `C6` — Multi-NCD Comorbidity Profile
![C6 Result](screenshots/DML/C6_DML.png)

### `C7` — Undiagnosed Abnormal Lab Alerts
![C7 Result](screenshots/DML/C7_DML.png)

---

## 11. Stored Procedures (`sp_Notify` & `sp_CalculateRiskAssessment`)

- **Generated `Risk_Assessments` Scenarios (`High`, `Medium`):**
  ![Risk Assessment SP Output](screenshots/procedure/P_RA.png)
- **Auto-Generated `Notifications` (`HIGH RISK ALERT`, `FOLLOW-UP ALERT`, `CARE GAP NOTICE`):**
  ![Notification SP Output](screenshots/procedure/P_Not.png)
