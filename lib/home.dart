import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rental_ps/login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Menyimpan indeks tab yang dipilih
  List<dynamic> _games = [];
  bool _isLoading = true;
  String apiUrl = 'http://191.1.7.159/game/api_game.php'; // Ganti dengan URL backend Anda

  // Fetch games data
  Future<void> _fetchGames() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          _games = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data: ${response.statusCode}')),
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    }
  }

  // Delete game
  Future<void> _deleteGame(String id) async {
    try {
      final response = await http.post(
        Uri.parse('http://191.1.7.159/game/delete_game.php'),
        body: {'ID_GAME': id},
      );

      if (response.statusCode == 200) {
        setState(() {
          _games.removeWhere((game) => game['ID_GAME'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Game berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus game')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    }
  }

  // Update game
  Future<void> _updateGame(String id, String newId, String newName, String newDate) async {
    try {
      final response = await http.post(
        Uri.parse('http://191.1.7.159/game/update_game.php'),
        body: {
          'ID_GAME': id, // ID yang asli untuk pembaruan
          'NEW_ID_GAME': newId, // ID yang baru
          'NAMA_GAME': newName,
          'TANGGAL_DITAMBAHKAN': newDate,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          final index = _games.indexWhere((game) => game['ID_GAME'] == id);
          if (index != -1) {
            _games[index]['ID_GAME'] = newId; // Update ID_GAME
            _games[index]['NAMA_GAME'] = newName;
            _games[index]['TANGGAL_DITAMBAHKAN'] = newDate;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Game berhasil diperbarui')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui game')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    }
  }

  // Dialog for updating game
  void _showUpdateDialog(String id, String currentId, String currentName, String currentDate) {
    TextEditingController idController = TextEditingController(text: currentId);
    TextEditingController nameController = TextEditingController(text: currentName);
    TextEditingController dateController = TextEditingController(text: currentDate);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Perbarui Game'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration: InputDecoration(labelText: 'ID Game'),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Game'),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Tanggal Ditambahkan'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _updateGame(id, idController.text, nameController.text, dateController.text);
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Handle navigation between tabs
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi berdasarkan indeks
    if (index == 1) {
      Navigator.pushNamed(context, '/ps'); // Halaman PS
    } else if (index == 2) {
      Navigator.pushNamed(context, '/profile'); // Halaman Profil
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Game'),
        backgroundColor: Colors.blueGrey[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_games.isEmpty)
                        Center(
                          child: Text(
                            'Tidak ada data tersedia',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _games.length,
                          itemBuilder: (context, index) {
                            final game = _games[index];
                            return Card(
                              margin: EdgeInsets.all(10),
                              color: Colors.blueGrey[800],
                              child: ListTile(
                                title: Text(
                                  game['NAMA_GAME'] ?? 'Nama tidak tersedia',
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'ID: ${game['ID_GAME'] ?? 'ID tidak tersedia'}\nTanggal Ditambahkan: ${game['TANGGAL_DITAMBAHKAN'] ?? 'Tanggal tidak tersedia'}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.orange),
                                      onPressed: () {
                                        _showUpdateDialog(
                                          game['ID_GAME'],
                                          game['ID_GAME'],
                                          game['NAMA_GAME'],
                                          game['TANGGAL_DITAMBAHKAN'],
                                        );
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _deleteGame(game['ID_GAME']);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tambah_game'); // Navigasi ke halaman tambah_game.dart
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Main',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blueGrey[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
