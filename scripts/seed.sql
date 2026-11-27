-- Database Seed Script
-- NCD Risk Identification and Triage System (ENSF 608 - Group 6)

USE NCD_Risk_Identification_System;

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

-- 1. Facilities
INSERT INTO Facilities (Facility_Name, Facility_Type, Address_Line1, Address_Line2, City, State, Country) VALUES
('Foothills Medical Centre',        'Hospital',          '1403 29 St NW',   'Main Building', 'Calgary', 'Alberta', 'Canada'),
('Peter Lougheed Centre',           'Hospital',          '3500 26 Ave NE',  NULL,            'Calgary', 'Alberta', 'Canada'),
('Rockyview General Hospital',      'Hospital',          '7007 14 St SW',   'West Wing',     'Calgary', 'Alberta', 'Canada'),
('South Health Campus',             'Hospital',          '4448 Front St SE',NULL,            'Calgary', 'Alberta', 'Canada'),
('Sheldon M. Chumir Health Centre', 'Clinic',            '1213 4 St SW',    'Suite 200',     'Calgary', 'Alberta', 'Canada'),
('Calgary Diagnostic Laboratories', 'Diagnostic Center', '1010 8 Ave SW',   'Floor 4',       'Calgary', 'Alberta', 'Canada');

-- 2. Departments
INSERT INTO Departments (Department_Name, Location, Facility_Name) VALUES
('Foothills Cardiology',                  'Specialty Services Bldg, Wing C', 'Foothills Medical Centre'),
('Foothills Endocrinology',               'Main Bldg, 4th Floor',            'Foothills Medical Centre'),
('Foothills Oncology',                    'Arthur J.E. Child Cancer Centre', 'Foothills Medical Centre'),
('Peter Lougheed Pulmonology',            'East Clinic Wing, Floor 3',       'Peter Lougheed Centre'),
('Peter Lougheed Internal Med',           'Ambulatory Wing, Floor 1',        'Peter Lougheed Centre'),
('Rockyview Cardiology',                  'South Wing, 2nd Floor',           'Rockyview General Hospital'),
('South Health Chronic Disease',          'Outpatient Pavilion, Floor 2',    'South Health Campus'),
('Chumir Urgent & Triage Care',           'Ground Level',                    'Sheldon M. Chumir Health Centre'),
('Calgary Central Diagnostics',           'Central Lab Wing, Room 400',      'Calgary Diagnostic Laboratories'),
('Preventive Medicine & Clinical Triage', 'Wing C - 1st Floor',              'Foothills Medical Centre');

-- 3. Rooms
INSERT INTO Rooms (Department_Name, Room_Number, Room_Type) VALUES
('Foothills Cardiology',         'CARD-101', 'Consultation'),
('Foothills Cardiology',         'CARD-102', 'Procedure'),
('Foothills Endocrinology',      'ENDO-201', 'Consultation'),
('Foothills Oncology',           'ONCO-301', 'Consultation'),
('Foothills Oncology',           'ONCO-302', 'Procedure'),
('Peter Lougheed Pulmonology',   'PULM-101', 'Consultation'),
('Peter Lougheed Pulmonology',   'PULM-102', 'Procedure'),
('Peter Lougheed Internal Med',  'IMED-105', 'Consultation'),
('Rockyview Cardiology',         'RCARD-01', 'Consultation'),
('South Health Chronic Disease', 'SHCD-210', 'Consultation'),
('Chumir Urgent & Triage Care',  'TRIAGE-1', 'Consultation'),
('Calgary Central Diagnostics',  'LAB-401',  'Lab'),
('Calgary Central Diagnostics',  'LAB-402',  'Lab');

