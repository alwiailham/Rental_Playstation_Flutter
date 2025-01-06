<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
// Koneksi ke database
$conn = new mysqli('localhost', 'root', '', 'db_game');

// Periksa koneksi
if ($conn->connect_error) {
    die("Koneksi gagal: " . $conn->connect_error);
}

// Debug untuk memeriksa data POST yang diterima
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['username']) && isset($_POST['password'])) {
        $username = $_POST['username'];
        $password = $_POST['password'];

        // Escape input untuk menghindari SQL Injection
        $username = $conn->real_escape_string($username);
        $password = $conn->real_escape_string($password);

        // Query untuk memeriksa login
        $sql = "SELECT * FROM login WHERE username = '$username' AND password = '$password'";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            echo json_encode(['status' => 'success', 'message' => 'Login berhasil']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Username atau password salah']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Username atau password tidak ditemukan']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}

// Tutup koneksi
$conn->close();
?>
