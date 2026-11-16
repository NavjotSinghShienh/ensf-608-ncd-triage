-- Data Population

-- Disable foreign key checks during cleanup if necessary
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE Notifications;
TRUNCATE TABLE Risk_Assessments;
TRUNCATE TABLE Risk_Model_Evaluations;
TRUNCATE TABLE Risk_Thresholds;
TRUNCATE TABLE Risk_Models;
TRUNCATE TABLE Test_Threshold_Rules;
TRUNCATE TABLE Patient_Diagnoses;
TRUNCATE TABLE Medical_Conditions;
TRUNCATE TABLE Lab_Tests;
TRUNCATE TABLE Test_Types;
TRUNCATE TABLE Appointment_Prescriptions;
TRUNCATE TABLE Medications;
TRUNCATE TABLE Appointment_Treatments;
TRUNCATE TABLE Treatment_Types;
TRUNCATE TABLE Appointments;
TRUNCATE TABLE Admins;
TRUNCATE TABLE Lab_Assistants;
TRUNCATE TABLE Doctors;
TRUNCATE TABLE Health_Professionals;
TRUNCATE TABLE Patient_Emergency_Contacts;
TRUNCATE TABLE Patients;
TRUNCATE TABLE Users;
TRUNCATE TABLE Rooms;
TRUNCATE TABLE Departments;
TRUNCATE TABLE Facilities;

SET FOREIGN_KEY_CHECKS = 1;
-- =========================================================================
-- 1. FACILITIES (Healthcare Infrastructure)
-- =========================================================================
INSERT INTO Facilities (Facility_Name, Facility_Type, Address_Line1, Address_Line2, City, State, Country) VALUES
('Foothills Medical Centre', 'Hospital', '1403 29 St NW', 'Main Building', 'Calgary', 'Alberta', 'Canada'),
('Peter Lougheed Centre', 'Hospital', '3500 26 Ave NE', 'Ambulatory Care Wing', 'Calgary', 'Alberta', 'Canada'),
('Rockyview General Hospital', 'Hospital', '7007 14 St SW', 'South Pavilion', 'Calgary', 'Alberta', 'Canada'),
('Sheldon M Chumir Health Centre', 'Clinic', '1213 4 St SW', 'Suite 200', 'Calgary', 'Alberta', 'Canada'),
('Calgary Central Diagnostic Hub', 'Diagnostic Center', '222 5 Ave SW', 'Level 1', 'Calgary', 'Alberta', 'Canada');

-- =========================================================================
-- 2. DEPARTMENTS  
-- =========================================================================
INSERT INTO Departments (Department_Name, Location, Facility_Name) VALUES
('Cardiology', 'Wing A - 3rd Floor', 'Foothills Medical Centre'),
('Endocrinology & Diabetes Clinic', 'Wing B - 2nd Floor', 'Peter Lougheed Centre'),
('Oncology & Cancer Care', 'South Pavilion - 4th Floor', 'Rockyview General Hospital'),
('Respirology & Chest Care', 'Main Building - 1st Floor', 'Foothills Medical Centre'),
('General Internal Medicine', 'Suite 201', 'Sheldon M Chumir Health Centre'),
('Diagnostic Pathology & Laboratory', 'Lower Level Lab Core', 'Calgary Central Diagnostic Hub'),
('Preventive Medicine & Clinical Triage', 'Wing C - 1st Floor', 'Foothills Medical Centre');

-- =========================================================================
-- 3. ROOMS (Weak Entity of Departments)
-- =========================================================================
INSERT INTO Rooms (Department_Name, Room_Number, Room_Type) VALUES
('Cardiology', 'A301', 'Consultation'),
('Cardiology', 'A302', 'Procedure'),
('Endocrinology & Diabetes Clinic', 'B201', 'Consultation'),
('Endocrinology & Diabetes Clinic', 'B202', 'Procedure'),
('Oncology & Cancer Care', 'O401', 'Consultation'),
('Oncology & Cancer Care', 'O402', 'Procedure'),
('Respirology & Chest Care', 'R101', 'Consultation'),
('Respirology & Chest Care', 'R102', 'Procedure'),
('General Internal Medicine', 'S201', 'Consultation'),
('General Internal Medicine', 'S202', 'Procedure'),
('Diagnostic Pathology & Laboratory', 'LAB01', 'Lab'),
('Diagnostic Pathology & Laboratory', 'LAB02', 'Lab'),
('Preventive Medicine & Clinical Triage', 'T101', 'Consultation');

-- =========================================================================
-- 4. USERS (Supertype for Patients, Health Professionals, and Admins)
-- =========================================================================
INSERT INTO Users (SSN, First_Name, Last_Name, DOB, Address, Email, Password, Phone_Number, Status) VALUES
-- Administrators
('100000001', 'Sarah', 'Connor', '1982-04-12', '123 Centre St N, Calgary, AB', 'sarah.connor@albertahealth.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0a', '4035550101', 'Active'),
('100000002', 'Mark', 'Ruffalo', '1980-09-22', '456 16 Ave NW, Calgary, AB', 'mark.ruffalo@albertahealth.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0b', '4035550102', 'Active'),
('100000003', 'Elena', 'Gilbert', '1988-06-15', '789 Heritage Dr SW, Calgary, AB', 'elena.gilbert@albertahealth.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0c', '4035550103', 'Active'),