-- 4. Users
INSERT INTO Users (SSN, First_Name, Last_Name, DOB, Address, Email, Password, Phone_Number, Status) VALUES
('100000001', 'David',    'Vanderberg', '1979-09-25', '452 Crestmont Dr SW, Calgary, AB',   'd.vanderberg@ahs.ca',      '$2y$10$e8T7HkG92kLqAdminClin1', '4035550101', 'Active'),
('100000002', 'Rachel',   'Ngo',        '1990-11-03', '88 University Gate NW, Calgary, AB', 'r.ngo@ahs.ca',             '$2y$10$e8T7HkG92kLqAdminRecep', '4035550102', 'Active'),
('100000003', 'Marcus',   'Brody',      '1985-02-18', '210 Aspen Stone Blvd, Calgary, AB',  'm.brody@ahs.ca',           '$2y$10$e8T7HkG92kLqAdminSys1',  '4035550103', 'Active'),
('200000001', 'Alistair', 'Finch',      '1974-06-15', '512 Rideau Rd SW, Calgary, AB',      'a.finch@ahs.ca',           '$2y$10$docPassHashedFinch01',   '4035550201', 'Active'),
('200000002', 'Elena',    'Rostova',    '1980-08-20', '320 Roxboro Rd SW, Calgary, AB',     'e.rostova@ahs.ca',         '$2y$10$docPassHashedRostova',   '4035550202', 'Active'),
('200000003', 'Kwame',    'Appiah',     '1977-01-30', '744 Elbow Dr SW, Calgary, AB',       'k.appiah@ahs.ca',          '$2y$10$docPassHashedAppiah',    '4035550203', 'Active'),
('200000004', 'Mei-Ling', 'Chen',       '1983-12-05', '118 Varsity Estates, Calgary, AB',   'ml.chen@ahs.ca',           '$2y$10$docPassHashedChen04',    '4035550204', 'Active'),
('200000005', 'Tariq',    'Mansoor',    '1981-05-14', '89 Westwinds Cres NE, Calgary, AB',  't.mansoor@ahs.ca',         '$2y$10$docPassHashedMansoor',   '4035550205', 'Active'),
('200000006', 'Nadia',    'Patel',      '1976-02-11', '310 Sunridge Way NE, Calgary, AB',   'n.patel@ahs.ca',           '$2y$10$docPassHashedPatel06',   '4035550206', 'Active'),
('300000001', 'Priya',    'Sharma',     '1991-03-22', '62 Saddletowne Cir NE, Calgary, AB', 'p.sharma@calgarylab.ca',   '$2y$10$labPassPriya001',        '4035550301', 'Active'),
('300000002', 'Lucas',    'Tremblay',   '1993-07-19', '140 Cranston Way SE, Calgary, AB',   'l.tremblay@calgarylab.ca', '$2y$10$labPassLucas002',        '4035550302', 'Active'),
('300000003', 'Fatima',   'Zahra',      '1988-10-10', '205 Taralake Way NE, Calgary, AB',   'f.zahra@calgarylab.ca',    '$2y$10$labPassFatima03',        '4035550303', 'Active'),
('300000004', 'Owen',     'Mercer',     '1984-05-07', '95 Martindale Blvd NE, Calgary, AB', 'o.mercer@calgarylab.ca',   '$2y$10$labPassOwen0004',        '4035550304', 'Inactive'),
('400000001', 'Arthur',   'Pendleton',  '1955-03-14', '814 1st Ave NW, Calgary, AB',        'arthur.pendleton@shaw.ca', '$2y$10$ptAuthPendleton1',       '4035550401', 'Active'),
('400000002', 'Beatrice', 'Gomez',      '1962-07-29', '302 Shawville Blvd SE, Calgary, AB', 'bgomez62@telus.net',       '$2y$10$ptAuthGomez0002',        '4035550402', 'Active'),
('400000003', 'Chloe',    'Desjardins', '1978-11-12', '1520 14th Ave SW, Calgary, AB',      'chloe.desj@gmail.com',     '$2y$10$ptAuthDesjardins',       '4035550403', 'Active'),
('400000004', 'Devon',    'Blackwood',  '1949-05-03', '904 Heritage Dr SW, Calgary, AB',    'dblackwood49@gmail.com',   '$2y$10$ptAuthBlackwood4',       '4035550404', 'Active'),
('400000005', 'Evelyn',   'Kowalski',   '1968-09-17', '44 Huntington Park Green, Calgary',  'ekowalski@shaw.ca',        '$2y$10$ptAuthKowalski05',       '4035550405', 'Active'),
('400000006', 'Farhan',   'Qureshi',    '1973-01-25', '112 Falconridge Dr NE, Calgary, AB', 'farhan.q@hotmail.com',     '$2y$10$ptAuthQureshi006',       '4035550406', 'Active'),
('400000007', 'Grace',    'MacDonald',  '1985-06-30', '65 Citadel Meadow Close, Calgary',   'grace.macd@gmail.com',     '$2y$10$ptAuthMacDonald7',       '4035550407', 'Active'),
('400000008', 'Harold',   'Zimmerman',  '1952-12-08', '212 Signal Hill Pt SW, Calgary',     'h.zimmerman@telus.net',    '$2y$10$ptAuthZimmerman8',       '4035550408', 'Active'),
('400000009', 'Irene',    'O\'Connor',  '1960-04-02', '78 Bridlewood Way SW, Calgary, AB',  'irene.oc@shaw.ca',         '$2y$10$ptAuthOConnor009',       '4035550409', 'Active'),
('400000010', 'Jamal',    'Hussein',    '1992-08-14', '55 Castleridge Way NE, Calgary, AB', 'jamal.h92@gmail.com',      '$2y$10$ptAuthHussein010',       '4035550410', 'Active'),
('400000011', 'Clara',    'Benson',     '1958-11-21', '18 Tuscany Valley Rd NW, Calgary',   'c.benson58@telus.net',     '$2y$10$ptAuthBenson011',        '4035550411', 'Inactive'),
('400000012', 'Walter',   'Houghton',   '1944-01-09', '610 Elbow Dr SW, Calgary, AB',       'w.houghton44@shaw.ca',     '$2y$10$ptAuthHoughton12',       '4035550412', 'Suspended');

-- 5. Patients
INSERT INTO Patients (SSN, Healthcare_Number, Gender, Blood_Type, Status) VALUES
('400000001', 'AB-904812301', 'Male',   'O+',  'Active'),
('400000002', 'AB-904812302', 'Female', 'A+',  'Active'),
('400000003', 'AB-904812303', 'Female', 'B-',  'Active'),
('400000004', 'AB-904812304', 'Male',   'A-',  'Active'),
('400000005', 'AB-904812305', 'Female', 'O-',  'Active'),
('400000006', 'AB-904812306', 'Male',   'AB+', 'Active'),
('400000007', 'AB-904812307', 'Female', 'A+',  'Active'),
('400000008', 'AB-904812308', 'Male',   'B+',  'Active'),
('400000009', 'AB-904812309', 'Female', 'O+',  'Active'),
('400000010', 'AB-904812310', 'Male',   'AB-', 'Active'),
('400000011', 'AB-904812311', 'Female', 'A+',  'Inactive'),
('400000012', 'AB-904812312', 'Male',   'O-',  'Deceased');

-- 6. Patient Emergency Contacts
INSERT INTO Patient_Emergency_Contacts (Patient_SSN, Contact_Name, Contact_Phone_Number) VALUES
('400000001', 'Mary Pendleton',    '4035558801'),
('400000001', 'Mary Pendleton',    '4035558899'),
('400000002', 'Carlos Gomez',      '4035558802'),
('400000002', 'Elena Gomez',       '4035558802'),
('400000003', 'Marc Desjardins',   '4035558803'),
('400000004', 'Judith Blackwood',  '4035558804'),
('400000005', 'Stan Kowalski',     '4035558805'),
('400000006', 'Amina Qureshi',     '4035558806'),
('400000007', 'Colin MacDonald',   '4035558807'),
('400000008', 'Ruth Zimmerman',    '4035558808'),
('400000009', 'Patrick O\'Connor', '4035558809'),
('400000010', 'Yasmin Hussein',    '4035558810'),
('400000011', 'Thomas Benson',     '4035558811');

