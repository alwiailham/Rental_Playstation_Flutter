<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

$conn = new mysqli('localhost', 'root', '', 'db_game');

if ($conn->connect_error) {
    die(json_encode(['error' => 'Gagal terkoneksi ke database']));
}

$id = $_POST['ID_GAME'];
$name = $_POST['NAMA_GAME'];
$date = $_POST['TANGGAL_DITAMBAHKAN'];

$query = "UPDATE game SET NAMA_GAME = ?, TANGGAL_DITAMBAHKAN = ? WHERE ID_GAME = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("sss", $name, $date, $id);

if ($stmt->execute()) {
    echo json_encode(['message' => 'Game berhasil diperbarui']);
} else {
    echo json_encode(['error' => 'Gagal memperbarui game']);
}

$stmt->close();
$conn->close();