-- Doctors (Health Professionals)
('200000001', 'Gregory', 'House', '1975-05-15', '101 University Dr NW, Calgary, AB', 'gregory.house@albertahealth.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0d', '4035550201', 'Active'),
('200000002', 'Allison', 'Cameron', '1981-11-03', '204 Kensington Rd NW, Calgary, AB', 'allison.cameron@albertahealth.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0e', '4035550202', 'Active'),
('200000003', 'Robert', 'Chase', '1979-02-12', '309 8 Ave SW, Calgary, AB', 'robert.chase@albertahealth.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0f', '4035550203', 'Active'),
('200000004', 'Eric', 'Foreman', '1978-08-19', '512 Crowfoot Cres NW, Calgary, AB', 'eric.foreman@albertahealth.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0g', '4035550204', 'Active'),
('200000005', 'Lisa', 'Cuddy', '1974-03-25', '888 Aspen Woods Dr SW, Calgary, AB', 'lisa.cuddy@albertahealth.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0h', '4035550205', 'Active'),

-- Lab Assistants (Health Professionals)
('300000001', 'Dexter', 'Morgan', '1983-02-01', '710 Memorial Dr NE, Calgary, AB', 'dexter.morgan@albertahealth.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0i', '4035550301', 'Active'),
('300000002', 'Abby', 'Sciuto', '1986-07-27', '920 17 Ave SW, Calgary, AB', 'abby.sciuto@albertahealth.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0j', '4035550302', 'Active'),
('300000003', 'Walter', 'Bishop', '1965-10-18', '431 Sunridge Way NE, Calgary, AB', 'walter.bishop@albertahealth.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0k', '4035550303', 'Active'),

-- Patients
('400000001', 'James', 'Wilson', '1958-03-10', '140 Cranston Dr SE, Calgary, AB', 'james.wilson@patients.ab.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0l', '4035550401', 'Active'),
('400000002', 'Arthur', 'Dent', '1966-07-11', '221B Baker Park NW, Calgary, AB', 'arthur.dent@patients.ab.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0m', '4035550402', 'Active'),
('400000003', 'Martha', 'Kent', '1952-12-05', '314 Country Hills Blvd NW, Calgary, AB', 'martha.kent@patients.ab.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0n', '4035550403', 'Active'),
('400000004', 'Bruce', 'Wayne', '1973-04-17', '100 Shawnessy Blvd SW, Calgary, AB', 'bruce.wayne@patients.ab.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0o', '4035550404', 'Active'),
('400000005', 'Diana', 'Prince', '1985-09-08', '505 Quarry Park Blvd SE, Calgary, AB', 'diana.prince@patients.ab.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0p', '4035550405', 'Active'),
('400000006', 'Clark', 'Kent', '1962-06-18', '77 Prairie Springs Dr, Calgary, AB', 'clark.kent@patients.ab.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0q', '4035550406', 'Active'),
('400000007', 'Peter', 'Parker', '1995-08-10', '12 Taradale Dr NE, Calgary, AB', 'peter.parker@patients.ab.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0r', '4035550407', 'Active'),
('400000008', 'Tony', 'Stark', '1960-05-29', '88 Elbow Dr SW, Calgary, AB', 'tony.stark@patients.ab.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0s', '4035550408', 'Active'),
('400000009', 'Natasha', 'Romanoff', '1984-11-22', '310 Bridgeland Ave NE, Calgary, AB', 'natasha.romanoff@patients.ab.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0t', '4035550409', 'Active'),
('400000010', 'Steve', 'Rogers', '1950-07-04', '420 Signal Hill Dr SW, Calgary, AB', 'steve.rogers@patients.ab.ca', '$2b$12$e8Y6l8m4R1N5d8e7h2w.3O8w8q1v8z0u', '4035550410', 'Active');

-- =========================================================================
-- 5. PATIENTS
-- =========================================================================
INSERT INTO Patients (SSN, Healthcare_Number, Gender, Blood_Type, Status) VALUES
('400000001', 'AB-908123401', 'Male', 'O+', 'Active'),
('400000002', 'AB-908123402', 'Male', 'A+', 'Active'),
('400000003', 'AB-908123403', 'Female', 'B+', 'Active'),
('400000004', 'AB-908123404', 'Male', 'O-', 'Active'),
('400000005', 'AB-908123405', 'Female', 'AB+', 'Active'),
('400000006', 'AB-908123406', 'Male', 'A-', 'Active'),
('400000007', 'AB-908123407', 'Male', 'O+', 'Active'),
('400000008', 'AB-908123408', 'Male', 'B-', 'Active'),
('400000009', 'AB-908123409', 'Female', 'AB-', 'Active'),
('400000010', 'AB-908123410', 'Male', 'O+', 'Active');

-- =========================================================================
-- 6. PATIENT EMERGENCY CONTACTS (Multivalued Attribute)
-- =========================================================================
INSERT INTO Patient_Emergency_Contacts (Patient_SSN, Contact_Name, Contact_Phone_Number) VALUES
('400000001', 'Julie Wilson', '4035559001'),
('400000002', 'Trillian Astra', '4035559002'),
('400000003', 'Jonathan Kent', '4035559003'),
('400000004', 'Alfred Pennyworth', '4035559004'),
('400000005', 'Hippolyta Prince', '4035559005'),
('400000006', 'Lois Lane-Kent', '4035559006'),
('400000007', 'May Parker', '4035559007'),
('400000008', 'Pepper Potts', '4035559008'),
('400000009', 'Clint Barton', '4035559009'),
('400000010', 'Bucky Barnes', '4035559010');