-- 7. Health Professionals
INSERT INTO Health_Professionals (SSN, Employee_Number, Employment_Date, Status, Department_Name) VALUES
('200000001', 'EMP-CARD-001', '2010-07-01', 'Active',     'Foothills Cardiology'),
('200000002', 'EMP-ENDO-002', '2014-01-15', 'Active',     'Foothills Endocrinology'),
('200000003', 'EMP-ONCO-003', '2012-09-01', 'Active',     'Foothills Oncology'),
('200000004', 'EMP-PULM-004', '2018-04-10', 'Active',     'Peter Lougheed Pulmonology'),
('200000005', 'EMP-IMED-005', '2016-11-20', 'Active',     'Peter Lougheed Internal Med'),
('200000006', 'EMP-CARD-006', '2015-03-01', 'On Leave',   'Foothills Cardiology'),
('300000001', 'EMP-LAB-101',  '2019-02-01', 'Active',     'Calgary Central Diagnostics'),
('300000002', 'EMP-LAB-102',  '2021-06-15', 'Active',     'Calgary Central Diagnostics'),
('300000003', 'EMP-LAB-103',  '2017-08-25', 'Active',     'Calgary Central Diagnostics'),
('300000004', 'EMP-LAB-104',  '2016-05-10', 'Terminated', 'Calgary Central Diagnostics');

-- 8. Doctors
INSERT INTO Doctors (SSN, License_Number, Speciality, Qualification) VALUES
('200000001', 'CPSA-MD-11820', 'Cardiology',        'MD, FRCPC (Cardiovascular Disease)'),
('200000002', 'CPSA-MD-14592', 'Endocrinology',     'MD, FRCPC (Endocrinology & Metabolism)'),
('200000003', 'CPSA-MD-09841', 'Medical Oncology',  'MBChB, FRCPC (Medical Oncology)'),
('200000004', 'CPSA-MD-22019', 'Respirology',       'MD, FRCPC (Adult Respirology)'),
('200000005', 'CPSA-MD-17844', 'Internal Medicine', 'MD, FACP, FRCPC (General Internal Medicine)'),
('200000006', 'CPSA-MD-30112', 'Cardiology',        'MD, FRCPC (Preventive Cardiology)');

-- 9. Lab Assistants
INSERT INTO Lab_Assistants (SSN, Certification_Number, Certification_Type, Lab_Specialization) VALUES
('300000001', 'CSMLS-MLT-88201', 'CSMLS Registered MLT', 'Clinical Biochemistry & Lipid Panels'),
('300000002', 'CSMLS-MLT-90412', 'CSMLS Registered MLT', 'Pulmonary Function & Blood Gas Analysis'),
('300000003', 'CSMLS-MLT-76344', 'CSMLS Registered MLT', 'Oncology Biomarkers & Immunoassays'),
('300000004', 'CSMLS-MLT-99104', 'CSMLS Registered MLT', 'Hematology & Routine Urinalysis');

-- 10. Admins
INSERT INTO Admins (SSN, Role, IsActive, Department_Name) VALUES
('100000001', 'Clinical Admin', TRUE, 'Preventive Medicine & Clinical Triage'),
('100000002', 'Receptionist',   TRUE, 'Preventive Medicine & Clinical Triage'),
('100000003', 'System Admin',   TRUE, 'Preventive Medicine & Clinical Triage');

-- 11. Treatment Types
INSERT INTO Treatment_Types (Treatment_Code, Treatment_Name, Treatment_Category) VALUES
('TX-LFS-01', 'Medical Nutrition Therapy & Low-Sodium Diet',   'Lifestyle Intervention'),
('TX-LFS-02', 'Structured Smoking Cessation Counseling',       'Lifestyle Intervention'),
('TX-LFS-03', 'Supervised Exercise & Cardiac Rehab Plan',      'Lifestyle Intervention'),
('TX-THP-01', 'Pulmonary Rehabilitation & Breathing Therapy',  'Therapy'),
('TX-THP-02', 'Targeted Systemic Chemotherapy',                'Therapy'),
('TX-THP-03', 'Adjuvant Radiation Therapy',                    'Therapy'),
('TX-THP-04', 'Inhaler Therapy Initiation & Technique Review', 'Therapy'),
('TX-SRG-01', 'Percutaneous Coronary Intervention (Stent)',    'Surgical'),
('TX-SRG-02', 'Oncological Tumor Resection Surgery',           'Surgical'),
('TX-DIA-01', 'Supportive Renal Replacement Dialysis',         'Dialysis'),
('TX-MON-01', 'Continuous Ambulatory Blood Pressure Mon.',     'Monitoring'),
('TX-MON-02', 'Continuous Glucose Monitoring (CGM) Review',    'Monitoring'),
('TX-MON-03', 'Serial Low-Dose CT Oncology Surveillance',      'Monitoring'),
('TX-MON-04', 'Spirometry & Pulmonary Function Monitoring',    'Monitoring');

-- 12. Medications
INSERT INTO Medications (DIN, Generic_Name, Brand_Name) VALUES
('02099233', 'Metformin hydrochloride 500 mg',               'Glucophage'),
('02443937', 'Empagliflozin 10 mg',                          'Jardiance'),
('02294338', 'Insulin glargine 100 units/mL (SoloStar pen)', 'Lantus'),
('02221853', 'Ramipril 10 mg',                               'Altace'),
('02230713', 'Atorvastatin calcium 20 mg',                   'Lipitor'),
('02247162', 'Rosuvastatin calcium 10 mg',                   'Crestor'),
('00878928', 'Amlodipine besylate 5 mg',                     'Norvasc'),
('02241497', 'Salbutamol sulfate 100 mcg/actuation inhaler', 'Ventolin HFA'),
('02245386', 'Budesonide/formoterol 200/6 mcg inhalation',   'Symbicort'),
('02435381', 'Tiotropium 2.5 mcg/actuation inhalation',      'Spiriva Respimat'),
('02404589', 'Capecitabine 500 mg',                          'Xeloda'),
('02048483', 'Tamoxifen citrate 20 mg',                      'Nolvadex-D');

