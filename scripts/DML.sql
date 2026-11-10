-- =========================================================================
-- Non-Communicable Diseases (NCD) Risk Assessment & Triage Database
-- Data Manipulation Language (DML) - Seed Data Population Script
-- Course: ENSF 608 - Group 6
-- Author: Iesrat Jahan Popy (UCID: 30304908) - Data Population
-- Target Database: NCD_Risk_Identification_System
-- =========================================================================

USE NCD_Risk_Identification_System;

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
('Nephrology', 'South Pavilion - 4th Floor', 'Rockyview General Hospital'),
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
('Nephrology', 'N401', 'Consultation'),
('Nephrology', 'N402', 'Procedure'),
('Respirology & Chest Care', 'R101', 'Consultation'),
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
('200000003', 'EMP-DOC-003', '2016-09-01', 'Active', 'Nephrology'),
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
('200000003', 'CPSA-MD-78103', 'Nephrology & Hypertension', 'MD, FRCPC Nephrology'),
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
('TR-DIA-001', 'Hemodialysis Chronic Maintenance Protocol', 'Dialysis'),
('TR-THE-001', 'Home Continuous Positive Airway Pressure (CPAP) Therapy', 'Therapy'),
('TR-THE-002', 'Comprehensive Diabetic Foot Ulcer Therapy & Wound Care', 'Therapy'),
('TR-SUR-001', 'Percutaneous Coronary Intervention / Angioplasty', 'Surgical'),
('TR-MON-001', 'Ambulatory 24-Hour Blood Pressure Monitoring Protocol', 'Monitoring'),
('TR-MON-002', 'Continuous Glucose Monitoring (CGM) Real-Time Profiling', 'Monitoring');

-- =========================================================================
-- 12. MEDICATIONS (Catalog keyed by 8-digit Canadian DIN)
-- =========================================================================
INSERT INTO Medications (DIN, Generic_Name, Brand_Name) VALUES
('02242518', 'Metformin Hydrochloride', 'Glucophage'),
('02237920', 'Atorvastatin Calcium', 'Lipitor'),
('02244344', 'Ramipril', 'Altace'),
('02247700', 'Amlodipine Besylate', 'Norvasc'),
('02248808', 'Metoprolol Tartrate', 'Lopressor'),
('02324956', 'Empagliflozin', 'Jardiance'),
('02444218', 'Semaglutide', 'Ozempic'),
('02243588', 'Furosemide', 'Lasix'),
('02284725', 'Tiotropium Bromide', 'Spiriva'),
('02231143', 'Aspirin (Acetylsalicylic Acid)', 'Bayer Cardio 81mg');

-- =========================================================================
-- 13. TEST TYPES (Catalog maintained by Clinical/System Admin)
-- =========================================================================
INSERT INTO Test_Types (Test_Name, Min_Range, Max_Range, Admin_SSN) VALUES
('Glycated Hemoglobin (HbA1c)', 4.00, 5.60, '100000001'),
('Fasting Blood Glucose', 3.90, 5.50, '100000001'),
('Total Cholesterol', 3.00, 5.20, '100000001'),
('Low-Density Lipoprotein (LDL-C)', 1.50, 3.40, '100000001'),
('High-Density Lipoprotein (HDL-C)', 1.00, 2.20, '100000001'),
('Serum Creatinine', 50.00, 110.00, '100000001'),
('Estimated Glomerular Filtration Rate (eGFR)', 60.00, 120.00, '100000001'),
('High-Sensitivity C-Reactive Protein (hs-CRP)', 0.00, 3.00, '100000003'),
('Systolic Blood Pressure (Clinical)', 90.00, 120.00, '100000001'),
('Body Mass Index (BMI)', 18.50, 24.90, '100000001');

-- =========================================================================
-- 14. MEDICAL CONDITIONS (Catalog keyed by ICD-10 Code)
-- =========================================================================
INSERT INTO Medical_Conditions (ICD_Code, Condition_Name, Category) VALUES
('I10', 'Essential (Primary) Hypertension', 'Cardiovascular'),
('I25.1', 'Atherosclerotic Heart Disease of Native Coronary Artery', 'Cardiovascular'),
('I50.9', 'Heart Failure, Unspecified', 'Cardiovascular'),
('E11.9', 'Type 2 Diabetes Mellitus without Complications', 'Metabolic'),
('E78.0', 'Pure Hypercholesterolemia', 'Metabolic'),
('E66.0', 'Obesity due to Excess Calories', 'Lifestyle'),
('N18.3', 'Chronic Kidney Disease, Stage 3 (Moderate)', 'Renal'),
('N18.4', 'Chronic Kidney Disease, Stage 4 (Severe)', 'Renal'),
('J44.9', 'Chronic Obstructive Pulmonary Disease (COPD), Unspecified', 'Respiratory'),
('Z82.49', 'Family History of Ischemic Heart Disease and Other Diseases of Circulatory System', 'Family History');

