# Relational Schema with Data Types - NCD Triage System

**ENSF 608 - Group 6**

**Notation** (follows the class ER Mapping example): each table header lists its attributes; `#` marks a foreign key (FK). Primary key columns are underlined in the attribute lines. Data types are standard MySQL-style defaults.

Derived from the Conceptual and Logical models.

---

### A. User hierarchy

**USER (SSN, FIRST_NAME, LAST_NAME, DOB, ADDRESS, EMAIL, PASSWORD, PHONE_NUMBER, STATUS)**
- <u>SSN</u> &nbsp; `char(9)`, digits only
- First_Name &nbsp; `varchar(50)`, not null
- Last_Name &nbsp; `varchar(50)`, not null
- DOB &nbsp; `date`, not null, must not be in the future (`Age` is derived from `DOB`, not stored)
- Address &nbsp; `varchar(150)`
- Email &nbsp; `varchar(100)`, unique, not null
- Password &nbsp; `varchar(255)`, not null, stored as a hash
- Phone_Number &nbsp; `varchar(15)`, unique
- Status &nbsp; `varchar(20)`, not null, one of `Active` / `Inactive` / `Suspended`
- Primary key is <u>SSN</u>

**PATIENT (SSN#, HEALTHCARE_NUMBER, GENDER, BLOOD_TYPE, STATUS)**
- <u>SSN#</u> &nbsp; `char(9)`, refers to `SSN` in the table `USER`
- Healthcare_Number &nbsp; `varchar(20)`, unique, not null
- Gender &nbsp; `varchar(20)`
- Blood_Type &nbsp; `varchar(3)`, one of `A+`, `A-`, `B+`, `B-`, `AB+`, `AB-`, `O+`, `O-`
- Status &nbsp; `varchar(20)`, not null, one of `Active` / `Inactive` / `Deceased`
- Primary key is <u>SSN#</u>

**PATIENT_EMERGENCY_CONTACT (PATIENT_SSN#, CONTACT_NAME, CONTACT_PHONE_NUMBER)**
- <u>Patient_SSN#</u> &nbsp; `char(9)`, refers to `SSN` in the table `PATIENT`
- <u>Contact_Name</u> &nbsp; `varchar(100)`, not null
- <u>Contact_Phone_Number</u> &nbsp; `varchar(15)`, not null
- Primary key is (`Patient_SSN`, `Contact_Name`, `Contact_Phone_Number`)

**HEALTH_PROFESSIONAL (SSN#, EMPLOYEE_NUMBER, EMPLOYMENT_DATE, STATUS, DEPARTMENT_NAME#)**
- <u>SSN#</u> &nbsp; `char(9)`, refers to `SSN` in the table `USER`
- Employee_Number &nbsp; `varchar(20)`, unique, not null
- Employment_Date &nbsp; `date`, not null
- Status &nbsp; `varchar(20)`, not null, one of `Active` / `On Leave` / `Terminated`
- Department_Name# &nbsp; `varchar(100)`, not null, refers to `Department_Name` in the table `DEPARTMENT`
- Primary key is <u>SSN#</u>

**DOCTOR (SSN#, LICENSE_NUMBER, SPECIALITY, QUALIFICATION)**
- <u>SSN#</u> &nbsp; `char(9)`, refers to `SSN` in the table `HEALTH_PROFESSIONAL`
- License_Number &nbsp; `varchar(30)`, unique, not null
- Speciality &nbsp; `varchar(100)`
- Qualification &nbsp; `varchar(150)`
- Primary key is <u>SSN#</u>

**LAB_ASSISTANT (SSN#, CERTIFICATION_NUMBER, CERTIFICATION_TYPE, LAB_SPECIALIZATION)**
- <u>SSN#</u> &nbsp; `char(9)`, refers to `SSN` in the table `HEALTH_PROFESSIONAL`
- Certification_Number &nbsp; `varchar(30)`, unique, not null
- Certification_Type &nbsp; `varchar(100)`
- Lab_Specialization &nbsp; `varchar(100)`
- Primary key is <u>SSN#</u>

**ADMIN (SSN#, ROLE, ISACTIVE, DEPARTMENT_NAME#)**
- <u>SSN#</u> &nbsp; `char(9)`, refers to `SSN` in the table `USER`
- Role &nbsp; `varchar(50)`, not null
- IsActive &nbsp; `boolean (tinyint(1))`, not null, default `true`
- Department_Name# &nbsp; `varchar(100)`, not null, refers to `Department_Name` in the table `DEPARTMENT`
- Primary key is <u>SSN#</u>

---

### B. Organization

**FACILITY (FACILITY_NAME, FACILITY_TYPE, ADDRESS_LINE1, ADDRESS_LINE2, CITY, STATE, COUNTRY)**
- <u>Facility_Name</u> &nbsp; `varchar(100)`
- Facility_Type &nbsp; `varchar(50)`, not null
- Address_Line1 &nbsp; `varchar(100)`, not null
- Address_Line2 &nbsp; `varchar(100)`
- City &nbsp; `varchar(50)`, not null
- State &nbsp; `varchar(50)`, not null (province or state)
- Country &nbsp; `varchar(50)`, not null
- Primary key is <u>Facility_Name</u>

**DEPARTMENT (DEPARTMENT_NAME, LOCATION, FACILITY_NAME#)**
- <u>Department_Name</u> &nbsp; `varchar(100)`
- Location &nbsp; `varchar(100)`
- Facility_Name# &nbsp; `varchar(100)`, not null, refers to `Facility_Name` in the table `FACILITY`
- Primary key is <u>Department_Name</u>

**ROOM (DEPARTMENT_NAME#, ROOM_NUMBER, ROOM_TYPE)**
- <u>Department_Name#</u> &nbsp; `varchar(100)`, refers to `Department_Name` in the table `DEPARTMENT`
- <u>Room_Number</u> &nbsp; `varchar(10)`, partial key of the weak entity
- Room_Type &nbsp; `varchar(50)`
- Primary key is (`Department_Name`, `Room_Number`)

---

### C. Appointments, treatment and medication

**APPOINTMENT (APPOINTMENT_NUMBER, APPOINTMENT_DATE, APPOINTMENT_TYPE, STATUS, PATIENT_SSN#, DOCTOR_SSN#, ADMIN_SSN#, DEPARTMENT_NAME#, ROOM_NUMBER#)**
- <u>Appointment_Number</u> &nbsp; `int`, auto increment
- Appointment_Date &nbsp; `datetime`, not null
- Appointment_Type &nbsp; `varchar(50)`, not null
- Status &nbsp; `varchar(20)`, not null, one of `Scheduled` / `Completed` / `Cancelled` / `No-Show`
- Patient_SSN# &nbsp; `char(9)`, not null, refers to `SSN` in the table `PATIENT`
- Doctor_SSN# &nbsp; `char(9)`, not null, refers to `SSN` in the table `DOCTOR`
- Admin_SSN# &nbsp; `char(9)`, not null, refers to `SSN` in the table `ADMIN`
- Department_Name#, Room_Number# &nbsp; `varchar(100)`, `varchar(10)`, not null, together refer to (`Department_Name`, `Room_Number`) in the table `ROOM`
- Primary key is <u>Appointment_Number</u>

**TREATMENT_TYPE (TREATMENT_CODE, TREATMENT_NAME, TREATMENT_CATEGORY)**
- <u>Treatment_Code</u> &nbsp; `varchar(20)`
- Treatment_Name &nbsp; `varchar(100)`, not null
- Treatment_Category &nbsp; `varchar(50)`
- Primary key is <u>Treatment_Code</u>

**APPOINTMENT_TREATMENT (APPOINTMENT_NUMBER#, TREATMENT_CODE#, TREATMENT_DATE, STATUS)**
- <u>Appointment_Number#</u> &nbsp; `int`, refers to `Appointment_Number` in the table `APPOINTMENT`
- <u>Treatment_Code#</u> &nbsp; `varchar(20)`, refers to `Treatment_Code` in the table `TREATMENT_TYPE`
- Treatment_Date &nbsp; `date`, not null
- Status &nbsp; `varchar(20)`, not null, one of `Recommended` / `In Progress` / `Completed` / `Cancelled`
- Primary key is (`Appointment_Number`, `Treatment_Code`)

**MEDICATION (DIN, GENERIC_NAME, BRAND_NAME)**
- <u>DIN</u> &nbsp; `char(8)`, Canadian Drug Identification Number
- Generic_Name &nbsp; `varchar(100)`, not null
- Brand_Name &nbsp; `varchar(100)`
- Primary key is <u>DIN</u>

**APPOINTMENT_PRESCRIPTION (APPOINTMENT_NUMBER#, DIN#, DOSE, INSTRUCTION, STATUS)**
- <u>Appointment_Number#</u> &nbsp; `int`, refers to `Appointment_Number` in the table `APPOINTMENT`
- <u>DIN#</u> &nbsp; `char(8)`, refers to `DIN` in the table `MEDICATION`
- Dose &nbsp; `varchar(50)`, not null
- Instruction &nbsp; `varchar(255)`
- Status &nbsp; `varchar(20)`, not null, one of `Active` / `Completed` / `Discontinued`
- Primary key is (`Appointment_Number`, `DIN`)

---

### D. Lab testing

**TEST_TYPE (TEST_NAME, MIN_RANGE, MAX_RANGE, ADMIN_SSN#)**
- <u>Test_Name</u> &nbsp; `varchar(100)`
- Min_Range &nbsp; `decimal(10,2)`
- Max_Range &nbsp; `decimal(10,2)`, must be ≥ `Min_Range`
- Admin_SSN# &nbsp; `char(9)`, not null, refers to `SSN` in the table `ADMIN`
- Primary key is <u>Test_Name</u>

**LAB_TEST (ACCESSION_NUMBER, TEST_DATE, TEST_RESULT, STATUS, APPOINTMENT_NUMBER#, LAB_ASSISTANT_SSN#, TEST_NAME#)**
- <u>Accession_Number</u> &nbsp; `varchar(20)`
- Test_Date &nbsp; `date`, not null
- Test_Result &nbsp; `decimal(10,2)`, null until the test is completed
- Status &nbsp; `varchar(20)`, not null, one of `Ordered` / `In Progress` / `Completed` / `Cancelled`
- Appointment_Number# &nbsp; `int`, not null, refers to `Appointment_Number` in the table `APPOINTMENT`
- Lab_Assistant_SSN# &nbsp; `char(9)`, not null, refers to `SSN` in the table `LAB_ASSISTANT`
- Test_Name# &nbsp; `varchar(100)`, not null, refers to `Test_Name` in the table `TEST_TYPE`
- Primary key is <u>Accession_Number</u>

---

### E. Clinical conditions

**MEDICAL_CONDITION (ICD_CODE, CONDITION_NAME, CATEGORY)**
- <u>ICD_Code</u> &nbsp; `varchar(10)`
- Condition_Name &nbsp; `varchar(150)`, unique, not null
- Category &nbsp; `varchar(50)`
- Primary key is <u>ICD_Code</u>

**PATIENT_DIAGNOSIS (PATIENT_SSN#, ICD_CODE#, DIAGNOSIS_DATE, STATUS)**
- <u>Patient_SSN#</u> &nbsp; `char(9)`, refers to `SSN` in the table `PATIENT`
- <u>ICD_Code#</u> &nbsp; `varchar(10)`, refers to `ICD_Code` in the table `MEDICAL_CONDITION`
- Diagnosis_Date &nbsp; `date`, not null
- Status &nbsp; `varchar(20)`, not null, one of `Active` / `Resolved` / `Chronic`
- Primary key is (`Patient_SSN`, `ICD_Code`)

**TEST_THRESHOLD_RULE (TEST_NAME#, ICD_CODE#, ABNORMALITY_THRESHOLD, OPERATOR)**
- <u>Test_Name#</u> &nbsp; `varchar(100)`, refers to `Test_Name` in the table `TEST_TYPE`
- <u>ICD_Code#</u> &nbsp; `varchar(10)`, refers to `ICD_Code` in the table `MEDICAL_CONDITION`
- Abnormality_Threshold &nbsp; `decimal(10,2)`, not null
- Operator &nbsp; `varchar(2)`, not null, one of `<`, `<=`, `>`, `>=`, `=`
- Primary key is (`Test_Name`, `ICD_Code`)

---

### F. Risk modelling

**RISK_MODEL (NCD_NAME, EFFECTIVE_DATE, DESCRIPTION, ADMIN_SSN#)**
- <u>NCD_Name</u> &nbsp; `varchar(100)`, part of primary key
- <u>Effective_Date</u> &nbsp; `date`, part of primary key
- Description &nbsp; `varchar(255)`
- Admin_SSN# &nbsp; `char(9)`, not null, refers to `SSN` in the table `ADMIN`
- Primary key is (`NCD_Name`, `Effective_Date`)

**RISK_THRESHOLD (NCD_NAME#, EFFECTIVE_DATE#, RISK_TIER, MIN_SCORE, MAX_SCORE)**
- <u>NCD_Name#</u> &nbsp; `varchar(100)`, refers to `NCD_Name` in the table `RISK_MODEL`
- <u>Effective_Date#</u> &nbsp; `date`, refers to `Effective_Date` in the table `RISK_MODEL`
- <u>Risk_Tier</u> &nbsp; `varchar(10)`, partial key, one of `Low` / `Medium` / `High`
- Min_Score &nbsp; `decimal(5,2)`, must be ≥ 0
- Max_Score &nbsp; `decimal(5,2)`, must be ≥ `Min_Score`
- Primary key is (`NCD_Name`, `Effective_Date`, `Risk_Tier`)

**RISK_MODEL_EVALUATION (NCD_NAME#, EFFECTIVE_DATE#, ICD_CODE#, RISK_WEIGHT)**
- <u>NCD_Name#</u> &nbsp; `varchar(100)`, refers to `NCD_Name` in the table `RISK_MODEL`
- <u>Effective_Date#</u> &nbsp; `date`, refers to `Effective_Date` in the table `RISK_MODEL`
- <u>ICD_Code#</u> &nbsp; `varchar(10)`, refers to `ICD_Code` in the table `MEDICAL_CONDITION`
- Risk_Weight &nbsp; `decimal(5,2)`, not null, must be ≥ 0
- Primary key is (`NCD_Name`, `Effective_Date`, `ICD_Code`)

**RISK_ASSESSMENT (ASSESSMENT_NUMBER, ASSESSMENT_DATE, SCORE, RISK_LEVEL, PATIENT_SSN#, NCD_NAME#, EFFECTIVE_DATE#)**
- <u>Assessment_Number</u> &nbsp; `int`, auto increment
- Assessment_Date &nbsp; `datetime`, not null
- Score &nbsp; `decimal(5,2)`, not null, must be ≥ 0
- Risk_Level &nbsp; `varchar(10)`, not null, one of `Low` / `Medium` / `High`
- Patient_SSN# &nbsp; `char(9)`, not null, refers to `SSN` in the table `PATIENT`
- NCD_Name# &nbsp; `varchar(100)`, refers to `NCD_Name` in the table `RISK_MODEL` (nullable, conceptual `Generates` is `0:1`)
- Effective_Date# &nbsp; `date`, refers to `Effective_Date` in the table `RISK_MODEL` (nullable, together with `NCD_Name`)
- Primary key is <u>Assessment_Number</u>

**NOTIFICATION (ASSESSMENT_NUMBER#, DATE_NOTIFIED, RECIPIENT_USER_SSN#, MESSAGE)**
- <u>Assessment_Number#</u> &nbsp; `int`, refers to `Assessment_Number` in the table `RISK_ASSESSMENT`
- <u>Date_Notified</u> &nbsp; `datetime`, partial key of the weak entity
- Recipient_User_SSN# &nbsp; `char(9)`, not null, refers to `SSN` in the table `USER`
- Message &nbsp; `varchar(500)`, not null
- Primary key is (`Assessment_Number`, `Date_Notified`)

