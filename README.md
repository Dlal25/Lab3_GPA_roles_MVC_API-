# 🎓 Academic GPA Management System

**Course:** Web Development — 2nd Year LMD  
**Stack:** PHP (MVC) + MySQL + jQuery AJAX + Bootstrap 5 + Chart.js

---

## 📁 Project Structure

```
project/
├── index.php                  ← Front controller (?page= routing)
├── config.php                 ← PDO connection + helpers
├── database.sql               ← Database schema + seed
│
├── models/
│   ├── User.php
│   ├── Semester.php
│   ├── Course.php
│   ├── Enrollment.php
│   ├── Assignment.php
│   ├── Grade.php
│   └── GPA.php
│
├── controllers/
│   ├── AuthController.php
│   ├── AdminController.php
│   ├── ProfessorController.php
│   └── StudentController.php
│
├── views/
│   ├── login.php
│   ├── _layout_header.php
│   ├── _layout_footer.php
│   ├── admin/
│   │   ├── dashboard.php
│   │   ├── semesters.php
│   │   ├── courses.php
│   │   ├── professors.php
│   │   ├── assignments.php
│   │   ├── students.php
│   │   └── enrollments.php
│   ├── professor/
│   │   └── grades.php
│   └── student/
│       ├── dashboard.php
│       └── history.php
│
├── api/
│   ├── grades.php             ← Professor AJAX API
│   └── gpa.php                ← Student AJAX API + CSV export
│
└── public/
    ├── css/style.css
    └── js/
        ├── professor.js
        └── student.js
```

---

## ⚙️ Setup Instructions

### 1. Database
```sql
-- In phpMyAdmin or MySQL CLI:
SOURCE database.sql;
```

### 2. Configure DB connection
Edit `config.php`:
```php
define('DB_USER', 'your_mysql_user');
define('DB_PASS', 'your_mysql_password');
```

### 3. Deploy
- Place the project folder in `htdocs/` (XAMPP) or `www/` (WAMP)
- Visit: `http://localhost/gpa_system/`

### 4. Default Admin Login
| Email | Password |
|-------|----------|
| admin@gpa.local | password |

> ⚠️ Change this in the database after first login!

---

## 🔑 Roles & Access

| Feature | Admin | Professor | Student |
|---------|-------|-----------|---------|
| Manage semesters | ✅ | ❌ | ❌ |
| Manage courses | ✅ | ❌ | ❌ |
| Manage professors/students | ✅ | ❌ | ❌ |
| Enroll students | ✅ | ❌ | ❌ |
| Assign professor to course | ✅ | ❌ | ❌ |
| Enter grades (AJAX) | ❌ | ✅ | ❌ |
| View own grades + GPA | ❌ | ❌ | ✅ |
| Export GPA history CSV | ❌ | ❌ | ✅ |

---

## 🔌 REST API Endpoints

| File | Action | Method | Description |
|------|--------|--------|-------------|
| `api/grades.php` | `courses` | GET | Professor's courses for a semester |
| `api/grades.php` | `students` | GET | Enrolled students + existing grades |
| `api/grades.php` | `save` | POST | Save grade batch + recompute GPA |
| `api/gpa.php` | `current` | GET | Active semester grades + GPA |
| `api/gpa.php` | `history` | GET | All semesters grades + GPA |
| `api/gpa.php` | `export` | GET | Download CSV |

---

## 📐 GPA Formula

```
GPA = Σ(grade × credits) / Σ(credits)
```

| GPA Range | Status | Bootstrap Class |
|-----------|--------|-----------------|
| ≥ 3.7 | Distinction | `alert-success` |
| ≥ 3.0 | Merit | `alert-info` |
| ≥ 2.0 | Pass | `alert-warning` |
| < 2.0 | Fail | `alert-danger` |

---

## 🔒 Security

- PDO prepared statements (no SQL injection)
- `htmlspecialchars()` on all view output
- `password_hash()` / `password_verify()` for passwords
- Role check (`requireRole()`) on every controller + API endpoint
- Session timeout after 30 minutes of inactivity
- Ownership verification in professor/student APIs