-- 13. Test Types
INSERT INTO Test_Types (Test_Name, Min_Range, Max_Range, Admin_SSN) VALUES
('Systolic Blood Pressure',                     90.00, 120.00, '100000001'),
('Diastolic Blood Pressure',                    60.00,  80.00, '100000001'),
('Low-Density Lipoprotein (LDL-C)',              1.50,   3.30, '100000001'),
('High-Density Lipoprotein (HDL-C)',             1.00,   2.20, '100000001'),
('Total Cholesterol',                            3.00,   5.20, '100000001'),
('High-Sensitivity C-Reactive Protein (hs-CRP)', 0.00,   3.00, '100000001'),
('Fasting Blood Glucose',                        3.90,   5.60, '100000001'),
('Hemoglobin A1c (HbA1c)',                       4.00,   5.60, '100000001'),
('Body Mass Index (BMI)',                       18.50,  24.90, '100000001'),
('FEV1/FVC Ratio',                               0.70,   0.85, '100000001'),
('FEV1 (% Predicted)',                          80.00, 120.00, '100000001'),
('Carcinoembryonic Antigen (CEA)',               0.00,   3.00, '100000001'),
('Prostate-Specific Antigen (PSA)',              0.00,   4.00, '100000001'),
('CA 19-9 Tumor Antigen',                        0.00,  37.00, '100000001');

-- 14. Medical Conditions (ICD-10)
INSERT INTO Medical_Conditions (ICD_Code, Condition_Name, Category) VALUES
('I10',    'Essential (Primary) Hypertension',                          'Cardiovascular'),
('I25.10', 'Atherosclerotic Heart Disease of Native Coronary Artery',   'Cardiovascular'),
('I48.91', 'Unspecified Atrial Fibrillation',                           'Cardiovascular'),
('I50.9',  'Heart Failure, Unspecified',                                'Cardiovascular'),
('C34.90', 'Malignant Neoplasm of Bronchus and Lung',                   'Oncological'),
('C18.9',  'Malignant Neoplasm of Colon, Unspecified',                  'Oncological'),
('C50.91', 'Malignant Neoplasm of Breast, Unspecified',                 'Oncological'),
('E11.9',  'Type 2 Diabetes Mellitus without Complications',            'Metabolic'),
('E78.5',  'Hyperlipidemia, Unspecified',                               'Metabolic'),
('E66.9',  'Obesity, Unspecified',                                      'Metabolic'),
('J44.9',  'Chronic Obstructive Pulmonary Disease (COPD), Unspecified', 'Respiratory'),
('J45.90', 'Unspecified Asthma, Uncomplicated',                         'Respiratory'),
('Z72.0',  'Tobacco Use (Current Cigarette Smoker)',                    'Lifestyle'),
('Z72.3',  'Lack of Physical Exercise (Sedentary Lifestyle)',           'Lifestyle'),
('Z72.4',  'Inappropriate Diet and Eating Habits',                      'Lifestyle'),
('Z82.49', 'Family History of Ischemic Heart Disease',                  'Family History'),
('Z83.3',  'Family History of Diabetes Mellitus',                       'Family History'),
('Z80.9',  'Family History of Malignant Neoplasm (Cancer)',             'Family History'),
('Z82.3',  'Family History of Stroke / Cerebrovascular Disease',        'Family History');

-- 15. Test Threshold Rules
INSERT INTO Test_Threshold_Rules (Test_Name, ICD_Code, Abnormality_Threshold, Operator) VALUES
('Systolic Blood Pressure',                      'I10',    130.00, '>='),
('Diastolic Blood Pressure',                     'I10',     85.00, '>='),
('Low-Density Lipoprotein (LDL-C)',              'E78.5',    3.40, '>='),
('Total Cholesterol',                            'E78.5',    5.20, '>='),
('High-Sensitivity C-Reactive Protein (hs-CRP)', 'I25.10',   3.00, '>'),
('Hemoglobin A1c (HbA1c)',                       'E11.9',    6.50, '>='),
('Fasting Blood Glucose',                        'E11.9',    7.00, '>='),
('Body Mass Index (BMI)',                        'E66.9',   30.00, '>='),
('FEV1/FVC Ratio',                               'J44.9',    0.70, '<'),
('FEV1 (% Predicted)',                           'J44.9',   80.00, '<'),
('FEV1 (% Predicted)',                           'J45.90',  80.00, '<'),
('Carcinoembryonic Antigen (CEA)',               'C18.9',    5.00, '>='),
('Carcinoembryonic Antigen (CEA)',               'C34.90',   5.00, '>='),
('CA 19-9 Tumor Antigen',                        'C18.9',   37.00, '>');

-- 16. Risk Models
INSERT INTO Risk_Models (NCD_Name, Effective_Date, Description, Admin_SSN) VALUES
('Cardiovascular Disease',      '2025-01-01', 'Previous 2025 heart disease model before 2026 weight update.', '100000001'),
('Cardiovascular Disease',      '2026-01-01', 'Scores heart disease risk using blood pressure, cholesterol, smoking, and family history.', '100000001'),
('Cardiovascular Disease',      '2027-01-01', 'Upcoming 2027 heart disease model with updated hypertension weight.', '100000001'),
('Cancer',                      '2026-01-01', 'Scores cancer risk based on cancer diagnoses, smoking, and family history.', '100000001'),
('Type 2 Diabetes',             '2026-01-01', 'Scores diabetes risk using diabetes diagnosis, obesity, diet, exercise, and family history.', '100000001'),
('Type 2 Diabetes',             '2027-01-01', 'Draft 2027 diabetes pilot model (pending clinical approval).', '100000001'),
('Chronic Respiratory Disease', '2026-01-01', 'Scores lung disease risk based on COPD, asthma, and smoking history.', '100000001');

-- 17. Risk Thresholds
INSERT INTO Risk_Thresholds (NCD_Name, Effective_Date, Risk_Tier, Min_Score, Max_Score) VALUES
('Cardiovascular Disease',      '2025-01-01', 'Low',     0.00,  30.00),
('Cardiovascular Disease',      '2025-01-01', 'Medium', 30.01,  65.00),
('Cardiovascular Disease',      '2025-01-01', 'High',   65.01, 100.00),

('Cardiovascular Disease',      '2026-01-01', 'Low',     0.00,  30.00),
('Cardiovascular Disease',      '2026-01-01', 'Medium', 30.01,  65.00),
('Cardiovascular Disease',      '2026-01-01', 'High',   65.01, 100.00),

('Cardiovascular Disease',      '2027-01-01', 'Low',     0.00,  30.00),
('Cardiovascular Disease',      '2027-01-01', 'Medium', 30.01,  65.00),
('Cardiovascular Disease',      '2027-01-01', 'High',   65.01, 100.00),

