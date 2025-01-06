<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Koneksi ke database
$conn = new mysqli('localhost', 'root', '', 'db_game'); // Sesuaikan dengan database Anda

if ($conn->connect_error) {
    die(json_encode(['error' => 'Gagal terkoneksi ke database']));
}

// Query untuk mendapatkan data
$query = "SELECT ID_GAME, NAMA_GAME, TANGGAL_DITAMBAHKAN FROM game";
$result = $conn->query($query);

$game = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $game[] = $row;
    }
}

echo json_encode($game);

$conn->close();