-- =========================================================================
-- 15. APPOINTMENTS (Clinical Consultations & Triage Visits)
-- =========================================================================
INSERT INTO Appointments (Appointment_Number, Appointment_Date, Appointment_Type, Status, Patient_SSN, Doctor_SSN, Admin_SSN, Department_Name, Room_Number) VALUES
(101, '2026-08-10 09:00:00', 'Initial Consultation', 'Completed', '400000001', '200000001', '100000002', 'Cardiology', 'A301'),
(102, '2026-08-15 10:30:00', 'Initial Consultation', 'Completed', '400000002', '200000002', '100000001', 'Endocrinology & Diabetes Clinic', 'B201'),
(103, '2026-08-20 14:00:00', 'Initial Consultation', 'Completed', '400000003', '200000003', '100000001', 'Nephrology', 'N401'),
(104, '2026-09-05 11:00:00', 'Initial Consultation', 'Completed', '400000004', '200000001', '100000002', 'Cardiology', 'A301'),
(105, '2026-09-12 13:30:00', 'Routine Checkup', 'Completed', '400000005', '200000005', '100000001', 'General Internal Medicine', 'S201'),
(106, '2026-09-25 15:00:00', 'Emergency', 'Completed', '400000006', '200000001', '100000002', 'Cardiology', 'A302'),
(107, '2026-10-02 09:30:00', 'Initial Consultation', 'Completed', '400000007', '200000004', '100000001', 'Respirology & Chest Care', 'R101'),
(108, '2026-10-18 10:00:00', 'Follow-Up', 'Completed', '400000008', '200000002', '100000001', 'Endocrinology & Diabetes Clinic', 'B201'),
(109, '2026-10-28 11:30:00', 'Routine Checkup', 'Completed', '400000009', '200000005', '100000001', 'General Internal Medicine', 'S201'),
(110, '2026-11-02 14:30:00', 'Follow-Up', 'Completed', '400000010', '200000003', '100000001', 'Nephrology', 'N401'),
-- Future Scheduled Appointments (for care gap analysis: Patients 400000001 and 400000003 have follow-ups; 400000006 and 400000008 have no future visits!)
(111, '2026-11-20 09:00:00', 'Follow-Up', 'Scheduled', '400000001', '200000001', '100000002', 'Cardiology', 'A301'),
(112, '2026-11-22 10:30:00', 'Follow-Up', 'Scheduled', '400000002', '200000002', '100000001', 'Endocrinology & Diabetes Clinic', 'B201'),
(113, '2026-11-25 13:00:00', 'Follow-Up', 'Scheduled', '400000003', '200000003', '100000001', 'Nephrology', 'N401'),
(114, '2026-12-05 14:00:00', 'Routine Checkup', 'Scheduled', '400000005', '200000005', '100000001', 'General Internal Medicine', 'S201');

-- =========================================================================
-- 16. APPOINTMENT TREATMENTS
-- =========================================================================
INSERT INTO Appointment_Treatments (Appointment_Number, Treatment_Code, Treatment_Date, Status) VALUES
(101, 'TR-LIF-002', '2026-08-10', 'Completed'),
(101, 'TR-MON-001', '2026-08-11', 'Completed'),
(102, 'TR-LIF-001', '2026-08-15', 'Completed'),
(102, 'TR-MON-002', '2026-08-15', 'Completed'),
(103, 'TR-DIA-001', '2026-08-20', 'In Progress'),
(104, 'TR-SUR-001', '2026-09-08', 'Completed'),
(105, 'TR-LIF-001', '2026-09-12', 'Completed'),
(106, 'TR-SUR-001', '2026-09-25', 'Completed'),
(107, 'TR-THE-001', '2026-10-02', 'In Progress'),
(108, 'TR-THE-002', '2026-10-18', 'Completed'),
(110, 'TR-DIA-001', '2026-11-02', 'In Progress'),
(111, 'TR-LIF-002', '2026-11-20', 'Recommended');