('Cancer',                      '2026-01-01', 'Low',     0.00,  20.00),
('Cancer',                      '2026-01-01', 'Medium', 20.01,  55.00),
('Cancer',                      '2026-01-01', 'High',   55.01, 100.00),

('Type 2 Diabetes',             '2026-01-01', 'Low',     0.00,  25.00),
('Type 2 Diabetes',             '2026-01-01', 'Medium', 25.01,  55.00),
('Type 2 Diabetes',             '2026-01-01', 'High',   55.01, 100.00),

('Type 2 Diabetes',             '2027-01-01', 'Low',     0.00,  25.00),
('Type 2 Diabetes',             '2027-01-01', 'Medium', 25.01,  55.00),
('Type 2 Diabetes',             '2027-01-01', 'High',   55.01, 100.00),

('Chronic Respiratory Disease', '2026-01-01', 'Low',     0.00,  25.00),
('Chronic Respiratory Disease', '2026-01-01', 'Medium', 25.01,  60.00),
('Chronic Respiratory Disease', '2026-01-01', 'High',   60.01, 100.00);

-- 18. Risk Model Evaluations
INSERT INTO Risk_Model_Evaluations (NCD_Name, Effective_Date, ICD_Code, Risk_Weight) VALUES
('Cardiovascular Disease', '2025-01-01', 'I10',    20.00),
('Cardiovascular Disease', '2025-01-01', 'I25.10', 35.00),
('Cardiovascular Disease', '2025-01-01', 'E78.5',  20.00),
('Cardiovascular Disease', '2025-01-01', 'Z72.0',  20.00),
('Cardiovascular Disease', '2025-01-01', 'Z82.49', 15.00),
('Cardiovascular Disease', '2025-01-01', 'E66.9',  10.00),

('Cardiovascular Disease', '2026-01-01', 'I10',    25.00),
('Cardiovascular Disease', '2026-01-01', 'I25.10', 35.00),
('Cardiovascular Disease', '2026-01-01', 'E78.5',  20.00),
('Cardiovascular Disease', '2026-01-01', 'Z72.0',  20.00),
('Cardiovascular Disease', '2026-01-01', 'Z82.49', 15.00),
('Cardiovascular Disease', '2026-01-01', 'E66.9',  10.00),

('Cardiovascular Disease', '2027-01-01', 'I10',    30.00),
('Cardiovascular Disease', '2027-01-01', 'I25.10', 35.00),
('Cardiovascular Disease', '2027-01-01', 'E78.5',  20.00),
('Cardiovascular Disease', '2027-01-01', 'Z72.0',  20.00),
('Cardiovascular Disease', '2027-01-01', 'Z82.49', 15.00),
('Cardiovascular Disease', '2027-01-01', 'E66.9',  10.00),

('Cancer', '2026-01-01', 'C34.90', 50.00),
('Cancer', '2026-01-01', 'C18.9',  45.00),
('Cancer', '2026-01-01', 'C50.91', 45.00),
('Cancer', '2026-01-01', 'Z72.0',  25.00),
('Cancer', '2026-01-01', 'Z80.9',  25.00),

('Type 2 Diabetes', '2026-01-01', 'E11.9',  40.00),
('Type 2 Diabetes', '2026-01-01', 'E66.9',  25.00),
('Type 2 Diabetes', '2026-01-01', 'Z72.3',  15.00),
('Type 2 Diabetes', '2026-01-01', 'Z72.4',  10.00),
('Type 2 Diabetes', '2026-01-01', 'Z83.3',  20.00),
('Type 2 Diabetes', '2026-01-01', 'I10',    15.00),

('Type 2 Diabetes', '2027-01-01', 'E11.9',  45.00),
('Type 2 Diabetes', '2027-01-01', 'E66.9',  25.00),
('Type 2 Diabetes', '2027-01-01', 'Z72.3',  15.00),
('Type 2 Diabetes', '2027-01-01', 'Z72.4',  10.00),
('Type 2 Diabetes', '2027-01-01', 'Z83.3',  20.00),
('Type 2 Diabetes', '2027-01-01', 'I10',    15.00),

('Chronic Respiratory Disease', '2026-01-01', 'J44.9',  50.00),
('Chronic Respiratory Disease', '2026-01-01', 'Z72.0',  35.00),
('Chronic Respiratory Disease', '2026-01-01', 'J45.90', 20.00);

