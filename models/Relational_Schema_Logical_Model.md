# Relational Schema with Data Types - NCD Triage System

**ENSF 608 - Group 6**

**Notation:** Each relation header lists its schema in the format **RELATION (<ins>PRIMARY_KEY</ins>, ATTRIBUTE, FOREIGN_KEY#)** where primary key attributes are underlined and `#` marks a foreign key (FK). Each attribute line specifies its domain (`Data Type` and `Semantics / Integrity Constraints`).

---

### A. User Hierarchy

**USER (<ins>SSN</ins>, FIRST_NAME, LAST_NAME, DOB, ADDRESS, EMAIL, PASSWORD, PHONE_NUMBER, STATUS)**
- <ins>SSN</ins> -> `char(9)`, not null, 9-digit Social Security Number (digits only)
- First_Name -> `varchar(50)`, not null, user's legal given name
- Last_Name -> `varchar(50)`, not null, user's legal family name
- DOB -> `date`, not null, date of birth (must not be a future date)
- Address -> `varchar(150)`, residential street address
- Email -> `varchar(100)`, unique, not null, candidate key in valid email format
- Password -> `varchar(255)`, not null, encrypted/hashed account password
- Phone_Number -> `varchar(15)`, unique, candidate key in standard contact number format
- Status -> `varchar(20)`, not null, account status: one of `Active` / `Inactive` / `Suspended`
- Primary key is <ins>SSN</ins>

**PATIENT (<ins>SSN#</ins>, HEALTHCARE_NUMBER, GENDER, BLOOD_TYPE, STATUS)**
- <ins>SSN#</ins> -> `char(9)`, not null, refers to `SSN` in table `USER`
- Healthcare_Number -> `varchar(20)`, unique, not null, candidate key (provincial/national health card number)
- Gender -> `varchar(20)`, patient gender identity
- Blood_Type -> `varchar(3)`, ABO/Rh blood group: one of `A+`, `A-`, `B+`, `B-`, `AB+`, `AB-`, `O+`, `O-`
- Status -> `varchar(20)`, not null, clinical status: one of `Active` / `Inactive` / `Deceased`
- Primary key is <ins>SSN#</ins>

**PATIENT_EMERGENCY_CONTACT (<ins>PATIENT_SSN#</ins>, <ins>CONTACT_NAME</ins>, <ins>CONTACT_PHONE_NUMBER</ins>)**
- <ins>Patient_SSN#</ins> -> `char(9)`, not null, part of composite primary key, refers to `SSN` in table `PATIENT`
- <ins>Contact_Name</ins> -> `varchar(100)`, not null, part of composite primary key, full name of emergency contact person
- <ins>Contact_Phone_Number</ins> -> `varchar(15)`, not null, part of composite primary key, telephone number of emergency contact
- Primary key is (<ins>Patient_SSN#</ins>, <ins>Contact_Name</ins>, <ins>Contact_Phone_Number</ins>)

**HEALTH_PROFESSIONAL (<ins>SSN#</ins>, EMPLOYEE_NUMBER, EMPLOYMENT_DATE, STATUS, DEPARTMENT_NAME#)**
- <ins>SSN#</ins> -> `char(9)`, not null, refers to `SSN` in table `USER`
- Employee_Number -> `varchar(20)`, unique, not null, candidate key (staff identifier)
- Employment_Date -> `date`, not null, date of hire
- Status -> `varchar(20)`, not null, employment status: one of `Active` / `On Leave` / `Terminated`
- Department_Name# -> `varchar(100)`, not null, refers to `Department_Name` in table `DEPARTMENT`
- Primary key is <ins>SSN#</ins>

**DOCTOR (<ins>SSN#</ins>, LICENSE_NUMBER, SPECIALITY, QUALIFICATION)**
- <ins>SSN#</ins> -> `char(9)`, not null, refers to `SSN` in table `HEALTH_PROFESSIONAL`
- License_Number -> `varchar(30)`, unique, not null, candidate key (medical license registration number)
- Speciality -> `varchar(100)`, clinical area of specialization
- Qualification -> `varchar(150)`, medical degrees and board certifications
- Primary key is <ins>SSN#</ins>

**LAB_ASSISTANT (<ins>SSN#</ins>, CERTIFICATION_NUMBER, CERTIFICATION_TYPE, LAB_SPECIALIZATION)**
- <ins>SSN#</ins> -> `char(9)`, not null, refers to `SSN` in table `HEALTH_PROFESSIONAL`
- Certification_Number -> `varchar(30)`, unique, not null, candidate key (laboratory technician certification ID)
- Certification_Type -> `varchar(100)`, category of laboratory certification
- Lab_Specialization -> `varchar(100)`, specialized laboratory testing domain
- Primary key is <ins>SSN#</ins>

**ADMIN (<ins>SSN#</ins>, ROLE, ISACTIVE, DEPARTMENT_NAME#)**
- <ins>SSN#</ins> -> `char(9)`, not null, refers to `SSN` in table `USER`
- Role -> `varchar(50)`, not null, administrative job role (e.g., `Receptionist`, `Security Admin`)
- IsActive -> `boolean (tinyint(1))`, not null, default `true`, indicates whether administrative privileges are active
- Department_Name# -> `varchar(100)`, not null, refers to `Department_Name` in table `DEPARTMENT`
- Primary key is <ins>SSN#</ins>

---

### B. Organization

**FACILITY (<ins>FACILITY_NAME</ins>, FACILITY_TYPE, ADDRESS_LINE1, ADDRESS_LINE2, CITY, STATE, COUNTRY)**
- <ins>Facility_Name</ins> -> `varchar(100)`, not null, unique official name of the healthcare institution
- Facility_Type -> `varchar(50)`, not null, type of healthcare facility (e.g., `Hospital`, `Clinic`, `Diagnostic Center`)
- Address_Line1 -> `varchar(100)`, not null, primary street address line
- Address_Line2 -> `varchar(100)`, secondary address line (suite, building, or floor)
- City -> `varchar(50)`, not null, city name
- State -> `varchar(50)`, not null, province or state name
- Country -> `varchar(50)`, not null, country name
- Primary key is <ins>Facility_Name</ins>

**DEPARTMENT (<ins>DEPARTMENT_NAME</ins>, LOCATION, FACILITY_NAME#)**
- <ins>Department_Name</ins> -> `varchar(100)`, not null, unique name of the hospital/clinic department
- Location -> `varchar(100)`, physical wing or floor location within the facility
- Facility_Name# -> `varchar(100)`, not null, refers to `Facility_Name` in table `FACILITY`
- Primary key is <ins>Department_Name</ins>

**ROOM (<ins>DEPARTMENT_NAME#</ins>, <ins>ROOM_NUMBER</ins>, ROOM_TYPE)**
- <ins>Department_Name#</ins> -> `varchar(100)`, not null, part of composite primary key, refers to `Department_Name` in table `DEPARTMENT`
- <ins>Room_Number</ins> -> `varchar(10)`, not null, part of composite primary key, room identifier within the department
- Room_Type -> `varchar(50)`, functional classification of the room (e.g., `Consultation`, `Lab`, `Procedure`)
- Primary key is (<ins>Department_Name#</ins>, <ins>Room_Number</ins>)

---

### C. Appointments, Treatment and Medication

**APPOINTMENT (<ins>APPOINTMENT_NUMBER</ins>, APPOINTMENT_DATE, APPOINTMENT_TYPE, STATUS, PATIENT_SSN#, DOCTOR_SSN#, ADMIN_SSN#, DEPARTMENT_NAME#, ROOM_NUMBER#)**
- <ins>Appointment_Number</ins> -> `int`, auto increment, not null, unique appointment identifier
- Appointment_Date -> `datetime`, not null, scheduled date and time of the appointment
- Appointment_Type -> `varchar(50)`, not null, visit category (e.g., `Initial Consultation`, `Follow-Up`, `Routine Checkup`)
- Status -> `varchar(20)`, not null, appointment state: one of `Scheduled` / `Completed` / `Cancelled` / `No-Show`
- Patient_SSN# -> `char(9)`, not null, refers to `SSN` in table `PATIENT`
- Doctor_SSN# -> `char(9)`, not null, refers to `SSN` in table `DOCTOR`
- Admin_SSN# -> `char(9)`, not null, refers to `SSN` in table `ADMIN`
- Department_Name# -> `varchar(100)`, not null, part of composite foreign key referring to (`Department_Name`, `Room_Number`) in table `ROOM`
- Room_Number# -> `varchar(10)`, not null, part of composite foreign key referring to (`Department_Name`, `Room_Number`) in table `ROOM`
- Primary key is <ins>Appointment_Number</ins>

**TREATMENT_TYPE (<ins>TREATMENT_CODE</ins>, TREATMENT_NAME, TREATMENT_CATEGORY)**
- <ins>Treatment_Code</ins> -> `varchar(20)`, not null, standardized clinical procedure/therapy code
- Treatment_Name -> `varchar(100)`, not null, descriptive name of the treatment or procedure
- Treatment_Category -> `varchar(50)`, clinical classification (e.g., `Lifestyle Intervention`, `Surgical`, `Dialysis`, `Therapy`)
- Primary key is <ins>Treatment_Code</ins>

**APPOINTMENT_TREATMENT (<ins>APPOINTMENT_NUMBER#</ins>, <ins>TREATMENT_CODE#</ins>, TREATMENT_DATE, STATUS)**
- <ins>Appointment_Number#</ins> -> `int`, not null, part of composite primary key, refers to `Appointment_Number` in table `APPOINTMENT`
- <ins>Treatment_Code#</ins> -> `varchar(20)`, not null, part of composite primary key, refers to `Treatment_Code` in table `TREATMENT_TYPE`
- Treatment_Date -> `date`, not null, scheduled or administered date of the treatment
- Status -> `varchar(20)`, not null, treatment progress state: one of `Recommended` / `In Progress` / `Completed` / `Cancelled`
- Primary key is (<ins>Appointment_Number#</ins>, <ins>Treatment_Code#</ins>)

**MEDICATION (<ins>DIN</ins>, GENERIC_NAME, BRAND_NAME)**
- <ins>DIN</ins> -> `char(8)`, not null, 8-digit Canadian Drug Identification Number
- Generic_Name -> `varchar(100)`, not null, standardized generic chemical name
- Brand_Name -> `varchar(100)`, commercial/trade name of the medication
- Primary key is <ins>DIN</ins>

**APPOINTMENT_PRESCRIPTION (<ins>APPOINTMENT_NUMBER#</ins>, <ins>DIN#</ins>, DOSE, INSTRUCTION, STATUS)**
- <ins>Appointment_Number#</ins> -> `int`, not null, part of composite primary key, refers to `Appointment_Number` in table `APPOINTMENT`
- <ins>DIN#</ins> -> `char(8)`, not null, part of composite primary key, refers to `DIN` in table `MEDICATION`
- Dose -> `varchar(50)`, not null, prescribed dosage strength and unit (e.g., `500 mg`, `10 mg`)
- Instruction -> `varchar(255)`, administration frequency and clinical directions
- Status -> `varchar(20)`, not null, prescription state: one of `Active` / `Completed` / `Discontinued`
- Primary key is (<ins>Appointment_Number#</ins>, <ins>DIN#</ins>)

---

### D. Lab Testing

**TEST_TYPE (<ins>TEST_NAME</ins>, MIN_RANGE, MAX_RANGE, ADMIN_SSN#)**
- <ins>Test_Name</ins> -> `varchar(100)`, not null, standardized name of the laboratory test
- Min_Range -> `decimal(10,2)`, lower bound of the normal physiological reference range
- Max_Range -> `decimal(10,2)`, upper bound of the normal physiological reference range (must be ≥ `Min_Range`)
- Admin_SSN# -> `char(9)`, not null, refers to `SSN` in table `ADMIN`
- Primary key is <ins>Test_Name</ins>

**LAB_TEST (<ins>ACCESSION_NUMBER</ins>, TEST_DATE, TEST_RESULT, STATUS, APPOINTMENT_NUMBER#, LAB_ASSISTANT_SSN#, TEST_NAME#)**
- <ins>Accession_Number</ins> -> `varchar(20)`, not null, unique laboratory specimen/order accession identifier
- Test_Date -> `date`, not null, date the laboratory test was ordered or performed
- Test_Result -> `decimal(10,2)`, quantitative empirical value returned from the lab test (nullable until test status is `Completed`)
- Status -> `varchar(20)`, not null, lab test state: one of `Ordered` / `In Progress` / `Completed` / `Cancelled`
- Appointment_Number# -> `int`, not null, refers to `Appointment_Number` in table `APPOINTMENT`
- Lab_Assistant_SSN# -> `char(9)`, not null, refers to `SSN` in table `LAB_ASSISTANT`
- Test_Name# -> `varchar(100)`, not null, refers to `Test_Name` in table `TEST_TYPE`
- Primary key is <ins>Accession_Number</ins>

---

### E. Clinical Conditions

**MEDICAL_CONDITION (<ins>ICD_CODE</ins>, CONDITION_NAME, CATEGORY)**
- <ins>ICD_Code</ins> -> `varchar(10)`, not null, standardized International Classification of Diseases (ICD) code
- Condition_Name -> `varchar(150)`, unique, not null, candidate key (clinical name of the medical condition or risk factor)
- Category -> `varchar(50)`, condition classification (e.g., `Cardiovascular`, `Metabolic`, `Respiratory`, `Oncological`, `Renal`, `Neurological`, `Lifestyle`, `Genetic / Family History`)
- Primary key is <ins>ICD_Code</ins>

**PATIENT_DIAGNOSIS (<ins>PATIENT_SSN#</ins>, <ins>ICD_CODE#</ins>, DIAGNOSIS_DATE, STATUS)**
- <ins>Patient_SSN#</ins> -> `char(9)`, not null, part of composite primary key, refers to `SSN` in table `PATIENT`
- <ins>ICD_Code#</ins> -> `varchar(10)`, not null, part of composite primary key, refers to `ICD_Code` in table `MEDICAL_CONDITION`
- Diagnosis_Date -> `date`, not null, date the condition was clinically diagnosed
- Status -> `varchar(20)`, not null, clinical diagnosis state: one of `Active` / `Resolved` / `Chronic`
- Primary key is (<ins>Patient_SSN#</ins>, <ins>ICD_Code#</ins>)

**TEST_THRESHOLD_RULE (<ins>TEST_NAME#</ins>, <ins>ICD_CODE#</ins>, ABNORMALITY_THRESHOLD, OPERATOR)**
- <ins>Test_Name#</ins> -> `varchar(100)`, not null, part of composite primary key, refers to `Test_Name` in table `TEST_TYPE`
- <ins>ICD_Code#</ins> -> `varchar(10)`, not null, part of composite primary key, refers to `ICD_Code` in table `MEDICAL_CONDITION`
- Abnormality_Threshold -> `decimal(10,2)`, not null, numerical cutoff value indicating clinical abnormality
- Operator -> `varchar(2)`, not null, comparison operator used against `Abnormality_Threshold`: one of `<`, `<=`, `>`, `>=`, `=`
- Primary key is (<ins>Test_Name#</ins>, <ins>ICD_Code#</ins>)

---

### F. Risk Modelling

**RISK_MODEL (<ins>NCD_NAME</ins>, <ins>EFFECTIVE_DATE</ins>, DESCRIPTION, ADMIN_SSN#)**
- <ins>NCD_Name</ins> -> `varchar(100)`, not null, part of composite primary key, target Non-Communicable Disease name
- <ins>Effective_Date</ins> -> `date`, not null, part of composite primary key, version effective date of the risk model
- Description -> `varchar(255)`, summary of clinical guidelines and scoring methodology
- Admin_SSN# -> `char(9)`, not null, refers to `SSN` in table `ADMIN`
- Primary key is (<ins>NCD_Name</ins>, <ins>Effective_Date</ins>)

**RISK_THRESHOLD (<ins>NCD_NAME#</ins>, <ins>EFFECTIVE_DATE#</ins>, <ins>RISK_TIER</ins>, MIN_SCORE, MAX_SCORE)**
- <ins>NCD_Name#</ins> -> `varchar(100)`, not null, part of composite primary key, part of composite foreign key referring to (`NCD_Name`, `Effective_Date`) in table `RISK_MODEL`
- <ins>Effective_Date#</ins> -> `date`, not null, part of composite primary key, part of composite foreign key referring to (`NCD_Name`, `Effective_Date`) in table `RISK_MODEL`
- <ins>Risk_Tier</ins> -> `varchar(10)`, not null, part of composite primary key, clinical triage tier: one of `Low` / `Medium` / `High`
- Min_Score -> `decimal(5,2)`, not null, minimum score bound for the tier (must be ≥ 0)
- Max_Score -> `decimal(5,2)`, not null, maximum score bound for the tier (must be ≥ `Min_Score`)
- Primary key is (<ins>NCD_Name#</ins>, <ins>Effective_Date#</ins>, <ins>Risk_Tier</ins>)

**RISK_MODEL_EVALUATION (<ins>NCD_NAME#</ins>, <ins>EFFECTIVE_DATE#</ins>, <ins>ICD_CODE#</ins>, RISK_WEIGHT)**
- <ins>NCD_Name#</ins> -> `varchar(100)`, not null, part of composite primary key, part of composite foreign key referring to (`NCD_Name`, `Effective_Date`) in table `RISK_MODEL`
- <ins>Effective_Date#</ins> -> `date`, not null, part of composite primary key, part of composite foreign key referring to (`NCD_Name`, `Effective_Date`) in table `RISK_MODEL`
- <ins>ICD_Code#</ins> -> `varchar(10)`, not null, part of composite primary key, refers to `ICD_Code` in table `MEDICAL_CONDITION`
- Risk_Weight -> `decimal(5,2)`, not null, numerical scoring weight assigned to the condition (must be ≥ 0)
- Primary key is (<ins>NCD_Name#</ins>, <ins>Effective_Date#</ins>, <ins>ICD_Code#</ins>)

**RISK_ASSESSMENT (<ins>ASSESSMENT_NUMBER</ins>, ASSESSMENT_DATE, SCORE, RISK_LEVEL, PATIENT_SSN#, NCD_NAME#, EFFECTIVE_DATE#)**
- <ins>Assessment_Number</ins> -> `int`, auto increment, not null, unique risk assessment identifier
- Assessment_Date -> `datetime`, not null, timestamp when the risk assessment was computed
- Score -> `decimal(5,2)`, not null, calculated aggregate patient risk score (must be ≥ 0)
- Risk_Level -> `varchar(10)`, not null, resulting clinical triage level: one of `Low` / `Medium` / `High`
- Patient_SSN# -> `char(9)`, not null, refers to `SSN` in table `PATIENT`
- NCD_Name# -> `varchar(100)`, not null, part of composite foreign key referring to (`NCD_Name`, `Effective_Date`) in table `RISK_MODEL`
- Effective_Date# -> `date`, not null, part of composite foreign key referring to (`NCD_Name`, `Effective_Date`) in table `RISK_MODEL`
- Primary key is <ins>Assessment_Number</ins>

**NOTIFICATION (<ins>ASSESSMENT_NUMBER#</ins>, <ins>DATE_NOTIFIED</ins>, RECIPIENT_USER_SSN#, MESSAGE)**
- <ins>Assessment_Number#</ins> -> `int`, not null, part of composite primary key, refers to `Assessment_Number` in table `RISK_ASSESSMENT`
- <ins>Date_Notified</ins> -> `datetime`, not null, part of composite primary key, timestamp when the notification alert was dispatched
- Recipient_User_SSN# -> `char(9)`, not null, refers to `SSN` in table `USER`
- Message -> `varchar(500)`, not null, clinical alert text delivered to the recipient
- Primary key is (<ins>Assessment_Number#</ins>, <ins>Date_Notified</ins>)