-- =========================================================================
-- 17. APPOINTMENT PRESCRIPTIONS
-- =========================================================================
INSERT INTO Appointment_Prescriptions (Appointment_Number, DIN, Dose, Instruction, Status) VALUES
(101, '02244344', '10 mg', 'Take 1 tablet daily every morning for hypertension', 'Active'),
(101, '02237920', '40 mg', 'Take 1 tablet at bedtime for hypercholesterolemia', 'Active'),
(101, '02231143', '81 mg', 'Take 1 tablet daily with food for cardioprotection', 'Active'),
(102, '02242518', '850 mg', 'Take 1 tablet twice daily with meals for blood glucose control', 'Active'),
(102, '02444218', '0.5 mg', 'Inject subcutaneously once weekly', 'Active'),
(103, '02243588', '40 mg', 'Take 1 tablet every morning with fluid restriction', 'Active'),
(103, '02247700', '5 mg', 'Take 1 tablet daily for blood pressure reduction', 'Active'),
(104, '02248808', '50 mg', 'Take 1 tablet twice daily post-PCI', 'Active'),
(104, '02237920', '80 mg', 'Take 1 tablet daily in the evening', 'Active'),
(106, '02248808', '100 mg', 'Take 1 tablet twice daily for acute heart failure control', 'Active'),
(106, '02243588', '80 mg', 'Take 1 tablet daily in morning', 'Active'),
(107, '02284725', '18 mcg', 'Inhale contents of 1 capsule daily using HandiHaler', 'Active'),
(108, '02324956', '25 mg', 'Take 1 tablet every morning', 'Active'),
(108, '02242518', '1000 mg', 'Take 1 tablet twice daily with meals', 'Active'),
(110, '02243588', '40 mg', 'Take 1 tablet daily', 'Active');

-- =========================================================================
-- 18. LAB TESTS
-- =========================================================================
INSERT INTO Lab_Tests (Accession_Number, Test_Date, Test_Result, Status, Appointment_Number, Lab_Assistant_SSN, Test_Name) VALUES
('ACC-2026-0001', '2026-08-11', 158.00, 'Completed', 101, '300000001', 'Systolic Blood Pressure (Clinical)'),
('ACC-2026-0002', '2026-08-11', 4.10, 'Completed', 101, '300000001', 'Low-Density Lipoprotein (LDL-C)'),
('ACC-2026-0003', '2026-08-11', 6.20, 'Completed', 101, '300000002', 'Total Cholesterol'),
('ACC-2026-0004', '2026-08-16', 8.90, 'Completed', 102, '300000002', 'Glycated Hemoglobin (HbA1c)'),
('ACC-2026-0005', '2026-08-16', 9.80, 'Completed', 102, '300000001', 'Fasting Blood Glucose'),
('ACC-2026-0006', '2026-08-21', 240.00, 'Completed', 103, '300000003', 'Serum Creatinine'),
('ACC-2026-0007', '2026-08-21', 24.50, 'Completed', 103, '300000003', 'Estimated Glomerular Filtration Rate (eGFR)'),
('ACC-2026-0008', '2026-09-06', 4.80, 'Completed', 104, '300000001', 'High-Sensitivity C-Reactive Protein (hs-CRP)'),
('ACC-2026-0009', '2026-09-06', 3.90, 'Completed', 104, '300000002', 'Low-Density Lipoprotein (LDL-C)'),
('ACC-2026-0010', '2026-09-13', 23.40, 'Completed', 105, '300000002', 'Body Mass Index (BMI)'),
('ACC-2026-0011', '2026-09-26', 172.00, 'Completed', 106, '300000001', 'Systolic Blood Pressure (Clinical)'),
('ACC-2026-0012', '2026-09-26', 7.50, 'Completed', 106, '300000003', 'High-Sensitivity C-Reactive Protein (hs-CRP)'),
('ACC-2026-0013', '2026-10-03', 27.80, 'Completed', 107, '300000002', 'Body Mass Index (BMI)'),
('ACC-2026-0014', '2026-10-19', 9.50, 'Completed', 108, '300000001', 'Glycated Hemoglobin (HbA1c)'),
('ACC-2026-0015', '2026-10-19', 11.20, 'Completed', 108, '300000002', 'Fasting Blood Glucose'),
('ACC-2026-0016', '2026-11-03', 285.00, 'Completed', 110, '300000003', 'Serum Creatinine'),
('ACC-2026-0017', '2026-11-03', 19.00, 'Completed', 110, '300000003', 'Estimated Glomerular Filtration Rate (eGFR)');

