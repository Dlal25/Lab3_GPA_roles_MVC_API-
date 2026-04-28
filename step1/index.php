<?php
// ============================================================
// index.php — Front Controller
// ============================================================

session_start();
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/controllers/AuthController.php';
require_once __DIR__ . '/controllers/AdminController.php';
require_once __DIR__ . '/controllers/ProfessorController.php';
require_once __DIR__ . '/controllers/StudentController.php';

$page = $_GET['page'] ?? 'login';

match (true) {
    in_array($page, ['login', 'logout'])    => (new AuthController())->handle($page),
    str_starts_with($page, 'admin.')        => (new AdminController())->handle($page),
    str_starts_with($page, 'professor.')    => (new ProfessorController())->handle($page),
    str_starts_with($page, 'student.')      => (new StudentController())->handle($page),
    default                                 => (function () {
        header('Location: index.php?page=login');
        exit;
    })()
};