-- 19. Appointments (400000003 and 400000005 intentionally have no future appointments for care-gap testing)
INSERT INTO Appointments (Appointment_Number, Appointment_Date, Appointment_Type, Status, Patient_SSN, Doctor_SSN, Admin_SSN, Department_Name, Room_Number) VALUES
(1001, '2026-09-10 09:00:00', 'Initial Consultation', 'Completed', '400000001', '200000001', '100000002', 'Foothills Cardiology',        'CARD-101'),
(1002, '2026-09-12 10:30:00', 'Initial Consultation', 'Completed', '400000002', '200000002', '100000002', 'Foothills Endocrinology',     'ENDO-201'),
(1003, '2026-09-15 14:00:00', 'Initial Consultation', 'Completed', '400000003', '200000004', '100000002', 'Peter Lougheed Pulmonology',  'PULM-101'),
(1004, '2026-09-18 11:15:00', 'Initial Consultation', 'Completed', '400000004', '200000003', '100000002', 'Foothills Oncology',          'ONCO-301'),
(1005, '2026-09-22 13:00:00', 'Initial Consultation', 'Completed', '400000005', '200000001', '100000002', 'Foothills Cardiology',        'CARD-101'),
(1006, '2026-10-05 09:30:00', 'Follow-Up',            'Completed', '400000001', '200000001', '100000002', 'Foothills Cardiology',        'CARD-101'),
(1007, '2026-10-08 11:00:00', 'Follow-Up',            'Completed', '400000002', '200000002', '100000002', 'Foothills Endocrinology',     'ENDO-201'),
(1008, '2026-10-15 15:30:00', 'Routine Checkup',      'Completed', '400000006', '200000005', '100000002', 'Peter Lougheed Internal Med', 'IMED-105'),
(1009, '2026-10-20 10:00:00', 'Routine Checkup',      'Completed', '400000008', '200000002', '100000002', 'Foothills Endocrinology',     'ENDO-201'),
(1010, '2026-10-25 14:00:00', 'Routine Checkup',      'Completed', '400000009', '200000003', '100000002', 'Foothills Oncology',          'ONCO-301'),
(1011, '2026-11-28 10:00:00', 'Follow-Up',            'Scheduled', '400000001', '200000001', '100000002', 'Foothills Cardiology',        'CARD-101'),
(1012, '2026-12-01 14:00:00', 'Follow-Up',            'Scheduled', '400000002', '200000002', '100000002', 'Foothills Endocrinology',     'ENDO-201'),
(1013, '2026-12-03 10:00:00', 'Follow-Up',            'Scheduled', '400000004', '200000003', '100000002', 'Foothills Oncology',          'ONCO-301'),
(1014, '2026-12-08 11:30:00', 'Routine Checkup',      'Scheduled', '400000007', '200000005', '100000002', 'Peter Lougheed Internal Med', 'IMED-105'),
(1015, '2026-10-26 16:45:00', 'Emergency',            'Completed', '400000006', '200000001', '100000002', 'Foothills Cardiology',        'CARD-102'),
(1016, '2026-10-28 09:00:00', 'Follow-Up',            'Cancelled', '400000008', '200000002', '100000002', 'Foothills Endocrinology',     'ENDO-201'),
(1017, '2026-10-30 13:15:00', 'Routine Checkup',      'No-Show',   '400000011', '200000005', '100000002', 'Peter Lougheed Internal Med', 'IMED-105'),
(1018, '2026-08-05 09:00:00', 'Initial Consultation', 'Completed', '400000012', '200000001', '100000002', 'Foothills Cardiology',        'CARD-101'),
(1019, '2026-10-20 09:30:00', 'Initial Consultation', 'Completed', '400000007', '200000002', '100000002', 'Foothills Endocrinology',     'ENDO-201'),
(1020, '2026-10-22 10:00:00', 'Routine Checkup',      'Completed', '400000010', '200000005', '100000002', 'Peter Lougheed Internal Med', 'IMED-105');

-- 20. Appointment Treatments
INSERT INTO Appointment_Treatments (Appointment_Number, Treatment_Code, Treatment_Date, Status) VALUES
(1001, 'TX-LFS-01', '2026-09-10', 'Completed'),
(1001, 'TX-LFS-03', '2026-09-10', 'In Progress'),
(1002, 'TX-LFS-01', '2026-09-12', 'In Progress'),
(1002, 'TX-MON-02', '2026-09-12', 'Completed'),
(1003, 'TX-LFS-02', '2026-09-15', 'In Progress'),
(1003, 'TX-THP-01', '2026-09-15', 'In Progress'),
(1003, 'TX-THP-04', '2026-09-15', 'Completed'),
(1003, 'TX-MON-04', '2026-09-15', 'Completed'),
(1004, 'TX-SRG-02', '2026-09-18', 'Completed'),
(1004, 'TX-THP-02', '2026-09-25', 'In Progress'),
(1004, 'TX-MON-03', '2026-09-18', 'In Progress'),
(1005, 'TX-LFS-01', '2026-09-22', 'Recommended'),
(1005, 'TX-LFS-02', '2026-09-22', 'Recommended'),
(1006, 'TX-MON-01', '2026-10-05', 'Completed'),
(1010, 'TX-MON-03', '2026-10-25', 'Recommended'),
(1016, 'TX-MON-02', '2026-10-28', 'Cancelled'),
(1019, 'TX-LFS-01', '2026-10-20', 'In Progress'),
(1020, 'TX-LFS-01', '2026-10-22', 'Completed');

-- 21. Appointment Prescriptions
INSERT INTO Appointment_Prescriptions (Appointment_Number, DIN, Dose, Instruction, Status) VALUES
(1001, '02221853', '10 mg',    'Take 1 capsule daily by mouth in the morning',        'Active'),
(1001, '02230713', '20 mg',    'Take 1 tablet daily by mouth at bedtime',             'Active'),
(1002, '02099233', '500 mg',   'Take 1 tablet twice daily with meals',                'Active'),
(1002, '02443937', '10 mg',    'Take 1 tablet once daily in the morning',             'Active'),
(1003, '02241497', '100 mcg',  'Inhale 2 puffs every 4 to 6 hours as needed',         'Active'),
(1003, '02435381', '2.5 mcg',  'Inhale 2 puffs once daily every morning',             'Active'),
(1004, '02404589', '500 mg',   'Take orally twice daily for 14 days of 21-day cycle', 'Active'),
(1005, '02221853', '10 mg',    'Take 1 capsule daily by mouth in the morning',        'Active'),
(1005, '02247162', '10 mg',    'Take 1 tablet daily at bedtime',                      'Active'),
(1006, '00878928', '5 mg',     'Take 1 tablet once daily in the morning',             'Active'),
(1007, '02294338', '10 units', 'Inject subcutaneously once daily at bedtime',         'Active'),
(1009, '02099233', '500 mg',   'Take 1 tablet once daily with dinner',                'Active'),
(1009, '02443937', '10 mg',    'Discontinued due to mild dizziness',                  'Discontinued'),
(1015, '02221853', '10 mg',    'Administered in urgent care',                         'Completed');