-- =========================================================================
-- 7. HEALTH PROFESSIONALS (Supertype for Doctors and Lab Assistants)

-- =========================================================================
INSERT INTO Health_Professionals (SSN, Employee_Number, Employment_Date, Status, Department_Name) VALUES
('200000001', 'EMP-DOC-001', '2010-07-01', 'Active', 'Cardiology'),
('200000002', 'EMP-DOC-002', '2014-03-15', 'Active', 'Endocrinology & Diabetes Clinic'),
('200000003', 'EMP-DOC-003', '2016-09-01', 'Active', 'Oncology & Cancer Care'),
('200000004', 'EMP-DOC-004', '2012-11-20', 'Active', 'Respirology & Chest Care'),
('200000005', 'EMP-DOC-005', '2008-01-10', 'Active', 'General Internal Medicine'),
('300000001', 'EMP-LAB-001', '2015-06-01', 'Active', 'Diagnostic Pathology & Laboratory'),
('300000002', 'EMP-LAB-002', '2018-04-12', 'Active', 'Diagnostic Pathology & Laboratory'),
('300000003', 'EMP-LAB-003', '2011-10-05', 'Active', 'Diagnostic Pathology & Laboratory');

-- =========================================================================
-- 8. DOCTORS (Subtype of Health Professionals)
-- =========================================================================
INSERT INTO Doctors (SSN, License_Number, Speciality, Qualification) VALUES
('200000001', 'CPSA-MD-78101', 'Cardiovascular Diseases', 'MD, FRCPC Cardiology'),
('200000002', 'CPSA-MD-78102', 'Endocrinology & Metabolism', 'MD, FRCPC Endocrinology'),
('200000003', 'CPSA-MD-78103', 'Medical Oncology', 'MD, FRCPC Medical Oncology'),
('200000004', 'CPSA-MD-78104', 'Pulmonary & Critical Care', 'MD, FRCPC Respirology'),
('200000005', 'CPSA-MD-78105', 'Internal Medicine & Triage', 'MD, FACP Internal Medicine');

-- =========================================================================
-- 9. LAB ASSISTANTS (Subtype of Health Professionals)
-- =========================================================================
INSERT INTO Lab_Assistants (SSN, Certification_Number, Certification_Type, Lab_Specialization) VALUES
('300000001', 'CSMLS-MLT-4101', 'Certified Medical Laboratory Technologist', 'Clinical Biochemistry & Hematology'),
('300000002', 'CSMLS-MLT-4102', 'Certified Medical Laboratory Technologist', 'Clinical Chemistry & Molecular Diagnostics'),
('300000003', 'CSMLS-MLT-4103', 'Senior Laboratory Technologist', 'Immunology & Toxicology');

-- =========================================================================
-- 10. ADMINS (Administrative Roles)
-- =========================================================================
INSERT INTO Admins (SSN, Role, IsActive, Department_Name) VALUES
('100000001', 'Clinical Admin', TRUE, 'Preventive Medicine & Clinical Triage'),
('100000002', 'Receptionist', TRUE, 'Cardiology'),
('100000003', 'System Admin', TRUE, 'Diagnostic Pathology & Laboratory');

-- =========================================================================
-- 11. TREATMENT TYPES 
-- =========================================================================
INSERT INTO Treatment_Types (Treatment_Code, Treatment_Name, Treatment_Category) VALUES
('TR-LIF-001', 'Therapeutic Lifestyle Modification & Dietary Counseling', 'Lifestyle Intervention'),
('TR-LIF-002', 'Supervised Cardiovascular Exercise & Rehabilitation', 'Lifestyle Intervention'),
('TR-LIF-003', 'Smoking Cessation Program', 'Lifestyle Intervention'),
('TR-THE-001', 'Inhaler Therapy Initiation and Review', 'Therapy'),
('TR-THE-002', 'Comprehensive Diabetic Foot Ulcer Therapy & Wound Care', 'Therapy'),
('TR-THE-003', 'Pulmonary Rehabilitation', 'Therapy'),
('TR-THE-004', 'Chemotherapy', 'Therapy'),
('TR-THE-005', 'Radiation Therapy', 'Therapy'),
('TR-THE-006', 'Hormone (Endocrine) Therapy for Breast Cancer', 'Therapy'),
('TR-SUR-001', 'Percutaneous Coronary Intervention / Angioplasty', 'Surgical'),
('TR-SUR-002', 'Breast Cancer Surgery (Lumpectomy or Mastectomy)', 'Surgical'),
('TR-MON-001', 'Ambulatory 24-Hour Blood Pressure Monitoring Protocol', 'Monitoring'),
('TR-MON-002', 'Continuous Glucose Monitoring (CGM) Real-Time Profiling', 'Monitoring'),
('TR-MON-003', 'Spirometry and Pulmonary Function Monitoring', 'Monitoring'),
('TR-MON-004', 'Cancer Screening and Surveillance', 'Monitoring');

