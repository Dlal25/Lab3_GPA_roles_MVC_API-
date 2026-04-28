<?php
// ============================================================
// config.php — PDO connection + session helpers
// ============================================================

define('DB_HOST', 'localhost');
define('DB_NAME', 'gpa_system');
define('DB_USER', 'root');       // change to your MySQL user
define('DB_PASS', '');           // change to your MySQL password
define('DB_CHARSET', 'utf8mb4');

// ---------- PDO singleton ----------
function getPDO(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        $dsn = 'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=' . DB_CHARSET;
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];
        $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
    }
    return $pdo;
}

// ---------- Session guard ----------
function requireRole(string $expected): void {
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    // Session expired or missing
    if (empty($_SESSION['role']) || time() - ($_SESSION['last_activity'] ?? 0) > 1800) {
        session_destroy();
        header('Location: index.php?page=login');
        exit;
    }

    // Wrong role
    if ($_SESSION['role'] !== $expected) {
        http_response_code(403);
        echo '<h1>403 — Access Denied</h1>';
        exit;
    }

    // Reset timeout
    $_SESSION['last_activity'] = time();
}

// ---------- Flash messages ----------
function flash(string $type, string $msg): void {
    if (session_status() === PHP_SESSION_NONE) session_start();
    $_SESSION['flash'] = ['type' => $type, 'msg' => $msg];
}

function getFlash(): ?array {
    if (session_status() === PHP_SESSION_NONE) session_start();
    if (!empty($_SESSION['flash'])) {
        $f = $_SESSION['flash'];
        unset($_SESSION['flash']);
        return $f;
    }
    return null;
}

// ---------- Sanitize helper ----------
function sanitize(string $val): string {
    return htmlspecialchars(trim($val), ENT_QUOTES, 'UTF-8');
}
