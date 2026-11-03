# Relational Schema with Data Types - NCD Triage System

**ENSF 608 - Group 6**

**Notation:** Each relation header lists its schema in the format **RELATION (<u>PRIMARY_KEY</u>, ATTRIBUTE, FOREIGN_KEY#)** where primary key attributes are underlined and `#` marks a foreign key (FK). Each attribute line specifies its domain (`Data Type` and `Semantics / Integrity Constraints`).

---

### A. User Hierarchy

**USER (<u>SSN</u>, FIRST_NAME, LAST_NAME, DOB, ADDRESS, EMAIL, PASSWORD, PHONE_NUMBER, STATUS)**
- <u>SSN</u> -> `char(9)`, not null, 9-digit Social Security Number (digits only)
- First_Name -> `varchar(50)`, not null, user's legal given name
- Last_Name -> `varchar(50)`, not null, user's legal family name
- DOB -> `date`, not null, date of birth (must not be a future date)
- Address -> `varchar(150)`, residential street address
- Email -> `varchar(100)`, unique, not null, candidate key in valid email format
- Password -> `varchar(255)`, not null, encrypted/hashed account password
- Phone_Number -> `varchar(15)`, unique, candidate key in standard contact number format
- Status -> `varchar(20)`, not null, account status: one of `Active` / `Inactive` / `Suspended`
- Primary key is <u>SSN</u>

**PATIENT (<u>SSN#</u>, HEALTHCARE_NUMBER, GENDER, BLOOD_TYPE, STATUS)**
- <u>SSN#</u> -> `char(9)`, not null, refers to `SSN` in table `USER`
- Healthcare_Number -> `varchar(20)`, unique, not null, candidate key (provincial/national health card number)
- Gender -> `varchar(20)`, patient gender identity
- Blood_Type -> `varchar(3)`, ABO/Rh blood group: one of `A+`, `A-`, `B+`, `B-`, `AB+`, `AB-`, `O+`, `O-`
- Status -> `varchar(20)`, not null, clinical status: one of `Active` / `Inactive` / `Deceased`
- Primary key is <u>SSN#</u>

**PATIENT_EMERGENCY_CONTACT (<u>PATIENT_SSN#</u>, <u>CONTACT_NAME</u>, <u>CONTACT_PHONE_NUMBER</u>)**
- <u>Patient_SSN#</u> -> `char(9)`, not null, part of composite primary key, refers to `SSN` in table `PATIENT`
- <u>Contact_Name</u> -> `varchar(100)`, not null, part of composite primary key, full name of emergency contact person
- <u>Contact_Phone_Number</u> -> `varchar(15)`, not null, part of composite primary key, telephone number of emergency contact
- Primary key is (<u>Patient_SSN#</u>, <u>Contact_Name</u>, <u>Contact_Phone_Number</u>)

**HEALTH_PROFESSIONAL (<u>SSN#</u>, EMPLOYEE_NUMBER, EMPLOYMENT_DATE, STATUS, DEPARTMENT_NAME#)**
- <u>SSN#</u> -> `char(9)`, not null, refers to `SSN` in table `USER`
- Employee_Number -> `varchar(20)`, unique, not null, candidate key (staff identifier)
- Employment_Date -> `date`, not null, date of hire
- Status -> `varchar(20)`, not null, employment status: one of `Active` / `On Leave` / `Terminated`
- Department_Name# -> `varchar(100)`, not null, refers to `Department_Name` in table `DEPARTMENT`
- Primary key is <u>SSN#</u>

**DOCTOR (<u>SSN#</u>, LICENSE_NUMBER, SPECIALITY, QUALIFICATION)**
- <u>SSN#</u> -> `char(9)`, not null, refers to `SSN` in table `HEALTH_PROFESSIONAL`
- License_Number -> `varchar(30)`, unique, not null, candidate key (medical license registration number)
- Speciality -> `varchar(100)`, clinical area of specialization
- Qualification -> `varchar(150)`, medical degrees and board certifications
- Primary key is <u>SSN#</u>

**LAB_ASSISTANT (<u>SSN#</u>, CERTIFICATION_NUMBER, CERTIFICATION_TYPE, LAB_SPECIALIZATION)**
- <u>SSN#</u> -> `char(9)`, not null, refers to `SSN` in table `HEALTH_PROFESSIONAL`
- Certification_Number -> `varchar(30)`, unique, not null, candidate key (laboratory technician certification ID)
- Certification_Type -> `varchar(100)`, category of laboratory certification
- Lab_Specialization -> `varchar(100)`, specialized laboratory testing domain
- Primary key is <u>SSN#</u>

**ADMIN (<u>SSN#</u>, ROLE, ISACTIVE, DEPARTMENT_NAME#)**
- <u>SSN#</u> -> `char(9)`, not null, refers to `SSN` in table `USER`
- Role -> `varchar(50)`, not null, administrative job role (e.g., `Receptionist`, `Security Admin`)
- IsActive -> `boolean (tinyint(1))`, not null, default `true`, indicates whether administrative privileges are active
- Department_Name# -> `varchar(100)`, not null, refers to `Department_Name` in table `DEPARTMENT`
- Primary key is <u>SSN#</u>

---

### B. Organization

**FACILITY (<u>FACILITY_NAME</u>, FACILITY_TYPE, ADDRESS_LINE1, ADDRESS_LINE2, CITY, STATE, COUNTRY)**
- <u>Facility_Name</u> -> `varchar(100)`, not null, unique official name of the healthcare institution
- Facility_Type -> `varchar(50)`, not null, type of healthcare facility (e.g., `Hospital`, `Clinic`, `Diagnostic Center`)
- Address_Line1 -> `varchar(100)`, not null, primary street address line
- Address_Line2 -> `varchar(100)`, secondary address line (suite, building, or floor)
- City -> `varchar(50)`, not null, city name
- State -> `varchar(50)`, not null, province or state name
- Country -> `varchar(50)`, not null, country name
- Primary key is <u>Facility_Name</u>

**DEPARTMENT (<u>DEPARTMENT_NAME</u>, LOCATION, FACILITY_NAME#)**
- <u>Department_Name</u> -> `varchar(100)`, not null, unique name of the hospital/clinic department
- Location -> `varchar(100)`, physical wing or floor location within the facility
- Facility_Name# -> `varchar(100)`, not null, refers to `Facility_Name` in table `FACILITY`
- Primary key is <u>Department_Name</u>

**ROOM (<u>DEPARTMENT_NAME#</u>, <u>ROOM_NUMBER</u>, ROOM_TYPE)**
- <u>Department_Name#</u> -> `varchar(100)`, not null, part of composite primary key, refers to `Department_Name` in table `DEPARTMENT`
- <u>Room_Number</u> -> `varchar(10)`, not null, part of composite primary key, room identifier within the department
- Room_Type -> `varchar(50)`, functional classification of the room (e.g., `Consultation`, `Lab`, `Procedure`)
- Primary key is (<u>Department_Name#</u>, <u>Room_Number</u>)

---

### C. Appointments, Treatment and Medication

**APPOINTMENT (<u>APPOINTMENT_NUMBER</u>, APPOINTMENT_DATE, APPOINTMENT_TYPE, STATUS, PATIENT_SSN#, DOCTOR_SSN#, ADMIN_SSN#, DEPARTMENT_NAME#, ROOM_NUMBER#)**
- <u>Appointment_Number</u> -> `int`, auto increment, not null, unique appointment identifier
- Appointment_Date -> `datetime`, not null, scheduled date and time of the appointment
- Appointment_Type -> `varchar(50)`, not null, visit category (e.g., `Initial Consultation`, `Follow-Up`, `Routine Checkup`)
- Status -> `varchar(20)`, not null, appointment state: one of `Scheduled` / `Completed` / `Cancelled` / `No-Show`
- Patient_SSN# -> `char(9)`, not null, refers to `SSN` in table `PATIENT`
- Doctor_SSN# -> `char(9)`, not null, refers to `SSN` in table `DOCTOR`
- Admin_SSN# -> `char(9)`, not null, refers to `SSN` in table `ADMIN`
- Department_Name# -> `varchar(100)`, not null, part of composite foreign key referring to (`Department_Name`, `Room_Number`) in table `ROOM`
- Room_Number# -> `varchar(10)`, not null, part of composite foreign key referring to (`Department_Name`, `Room_Number`) in table `ROOM`
- Primary key is <u>Appointment_Number</u>

**TREATMENT_TYPE (<u>TREATMENT_CODE</u>, TREATMENT_NAME, TREATMENT_CATEGORY)**
- <u>Treatment_Code</u> -> `varchar(20)`, not null, standardized clinical procedure/therapy code
- Treatment_Name -> `varchar(100)`, not null, descriptive name of the treatment or procedure
- Treatment_Category -> `varchar(50)`, clinical classification (e.g., `Lifestyle Intervention`, `Surgical`, `Dialysis`, `Therapy`)
- Primary key is <u>Treatment_Code</u>

**APPOINTMENT_TREATMENT (<u>APPOINTMENT_NUMBER#</u>, <u>TREATMENT_CODE#</u>, TREATMENT_DATE, STATUS)**
- <u>Appointment_Number#</u> -> `int`, not null, part of composite primary key, refers to `Appointment_Number` in table `APPOINTMENT`
- <u>Treatment_Code#</u> -> `varchar(20)`, not null, part of composite primary key, refers to `Treatment_Code` in table `TREATMENT_TYPE`
- Treatment_Date -> `date`, not null, scheduled or administered date of the treatment
- Status -> `varchar(20)`, not null, treatment progress state: one of `Recommended` / `In Progress` / `Completed` / `Cancelled`
- Primary key is (<u>Appointment_Number#</u>, <u>Treatment_Code#</u>)

**MEDICATION (<u>DIN</u>, GENERIC_NAME, BRAND_NAME)**
- <u>DIN</u> -> `char(8)`, not null, 8-digit Canadian Drug Identification Number
- Generic_Name -> `varchar(100)`, not null, standardized generic chemical name
- Brand_Name -> `varchar(100)`, commercial/trade name of the medication
- Primary key is <u>DIN</u>

**APPOINTMENT_PRESCRIPTION (<u>APPOINTMENT_NUMBER#</u>, <u>DIN#</u>, DOSE, INSTRUCTION, STATUS)**
- <u>Appointment_Number#</u> -> `int`, not null, part of composite primary key, refers to `Appointment_Number` in table `APPOINTMENT`
- <u>DIN#</u> -> `char(8)`, not null, part of composite primary key, refers to `DIN` in table `MEDICATION`
- Dose -> `varchar(50)`, not null, prescribed dosage strength and unit (e.g., `500 mg`, `10 mg`)
- Instruction -> `varchar(255)`, administration frequency and clinical directions
- Status -> `varchar(20)`, not null, prescription state: one of `Active` / `Completed` / `Discontinued`
- Primary key is (<u>Appointment_Number#</u>, <u>DIN#</u>)

---

### D. Lab Testing

**TEST_TYPE (<u>TEST_NAME</u>, MIN_RANGE, MAX_RANGE, ADMIN_SSN#)**
- <u>Test_Name</u> -> `varchar(100)`, not null, standardized name of the laboratory test
- Min_Range -> `decimal(10,2)`, lower bound of the normal physiological reference range
- Max_Range -> `decimal(10,2)`, upper bound of the normal physiological reference range (must be ≥ `Min_Range`)
- Admin_SSN# -> `char(9)`, not null, refers to `SSN` in table `ADMIN`
- Primary key is <u>Test_Name</u>

**LAB_TEST (<u>ACCESSION_NUMBER</u>, TEST_DATE, TEST_RESULT, STATUS, APPOINTMENT_NUMBER#, LAB_ASSISTANT_SSN#, TEST_NAME#)**
- <u>Accession_Number</u> -> `varchar(20)`, not null, unique laboratory specimen/order accession identifier
- Test_Date -> `date`, not null, date the laboratory test was ordered or performed
- Test_Result -> `decimal(10,2)`, quantitative empirical value returned from the lab test (nullable until test status is `Completed`)
- Status -> `varchar(20)`, not null, lab test state: one of `Ordered` / `In Progress` / `Completed` / `Cancelled`
- Appointment_Number# -> `int`, not null, refers to `Appointment_Number` in table `APPOINTMENT`
- Lab_Assistant_SSN# -> `char(9)`, not null, refers to `SSN` in table `LAB_ASSISTANT`
- Test_Name# -> `varchar(100)`, not null, refers to `Test_Name` in table `TEST_TYPE`
- Primary key is <u>Accession_Number</u>

---

### E. Clinical Conditions

**MEDICAL_CONDITION (<u>ICD_CODE</u>, CONDITION_NAME, CATEGORY)**
- <u>ICD_Code</u> -> `varchar(10)`, not null, standardized International Classification of Diseases (ICD) code
- Condition_Name -> `varchar(150)`, unique, not null, candidate key (clinical name of the medical condition or risk factor)
- Category -> `varchar(50)`, condition classification (e.g., `Cardiovascular`, `Metabolic`, `Respiratory`, `Lifestyle`)
- Primary key is <u>ICD_Code</u>

**PATIENT_DIAGNOSIS (<u>PATIENT_SSN#</u>, <u>ICD_CODE#</u>, DIAGNOSIS_DATE, STATUS)**
- <u>Patient_SSN#</u> -> `char(9)`, not null, part of composite primary key, refers to `SSN` in table `PATIENT`
- <u>ICD_Code#</u> -> `varchar(10)`, not null, part of composite primary key, refers to `ICD_Code` in table `MEDICAL_CONDITION`
- Diagnosis_Date -> `date`, not null, date the condition was clinically diagnosed
- Status -> `varchar(20)`, not null, clinical diagnosis state: one of `Active` / `Resolved` / `Chronic`
- Primary key is (<u>Patient_SSN#</u>, <u>ICD_Code#</u>)

**TEST_THRESHOLD_RULE (<u>TEST_NAME#</u>, <u>ICD_CODE#</u>, ABNORMALITY_THRESHOLD, OPERATOR)**
- <u>Test_Name#</u> -> `varchar(100)`, not null, part of composite primary key, refers to `Test_Name` in table `TEST_TYPE`
- <u>ICD_Code#</u> -> `varchar(10)`, not null, part of composite primary key, refers to `ICD_Code` in table `MEDICAL_CONDITION`
- Abnormality_Threshold -> `decimal(10,2)`, not null, numerical cutoff value indicating clinical abnormality
- Operator -> `varchar(2)`, not null, comparison operator used against `Abnormality_Threshold`: one of `<`, `<=`, `>`, `>=`, `=`
- Primary key is (<u>Test_Name#</u>, <u>ICD_Code#</u>)

---

### F. Risk Modelling

**RISK_MODEL (<u>NCD_NAME</u>, <u>EFFECTIVE_DATE</u>, DESCRIPTION, ADMIN_SSN#)**
- <u>NCD_Name</u> -> `varchar(100)`, not null, part of composite primary key, target Non-Communicable Disease name
- <u>Effective_Date</u> -> `date`, not null, part of composite primary key, version effective date of the risk model
- Description -> `varchar(255)`, summary of clinical guidelines and scoring methodology
- Admin_SSN# -> `char(9)`, not null, refers to `SSN` in table `ADMIN`
- Primary key is (<u>NCD_Name</u>, <u>Effective_Date</u>)

**RISK_THRESHOLD (<u>NCD_NAME#</u>, <u>EFFECTIVE_DATE#</u>, <u>RISK_TIER</u>, MIN_SCORE, MAX_SCORE)**
- <u>NCD_Name#</u> -> `varchar(100)`, not null, part of composite primary key, part of composite foreign key referring to (`NCD_Name`, `Effective_Date`) in table `RISK_MODEL`
- <u>Effective_Date#</u> -> `date`, not null, part of composite primary key, part of composite foreign key referring to (`NCD_Name`, `Effective_Date`) in table `RISK_MODEL`
- <u>Risk_Tier</u> -> `varchar(10)`, not null, part of composite primary key, clinical triage tier: one of `Low` / `Medium` / `High`
- Min_Score -> `decimal(5,2)`, not null, minimum score bound for the tier (must be ≥ 0)
- Max_Score -> `decimal(5,2)`, not null, maximum score bound for the tier (must be ≥ `Min_Score`)
- Primary key is (<u>NCD_Name#</u>, <u>Effective_Date#</u>, <u>Risk_Tier</u>)

**RISK_MODEL_EVALUATION (<u>NCD_NAME#</u>, <u>EFFECTIVE_DATE#</u>, <u>ICD_CODE#</u>, RISK_WEIGHT)**
- <u>NCD_Name#</u> -> `varchar(100)`, not null, part of composite primary key, part of composite foreign key referring to (`NCD_Name`, `Effective_Date`) in table `RISK_MODEL`
- <u>Effective_Date#</u> -> `date`, not null, part of composite primary key, part of composite foreign key referring to (`NCD_Name`, `Effective_Date`) in table `RISK_MODEL`
- <u>ICD_Code#</u> -> `varchar(10)`, not null, part of composite primary key, refers to `ICD_Code` in table `MEDICAL_CONDITION`
- Risk_Weight -> `decimal(5,2)`, not null, numerical scoring weight assigned to the condition (must be ≥ 0)
- Primary key is (<u>NCD_Name#</u>, <u>Effective_Date#</u>, <u>ICD_Code#</u>)

**RISK_ASSESSMENT (<u>ASSESSMENT_NUMBER</u>, ASSESSMENT_DATE, SCORE, RISK_LEVEL, PATIENT_SSN#, NCD_NAME#, EFFECTIVE_DATE#)**
- <u>Assessment_Number</u> -> `int`, auto increment, not null, unique risk assessment identifier
- Assessment_Date -> `datetime`, not null, timestamp when the risk assessment was computed
- Score -> `decimal(5,2)`, not null, calculated aggregate patient risk score (must be ≥ 0)
- Risk_Level -> `varchar(10)`, not null, resulting clinical triage level: one of `Low` / `Medium` / `High`
- Patient_SSN# -> `char(9)`, not null, refers to `SSN` in table `PATIENT`
- NCD_Name# -> `varchar(100)`, nullable, part of composite foreign key referring to (`NCD_Name`, `Effective_Date`) in table `RISK_MODEL`
- Effective_Date# -> `date`, nullable, part of composite foreign key referring to (`NCD_Name`, `Effective_Date`) in table `RISK_MODEL`
- Primary key is <u>Assessment_Number</u>

**NOTIFICATION (<u>ASSESSMENT_NUMBER#</u>, <u>DATE_NOTIFIED</u>, RECIPIENT_USER_SSN#, MESSAGE)**
- <u>Assessment_Number#</u> -> `int`, not null, part of composite primary key, refers to `Assessment_Number` in table `RISK_ASSESSMENT`
- <u>Date_Notified</u> -> `datetime`, not null, part of composite primary key, timestamp when the notification alert was dispatched
- Recipient_User_SSN# -> `char(9)`, not null, refers to `SSN` in table `USER`
- Message -> `varchar(500)`, not null, clinical alert text delivered to the recipient
- Primary key is (<u>Assessment_Number#</u>, <u>Date_Notified</u>)
