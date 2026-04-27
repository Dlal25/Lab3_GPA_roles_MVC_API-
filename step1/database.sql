-- ============================================================
-- Academic GPA Management System — Database Schema
-- ============================================================

CREATE DATABASE IF NOT EXISTS gpa_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gpa_system;

-- Users (admin / professor / student)
CREATE TABLE users (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    email        VARCHAR(150) NOT NULL UNIQUE,
    password     VARCHAR(255) NOT NULL,
    role         ENUM('admin','professor','student') NOT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Semesters
CREATE TABLE semesters (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    label         VARCHAR(20)  NOT NULL,          -- e.g. S1, S2
    academic_year VARCHAR(20)  NOT NULL,           -- e.g. 2024/2025
    is_active     BOOLEAN DEFAULT FALSE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Courses (linked to a semester)
CREATE TABLE courses (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    semester_id INT NOT NULL,
    name        VARCHAR(150) NOT NULL,
    credits     INT NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (semester_id) REFERENCES semesters(id)
);

-- Enrollments: student <-> semester
CREATE TABLE enrollments (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    student_id  INT NOT NULL,
    semester_id INT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_enroll (student_id, semester_id),
    FOREIGN KEY (student_id)  REFERENCES users(id),
    FOREIGN KEY (semester_id) REFERENCES semesters(id)
);

-- Assignments: professor <-> course <-> semester
CREATE TABLE assignments (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    professor_id INT NOT NULL,
    course_id    INT NOT NULL,
    semester_id  INT NOT NULL,
    assigned_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_assign (professor_id, course_id, semester_id),
    FOREIGN KEY (professor_id) REFERENCES users(id),
    FOREIGN KEY (course_id)    REFERENCES courses(id),
    FOREIGN KEY (semester_id)  REFERENCES semesters(id)
);

-- Grades
CREATE TABLE grades (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    student_id   INT NOT NULL,
    course_id    INT NOT NULL,
    semester_id  INT NOT NULL,
    professor_id INT NOT NULL,
    grade        DECIMAL(3,1) NOT NULL,            -- 0.0 to 4.0
    entered_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_grade (student_id, course_id, semester_id),
    FOREIGN KEY (student_id)   REFERENCES users(id),
    FOREIGN KEY (course_id)    REFERENCES courses(id),
    FOREIGN KEY (semester_id)  REFERENCES semesters(id),
    FOREIGN KEY (professor_id) REFERENCES users(id)
);

-- GPA Records (recomputed on every grade save)
CREATE TABLE gpa_records (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    student_id  INT NOT NULL,
    semester_id INT NOT NULL,
    gpa         DECIMAL(4,2) NOT NULL,
    computed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_gpa (student_id, semester_id),
    FOREIGN KEY (student_id)  REFERENCES users(id),
    FOREIGN KEY (semester_id) REFERENCES semesters(id)
);

-- ============================================================
-- Seed: default admin account  (password: admin123)
-- ============================================================
INSERT INTO users (name, email, password, role) VALUES
('Administrator', 'admin@gpa.local',
 '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');
