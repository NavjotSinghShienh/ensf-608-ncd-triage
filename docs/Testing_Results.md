# Database Testing Results

## Execution summary

Executed on **MySQL Server 8.4.11** against `NCD_Risk_Identification_System`
after running `scripts/DDL.sql`, `scripts/seed.sql`, and `scripts/testing.sql`
in order.

| Total tests | Passed | Failed |
| ---: | ---: | ---: |
| 28 | 28 | 0 |

The test script emitted the actual outputs below. For expected failures, it
captures MySQL's error code and message in `Actual_Output`. Both risk-procedure
`CALL`s also returned the stated rows. Positive DML and the cascade test were
rolled back; follow-up queries confirmed the seeded counts remained
`Users=21`, `Patients=10`, `Appointments=14`, `Risk_Models=4`, and
`Risk_Thresholds=12`, with no test users, patients, or models remaining.

## Constraint and referential-integrity tests

| Test ID | Category | Expected outcome | Actual MySQL output/error | Pass/Fail |
| --- | --- | --- | --- | --- |
| NEG-DUP-SSN | PK / UNIQUE | Duplicate user SSN rejected (1062) | `1062`: Duplicate entry for `users.PRIMARY` | PASS |
| NEG-DUP-EMAIL | PK / UNIQUE | Duplicate user email rejected (1062) | `1062`: Duplicate entry for `users.UQ_Users_Email` | PASS |
| NEG-DUP-HEALTHCARE | PK / UNIQUE | Duplicate healthcare number rejected (1062) | `1062`: Duplicate entry for `patients.UQ_Patients_Healthcare_Number` | PASS |
| NEG-DUP-LICENSE | PK / UNIQUE | Duplicate doctor license rejected (1062) | `1062`: Duplicate entry for `doctors.UQ_Doctors_License` | PASS |
| NEG-DUP-EMPLOYEE-NUMBER | PK / UNIQUE | Duplicate employee number rejected (1062) | `1062`: Duplicate entry for `health_professionals.UQ_Health_Professionals_Emp_No` | PASS |
| NEG-DUP-CERTIFICATION | PK / UNIQUE | Duplicate lab certification rejected (1062) | `1062`: Duplicate entry for `lab_assistants.UQ_Lab_Assistants_Cert_No` | PASS |
| NEG-FK-ASSISTANT-DOCTOR | Foreign key | Lab assistant cannot be assigned as appointment doctor (1452) | `1452`: Foreign key constraint `FK_Appointments_Doctors` failed | PASS |
| NEG-FK-ROOM | Foreign key | Nonexistent department/room pair rejected (1452) | `1452`: Foreign key constraint `FK_Appointments_Rooms` failed | PASS |
| NEG-CHECK-SSN | CHECK | Eight-digit SSN rejected (3819) | `3819`: `CK_Users_SSN` violated | PASS |
| NEG-CHECK-DIN | CHECK | Invalid DIN rejected (3819) | `3819`: `CK_Medications_DIN` violated | PASS |
| NEG-CHECK-BLOOD-TYPE | CHECK | Invalid blood type rejected (3819) | `3819`: `CK_Patients_Blood_Type` violated | PASS |
| NEG-CHECK-RANGE | CHECK | Maximum range below minimum rejected (3819) | `3819`: `CK_Test_Types_Range` violated | PASS |
| NEG-CHECK-NEGATIVE-SCORE | CHECK | Negative risk score rejected (3819) | `3819`: `CK_Risk_Assessments_Score` violated | PASS |
| NEG-CHECK-STATUS | CHECK | Invalid appointment status rejected (3819) | `3819`: `CK_Appointments_Status` violated | PASS |
| NEG-MISSING-EMAIL | NOT NULL omission | Omitted mandatory `Users.Email` rejected | `1364`: Field `Email` doesn't have a default value | PASS |
| NEG-MISSING-PATIENT | NOT NULL omission | Omitted mandatory `Appointments.Patient_SSN` rejected | `1364`: Field `Patient_SSN` doesn't have a default value | PASS |
| NEG-NULL-EMAIL | NOT NULL | `NULL` `Users.Email` rejected (1048) | `1048`: Column `Email` cannot be null | PASS |
| NEG-NULL-PATIENT | NOT NULL | `NULL` `Appointments.Patient_SSN` rejected (1048) | `1048`: Column `Patient_SSN` cannot be null | PASS |
| DELETE-CASCADE-THRESHOLD | ON DELETE | Deleting a test `Risk_Model` removes its `Risk_Thresholds` | Remaining model rows: 0; threshold rows: 0 | PASS |
| NEG-DELETE-DOCTOR | ON DELETE | Deleting a doctor referenced by appointments rejected (1451) | `1451`: Foreign key constraint `FK_Appointments_Doctors` failed | PASS |

## Positive DML and stored-procedure tests

| Test ID | Category | Expected outcome | Actual MySQL output | Pass/Fail |
| --- | --- | --- | --- | --- |
| DML-INSERT-USER | Positive DML | Test user inserted | Rows found: 1 | PASS |
| DML-INSERT-PATIENT | Positive DML | Test patient inserted | Rows found: 1 | PASS |
| DML-UPDATE-USER | Positive DML | Test user status changes to Suspended | Status: Suspended | PASS |
| DML-UPDATE-PATIENT | Positive DML | Test patient status changes to Inactive | Status: Inactive | PASS |
| DML-DELETE-CONTACT | Positive DML | One test contact deleted; the other remains | Remaining test contacts: 1 | PASS |
| DML-DELETE-PATIENT | Positive DML | Test patient and dependent contacts deleted | Patients: 0; contacts: 0 | PASS |
| PROC-PATIENT-RISK | Stored procedure | `GetPatientRiskAssessments` returns assessment 501 for patient 400000001 | Returned assessment 501; matching seeded assessments: 1 | PASS |
| PROC-HIGH-RISK | Stored procedure | `GetHighRiskAssessments` returns six seeded high-risk assessments | Returned assessments 506, 501, 503, 502, 510, 508; matching seeded assessments: 6 | PASS |