-- =========================================================================
-- 12. MEDICATIONS (real Health Canada DINs; keep DINs as quoted strings)
-- =========================================================================
INSERT INTO Medications (DIN, Generic_Name, Brand_Name) VALUES
('02099233', 'Metformin hydrochloride 500 mg',               'Glucophage'),
('02443937', 'Empagliflozin 10 mg',                          'Jardiance'),
('02443945', 'Empagliflozin 25 mg',                          'Jardiance'),
('02294338', 'Insulin glargine 100 units/mL (SoloStar pen)', 'Lantus'),
('02230713', 'Atorvastatin calcium 20 mg',                   'Lipitor'),
('02247162', 'Rosuvastatin calcium 10 mg',                   'Crestor'),
('02221853', 'Ramipril 10 mg',                               'Altace'),
('00878928', 'Amlodipine besylate 5 mg',                     'Norvasc'),
('02241497', 'Salbutamol sulfate 100 mcg/actuation inhaler', 'Ventolin HFA'),
('02245386', 'Budesonide/formoterol 200/6 mcg inhalation powder', 'Symbicort 200 Turbuhaler'),
('02435381', 'Tiotropium 2.5 mcg/actuation inhalation solution',  'Spiriva Respimat'),
('02224135', 'Anastrozole 1 mg',                             'Arimidex');

-- =========================================================================
-- 13. TEST TYPES 
-- =========================================================================
INSERT INTO Test_Types (Test_Name, Min_Range, Max_Range, Admin_SSN) VALUES
('Glycated Hemoglobin (HbA1c)', 4.00, 6.00, '100000001'),
('Fasting Blood Glucose', 3.30, 6.00, '100000001'),
('Total Cholesterol', 3.00, 5.20, '100000001'),
('Low-Density Lipoprotein (LDL-C)', 1.50, 3.40, '100000001'),
('High-Density Lipoprotein (HDL-C)', 1.00, 2.20, '100000001'),
('High-Sensitivity C-Reactive Protein (hs-CRP)', 0.00, 3.00, '100000003'),
('Systolic Blood Pressure (Clinical)', 90.00, 120.00, '100000001'),
('Body Mass Index (BMI)', 18.50, 24.90, '100000001'),
('CA 15-3 (Breast Cancer Marker)', 0.00, 30.00, '100000001'),
('Carcinoembryonic Antigen (CEA)', 0.00, 5.00, '100000001'),
('Prostate-Specific Antigen (PSA)', 0.00, 4.00, '100000001'),
('FEV1 (% Predicted)', 80.00, 120.00, '100000001'),
('FEV1/FVC Ratio', 0.70, 1.00, '100000001');

-- =========================================================================
-- 14. MEDICAL CONDITIONS 
--     Categories must match CK_Medical_Conditions_Category
-- =========================================================================
INSERT INTO Medical_Conditions (ICD_Code, Condition_Name, Category) VALUES
('I10', 'Essential (Primary) Hypertension', 'Cardiovascular'),
('I25.1', 'Atherosclerotic Heart Disease of Native Coronary Artery', 'Cardiovascular'),
('I50.9', 'Heart Failure, Unspecified', 'Cardiovascular'),
('E11.9', 'Type 2 Diabetes Mellitus without Complications', 'Metabolic'),
('E78.0', 'Pure Hypercholesterolemia', 'Metabolic'),
('E66.0', 'Obesity due to Excess Calories', 'Lifestyle'),
('J44.9', 'Chronic Obstructive Pulmonary Disease (COPD), Unspecified', 'Respiratory'),
('J45.9', 'Asthma, Unspecified', 'Respiratory'),
('C50.9', 'Malignant Neoplasm of Breast, Unspecified', 'Oncological'),
('C61', 'Malignant Neoplasm of Prostate', 'Oncological'),
('C34.9', 'Malignant Neoplasm of Bronchus or Lung, Unspecified', 'Oncological'),
('C18.9', 'Malignant Neoplasm of Colon, Unspecified', 'Oncological'),
('Z82.49', 'Family History of Ischemic Heart Disease and Other Diseases of Circulatory System', 'Family History'),
('Z80.3', 'Family History of Malignant Neoplasm of Breast', 'Family History');

-- =========================================================================
-- 15. APPOINTMENTS (Clinical Consultations & Triage Visits)
-- =========================================================================
INSERT INTO Appointments (Appointment_Number, Appointment_Date, Appointment_Type, Status, Patient_SSN, Doctor_SSN, Admin_SSN, Department_Name, Room_Number) VALUES
(101, '2026-08-10 09:00:00', 'Initial Consultation', 'Completed', '400000001', '200000001', '100000002', 'Cardiology', 'A301'),
(102, '2026-08-15 10:30:00', 'Initial Consultation', 'Completed', '400000002', '200000002', '100000001', 'Endocrinology & Diabetes Clinic', 'B201'),
(103, '2026-08-20 14:00:00', 'Initial Consultation', 'Completed', '400000003', '200000003', '100000001', 'Oncology & Cancer Care', 'O401'),
(104, '2026-09-05 11:00:00', 'Initial Consultation', 'Completed', '400000004', '200000001', '100000002', 'Cardiology', 'A301'),
(105, '2026-09-12 13:30:00', 'Routine Checkup', 'Completed', '400000005', '200000005', '100000001', 'General Internal Medicine', 'S201'),
(106, '2026-09-25 15:00:00', 'Emergency', 'Completed', '400000006', '200000001', '100000002', 'Cardiology', 'A302'),
(107, '2026-10-02 09:30:00', 'Initial Consultation', 'Completed', '400000007', '200000004', '100000001', 'Respirology & Chest Care', 'R101'),
(108, '2026-10-18 10:00:00', 'Follow-Up', 'Completed', '400000008', '200000002', '100000001', 'Endocrinology & Diabetes Clinic', 'B201'),
(109, '2026-10-28 11:30:00', 'Routine Checkup', 'Completed', '400000009', '200000005', '100000001', 'General Internal Medicine', 'S201'),
(110, '2026-11-02 14:30:00', 'Follow-Up', 'Completed', '400000010', '200000004', '100000001', 'Respirology & Chest Care', 'R101'),
-- Future Scheduled Appointments (for care gap analysis: Patients 400000001 and 400000003 have follow-ups; 400000006, 400000008 and 400000010 are HIGH risk with no future visits!)
(111, '2026-11-20 09:00:00', 'Follow-Up', 'Scheduled', '400000001', '200000001', '100000002', 'Cardiology', 'A301'),
(112, '2026-11-22 10:30:00', 'Follow-Up', 'Scheduled', '400000002', '200000002', '100000001', 'Endocrinology & Diabetes Clinic', 'B201'),
(113, '2026-11-25 13:00:00', 'Follow-Up', 'Scheduled', '400000003', '200000003', '100000001', 'Oncology & Cancer Care', 'O401'),
(114, '2026-12-05 14:00:00', 'Routine Checkup', 'Scheduled', '400000005', '200000005', '100000001', 'General Internal Medicine', 'S201');

