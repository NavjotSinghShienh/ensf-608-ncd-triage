# Patient Risk Assessment System for Non-Communicable Diseases (NCD Triage System)

**Course:** ENSF 608 L01 – Databases (University of Calgary)  
**Instructor:** Dr. Ronnie de Souza Santos, PhD  
**Team:** Group 6  

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [UN Sustainable Development Goal (SDG) Alignment](#2-un-sustainable-development-goal-sdg-alignment)
3. [Team Members & Roles](#3-team-members--roles)
4. [Repository Structure](#4-repository-structure)
5. [Project Continuity: Evolution from Proposal to Models](#5-project-continuity-evolution-from-proposal-to-models)
6. [Conceptual Database Model (EER Diagram)](#6-conceptual-database-model-eer-diagram)
7. [Logical Database Model (Relational Schema)](#7-logical-database-model-relational-schema)
8. [Normalization Summary (1NF, 2NF, 3NF)](#8-normalization-summary-1nf-2nf-3nf)
9. [Key Database Queries & Analytical Use Cases](#9-key-database-queries--analytical-use-cases)
10. [Required SQL Operations, Testing & Final Deliverables](#10-required-sql-operations-testing--final-deliverables)

---

## 1. Project Overview

The **Patient Risk Assessment System for Non-Communicable Diseases** is a clinical decision-support and triage database system designed to help healthcare professionals identify, evaluate, and prioritize patients at high risk of severe outcomes from chronic non-communicable diseases (NCDs).

The system consolidates each patient's longitudinal medical diagnoses, laboratory test results, clinical consultations, prescriptions, and non-pharmacological treatment plans. Using configurable, versioned clinical risk models and scoring thresholds, the database computes individual risk assessment scores, assigns triage tiers (`Low`, `Medium`, `High`), and dispatches automated notifications to clinical staff so high-risk patients receive timely intervention and consistent follow-up care.

### Core Data Domains Managed
- **Users & Role-Based Profiles:** Centralized identity, authentication, and contact management (`User`) with specialized profiles for `Patient`, `Admin` (e.g., receptionists, security admins), and `Health_Professional` (`Doctor` and `Lab_Assistant`).
- **Patient Health, Diagnostics & Risk Triage:** Standardized disease dictionaries (`Medical_Condition`), patient diagnosis histories (`Patient_Diagnosis`), automated lab abnormality indicators (`Test_Threshold_Rule`), versioned risk scoring models (`Risk_Model`, `Risk_Model_Evaluation`, `Risk_Threshold`), calculated patient risk snapshots (`Risk_Assessment`), and alert logs (`Notification`).
- **Healthcare Facilities, Departments & Appointments:** Multi-facility physical infrastructure (`Facility`, `Department`, `Room`) and appointment scheduling/tracking (`Appointment`) across clinical and administrative staff.
- **Clinical Orders, Lab Results & Care Plans:** Standardized diagnostic test catalogs (`Test_Type`), empirical laboratory test results (`Lab_Test`), pharmaceutical catalogs (`Medication`), prescribed regimens (`Appointment_Prescription`), and procedural/therapeutic care plans (`Treatment_Type`, `Appointment_Treatment`).

---

## 2. UN Sustainable Development Goal (SDG) Alignment

This database operationalizes **United Nations Sustainable Development Goal 3: Good Health and Well-Being**:
- **Target 3.4:** *By 2030, reduce by one third premature mortality from non-communicable diseases through prevention and treatment and promote mental health and well-being.*
- **Indicator 3.4.1:** *Mortality rate attributed to cardiovascular disease, cancer, diabetes, or chronic respiratory disease.*

### How SDG 3.4 Is Operationalized in the Database
1. **Standardized Chronic Disease Tracking:** Stores ICD-coded chronic conditions (`Medical_Condition`) and longitudinal patient diagnosis states (`Patient_Diagnosis`).
2. **Evidence-Based Risk Stratification:** Evaluates patient conditions against versioned `Risk_Model` definitions, condition weights (`Risk_Model_Evaluation`), and tier cutoffs (`Risk_Threshold`) to generate quantifiable `Risk_Assessment` records (`Low`, `Medium`, `High`).
3. **Proactive Clinical Alerting:** Automatically links high-risk assessments to `Notification` records sent to responsible healthcare providers (`User`), preventing high-risk patients from being overlooked.
4. **Continuity of Care & Follow-Up Verification:** Connects risk assessments with scheduled `Appointment` records, diagnostic `Lab_Test` panels, `Appointment_Prescription` medications, and `Appointment_Treatment` procedures to identify care gaps (such as high-risk patients without scheduled follow-up appointments).

---

## 3. Team Members & Roles

| Participant Name | UCID | Team Role & Responsibilities |
| :--- | :---: | :--- |
| **Navjot Singh Shienh** | `30332849` | Project Management, Requirements Gathering, Database Implementation |
| **Iesrat Jahan Popy** | `30304908` | Conceptual Model, Data Population |
| **Nikita Williams** | `30143759` | Logical Model, Normalization |
| **Md Jubayer Khan** | `30336019` | Documentation, Database Testing |

---

## 4. Repository Structure

```text
ensf-608-ncd-triage/
├── models/
│   ├── Conceptual_Model.drawio               # Editable Draw.io EER Conceptual Model
│   ├── Conceptual_Model_Image.png            # Exported Conceptual Model diagram (PNG)
│   ├── Logical_Model.drawio                  # Editable Draw.io Relational Logical Model
│   ├── Logical_Model_Image.png               # Exported Logical Model schema diagram (PNG)
│   └── Relational_Schema_Logical_Model.md    # Relational Schema with data types, domains & keys
├── scripts/
│   ├── DDL.sql                               # Physical SQL database creation & constraints
│   └── populate.sql                          # Real-world clinical seed data (ICD-10, DINs, AHS sites)
└── README.md                                 # Project documentation
```

---

## 5. Project Continuity: Evolution from Proposal to Models

In accordance with the ENSF 608 project continuity guidelines, the 15 preliminary entities proposed in the **Team Project Proposal** were refined through Enhanced Entity-Relationship (EER) modelling and relational normalization (1NF–3NF) into **19 conceptual entities** and **25 relational tables**:

| Preliminary Entity (Proposal) | Conceptual Model Representation | Logical Model Table(s) | Modelling & Normalization Refinement |
| :--- | :--- | :--- | :--- |
| `User` | `User` (Supertype) | `User` | Flattened composite `Name` and `Login` attributes; omitted derived `Age` (computed from `DOB`). |
| `Patient` | `Patient` (Subtype of `User`) | `Patient`, `Patient_Emergency_Contact` | Extracted multivalued composite `Emergency Contact` attribute into `Patient_Emergency_Contact` for 1NF compliance. |
| *(Implicit Staff Roles)* | `Admin`, `Health Professional`, `Doctor`, `Lab_assistant` | `Admin`, `Health_Professional`, `Doctor`, `Lab_Assistant` | Introduced two-level EER specialization hierarchy (`User` $\rightarrow$ `Patient` / `Admin` / `Health_Professional` $\rightarrow$ `Doctor` / `Lab_Assistant`) to enforce role-specific attributes and relationships. |
| `Doctor` | `Doctor` (Subtype of `Health Professional`) | `Doctor` | Linked to `Health_Professional` via shared `SSN` primary/foreign key. |
| `Facility` | `Facility`, `Department`, `Room` (Weak Entity) | `Facility`, `Department`, `Room` | Decomposed facility infrastructure into `Facility`, `Department`, and weak entity `Room` to track clinical locations and room allocations without redundancy. |
| `MedicalCondition` | `Medical Condition` | `Medical_Condition` | Standardized master dictionary keyed by `ICD_Code`. |
| `PatientHistory` | `Diagnosed With` (M:N Relationship) | `Patient_Diagnosis` | Modeled as an associative entity/table linking `Patient` and `Medical_Condition` with `Diagnosis_Date` and `Status`. |
| `LabTest` & `LabResult` | `Test Type`, `Lab Test`, `Indicates` (M:N Relationship) | `Test_Type`, `Lab_Test`, `Test_Threshold_Rule` | Separated test catalog metadata (`Test_Type`: `Min_Range`, `Max_Range`) from empirical patient test executions (`Lab_Test`) to eliminate transitive dependencies (3NF), and added `Test_Threshold_Rule` to link abnormal results to `Medical_Condition`. |
| `Medication` & `Prescription` | `Medication`, `Prescribes` (M:N Relationship) | `Medication`, `Appointment_Prescription` | Separated pharmaceutical catalog (`Medication` keyed by `DIN`) from appointment-level prescription orders (`Appointment_Prescription`). |
| `Treatment` | `Treatment Type`, `Recommends` (M:N Relationship) | `Treatment_Type`, `Appointment_Treatment` | Separated master procedure catalog (`Treatment_Type`) from patient treatment assignments (`Appointment_Treatment`) for 3NF compliance. |
| `RiskModel` | `Risk Model`, `Risk Threshold` (Weak Entity) | `Risk_Model`, `Risk_Threshold` | Keyed `Risk_Model` by composite key (`NCD_Name`, `Effective_Date`) for versioning; extracted tier score bounds into weak entity `Risk_Threshold` (`Risk_Tier`, `Min_Score`, `Max_Score`). |
| `RiskModelRule` | `Evaluates` (M:N Relationship) | `Risk_Model_Evaluation` | Associative table linking `Risk_Model` and `Medical_Condition` with numerical `Risk_Weight`. |
| `RiskAssessmentResult` | `Risk Assessment`, `Notification` (Weak Entity) | `Risk_Assessment`, `Notification` | Captures calculated `Score` and `Risk_Level` per patient and model version, and triggers weak entity `Notification` alerts to recipient users. |
| `Appointment` | `Appointment` | `Appointment` | Connects `Patient`, `Doctor`, `Admin`, and `Room` (`Department_Name`, `Room_Number`). |

---

## 6. Conceptual Database Model (EER Diagram)

- **Source File:** [`models/Conceptual_Model.drawio`](models/Conceptual_Model.drawio)
- **Diagram Image:** [`models/Conceptual_Model_Image.png`](models/Conceptual_Model_Image.png)

![Conceptual Database Model](models/Conceptual_Model_Image.png)

### Key Conceptual Modelling Features
1. **Specialization & Generalization Hierarchies:**
   - **Level 1 (`User` Supertype):** Overlapping (`o`), total participation specialization into `Patient`, `Health Professional`, and `Admin`. A system user must hold at least one role and may hold multiple roles simultaneously (e.g., a staff member who is also a patient).
   - **Level 2 (`Health Professional` Supertype):** Disjoint (`d`), total participation specialization into `Doctor` and `Lab_assistant`. Every health professional is either a licensed doctor or a certified lab assistant.
2. **Weak Entities & Identifying Relationships:**
   - `Room` (identified by partial key `Room_Number` via `Allocated To` with `Department`).
   - `Risk Threshold` (identified by partial key `Risk_Tier` via `Consists of` with `Risk Model`, with `3:3` cardinality representing Low, Medium, and High tiers).
   - `Notification` (identified by partial key `Date_Notified` via `Triggers` with `Risk Assessment`).
3. **Composite, Multivalued & Derived Attributes:**
   - **Composite Attributes:** `User.Name` (`First Name`, `Last Name`), `User.Login` (`e-mail`, `Password`), `Facility.Address` (`Address_Line1`, `Address_Line2`, `City`, `State`, `Country`), and `Risk Model.Model_Key` (`NCD_Name`, `Effective_Date`).
   - **Multivalued Composite Attribute:** `Patient.Emergency Contact` (`Name`, `Phone_No`).
   - **Derived Attribute:** `User.Age` (derived dynamically from `DOB`).

### Conceptual Relationships & Cardinalities Summary

| Relationship | Participating Entities | Cardinality | Relationship Attributes / Notes |
| :--- | :--- | :---: | :--- |
| `Operates` | `Facility` — `Department` | `1:1` to `1:N` | Each department operates within one facility; a facility has one or more departments. |
| `Allocated To` | `Department` — `Room` | `1:1` to `1:N` | **Identifying relationship** for weak entity `Room`. |
| `Assigned To` | `Department` — `Health Professional` | `1:1` to `0:N` | Each health professional is assigned to one department. |
| `Works In` | `Department` — `Admin` | `1:1` to `0:N` | Each admin works in one department. |
| `Attends` | `Patient` — `Appointment` | `1:1` to `0:N` | Each appointment is attended by one patient; a patient may have zero or more appointments. |
| `Conducts` | `Doctor` — `Appointment` | `1:1` to `0:N` | Each appointment is conducted by one doctor; a doctor may conduct zero or more appointments. |
| `Books` | `Admin` — `Appointment` | `1:1` to `0:N` | Admin staff book appointments. |
| `Happens At` | `Room` — `Appointment` | `1:1` to `0:N` | Each appointment is hosted in a specific department room; a room may host zero or more appointments. |
| `Requires` | `Appointment` — `Lab Test` | `1:1` to `0:N` | An appointment may require zero or more lab tests. |
| `Performs` | `Lab_assistant` — `Lab Test` | `1:1` to `0:N` | A lab assistant performs zero or more lab tests. |
| `Process` | `Test Type` — `Lab Test` | `1:1` to `0:N` | Each lab test instance follows a standardized test type definition; a test type may have zero or more lab test instances. |
| `Maintains` | `Admin` — `Test Type` | `1:1` to `0:N` | Admins maintain the standardized test catalog. |
| `Prescribes` | `Appointment` — `Medication` | `0:N` to `0:N` | Attributes: `Dose`, `Instruction`, `Status`. |
| `Recommends` | `Appointment` — `Treatment Type` | `0:N` to `0:N` | Attributes: `Treatment_Date`, `Status`. |
| `Diagnosed With` | `Patient` — `Medical Condition` | `0:N` to `0:N` | Attributes: `Diagnosis_Date`, `Status`. |
| `Indicates` | `Test Type` — `Medical Condition` | `0:N` to `0:N` | Attributes: `Operator`, `Abnormality_Threshold`. |
| `Evaluates` | `Risk Model` — `Medical Condition` | `1:N` to `0:N` | Attribute: `Risk_weight`. |
| `Manages` | `Admin` — `Risk Model` | `1:1` to `0:N` | Admins manage risk model versions. |
| `Consists of` | `Risk Model` — `Risk Threshold` | `1:1` to `3:3` | **Identifying relationship** for weak entity `Risk Threshold`. |
| `Generates` | `Risk Model` — `Risk Assessment` | `1:1` to `0:N` | Each Risk Assessment is evaluated by exactly one Risk Model version (1:1 mandatory), while a Risk Model can generate zero or more Risk Assessments over time (0:N). |
| `Undergoes` | `Patient` — `Risk Assessment` | `1:1` to `0:N` | A patient undergoes risk assessments over time. |
| `Triggers` | `Risk Assessment` — `Notification` | `1:1` to `0:N` | **Identifying relationship** for weak entity `Notification`. |
| `Receives` | `User` — `Notification` | `1:1` to `0:N` | System user who receives the generated notification alert. |

---

## 7. Logical Database Model (Relational Schema)

- **Source File:** [`models/Logical_Model.drawio`](models/Logical_Model.drawio)
- **Schema Image:** [`models/Logical_Model_Image.png`](models/Logical_Model_Image.png)
- **Relational Schema & Data Types Document:** [`models/Relational_Schema_Logical_Model.md`](models/Relational_Schema_Logical_Model.md)

![Logical Database Model](models/Logical_Model_Image.png)

### Complete Relational Schema (25 Tables)

Below is the complete relational schema mapped from the Conceptual EER Model. **Primary Keys (PK)** are underlined (`<ins>...</ins>`) and **Foreign Keys (FK)** are marked with `#` and explicitly noted with their referenced target tables.

#### A. Identity, Roles & Specialization Tables
1. **`USER` (<ins>SSN</ins>, FIRST_NAME, LAST_NAME, DOB, ADDRESS, EMAIL, PASSWORD, PHONE_NUMBER, STATUS)**
   - **PK:** <ins>SSN</ins>
   - **Candidate Keys:** `Email` (Unique), `Phone_Number` (Unique)
2. **`PATIENT` (<ins>SSN#</ins>, HEALTHCARE_NUMBER, GENDER, BLOOD_TYPE, STATUS)**
   - **PK:** <ins>SSN#</ins>
   - **FK:** `SSN#` $\rightarrow$ `USER(SSN)`
   - **Candidate Key:** `Healthcare_Number` (Unique)
3. **`PATIENT_EMERGENCY_CONTACT` (<ins>PATIENT_SSN#</ins>, <ins>CONTACT_NAME</ins>, <ins>CONTACT_PHONE_NUMBER</ins>)**
   - **PK:** (<ins>Patient_SSN#</ins>, <ins>Contact_Name</ins>, <ins>Contact_Phone_Number</ins>)
   - **FK:** `Patient_SSN#` $\rightarrow$ `PATIENT(SSN)`
4. **`ADMIN` (<ins>SSN#</ins>, ROLE, ISACTIVE, DEPARTMENT_NAME#)**
   - **PK:** <ins>SSN#</ins>
   - **FKs:** `SSN#` $\rightarrow$ `USER(SSN)`, `Department_Name#` $\rightarrow$ `DEPARTMENT(Department_Name)`
5. **`HEALTH_PROFESSIONAL` (<ins>SSN#</ins>, EMPLOYEE_NUMBER, EMPLOYMENT_DATE, STATUS, DEPARTMENT_NAME#)**
   - **PK:** <ins>SSN#</ins>
   - **FKs:** `SSN#` $\rightarrow$ `USER(SSN)`, `Department_Name#` $\rightarrow$ `DEPARTMENT(Department_Name)`
   - **Candidate Key:** `Employee_Number` (Unique)
6. **`DOCTOR` (<ins>SSN#</ins>, LICENSE_NUMBER, SPECIALITY, QUALIFICATION)**
   - **PK:** <ins>SSN#</ins>
   - **FK:** `SSN#` $\rightarrow$ `HEALTH_PROFESSIONAL(SSN)`
   - **Candidate Key:** `License_Number` (Unique)
7. **`LAB_ASSISTANT` (<ins>SSN#</ins>, CERTIFICATION_NUMBER, CERTIFICATION_TYPE, LAB_SPECIALIZATION)**
   - **PK:** <ins>SSN#</ins>
   - **FK:** `SSN#` $\rightarrow$ `HEALTH_PROFESSIONAL(SSN)`
   - **Candidate Key:** `Certification_Number` (Unique)

#### B. Healthcare Facility Infrastructure Tables
8. **`FACILITY` (<ins>FACILITY_NAME</ins>, FACILITY_TYPE, ADDRESS_LINE1, ADDRESS_LINE2, CITY, STATE, COUNTRY)**
   - **PK:** <ins>Facility_Name</ins>
9. **`DEPARTMENT` (<ins>DEPARTMENT_NAME</ins>, LOCATION, FACILITY_NAME#)**
   - **PK:** <ins>Department_Name</ins>
   - **FK:** `Facility_Name#` $\rightarrow$ `FACILITY(Facility_Name)`
10. **`ROOM` (<ins>DEPARTMENT_NAME#</ins>, <ins>ROOM_NUMBER</ins>, ROOM_TYPE)**
    - **PK:** (<ins>Department_Name#</ins>, <ins>Room_Number</ins>)
    - **FK:** `Department_Name#` $\rightarrow$ `DEPARTMENT(Department_Name)`

#### C. Clinical Appointments, Diagnostics & Care Plan Tables
11. **`APPOINTMENT` (<ins>APPOINTMENT_NUMBER</ins>, APPOINTMENT_DATE, APPOINTMENT_TYPE, STATUS, PATIENT_SSN#, DOCTOR_SSN#, ADMIN_SSN#, DEPARTMENT_NAME#, ROOM_NUMBER#)**
    - **PK:** <ins>Appointment_Number</ins>
    - **FKs:**
      - `Patient_SSN#` $\rightarrow$ `PATIENT(SSN)`
      - `Doctor_SSN#` $\rightarrow$ `DOCTOR(SSN)`
      - `Admin_SSN#` $\rightarrow$ `ADMIN(SSN)`
      - (`Department_Name#`, `Room_Number#`) $\rightarrow$ `ROOM(Department_Name, Room_Number)`
12. **`TEST_TYPE` (<ins>TEST_NAME</ins>, MIN_RANGE, MAX_RANGE, ADMIN_SSN#)**
    - **PK:** <ins>Test_Name</ins>
    - **FK:** `Admin_SSN#` $\rightarrow$ `ADMIN(SSN)`
13. **`LAB_TEST` (<ins>ACCESSION_NUMBER</ins>, TEST_DATE, TEST_RESULT, STATUS, APPOINTMENT_NUMBER#, LAB_ASSISTANT_SSN#, TEST_NAME#)**
    - **PK:** <ins>Accession_Number</ins>
    - **FKs:**
      - `Appointment_Number#` $\rightarrow$ `APPOINTMENT(Appointment_Number)`
      - `Lab_Assistant_SSN#` $\rightarrow$ `LAB_ASSISTANT(SSN)`
      - `Test_Name#` $\rightarrow$ `TEST_TYPE(Test_Name)`
14. **`TREATMENT_TYPE` (<ins>TREATMENT_CODE</ins>, TREATMENT_NAME, TREATMENT_CATEGORY)**
    - **PK:** <ins>Treatment_Code</ins>
15. **`APPOINTMENT_TREATMENT` (<ins>APPOINTMENT_NUMBER#</ins>, <ins>TREATMENT_CODE#</ins>, TREATMENT_DATE, STATUS)**
    - **PK:** (<ins>Appointment_Number#</ins>, <ins>Treatment_Code#</ins>)
    - **FKs:**
      - `Appointment_Number#` $\rightarrow$ `APPOINTMENT(Appointment_Number)`
      - `Treatment_Code#` $\rightarrow$ `TREATMENT_TYPE(Treatment_Code)`
16. **`MEDICATION` (<ins>DIN</ins>, GENERIC_NAME, BRAND_NAME)**
    - **PK:** <ins>DIN</ins>
17. **`APPOINTMENT_PRESCRIPTION` (<ins>APPOINTMENT_NUMBER#</ins>, <ins>DIN#</ins>, DOSE, INSTRUCTION, STATUS)**
    - **PK:** (<ins>Appointment_Number#</ins>, <ins>DIN#</ins>)
    - **FKs:**
      - `Appointment_Number#` $\rightarrow$ `APPOINTMENT(Appointment_Number)`
      - `DIN#` $\rightarrow$ `MEDICATION(DIN)`

#### D. Medical Conditions, Risk Models & Triage Alerting Tables
18. **`MEDICAL_CONDITION` (<ins>ICD_CODE</ins>, CONDITION_NAME, CATEGORY)**
    - **PK:** <ins>ICD_Code</ins>
    - **Candidate Key:** `Condition_Name` (Unique)
19. **`PATIENT_DIAGNOSIS` (<ins>PATIENT_SSN#</ins>, <ins>ICD_CODE#</ins>, DIAGNOSIS_DATE, STATUS)**
    - **PK:** (<ins>Patient_SSN#</ins>, <ins>ICD_Code#</ins>)
    - **FKs:**
      - `Patient_SSN#` $\rightarrow$ `PATIENT(SSN)`
      - `ICD_Code#` $\rightarrow$ `MEDICAL_CONDITION(ICD_Code)`
20. **`TEST_THRESHOLD_RULE` (<ins>TEST_NAME#</ins>, <ins>ICD_CODE#</ins>, ABNORMALITY_THRESHOLD, OPERATOR)**
    - **PK:** (<ins>Test_Name#</ins>, <ins>ICD_Code#</ins>)
    - **FKs:**
      - `Test_Name#` $\rightarrow$ `TEST_TYPE(Test_Name)`
      - `ICD_Code#` $\rightarrow$ `MEDICAL_CONDITION(ICD_Code)`
21. **`RISK_MODEL` (<ins>NCD_NAME</ins>, <ins>EFFECTIVE_DATE</ins>, DESCRIPTION, ADMIN_SSN#)**
    - **PK:** (<ins>NCD_Name</ins>, <ins>Effective_Date</ins>)
    - **FK:** `Admin_SSN#` $\rightarrow$ `ADMIN(SSN)`
22. **`RISK_THRESHOLD` (<ins>NCD_NAME#</ins>, <ins>EFFECTIVE_DATE#</ins>, <ins>RISK_TIER</ins>, MIN_SCORE, MAX_SCORE)**
    - **PK:** (<ins>NCD_Name#</ins>, <ins>Effective_Date#</ins>, <ins>Risk_Tier</ins>)
    - **FK:** (`NCD_Name#`, `Effective_Date#`) $\rightarrow$ `RISK_MODEL(NCD_Name, Effective_Date)`
23. **`RISK_MODEL_EVALUATION` (<ins>NCD_NAME#</ins>, <ins>EFFECTIVE_DATE#</ins>, <ins>ICD_CODE#</ins>, RISK_WEIGHT)**
    - **PK:** (<ins>NCD_Name#</ins>, <ins>Effective_Date#</ins>, <ins>ICD_Code#</ins>)
    - **FKs:**
      - (`NCD_Name#`, `Effective_Date#`) $\rightarrow$ `RISK_MODEL(NCD_Name, Effective_Date)`
      - `ICD_Code#` $\rightarrow$ `MEDICAL_CONDITION(ICD_Code)`
24. **`RISK_ASSESSMENT` (<ins>ASSESSMENT_NUMBER</ins>, ASSESSMENT_DATE, SCORE, RISK_LEVEL, PATIENT_SSN#, NCD_NAME#, EFFECTIVE_DATE#)**
    - **PK:** <ins>Assessment_Number</ins>
    - **FKs:**
      - `Patient_SSN#` $\rightarrow$ `PATIENT(SSN)`
      - (`NCD_Name#`, `Effective_Date#`) $\rightarrow$ `RISK_MODEL(NCD_Name, Effective_Date)`
25. **`NOTIFICATION` (<ins>ASSESSMENT_NUMBER#</ins>, <ins>DATE_NOTIFIED</ins>, RECIPIENT_USER_SSN#, MESSAGE)**
    - **PK:** (<ins>Assessment_Number#</ins>, <ins>Date_Notified</ins>)
    - **FKs:**
      - `Assessment_Number#` $\rightarrow$ `RISK_ASSESSMENT(Assessment_Number)`
      - `Recipient_User_SSN#` $\rightarrow$ `USER(SSN)`

---

## 8. Normalization Summary (1NF, 2NF, 3NF)

The relational schema satisfies **First Normal Form (1NF)**, **Second Normal Form (2NF)**, and **Third Normal Form (3NF)**:

1. **First Normal Form (1NF) — Atomic Attributes & Removal of Repeating Groups:**
   - Composite attributes (`User.Name`, `User.Login`, `Facility.Address`) are decomposed into atomic columns (`First_Name`, `Last_Name`, `Email`, `Password`, `Address_Line1`, `Address_Line2`, `City`, `State`, `Country`).
   - The multivalued composite attribute `Emergency Contact` on `Patient` is extracted into a dedicated relation `Patient_Emergency_Contact(Patient_SSN, Contact_Name, Contact_Phone_Number)`.
2. **Second Normal Form (2NF) — Elimination of Partial Dependencies:**
   - Every non-key attribute in tables with composite primary keys (`Room`, `Patient_Diagnosis`, `Risk_Model`, `Risk_Threshold`, `Risk_Model_Evaluation`, `Test_Threshold_Rule`, `Appointment_Treatment`, `Appointment_Prescription`, `Notification`) is fully functionally dependent on the *entire* composite primary key.
   - For example, in `Appointment_Prescription(Appointment_Number, DIN)`, `Dose`, `Instruction`, and `Status` depend on both the specific appointment and the specific medication (`DIN`), while drug-specific attributes (`Generic_Name`, `Brand_Name`) reside solely in `Medication(DIN)`.
   - Similarly, in `Appointment_Treatment(Appointment_Number, Treatment_Code)`, `Treatment_Date` and `Status` depend on the full key, whereas `Treatment_Name` and `Treatment_Category` depend only on `Treatment_Code` and are isolated in `Treatment_Type`.
3. **Third Normal Form (3NF) — Elimination of Transitive Dependencies:**
   - Non-key attributes depend *only* on the primary key and not on other non-key attributes.
   - **Lab Tests vs. Test Types:** Reference range metadata (`Min_Range`, `Max_Range`) depends on `Test_Name` rather than `Accession_Number`. Separating `Test_Type` from `Lab_Test` removes the transitive dependency `Accession_Number` $\rightarrow$ `Test_Name` $\rightarrow$ (`Min_Range`, `Max_Range`).
   - **Facility vs. Department vs. Room:** Facility address details (`Address_Line1`, `City`, `State`, `Country`) depend on `Facility_Name` and are stored in `Facility`, while `Department` references `Facility_Name` as a foreign key rather than duplicating facility address fields.
   - **Role Specialization:** Role-specific attributes (`License_Number`, `Speciality`, `Qualification` for `Doctor`; `Certification_Number`, `Lab_Specialization` for `Lab_Assistant`; `Healthcare_Number`, `Blood_Type` for `Patient`) are placed in their respective subtype relations rather than introducing nullable or transitively dependent columns in `User`.

---

## 9. Key Database Queries & Analytical Use Cases

The database is designed to answer core clinical and operational questions identified in the project proposal, as well as broader SQL operations:

1. **Patient Risk Stratification Summary:**
   - *How many patients are currently classified in each risk level (`Low`, `Medium`, `High`)?*
2. **Care Gap & Overdue Follow-Up Identification (SDG 3.4 Operationalization):**
   - *Which patients were classified as `High` risk in the past six months, but currently have no future appointments scheduled with any doctor at any facility?*
3. **Facility Workload & Condition Prevalence Analysis:**
   - *Which `Facility` locations are managing the highest volume of `High` risk patients, and what are the top three most frequent `Medical_Condition` diagnoses among patients in those facilities?*
4. **Clinician Schedule & Patient Acuity Overview:**
   - *For a specific `Doctor`, what is the summary of their upcoming week's appointment schedule, including each patient's latest risk score alongside a count of active `Appointment_Prescription` and `Appointment_Treatment` records?*
5. **Comparative Treatment & Laboratory Outcome Analysis:**
   - *What is the average `Lab_Test` result value for a specific `Test_Type` among patients actively taking a specific `Medication`, compared to patients managed via a non-medicated `Treatment_Type` plan?*

---

## 10. Required SQL Operations, Testing & Final Deliverables

Per the **ENSF 608 Project Description**, the physical implementation and testing scripts in [`scripts/`](scripts/) are organized to fulfill all required project milestones:

### SQL Operations & Queries Coverage (Minimum 25 Distinct Operations)
| Category | Minimum Required |
| :--- | :---: |
| `INSERT` operations | 2 |
| `UPDATE` operations | 2 |
| `DELETE` operations | 2 |
| Basic `SELECT` queries with filtering (`WHERE`, `LIKE`, `IN`, `BETWEEN`, `AND`, `OR`) | 4 |
| `SELECT` queries using `ORDER BY`, `DISTINCT`, or `LIMIT` | 2 |
| `SELECT` queries using aggregate functions (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`) | 3 |
| `SELECT` queries using `GROUP BY` (including at least one with `HAVING`) | 2 |
| `SELECT` queries using `INNER JOIN` (including 3+ table joins) | 3 |
| `SELECT` queries using `LEFT JOIN` or `RIGHT JOIN` | 2 |
| Complex `SELECT` query combining `JOIN`s, aggregations, filtering, and grouping | 1 |
| Executable `STORED PROCEDURE`s (including at least one with an input parameter) | 2 |
| **Total Minimum Operations** | **25** |

### Systematic Database Testing
The database testing suite verifies:
- **Structural & Constraint Integrity:** Primary key uniqueness, foreign key referential integrity (`ON DELETE` / `ON UPDATE` rules), `UNIQUE` constraints (`Healthcare_Number`, `Employee_Number`, `License_Number`, `Certification_Number`), `NOT NULL` enforcement, and domain `CHECK` constraints (e.g., valid status values and score ranges).
- **Positive & Negative Test Cases:** Execution evidence demonstrating both valid clinical transactions and proper rejection of invalid or inconsistent data.
