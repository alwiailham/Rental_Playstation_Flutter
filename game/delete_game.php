<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

$conn = new mysqli('localhost', 'root', '', 'db_game');

if ($conn->connect_error) {
    die(json_encode(['error' => 'Gagal terkoneksi ke database']));
}

$id = $_POST['ID_GAME'];

$query = "DELETE FROM game WHERE ID_GAME = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $id);

if ($stmt->execute()) {
    echo json_encode(['message' => 'Game berhasil dihapus']);
} else {
    echo json_encode(['error' => 'Gagal menghapus game']);
}

$stmt->close();
$conn->close();