-- =========================================================================
-- 16. APPOINTMENT TREATMENTS
-- =========================================================================
INSERT INTO Appointment_Treatments (Appointment_Number, Treatment_Code, Treatment_Date, Status) VALUES
(101, 'TR-LIF-002', '2026-08-10', 'Completed'),
(101, 'TR-MON-001', '2026-08-11', 'Completed'),
(102, 'TR-LIF-001', '2026-08-15', 'Completed'),
(102, 'TR-MON-002', '2026-08-15', 'Completed'),
-- Cancer (breast): screening, surgery, radiation, hormone therapy
(103, 'TR-MON-004', '2026-08-20', 'Completed'),
(103, 'TR-SUR-002', '2026-09-10', 'Completed'),
(103, 'TR-THE-006', '2026-09-24', 'In Progress'),
(103, 'TR-THE-005', '2026-10-01', 'In Progress'),
(104, 'TR-SUR-001', '2026-09-08', 'Completed'),
(105, 'TR-LIF-001', '2026-09-12', 'Completed'),
(106, 'TR-SUR-001', '2026-09-25', 'Completed'),
-- Chronic respiratory disease (asthma)
(107, 'TR-THE-001', '2026-10-02', 'In Progress'),
(107, 'TR-MON-003', '2026-10-02', 'Completed'),
(108, 'TR-THE-002', '2026-10-18', 'Completed'),
(109, 'TR-MON-004', '2026-10-28', 'Completed'),
-- Chronic respiratory disease (COPD)
(110, 'TR-MON-003', '2026-11-02', 'Completed'),
(110, 'TR-THE-003', '2026-11-02', 'In Progress'),
(110, 'TR-LIF-003', '2026-11-02', 'In Progress'),
(111, 'TR-LIF-002', '2026-11-20', 'Recommended');

-- =========================================================================
-- 17. APPOINTMENT PRESCRIPTIONS (real DINs from Section 12)
-- =========================================================================
INSERT INTO Appointment_Prescriptions (Appointment_Number, DIN, Dose, Instruction, Status) VALUES
(101, '02221853', '10 mg', 'Take 1 capsule daily every morning for hypertension', 'Active'),
(101, '02230713', '20 mg', 'Take 1 tablet at bedtime for hypercholesterolemia', 'Active'),
(102, '02099233', '500 mg', 'Take 1 tablet twice daily with meals for blood glucose control', 'Active'),
(102, '02443937', '10 mg', 'Take 1 tablet every morning', 'Active'),
(103, '02224135', '1 mg', 'Take 1 tablet by mouth once daily; usually continued for 5 years', 'Active'),
(103, '00878928', '5 mg', 'Take 1 tablet daily for blood pressure reduction', 'Active'),
(104, '02247162', '10 mg', 'Take 1 tablet daily in the evening post-PCI', 'Active'),
(106, '02221853', '10 mg', 'Take 1 capsule daily for heart failure and blood pressure control', 'Active'),
(106, '02443937', '10 mg', 'Take 1 tablet every morning', 'Active'),
(107, '02245386', '1-2 inhalations (200/6 mcg)', 'Inhale 1 to 2 times daily as directed; rinse mouth after use', 'Active'),
(107, '02241497', '1-2 puffs (100 mcg each)', 'Inhale as needed for wheeze or shortness of breath; maximum 8 puffs per day', 'Active'),
(108, '02443945', '25 mg', 'Take 1 tablet every morning', 'Active'),
(108, '02099233', '1000 mg (2 x 500 mg)', 'Take 2 tablets twice daily with meals', 'Active'),
(108, '02294338', '10 units', 'Inject under the skin once daily at the same time each day', 'Active'),
(110, '02435381', '2 inhalations (2.5 mcg each)', 'Inhale 2 puffs once daily with the Respimat inhaler', 'Active'),
(110, '02241497', '1-2 puffs (100 mcg each)', 'Inhale as needed for shortness of breath; maximum 8 puffs per day', 'Active');

