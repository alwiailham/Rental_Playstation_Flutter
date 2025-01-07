<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Koneksi ke database
$host = 'localhost';
$username = 'root';
$password = ''; // Sesuaikan dengan konfigurasi Anda
$database = 'db_game';
$port = 3306;

$conn = new mysqli($host, $username, $password, $database, $port);
if ($conn->connect_error) {
    die(json_encode(['error' => 'Gagal terkoneksi ke database: ' . $conn->connect_error]));
}

// Ambil metode HTTP dan data
$method = $_SERVER['REQUEST_METHOD'];
$data = json_decode(file_get_contents('php://input'), true);

// Debug: Log data request untuk pemeriksaan
file_put_contents('php://stderr', print_r($data, true));

/// Ambil metode HTTP
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        listGames($conn);
        break;
    
    case 'POST':
        if (isset($data['username']) && isset($data['password'])) {
            login($conn, $data);
        } else {
            addGame($conn, $data);
        }
        break;

    case 'PUT':
        updateGame($conn, $data);  // Tangani update
        break;

    case 'DELETE':
        deleteGame($conn, $data);  // Tangani delete
        break;

    default:
        echo json_encode(['error' => 'Metode HTTP tidak valid']);
        break;
}

// Fungsi untuk login (POST)
function login($conn, $data) {
    $username = $conn->real_escape_string($data['username']);
    $password = $conn->real_escape_string($data['password']);

    $sql = "SELECT * FROM login WHERE username = '$username' AND password = '$password'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        echo json_encode(['status' => 'success', 'message' => 'Login berhasil']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Username atau password salah']);
    }
}

// Fungsi untuk daftar game (GET)
function listGames($conn) {
    $query = "SELECT ID_GAME, NAMA_GAME, TANGGAL_DITAMBAHKAN FROM game";
    $result = $conn->query($query);

    $games = [];
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $games[] = $row;
        }
    }
    echo json_encode($games);
}

// Fungsi untuk menambah game (POST)
function addGame($conn, $data) {
    if (isset($data['ID_GAME'], $data['NAMA_GAME'], $data['TANGGAL_DITAMBAHKAN'])) {
        $query = "INSERT INTO game (ID_GAME, NAMA_GAME, TANGGAL_DITAMBAHKAN) VALUES (?, ?, ?)";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("sss", $data['ID_GAME'], $data['NAMA_GAME'], $data['TANGGAL_DITAMBAHKAN']);

        if ($stmt->execute()) {
            echo json_encode(['success' => true, 'message' => 'Game berhasil ditambahkan']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Gagal menambahkan game: ' . $stmt->error]);
        }
        $stmt->close();
    } else {
        echo json_encode(['success' => false, 'message' => 'Data tidak lengkap']);
    }
}

// Fungsi untuk memperbarui game (PUT)
function updateGame($conn, $data) {
    if (isset($data['ID_GAME'], $data['NAMA_GAME'], $data['TANGGAL_DITAMBAHKAN'])) {
        $query = "UPDATE game SET NAMA_GAME = ?, TANGGAL_DITAMBAHKAN = ? WHERE ID_GAME = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("sss", $data['NAMA_GAME'], $data['TANGGAL_DITAMBAHKAN'], $data['ID_GAME']);

        if ($stmt->execute()) {
            echo json_encode(['success' => true, 'message' => 'Game berhasil diperbarui']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Gagal memperbarui game: ' . $stmt->error]);
        }
        $stmt->close();
    } else {
        echo json_encode(['success' => false, 'message' => 'Data tidak lengkap']);
    }
}

// Fungsi untuk menghapus game (DELETE)
function deleteGame($conn, $data) {
    if (isset($data['ID_GAME'])) {
        $query = "DELETE FROM game WHERE ID_GAME = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("s", $data['ID_GAME']);

        if ($stmt->execute()) {
            echo json_encode(['message' => 'Game berhasil dihapus']);
        } else {
            echo json_encode(['error' => 'Gagal menghapus game: ' . $stmt->error]);
        }
        $stmt->close();
    } else {
        echo json_encode(['error' => 'ID_GAME tidak diberikan']);
    }
}


// Tutup koneksi
$conn->close();
?>
