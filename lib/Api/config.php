<?php

// Database configuration
$database_host = '127.0.0.1';
$database_name = 'profiles';
$database_user = 'root';
$database_password = '';

// PDO database connection
try {
    $pdo = new PDO("mysql:host=$database_host;dbname=$database_name", $database_user, $database_password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}

?>