-- =========================================================================
-- 18. LAB TESTS 
-- =========================================================================
INSERT INTO Lab_Tests (Accession_Number, Test_Date, Test_Result, Status, Appointment_Number, Lab_Assistant_SSN, Test_Name) VALUES
('ACC-2026-0001', '2026-08-11', 158.00, 'Completed', 101, '300000001', 'Systolic Blood Pressure (Clinical)'),
('ACC-2026-0002', '2026-08-11', 4.10, 'Completed', 101, '300000001', 'Low-Density Lipoprotein (LDL-C)'),
('ACC-2026-0003', '2026-08-11', 6.20, 'Completed', 101, '300000002', 'Total Cholesterol'),
('ACC-2026-0004', '2026-08-16', 8.90, 'Completed', 102, '300000002', 'Glycated Hemoglobin (HbA1c)'),
('ACC-2026-0005', '2026-08-16', 9.80, 'Completed', 102, '300000001', 'Fasting Blood Glucose'),
('ACC-2026-0006', '2026-08-21', 62.00, 'Completed', 103, '300000003', 'CA 15-3 (Breast Cancer Marker)'),
('ACC-2026-0007', '2026-08-21', 6.80, 'Completed', 103, '300000002', 'Carcinoembryonic Antigen (CEA)'),
('ACC-2026-0008', '2026-09-06', 4.80, 'Completed', 104, '300000001', 'High-Sensitivity C-Reactive Protein (hs-CRP)'),
('ACC-2026-0009', '2026-09-06', 3.90, 'Completed', 104, '300000002', 'Low-Density Lipoprotein (LDL-C)'),
('ACC-2026-0010', '2026-09-13', 23.40, 'Completed', 105, '300000002', 'Body Mass Index (BMI)'),
('ACC-2026-0011', '2026-09-26', 172.00, 'Completed', 106, '300000001', 'Systolic Blood Pressure (Clinical)'),
('ACC-2026-0012', '2026-09-26', 7.50, 'Completed', 106, '300000003', 'High-Sensitivity C-Reactive Protein (hs-CRP)'),
('ACC-2026-0013', '2026-10-03', 27.80, 'Completed', 107, '300000002', 'Body Mass Index (BMI)'),
('ACC-2026-0014', '2026-10-03', 0.68, 'Completed', 107, '300000002', 'FEV1/FVC Ratio'),
('ACC-2026-0015', '2026-10-03', 78.00, 'Completed', 107, '300000002', 'FEV1 (% Predicted)'),
('ACC-2026-0016', '2026-10-19', 9.50, 'Completed', 108, '300000001', 'Glycated Hemoglobin (HbA1c)'),
('ACC-2026-0017', '2026-10-19', 11.20, 'Completed', 108, '300000002', 'Fasting Blood Glucose'),
('ACC-2026-0018', '2026-10-29', 32.10, 'Completed', 109, '300000002', 'Body Mass Index (BMI)'),
('ACC-2026-0019', '2026-10-29', 18.00, 'Completed', 109, '300000003', 'CA 15-3 (Breast Cancer Marker)'),
('ACC-2026-0020', '2026-11-03', 0.54, 'Completed', 110, '300000003', 'FEV1/FVC Ratio'),
('ACC-2026-0021', '2026-11-03', 42.00, 'Completed', 110, '300000003', 'FEV1 (% Predicted)');

-- =========================================================================
-- 19. PATIENT DIAGNOSES
-- =========================================================================
INSERT INTO Patient_Diagnoses (Patient_SSN, ICD_Code, Diagnosis_Date, Status) VALUES
-- Patient 400000001 (James Wilson): Cardiovascular, multiple conditions -> High Risk
('400000001', 'I10', '2021-03-15', 'Chronic'),
('400000001', 'I25.1', '2023-07-20', 'Chronic'),
('400000001', 'E78.0', '2021-03-15', 'Active'),

-- Patient 400000002 (Arthur Dent): Diabetes & Obesity -> Medium Risk
('400000002', 'E11.9', '2022-05-10', 'Active'),
('400000002', 'E66.0', '2022-05-10', 'Active'),

-- Patient 400000003 (Martha Kent): Breast cancer + Hypertension -> High Risk (cancer)
('400000003', 'C50.9', '2026-08-20', 'Active'),
('400000003', 'I10', '2019-11-02', 'Chronic'),

-- Patient 400000004 (Bruce Wayne): CAD & Family History -> Medium Risk
('400000004', 'I25.1', '2024-02-18', 'Active'),
('400000004', 'Z82.49', '2024-02-18', 'Active'),

-- Patient 400000005 (Diana Prince): Mild Hypercholesterolemia -> Low Risk
('400000005', 'E78.0', '2025-01-10', 'Active'),

-- Patient 400000006 (Clark Kent): Heart Failure + CAD + Hypertension -> High Risk (Care gap: No future appt!)
('400000006', 'I50.9', '2023-11-12', 'Chronic'),
('400000006', 'I25.1', '2022-08-04', 'Chronic'),
('400000006', 'I10', '2021-05-22', 'Chronic'),

-- Patient 400000007 (Peter Parker): Asthma -> Medium Risk (chronic respiratory)
('400000007', 'J45.9', '2023-04-18', 'Chronic'),

-- Patient 400000008 (Tony Stark): Severe T2D + CAD + Hypercholesterolemia -> High Risk (Care gap: No future appt!)
('400000008', 'E11.9', '2019-06-25', 'Chronic'),
('400000008', 'I25.1', '2020-10-14', 'Chronic'),
('400000008', 'E78.0', '2021-02-10', 'Chronic'),

