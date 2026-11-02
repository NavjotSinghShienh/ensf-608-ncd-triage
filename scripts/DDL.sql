CREATE DATABASE IF NOT EXISTS NCD_Risk_Identification_System;

USE NCD_Risk_Identification_System;

-- drop all tables for clean db schema
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Doctors;
DROP TABLE IF EXISTS LabAssistants;
DROP TABLE IF EXISTS HealthProfessionals;
DROP TABLE IF EXISTS Admins;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Rooms;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Facilities;
-- missing all drop statements

-- create all the tables

CREATE TABLE Users
(
	UserId INT PRIMARY KEY AUTO_INCREMENT, 
	SSN BIGINT UNIQUE NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50),
	DateOfBirth DATE,
	CreatedTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	UpdatedTime DATETIME ON UPDATE CURRENT_TIMESTAMP
	-- Status ? what status could be?
	-- Address ? should be another table maybe
	-- PhoneNo ? another table but what will be attributes
	-- Email ? could be seperate login table
	-- Password ? could be seperate login table
);

CREATE TABLE Patients
(
	PatientId INT PRIMARY KEY,
	HealthCare_Number CHAR(9) UNIQUE NOT NULL,
	Gender CHAR,
	BloodType CHAR(2),
	Status VARCHAR(10) NOT NULL DEFAULT 'Active' CONSTRAINT CK_Patient_Status CHECK (Status IN ('Active', 'InActive', 'Deceased')), -- added constraint of active, inactive, deceased
	CreatedTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	UpdatedTime DATETIME ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT Fk_Patients_Users FOREIGN KEY (PatientId) REFERENCES Users(UserId)
);

CREATE TABLE Facilities
(
	FacilityId INT PRIMARY KEY AUTO_INCREMENT,
	FacilityName VARCHAR(200) NOT NULL,
	AddressLine1 VARCHAR(100) NOT NULL,
	AddressLine2 VARCHAR(100),
	City VARCHAR(100), -- might make table
	State VARCHAR(100), -- might make table
	Country VARCHAR(100) -- might make table
	-- add created/updated time
);

CREATE TABLE Departments
(
	DepartmentId INT PRIMARY KEY AUTO_INCREMENT,
	FacilityId INT NOT NULL,
	DepartmentName VARCHAR(100) NOT NULL,
	Location VARCHAR(50),
	CreatedTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	UpdatedTime DATETIME ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT Fk_Departments_Facilities FOREIGN KEY (FacilityId) REFERENCES Facilities(FacilityId)
	-- add created/updated time
);

CREATE TABLE Rooms
(
	RoomId INT PRIMARY KEY AUTO_INCREMENT,
	FacilityId INT NOT NULL,
	RoomNumber VARCHAR(50) NOT NULL,
	DepartmentId INT,
	RoomType VARCHAR(50),
	CONSTRAINT Fk_Rooms_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(DepartmentId),
	UNIQUE(FacilityId, RoomNumber) 
	-- add created/updated time
);

CREATE TABLE HealthProfessionals
(
	HealthProfessionalId INT PRIMARY KEY,
	EmployeeNumber INT UNIQUE NOT NULL, -- Follows numbers like 100, 200 etc., numbers like 001, E001 not possible
	Status VARCHAR(10) NOT NULL DEFAULT 'Active' CONSTRAINT CK_HealthProfessional_Status CHECK (Status IN ('Active', 'Suspended', 'Terminated', 'Retired')), -- added constraint of active, suspended, terminated, retired
	EmploymentDate DATE NOT NULL,
	DepartmentId INT NOT NULL,
	CreatedTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	UpdatedTime DATETIME ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT Fk_HealthProfessionals_Users FOREIGN KEY (HealthProfessionalId) REFERENCES Users(UserId),
	CONSTRAINT Fk_HealthProfessionals_Departments FOREIGN KEY (DepartmentId) REFERENCES Departments(DepartmentId)
	-- add created/updated time
);

