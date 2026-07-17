```sql
-- Hospital Management System Database Schema
-- Database: hospital_management_system
-- Engine: InnoDB

SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- 1. AUTHENTICATION AND AUTHORIZATION
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS roles (
    role_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS users (
    user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    role_id TINYINT UNSIGNED NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    last_login DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_role FOREIGN KEY (role_id) REFERENCES roles (role_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 2. HOSPITAL STRUCTURE
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS departments (
    department_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    head_doctor_id INT UNSIGNED,
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS rooms (
    room_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    department_id INT UNSIGNED NOT NULL,
    room_type ENUM('General', 'Private', 'ICU', 'Emergency', 'Operation Theater') NOT NULL,
    status ENUM('Available', 'Occupied', 'Maintenance') DEFAULT 'Available',
    daily_rate DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_room_department FOREIGN KEY (department_id) REFERENCES departments (department_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 3. STAFF AND DOCTORS
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS staff (
    staff_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL UNIQUE,
    department_id INT UNSIGNED NOT NULL,
    designation VARCHAR(100),
    joining_date DATE NOT NULL,
    salary DECIMAL(10, 2),
    status ENUM('Active', 'On Leave', 'Resigned') DEFAULT 'Active',
    CONSTRAINT fk_staff_user FOREIGN KEY (user_id) REFERENCES users (user_id),
    CONSTRAINT fk_staff_dept FOREIGN KEY (department_id) REFERENCES departments (department_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS doctors (
    doctor_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    staff_id INT UNSIGNED NOT NULL UNIQUE,
    specialization VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) NOT NULL UNIQUE,
    experience_years TINYINT UNSIGNED,
    consultation_fee DECIMAL(10, 2) NOT NULL,
    bio TEXT,
    CONSTRAINT fk_doctor_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 4. PATIENTS
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS patients (
    patient_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    blood_group ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    address_line1 VARCHAR(255),
    city VARCHAR(100),
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    medical_history_summary TEXT,
    CONSTRAINT fk_patient_user FOREIGN KEY (user_id) REFERENCES users (user_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 5. APPOINTMENTS AND CONSULTATIONS
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS appointments (
    appointment_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    patient_id INT UNSIGNED NOT NULL,
    doctor_id INT UNSIGNED NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled', 'No Show') DEFAULT 'Scheduled',
    reason_for_visit TEXT,
    symptoms TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_appt_patient FOREIGN KEY (patient_id) REFERENCES patients (patient_id),
    CONSTRAINT fk_appt_doctor FOREIGN KEY (doctor_id) REFERENCES doctors (doctor_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS medical_records (
    record_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    patient_id INT UNSIGNED NOT NULL,
    doctor_id INT UNSIGNED NOT NULL,
    appointment_id INT UNSIGNED,
    diagnosis TEXT NOT NULL,
    treatment_plan TEXT,
    notes TEXT,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_record_patient FOREIGN KEY (patient_id) REFERENCES patients (patient_id),
    CONSTRAINT fk_record_doctor FOREIGN KEY (doctor_id) REFERENCES doctors (doctor_id),
    CONSTRAINT fk_record_appt FOREIGN KEY (appointment_id) REFERENCES appointments (appointment_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 6. PHARMACY AND PRESCRIPTIONS
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS medications (
    medication_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    generic_name VARCHAR(150),
    manufacturer VARCHAR(150),
    unit_price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    expiry_date DATE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS prescriptions (
    prescription_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    record_id INT UNSIGNED NOT NULL,
    doctor_id INT UNSIGNED NOT NULL,
    patient_id INT UNSIGNED NOT NULL,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_presc_record FOREIGN KEY (record_id) REFERENCES medical_records (record_id),
    CONSTRAINT fk_presc_doctor FOREIGN KEY (doctor_id) REFERENCES doctors (doctor_id),
    CONSTRAINT fk_presc_patient FOREIGN KEY (patient_id) REFERENCES patients (patient_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS prescription_items (
    item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT UNSIGNED NOT NULL,
    medication_id INT UNSIGNED NOT NULL,
    dosage VARCHAR(100) NOT NULL, -- e.g., "500mg"
    frequency VARCHAR(100) NOT NULL, -- e.g., "Twice a day"
    duration VARCHAR(50) NOT NULL, -- e.g., "7 days"
    instructions TEXT,
    CONSTRAINT fk_item_presc FOREIGN KEY (prescription_id) REFERENCES prescriptions (prescription_id),
    CONSTRAINT fk_item_med FOREIGN KEY (medication_id) REFERENCES medications (medication_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 7. LABORATORY
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS lab_tests (
    test_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    test_name VARCHAR(150) NOT NULL,
    description TEXT,
    base_cost DECIMAL(10, 2) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS lab_reports (
    report_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    patient_id INT UNSIGNED NOT NULL,
    doctor_id INT UNSIGNED NOT NULL,
    test_id INT UNSIGNED NOT NULL,
    results TEXT,
    status ENUM('Pending', 'Completed') DEFAULT 'Pending',
    test_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    report_file_url VARCHAR(255),
    CONSTRAINT fk_lab_patient FOREIGN KEY (patient_id) REFERENCES patients (patient_id),
    CONSTRAINT fk_lab_doctor FOREIGN KEY (doctor_id) REFERENCES doctors (doctor_id),
    CONSTRAINT fk_lab_test FOREIGN KEY (test_id) REFERENCES lab_tests (test_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 8. BILLING AND PAYMENTS
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS invoices (
    invoice_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    patient_id INT UNSIGNED NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) DEFAULT 0.00,
    discount_amount DECIMAL(10, 2) DEFAULT 0.00,
    grand_total DECIMAL(10, 2) NOT NULL,
    status ENUM('Unpaid', 'Partially Paid', 'Paid', 'Refunded') DEFAULT 'Unpaid',
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_invoice_patient FOREIGN KEY (patient_id) REFERENCES patients (patient_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS payments (
    payment_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT UNSIGNED NOT NULL,
    payment_method ENUM('Cash', 'Credit Card', 'Insurance', 'Online Banking') NOT NULL,
    transaction_reference VARCHAR(100),
    amount_paid DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_invoice FOREIGN KEY (invoice_id) REFERENCES invoices (invoice_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 9. INVENTORY AND ANALYTICS
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS hospital_inventory (
    item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(150) NOT NULL,
    category ENUM('Surgical', 'General Supplies', 'Equipment', 'Emergency') NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 10,
    supplier_info TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 10. SYSTEM AUDIT AND LOGS
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS audit_logs (
    log_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED,
    action VARCHAR(100) NOT NULL,
    table_affected VARCHAR(50),
    record_id INT UNSIGNED,
    old_value JSON,
    new_value JSON,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users (user_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS notifications (
    notification_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('Email', 'SMS', 'In-App') NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users (user_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- INDEXES FOR PERFORMANCE
-- -----------------------------------------------------

CREATE INDEX idx_appointment_date ON appointments(appointment_date);
CREATE INDEX idx_med_expiry ON medications(expiry_date);
CREATE INDEX idx_invoice_status ON invoices(status);
CREATE INDEX idx_lab_report_status ON lab_reports(status);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
```