-- 22. Lab Tests
INSERT INTO Lab_Tests (Accession_Number, Test_Date, Test_Result, Status, Appointment_Number, Lab_Assistant_SSN, Test_Name) VALUES
('ACC-2026-001', '2026-09-10', 148.00, 'Completed',   1001, '300000001', 'Systolic Blood Pressure'),
('ACC-2026-002', '2026-09-10',  92.00, 'Completed',   1001, '300000001', 'Diastolic Blood Pressure'),
('ACC-2026-003', '2026-09-10',   4.10, 'Completed',   1001, '300000001', 'Low-Density Lipoprotein (LDL-C)'),
('ACC-2026-004', '2026-09-10',   4.60, 'Completed',   1001, '300000001', 'High-Sensitivity C-Reactive Protein (hs-CRP)'),
('ACC-2026-005', '2026-09-12',   8.20, 'Completed',   1002, '300000001', 'Hemoglobin A1c (HbA1c)'),
('ACC-2026-006', '2026-09-12',   9.60, 'Completed',   1002, '300000001', 'Fasting Blood Glucose'),
('ACC-2026-007', '2026-09-12',  32.40, 'Completed',   1002, '300000001', 'Body Mass Index (BMI)'),
('ACC-2026-008', '2026-09-15',   0.64, 'Completed',   1003, '300000002', 'FEV1/FVC Ratio'),
('ACC-2026-009', '2026-09-15',  58.00, 'Completed',   1003, '300000002', 'FEV1 (% Predicted)'),
('ACC-2026-010', '2026-09-18',  14.80, 'Completed',   1004, '300000003', 'Carcinoembryonic Antigen (CEA)'),
('ACC-2026-011', '2026-09-18',  68.50, 'Completed',   1004, '300000003', 'CA 19-9 Tumor Antigen'),
('ACC-2026-012', '2026-09-22', 142.00, 'Completed',   1005, '300000001', 'Systolic Blood Pressure'),
('ACC-2026-013', '2026-09-22',   5.90, 'Completed',   1005, '300000001', 'Total Cholesterol'),
('ACC-2026-104', '2026-10-05', 128.00, 'Completed',   1006, '300000001', 'Systolic Blood Pressure'),
('ACC-2026-015', '2026-10-08',   7.10, 'Completed',   1007, '300000001', 'Hemoglobin A1c (HbA1c)'),
('ACC-2026-016', '2026-10-15',   5.10, 'Completed',   1008, '300000001', 'Fasting Blood Glucose'),
('ACC-2026-017', '2026-10-20',   6.40, 'Completed',   1009, '300000001', 'Hemoglobin A1c (HbA1c)'),
('ACC-2026-018', '2026-10-25',   2.10, 'Completed',   1010, '300000003', 'Carcinoembryonic Antigen (CEA)'),
('ACC-2026-019', '2026-11-28',   NULL, 'Ordered',     1011, '300000001', 'Low-Density Lipoprotein (LDL-C)'),
('ACC-2026-020', '2026-12-01',   NULL, 'In Progress', 1012, '300000001', 'Hemoglobin A1c (HbA1c)'),
('ACC-2026-021', '2026-10-28',   NULL, 'Cancelled',   1016, '300000001', 'Fasting Blood Glucose'),
('ACC-2026-022', '2026-10-20',   5.50, 'Completed',   1019, '300000001', 'Hemoglobin A1c (HbA1c)'),
('ACC-2026-023', '2026-10-22',   5.20, 'Completed',   1020, '300000001', 'Hemoglobin A1c (HbA1c)'),
('ACC-2026-024', '2026-10-20',   6.80, 'Completed',   1009, '300000001', 'Fasting Blood Glucose'),
('ACC-2026-025', '2026-10-20',   5.40, 'Completed',   1019, '300000001', 'Fasting Blood Glucose'),
('ACC-2026-026', '2026-10-22',   4.90, 'Completed',   1020, '300000001', 'Fasting Blood Glucose'),
('ACC-2026-027', '2026-10-26', 136.00, 'Completed',   1015, '300000001', 'Systolic Blood Pressure'),
('ACC-2026-028', '2026-10-20', 118.00, 'Completed',   1019, '300000001', 'Systolic Blood Pressure'),
('ACC-2026-029', '2026-10-22', 114.00, 'Completed',   1020, '300000001', 'Systolic Blood Pressure');

-- 23. Patient Diagnoses
INSERT INTO Patient_Diagnoses (Patient_SSN, ICD_Code, Diagnosis_Date, Status) VALUES
('400000001', 'I10',    '2018-05-10', 'Chronic'),
('400000001', 'I25.10', '2021-03-22', 'Chronic'),
('400000001', 'E78.5',  '2019-11-14', 'Resolved'),
('400000001', 'Z82.49', '2018-05-10', 'Chronic'),
('400000002', 'E11.9',  '2017-02-18', 'Chronic'),
('400000002', 'E66.9',  '2019-06-30', 'Active'),
('400000002', 'I10',    '2020-01-15', 'Chronic'),
('400000002', 'Z83.3',  '2017-02-18', 'Chronic'),
('400000003', 'J44.9',  '2022-08-11', 'Chronic'),
('400000003', 'Z72.0',  '2010-01-01', 'Active'),
('400000003', 'J45.90', '2015-04-12', 'Active'),
('400000004', 'C18.9',  '2025-11-05', 'Active'),
('400000004', 'Z72.0',  '2016-12-01', 'Active'),
('400000004', 'Z80.9',  '2020-09-05', 'Chronic'),
('400000005', 'I10',    '2021-04-19', 'Chronic'),
('400000005', 'E78.5',  '2021-04-19', 'Chronic'),
('400000005', 'Z72.0',  '2015-06-01', 'Active'),
('400000005', 'Z82.49', '2021-04-19', 'Chronic'),
('400000006', 'I10',    '2023-01-10', 'Active'),
('400000006', 'E78.5',  '2024-01-10', 'Resolved'),
('400000006', 'Z72.0',  '2024-01-10', 'Resolved'),
('400000006', 'E66.9',  '2024-01-10', 'Resolved'),
('400000007', 'Z72.4',  '2024-02-14', 'Active'),
('400000008', 'E11.9',  '2022-10-01', 'Chronic'),
('400000009', 'Z80.9',  '2023-05-18', 'Chronic'),
('400000010', 'Z72.3',  '2025-01-10', 'Resolved'),
('400000011', 'E11.9',  '2020-03-15', 'Chronic'),
('400000011', 'I10',    '2021-06-20', 'Chronic'),
('400000011', 'E66.9',  '2022-01-10', 'Active'),
('400000012', 'I25.10', '2016-05-12', 'Chronic'),
('400000012', 'I10',    '2014-08-01', 'Chronic'),
('400000012', 'Z72.0',  '2010-01-01', 'Active');