CREATE TABLE Admins
(
	AdminId INT PRIMARY KEY,
	Role VARCHAR(20) NOT NULL CONSTRAINT CK_Admin_Status CHECK (Role IN ('Security Admin', 'Receptionist')),
	IsActive BIT,
	CreatedTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	UpdatedTime DATETIME ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT Fk_Admins_Users FOREIGN KEY (AdminId) REFERENCES Users(UserId)
	-- add created/updated time
);

CREATE TABLE Doctors
(
	DoctorId INT PRIMARY KEY,
	LicenseNumber VARCHAR(20) UNIQUE NOT NULL,
	Speciality VARCHAR(100),
	Qualification VARCHAR(100),
	CreatedTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	UpdatedTime DATETIME ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT Fk_Doctors_HealthProfessionals FOREIGN KEY (DoctorId) REFERENCES HealthProfessionals(HealthProfessionalId)
	-- Schedule (To normalize) 
	-- add created/updated time
);

CREATE TABLE LabAssistants
(
	LabAssistantId INT PRIMARY KEY,
	CertificationNumber VARCHAR(20) UNIQUE NOT NULL,
	LabSpecialization VARCHAR(100),
	CertificationType VARCHAR(100),
	CreatedTime DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	UpdatedTime DATETIME ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT Fk_LabAssistants_HealthProfessionals FOREIGN KEY (LabAssistantId) REFERENCES HealthProfessionals(HealthProfessionalId)
	-- Schedule (To normalize) 
	-- add created/updated time
);

CREATE TABLE Appointments
(
	AppointmentId INT PRIMARY KEY AUTO_INCREMENT,
	AppointmentNumber VARCHAR(20) UNIQUE NOT NULL,
	AppointmentDate DATETIME,
	Status VARCHAR(20) NOT NULL DEFAULT 'Scheduled' CONSTRAINT CK_Appointment_Status CHECK (Status IN ('Scheduled', 'Cancelled', 'Rescheduled', 'Completed')),
	PatientId INT NOT NULL,
	DoctorId INT NOT NULL,
	RoomId INT,
	CONSTRAINT Fk_Appointments_Patients FOREIGN KEY (PatientId) REFERENCES Patients(PatientId),
	CONSTRAINT Fk_Appointments_Doctors FOREIGN KEY (DoctorId) REFERENCES Doctors(DoctorId),
	CONSTRAINT Fk_Appointments_Rooms FOREIGN KEY (RoomId) REFERENCES Rooms(RoomId)
	-- add created/updated time
);

CREATE TABLE TestTypes
(
	TestTypeId INT NOT NULL AUTO_INCREMENT,
	TestName VARCHAR(100) NOT NULL UNIQUE,
	MinRange FLOAT,
	MaxRange FLOAT
	-- add created/updated time
);

CREATE TABLE LabTests
(
	LabTestId INT PRIMARY KEY AUTO_INCREMENT,
	AccessionNumber VARCHAR(20) UNIQUE NOT NULL,
	Status VARCHAR(20) NOT NULL DEFAULT 'Scheduled' CONSTRAINT CK_Appointment_Status CHECK (Status IN ('Scheduled', 'Cancelled', 'Completed')), 
	TestDate DATETIME,
	TestResult FLOAT,
	AppointmentId INT NOT NULL,
	LabAssistantId INT NOT NULL,
	TestTypeId INT NOT NULL,
	CONSTRAINT Fk_LabTests_Appointments FOREIGN KEY (AppointmentId) REFERENCES Appointments(AppointmentId),
	CONSTRAINT Fk_LabTests_LabAssistants FOREIGN KEY (LabAssistantId) REFERENCES LabAssistants(LabAssistantId),
	CONSTRAINT Fk_LabTests_TestTypes FOREIGN KEY (TestTypeId) REFERENCES TestTypes(TestTypeId)
	-- add created/updated time
);





