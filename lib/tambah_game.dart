import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahGamePage extends StatefulWidget {
  @override
  _TambahGamePageState createState() => _TambahGamePageState();
}

class _TambahGamePageState extends State<TambahGamePage> {
  final TextEditingController _idGameController = TextEditingController();
  final TextEditingController _namaGameController = TextEditingController();
  final TextEditingController _tanggalDitambahkanController = TextEditingController();

  // Fungsi untuk menambahkan game ke server
  Future<void> _addGame() async {
    final String idGame = _idGameController.text.trim();
    final String namaGame = _namaGameController.text.trim();
    final String tanggalDitambahkan = _tanggalDitambahkanController.text.trim();

    if (idGame.isEmpty || namaGame.isEmpty || tanggalDitambahkan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua kolom harus diisi!')),
      );
      return;
    }

    try {
      // Kirim data ke server
      final response = await http.post(
        Uri.parse('http://191.1.7.159/game/add_game.php'), // Ganti dengan URL endpoint Anda
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'ID_GAME': idGame,
          'NAMA_GAME': namaGame,
          'TANGGAL_DITAMBAHKAN': tanggalDitambahkan,
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Game berhasil ditambahkan')),
          );
          Navigator.pop(context); // Kembali ke halaman sebelumnya
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambahkan game: ${result['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan game: HTTP ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  // Fungsi untuk menampilkan DatePicker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Tanggal awal (2000)
      lastDate: DateTime(2100),  // Tanggal akhir (2100)
    );

    if (pickedDate != null) {
      // Format tanggal ke format "YYYY-MM-DD"
      String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      setState(() {
        _tanggalDitambahkanController.text = formattedDate; // Set hasil tanggal ke TextField
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Game', style: TextStyle(fontFamily: 'Roboto', fontSize: 24)),
        backgroundColor: Colors.blueGrey[900],
        elevation: 5,
      ),
      body: Stack(
        children: [
          // Latar belakang gambar bertema PlayStation yang menutupi seluruh layar
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:AssetImage('lib/assets/2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Konten halaman yang berada di atas latar belakang gambar
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Judul
                  Center(
                    child: Text(
                      'Tambah Game Baru',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Input ID Game
                  TextField(
                    controller: _idGameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'ID Game',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.7),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 15),
                  // Input Nama Game
                  TextField(
                    controller: _namaGameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Nama Game',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.7),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 15),
                  // Input Tanggal Ditambahkan
                  TextField(
                    controller: _tanggalDitambahkanController,
                    readOnly: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Tanggal Ditambahkan',
                      labelStyle: TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today, color: Colors.white),
                        onPressed: () => _selectDate(context),
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.7),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Tombol Tambah Game
                  ElevatedButton(
                    onPressed: _addGame,
                    child: Text(
                      'Tambah Game',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue[900],
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