-- 24. Risk Assessments (ordered chronologically; 400000010 intentionally has no assessment yet)
INSERT INTO Risk_Assessments (Assessment_Number, Assessment_Date, Score, Risk_Level, Patient_SSN, NCD_Name, Effective_Date) VALUES
(5001, '2026-06-10 10:00:00',  75.00, 'High',   '400000006', 'Cardiovascular Disease',      '2026-01-01'),
(5002, '2026-08-05 09:30:00',  80.00, 'High',   '400000012', 'Cardiovascular Disease',      '2026-01-01'),
(5003, '2026-08-15 11:00:00',  80.00, 'High',   '400000011', 'Type 2 Diabetes',             '2026-01-01'),
(5004, '2026-09-10 11:30:00',  95.00, 'High',   '400000001', 'Cardiovascular Disease',      '2026-01-01'),
(5005, '2026-09-10 11:35:00',  15.00, 'Low',    '400000001', 'Type 2 Diabetes',             '2026-01-01'),
(5006, '2026-09-12 12:00:00', 100.00, 'High',   '400000002', 'Type 2 Diabetes',             '2026-01-01'),
(5007, '2026-09-12 12:05:00',  35.00, 'Medium', '400000002', 'Cardiovascular Disease',      '2026-01-01'),
(5008, '2026-09-15 16:30:00', 100.00, 'High',   '400000003', 'Chronic Respiratory Disease', '2026-01-01'),
(5009, '2026-09-15 16:35:00',  20.00, 'Low',    '400000003', 'Cardiovascular Disease',      '2026-01-01'),
(5010, '2026-09-15 16:40:00',  25.00, 'Medium', '400000003', 'Cancer',                      '2026-01-01'),
(5011, '2026-09-18 13:00:00',  95.00, 'High',   '400000004', 'Cancer',                      '2026-01-01'),
(5012, '2026-09-18 13:05:00',  20.00, 'Low',    '400000004', 'Cardiovascular Disease',      '2026-01-01'),
(5013, '2026-09-18 13:10:00',  35.00, 'Medium', '400000004', 'Chronic Respiratory Disease', '2026-01-01'),
(5014, '2026-09-22 14:00:00',  80.00, 'High',   '400000005', 'Cardiovascular Disease',      '2026-01-01'),
(5015, '2026-09-22 14:05:00',  25.00, 'Medium', '400000005', 'Cancer',                      '2026-01-01'),
(5016, '2026-09-22 14:10:00',  15.00, 'Low',    '400000005', 'Type 2 Diabetes',             '2026-01-01'),
(5017, '2026-09-22 14:15:00',  35.00, 'Medium', '400000005', 'Chronic Respiratory Disease', '2026-01-01'),
(5018, '2026-10-05 10:30:00',  75.00, 'High',   '400000001', 'Cardiovascular Disease',      '2026-01-01'),
(5019, '2026-10-08 12:00:00', 100.00, 'High',   '400000002', 'Type 2 Diabetes',             '2026-01-01'),
(5020, '2026-10-15 16:45:00',  25.00, 'Low',    '400000006', 'Cardiovascular Disease',      '2026-01-01'),
(5021, '2026-10-15 16:50:00',  15.00, 'Low',    '400000006', 'Type 2 Diabetes',             '2026-01-01'),
(5022, '2026-10-20 10:15:00',  10.00, 'Low',    '400000007', 'Type 2 Diabetes',             '2026-01-01'),
(5023, '2026-10-22 11:30:00',  40.00, 'Medium', '400000008', 'Type 2 Diabetes',             '2026-01-01'),
(5024, '2026-10-25 09:30:00',  25.00, 'Medium', '400000009', 'Cancer',                      '2026-01-01'),
(5025, '2025-09-10 10:00:00',  70.00, 'High',   '400000001', 'Cardiovascular Disease',      '2025-01-01'),
(5026, '2025-11-15 14:00:00',  75.00, 'High',   '400000005', 'Cardiovascular Disease',      '2025-01-01');

-- 25. Notifications
INSERT INTO Notifications (Assessment_Number, Date_Notified, Recipient_User_SSN, Message) VALUES
(5004, '2026-09-10 11:30:05', '200000001', 'HIGH RISK ALERT: Patient Arthur Pendleton (AB-904812301) scored 95.00 (High Risk) for Cardiovascular Disease.'),
(5004, '2026-09-10 11:31:05', '100000002', 'CARE GAP NOTICE: Patient Arthur Pendleton (AB-904812301) flagged High Risk (95.00) for Cardiovascular Disease with NO upcoming appointment scheduled.'),
(5006, '2026-09-12 12:00:05', '200000002', 'HIGH RISK ALERT: Patient Beatrice Gomez (AB-904812302) scored 100.00 (High Risk) for Type 2 Diabetes.'),
(5008, '2026-09-15 16:30:05', '200000004', 'HIGH RISK ALERT: Patient Chloe Desjardins (AB-904812303) scored 100.00 (High Risk) for Chronic Respiratory Disease.'),
(5008, '2026-09-15 16:31:05', '100000002', 'CARE GAP NOTICE: Patient Chloe Desjardins (AB-904812303) flagged High Risk (100.00) for Chronic Respiratory Disease with NO upcoming appointment scheduled.'),
(5011, '2026-09-18 13:00:05', '200000003', 'HIGH RISK ALERT: Patient Devon Blackwood (AB-904812304) scored 95.00 (High Risk) for Cancer.'),
(5014, '2026-09-22 14:00:05', '200000001', 'HIGH RISK ALERT: Patient Evelyn Kowalski (AB-904812305) scored 80.00 (High Risk) for Cardiovascular Disease.'),
(5014, '2026-09-22 14:01:05', '100000002', 'CARE GAP NOTICE: Patient Evelyn Kowalski (AB-904812305) flagged High Risk (80.00) for Cardiovascular Disease with NO upcoming appointment scheduled.'),
(5018, '2026-10-05 10:30:05', '200000001', 'FOLLOW-UP ALERT: Patient Arthur Pendleton (AB-904812301) scored 75.00 (previous: 95.00, still High Risk) for Cardiovascular Disease.'),
(5019, '2026-10-08 12:00:05', '200000002', 'FOLLOW-UP ALERT: Patient Beatrice Gomez (AB-904812302) scored 100.00 (previous: 100.00, still High Risk) for Type 2 Diabetes.');
