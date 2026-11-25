# Database Testing Results

## Execution status

**Pending MySQL execution.** The implementation environment did not have a
MySQL client/server, MySQL Shell, or a container runtime available, so no
database execution results are claimed here. The expected results below are
test criteria, not passes. Run the scripts against MySQL 8.0.16 or later and
replace each pending actual-output/status entry with the output from that run.

Run `scripts/DDL.sql`, then `scripts/seed.sql`, then `scripts/testing.sql` in
the same MySQL version. The final result sets from `testing.sql` contain
`Test_ID`, `Category`, `Expected_Outcome`, `Actual_Output`, and `Pass_Fail`.
The two `CALL` statements also emit result sets; confirm the returned rows
match their expected outcomes below. Preserve the final output or screenshots
with this document when recording the execution.

## Constraint and referential-integrity tests

| Test ID | Category | Expected outcome | Actual MySQL output/error | Pass/Fail |
| --- | --- | --- | --- | --- |
| NEG-DUP-SSN | PK / UNIQUE | Duplicate user SSN rejected (1062) | Pending MySQL run | Pending |
| NEG-DUP-EMAIL | PK / UNIQUE | Duplicate user email rejected (1062) | Pending MySQL run | Pending |
| NEG-DUP-HEALTHCARE | PK / UNIQUE | Duplicate healthcare number rejected (1062) | Pending MySQL run | Pending |
| NEG-DUP-LICENSE | PK / UNIQUE | Duplicate doctor license rejected (1062) | Pending MySQL run | Pending |
| NEG-DUP-EMPLOYEE-NUMBER | PK / UNIQUE | Duplicate employee number rejected (1062) | Pending MySQL run | Pending |
| NEG-DUP-CERTIFICATION | PK / UNIQUE | Duplicate lab certification rejected (1062) | Pending MySQL run | Pending |
| NEG-FK-ASSISTANT-DOCTOR | Foreign key | Lab assistant cannot be assigned as appointment doctor (1452) | Pending MySQL run | Pending |
| NEG-FK-ROOM | Foreign key | Nonexistent department/room pair rejected (1452) | Pending MySQL run | Pending |
| NEG-CHECK-SSN | CHECK | Eight-digit SSN rejected (3819) | Pending MySQL run | Pending |
| NEG-CHECK-DIN | CHECK | Invalid DIN rejected (3819) | Pending MySQL run | Pending |
| NEG-CHECK-BLOOD-TYPE | CHECK | Invalid blood type rejected (3819) | Pending MySQL run | Pending |
| NEG-CHECK-RANGE | CHECK | Maximum range below minimum rejected (3819) | Pending MySQL run | Pending |
| NEG-CHECK-NEGATIVE-SCORE | CHECK | Negative risk score rejected (3819) | Pending MySQL run | Pending |
| NEG-CHECK-STATUS | CHECK | Invalid appointment status rejected (3819) | Pending MySQL run | Pending |
| NEG-NOT-NULL-EMAIL | NOT NULL | Missing mandatory Users.Email rejected (1048) | Pending MySQL run | Pending |
| NEG-NOT-NULL-PATIENT | NOT NULL | Missing mandatory Appointments.Patient_SSN rejected (1048) | Pending MySQL run | Pending |
| DELETE-CASCADE-THRESHOLD | ON DELETE | Deleting a test Risk_Model removes its Risk_Thresholds | Pending MySQL run | Pending |
| NEG-DELETE-DOCTOR | ON DELETE | Deleting a doctor referenced by appointments rejected (1451) | Pending MySQL run | Pending |

## Positive DML and stored-procedure tests

| Test ID | Category | Expected outcome | Actual MySQL output/error | Pass/Fail |
| --- | --- | --- | --- | --- |
| DML-INSERT-USER | Positive DML | Test user inserted | Pending MySQL run | Pending |
| DML-INSERT-PATIENT | Positive DML | Test patient inserted | Pending MySQL run | Pending |
| DML-UPDATE-USER | Positive DML | Test user status changes to Suspended | Pending MySQL run | Pending |
| DML-UPDATE-PATIENT | Positive DML | Test patient status changes to Inactive | Pending MySQL run | Pending |
| DML-DELETE-CONTACT | Positive DML | One test contact deleted; the other remains | Pending MySQL run | Pending |
| DML-DELETE-PATIENT | Positive DML | Test patient and remaining dependent contact deleted | Pending MySQL run | Pending |
| PROC-PATIENT-RISK | Stored procedure | `GetPatientRiskAssessments` returns assessment 501 for patient 400000001 | Pending MySQL run | Pending |
| PROC-HIGH-RISK | Stored procedure | `GetHighRiskAssessments` returns six seeded high-risk assessments | Pending MySQL run | Pending |

Positive DML and the cascade test run inside a transaction that ends with
`ROLLBACK`, so the seeded database is unchanged. The results table is
session-only; export or copy the final result sets before closing the session.