-- Patient 400000009 (Natasha Romanoff): Obesity & Family History of breast cancer -> Low Risk (cancer)
('400000009', 'E66.0', '2024-06-11', 'Active'),
('400000009', 'Z80.3', '2024-06-11', 'Active'),

-- Patient 400000010 (Steve Rogers): COPD + Hypertension -> High Risk (chronic respiratory; Care gap: No future appt!)
('400000010', 'J44.9', '2022-01-08', 'Chronic'),
('400000010', 'I10', '2020-04-19', 'Chronic');

-- =========================================================================
-- 20. TEST THRESHOLD RULES (Associative table linking Test_Type & Medical_Condition)
--     HbA1c >= 6.5 and fasting glucose >= 7.0: Diabetes Canada diagnostic values
--     COPD: post-bronchodilator FEV1/FVC < 0.70 (GOLD); FEV1 < 80% = beyond mild
--     SBP >= 140: Hypertension Canada office treatment threshold
-- =========================================================================
INSERT INTO Test_Threshold_Rules (Test_Name, ICD_Code, Abnormality_Threshold, Operator) VALUES
('Systolic Blood Pressure (Clinical)', 'I10', 140.00, '>='),
('Low-Density Lipoprotein (LDL-C)', 'E78.0', 3.50, '>='),
('Total Cholesterol', 'E78.0', 5.20, '>='),
('Glycated Hemoglobin (HbA1c)', 'E11.9', 6.50, '>='),
('Fasting Blood Glucose', 'E11.9', 7.00, '>='),
('High-Sensitivity C-Reactive Protein (hs-CRP)', 'I25.1', 3.00, '>'),
('Body Mass Index (BMI)', 'E66.0', 30.00, '>='),
('FEV1/FVC Ratio', 'J44.9', 0.70, '<'),
('FEV1 (% Predicted)', 'J44.9', 80.00, '<'),
('FEV1 (% Predicted)', 'J45.9', 80.00, '<'),
('CA 15-3 (Breast Cancer Marker)', 'C50.9', 30.00, '>'),
('Carcinoembryonic Antigen (CEA)', 'C50.9', 5.00, '>'),
('Prostate-Specific Antigen (PSA)', 'C61', 4.00, '>');

-- =========================================================================
-- 21. RISK MODELS 
-- =========================================================================
INSERT INTO Risk_Models (NCD_Name, Effective_Date, Description, Admin_SSN) VALUES
('Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01', 'Quantifies 10-year major adverse cardiovascular event risk using longitudinal clinical diagnoses, blood pressure, and lipid profiles.', '100000001'),
('Metabolic & Type 2 Diabetes Complication Model', '2026-01-01', 'Calculates progressive microvascular and macrovascular triage risk based on glycemic control and comorbid metabolic factors.', '100000001'),
('Cancer Risk Triage Model', '2026-01-01', 'Prioritizes patients for oncology review using cancer diagnoses, family history of cancer, and tumour marker results.', '100000001'),
('Chronic Respiratory Disease Exacerbation Risk Model', '2026-01-01', 'Estimates exacerbation and hospitalization risk for asthma and COPD using diagnoses, spirometry (FEV1, FEV1/FVC) and comorbid conditions.', '100000001');

-- =========================================================================
-- 22. RISK THRESHOLDS (Weak Entity of Risk_Models)
-- =========================================================================
INSERT INTO Risk_Thresholds (NCD_Name, Effective_Date, Risk_Tier, Min_Score, Max_Score) VALUES
-- Cardiovascular Model Tiers
('Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01', 'Low', 0.00, 29.99),
('Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01', 'Medium', 30.00, 59.99),
('Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01', 'High', 60.00, 100.00),

-- Metabolic Model Tiers
('Metabolic & Type 2 Diabetes Complication Model', '2026-01-01', 'Low', 0.00, 24.99),
('Metabolic & Type 2 Diabetes Complication Model', '2026-01-01', 'Medium', 25.00, 54.99),
('Metabolic & Type 2 Diabetes Complication Model', '2026-01-01', 'High', 55.00, 100.00),

-- Cancer Model Tiers
('Cancer Risk Triage Model', '2026-01-01', 'Low', 0.00, 24.99),
('Cancer Risk Triage Model', '2026-01-01', 'Medium', 25.00, 59.99),
('Cancer Risk Triage Model', '2026-01-01', 'High', 60.00, 100.00),

-- Chronic Respiratory Model Tiers
('Chronic Respiratory Disease Exacerbation Risk Model', '2026-01-01', 'Low', 0.00, 29.99),
('Chronic Respiratory Disease Exacerbation Risk Model', '2026-01-01', 'Medium', 30.00, 59.99),
('Chronic Respiratory Disease Exacerbation Risk Model', '2026-01-01', 'High', 60.00, 100.00);

-- =========================================================================
-- 23. RISK MODEL EVALUATIONS (Associative weights between Model & Condition)
-- =========================================================================
INSERT INTO Risk_Model_Evaluations (NCD_Name, Effective_Date, ICD_Code, Risk_Weight) VALUES
-- Weights for Cardiovascular Disease Model
('Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01', 'I10', 25.00),
('Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01', 'I25.1', 40.00),
('Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01', 'I50.9', 45.00),
('Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01', 'E78.0', 15.00),
('Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01', 'Z82.49', 10.00),

