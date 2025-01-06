<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Database connection
$host = 'localhost';
$username = 'root'; // Ganti dengan username MySQL Anda
$password = ''; // Ganti dengan password MySQL Anda
$database = 'db_game'; // Nama database Anda

$conn = new mysqli($host, $username, $password, $database);

if ($conn->connect_error) {
    echo json_encode(['success' => false, 'message' => 'Koneksi database gagal: ' . $conn->connect_error]);
    exit();
}

$data = $_POST;
if (isset($data['ID_GAME'], $data['NAMA_GAME'], $data['TANGGAL_DITAMBAHKAN'])) {
    $id_game = $conn->real_escape_string($data['ID_GAME']);
    $nama_game = $conn->real_escape_string($data['NAMA_GAME']);
    $tanggal_ditambahkan = $conn->real_escape_string($data['TANGGAL_DITAMBAHKAN']);

    $query = "INSERT INTO game (ID_GAME, NAMA_GAME, TANGGAL_DITAMBAHKAN) VALUES ('$id_game', '$nama_game', '$tanggal_ditambahkan')";

    if ($conn->query($query)) {
        echo json_encode(['success' => true, 'message' => 'Game berhasil ditambahkan']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Gagal menambahkan game: ' . $conn->error]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Data tidak lengkap']);
}

$conn->close();
?>