-- =========================================================================
-- 19. PATIENT DIAGNOSES
-- =========================================================================
INSERT INTO Patient_Diagnoses (Patient_SSN, ICD_Code, Diagnosis_Date, Status) VALUES
-- Patient 400000001 (James Wilson): Multiple conditions -> High Risk
('400000001', 'I10', '2021-03-15', 'Chronic'),
('400000001', 'I25.1', '2023-07-20', 'Chronic'),
('400000001', 'E78.0', '2021-03-15', 'Active'),

-- Patient 400000002 (Arthur Dent): Moderate Diabetes & Obesity -> Medium Risk
('400000002', 'E11.9', '2022-05-10', 'Active'),
('400000002', 'E66.0', '2022-05-10', 'Active'),

-- Patient 400000003 (Martha Kent): Severe Renal + Hypertension -> High Risk
('400000003', 'N18.4', '2020-01-14', 'Chronic'),
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

-- Patient 400000007 (Peter Parker): COPD -> Medium Risk
('400000007', 'J44.9', '2023-04-18', 'Chronic'),

-- Patient 400000008 (Tony Stark): Severe T2D + CAD + CKD Stage 3 -> High Risk (Care gap: No future appt!)
('400000008', 'E11.9', '2019-06-25', 'Chronic'),
('400000008', 'I25.1', '2020-10-14', 'Chronic'),
('400000008', 'N18.3', '2022-03-30', 'Chronic'),

-- Patient 400000009 (Natasha Romanoff): Obesity & Family History -> Low Risk
('400000009', 'E66.0', '2024-06-11', 'Active'),
('400000009', 'Z82.49', '2024-06-11', 'Active'),

-- Patient 400000010 (Steve Rogers): Severe CKD + Hypertension -> High Risk
('400000010', 'N18.4', '2022-01-08', 'Chronic'),
('400000010', 'I10', '2020-04-19', 'Chronic');

-- =========================================================================
-- 20. TEST THRESHOLD RULES (Associative table linking Test_Type & Medical_Condition)
-- =========================================================================
INSERT INTO Test_Threshold_Rules (Test_Name, ICD_Code, Abnormality_Threshold, Operator) VALUES
('Systolic Blood Pressure (Clinical)', 'I10', 140.00, '>='),
('Low-Density Lipoprotein (LDL-C)', 'E78.0', 3.50, '>='),
('Total Cholesterol', 'E78.0', 5.20, '>='),
('Glycated Hemoglobin (HbA1c)', 'E11.9', 6.50, '>='),
('Fasting Blood Glucose', 'E11.9', 7.00, '>='),
('Serum Creatinine', 'N18.3', 140.00, '>='),
('Estimated Glomerular Filtration Rate (eGFR)', 'N18.3', 59.00, '<='),
('Estimated Glomerular Filtration Rate (eGFR)', 'N18.4', 29.00, '<='),
('High-Sensitivity C-Reactive Protein (hs-CRP)', 'I25.1', 3.00, '>'),
('Body Mass Index (BMI)', 'E66.0', 30.00, '>=');

-- =========================================================================
-- 21. RISK MODELS (Versioned Target NCD Models)
-- =========================================================================
INSERT INTO Risk_Models (NCD_Name, Effective_Date, Description, Admin_SSN) VALUES
('Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01', 'Quantifies 10-year major adverse cardiovascular event risk using longitudinal clinical diagnoses, blood pressure, and lipid profiles.', '100000001'),
('Metabolic & Type 2 Diabetes Complication Model', '2026-01-01', 'Calculates progressive microvascular and macrovascular triage risk based on glycemic control and comorbid metabolic factors.', '100000001'),
('Chronic Kidney Disease (CKD) Progression Model', '2026-01-01', 'Evaluates rapid renal decline risk and kidney failure progression requiring nephrology specialist escalation.', '100000001');

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

-- Renal CKD Progression Model Tiers
('Chronic Kidney Disease (CKD) Progression Model', '2026-01-01', 'Low', 0.00, 29.99),
('Chronic Kidney Disease (CKD) Progression Model', '2026-01-01', 'Medium', 30.00, 64.99),
('Chronic Kidney Disease (CKD) Progression Model', '2026-01-01', 'High', 65.00, 100.00);

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