-- Weights for Metabolic & Type 2 Diabetes Model
('Metabolic & Type 2 Diabetes Complication Model', '2026-01-01', 'E11.9', 45.00),
('Metabolic & Type 2 Diabetes Complication Model', '2026-01-01', 'E66.0', 20.00),
('Metabolic & Type 2 Diabetes Complication Model', '2026-01-01', 'E78.0', 15.00),
('Metabolic & Type 2 Diabetes Complication Model', '2026-01-01', 'I10', 20.00),

-- Weights for Cancer Risk Triage Model
('Cancer Risk Triage Model', '2026-01-01', 'C50.9', 60.00),
('Cancer Risk Triage Model', '2026-01-01', 'C61', 60.00),
('Cancer Risk Triage Model', '2026-01-01', 'C34.9', 70.00),
('Cancer Risk Triage Model', '2026-01-01', 'C18.9', 55.00),
('Cancer Risk Triage Model', '2026-01-01', 'Z80.3', 20.00),
('Cancer Risk Triage Model', '2026-01-01', 'I10', 10.00),

-- Weights for Chronic Respiratory Disease Model
('Chronic Respiratory Disease Exacerbation Risk Model', '2026-01-01', 'J44.9', 50.00),
('Chronic Respiratory Disease Exacerbation Risk Model', '2026-01-01', 'J45.9', 30.00),
('Chronic Respiratory Disease Exacerbation Risk Model', '2026-01-01', 'I10', 15.00);

-- =========================================================================
-- 24. RISK ASSESSMENTS (Calculated patient risk snapshots)
-- =========================================================================
INSERT INTO Risk_Assessments (Assessment_Number, Assessment_Date, Score, Risk_Level, Patient_SSN, NCD_Name, Effective_Date) VALUES
(501, '2026-08-11 11:00:00', 80.00, 'High', '400000001', 'Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01'),
(502, '2026-08-16 12:30:00', 45.00, 'Medium', '400000002', 'Metabolic & Type 2 Diabetes Complication Model', '2026-01-01'),
(503, '2026-08-21 15:00:00', 70.00, 'High', '400000003', 'Cancer Risk Triage Model', '2026-01-01'),
(504, '2026-09-06 14:00:00', 50.00, 'Medium', '400000004', 'Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01'),
(505, '2026-09-13 10:00:00', 15.00, 'Low', '400000005', 'Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01'),
(506, '2026-09-26 16:30:00', 85.00, 'High', '400000006', 'Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01'),
(507, '2026-10-03 11:30:00', 30.00, 'Medium', '400000007', 'Chronic Respiratory Disease Exacerbation Risk Model', '2026-01-01'),
(508, '2026-10-19 14:00:00', 90.00, 'High', '400000008', 'Metabolic & Type 2 Diabetes Complication Model', '2026-01-01'),
(509, '2026-10-29 10:15:00', 20.00, 'Low', '400000009', 'Cancer Risk Triage Model', '2026-01-01'),
(510, '2026-11-03 16:00:00', 65.00, 'High', '400000010', 'Chronic Respiratory Disease Exacerbation Risk Model', '2026-01-01');

-- =========================================================================
-- 25. NOTIFICATIONS (Weak Entity of Risk_Assessments -> Clinical Provider Alerts)
--     PK is (Assessment_Number, Date_Notified): two alerts for the same
--     assessment need different timestamps, so the second one is 1 minute later.
-- =========================================================================
INSERT INTO Notifications (Assessment_Number, Date_Notified, Recipient_User_SSN, Message) VALUES
(501, '2026-08-11 11:05:00', '200000001', 'CRITICAL ALERT: Patient James Wilson assessed as HIGH risk (Score: 80.00) under Cardiovascular Model. Multidisciplinary care plan review required.'),
(501, '2026-08-11 11:06:00', '100000001', 'PRIORITY TRIAGE: Patient James Wilson requires high-risk care coordination and cardiology follow-up scheduling.'),
(503, '2026-08-21 15:05:00', '200000003', 'CRITICAL ALERT: Patient Martha Kent assessed as HIGH risk (Score: 70.00) under Cancer Risk Triage Model. Oncology treatment plan and hormone therapy review required.'),
(506, '2026-09-26 16:35:00', '200000001', 'CRITICAL ALERT: Patient Clark Kent assessed as HIGH risk (Score: 85.00) following acute cardiovascular episode. Urgent physician follow-up required.'),
(506, '2026-09-26 16:36:00', '100000001', 'CARE GAP NOTICE: Patient Clark Kent flagged HIGH risk with NO upcoming follow-up appointments scheduled.'),
(508, '2026-10-19 14:05:00', '200000002', 'CRITICAL ALERT: Patient Tony Stark assessed as HIGH risk (Score: 90.00) for severe Diabetic and Vascular complications. Urgent follow-up required.'),
(508, '2026-10-19 14:06:00', '100000001', 'CARE GAP NOTICE: Patient Tony Stark has HIGH risk triage level with NO future appointments booked in system.'),
(510, '2026-11-03 16:05:00', '200000004', 'CRITICAL ALERT: Patient Steve Rogers assessed as HIGH risk (Score: 65.00) for chronic respiratory exacerbation. Pulmonary rehabilitation and inhaler therapy review required.'),
(510, '2026-11-03 16:06:00', '100000001', 'CARE GAP NOTICE: Patient Steve Rogers flagged HIGH risk with NO upcoming follow-up appointments scheduled.');

-- =========================================================================
-- END OF DML SEED DATA POPULATION SCRIPT
-- =========================================================================