-- Weights for Chronic Kidney Disease Progression Model
('Chronic Kidney Disease (CKD) Progression Model', '2026-01-01', 'N18.3', 35.00),
('Chronic Kidney Disease (CKD) Progression Model', '2026-01-01', 'N18.4', 60.00),
('Chronic Kidney Disease (CKD) Progression Model', '2026-01-01', 'I10', 20.00),
('Chronic Kidney Disease (CKD) Progression Model', '2026-01-01', 'E11.9', 25.00);

-- =========================================================================
-- 24. RISK ASSESSMENTS (Calculated patient risk snapshots)
-- =========================================================================
INSERT INTO Risk_Assessments (Assessment_Number, Assessment_Date, Score, Risk_Level, Patient_SSN, NCD_Name, Effective_Date) VALUES
(501, '2026-08-11 11:00:00', 80.00, 'High', '400000001', 'Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01'),
(502, '2026-08-16 12:30:00', 45.00, 'Medium', '400000002', 'Metabolic & Type 2 Diabetes Complication Model', '2026-01-01'),
(503, '2026-08-21 15:00:00', 80.00, 'High', '400000003', 'Chronic Kidney Disease (CKD) Progression Model', '2026-01-01'),
(504, '2026-09-06 14:00:00', 50.00, 'Medium', '400000004', 'Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01'),
(505, '2026-09-13 10:00:00', 15.00, 'Low', '400000005', 'Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01'),
(506, '2026-09-26 16:30:00', 85.00, 'High', '400000006', 'Cardiovascular Disease Risk Model (Framingham-Alberta Adaptation)', '2026-01-01'),
(507, '2026-10-03 11:30:00', 35.00, 'Medium', '400000007', 'Metabolic & Type 2 Diabetes Complication Model', '2026-01-01'),
(508, '2026-10-19 14:00:00', 90.00, 'High', '400000008', 'Metabolic & Type 2 Diabetes Complication Model', '2026-01-01'),
(509, '2026-10-29 10:15:00', 20.00, 'Low', '400000009', 'Metabolic & Type 2 Diabetes Complication Model', '2026-01-01'),
(510, '2026-11-03 16:00:00', 80.00, 'High', '400000010', 'Chronic Kidney Disease (CKD) Progression Model', '2026-01-01');

-- =========================================================================
-- 25. NOTIFICATIONS (Weak Entity of Risk_Assessments -> Clinical Provider Alerts)
-- =========================================================================
INSERT INTO Notifications (Assessment_Number, Date_Notified, Recipient_User_SSN, Message) VALUES
(501, '2026-08-11 11:05:00', '200000001', 'CRITICAL ALERT: Patient James Wilson assessed as HIGH risk (Score: 80.00) under Cardiovascular Model. Multidisciplinary care plan review required.'),
(501, '2026-08-11 11:05:00', '100000001', 'PRIORITY TRIAGE: Patient James Wilson requires high-risk care coordination and cardiology follow-up scheduling.'),
(503, '2026-08-21 15:05:00', '200000003', 'CRITICAL ALERT: Patient Martha Kent assessed as HIGH risk (Score: 80.00) for CKD progression. Stage 4 renal monitoring and hemodialysis review mandated.'),
(506, '2026-09-26 16:35:00', '200000001', 'CRITICAL ALERT: Patient Clark Kent assessed as HIGH risk (Score: 85.00) following acute cardiovascular episode. Urgent physician follow-up required.'),
(506, '2026-09-26 16:35:00', '100000001', 'CARE GAP NOTICE: Patient Clark Kent flagged HIGH risk with NO upcoming follow-up appointments scheduled.'),
(508, '2026-10-19 14:05:00', '200000002', 'CRITICAL ALERT: Patient Tony Stark assessed as HIGH risk (Score: 90.00) for severe Diabetic and Vascular complications. Urgent follow-up required.'),
(508, '2026-10-19 14:05:00', '100000001', 'CARE GAP NOTICE: Patient Tony Stark has HIGH risk triage level with NO future appointments booked in system.'),
(510, '2026-11-03 16:05:00', '200000003', 'CRITICAL ALERT: Patient Steve Rogers assessed as HIGH risk (Score: 80.00) for End-Stage Renal Disease progression.');

-- =========================================================================
-- END OF DML SEED DATA POPULATION SCRIPT
-- =========================================================================
