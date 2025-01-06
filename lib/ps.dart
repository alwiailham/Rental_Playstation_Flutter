import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'daftar_PS/ps_1.dart';
import 'daftar_PS/ps_2.dart';
import 'daftar_PS/ps_3.dart';
import 'daftar_PS/ps_4.dart';
import 'daftar_PS/ps_5.dart';
import 'daftar_PS/ps_6.dart';
import 'daftar_PS/ps_7.dart';
import 'daftar_PS/ps_8.dart';
import 'daftar_PS/ps_9.dart';
import 'daftar_PS/ps_10.dart';
import 'home.dart';
import 'profile.dart';

class PSPage extends StatefulWidget {
  @override
  _PSPageState createState() => _PSPageState();
}

class _PSPageState extends State<PSPage> {
  Map<int, bool> bookingStatus = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
    6: false,
    7: false,
    8: false,
    9: false,
    10: false,
  };

  @override
  void initState() {
    super.initState();
    _loadBookingStatus();
  }

  Future<void> _loadBookingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int id = 1; id <= 10; id++) {
        bookingStatus[id] = prefs.getBool('ps_status_$id') ?? false;
      }
    });
  }

  Future<void> _saveBookingStatus(int id, bool isBooked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ps_status_$id', isBooked);
  }

  void updateBookingStatus(int id, bool isBooked) {
    setState(() {
      bookingStatus[id] = isBooked;
    });
    _saveBookingStatus(id, isBooked);
  }

  Widget _buildPSCard(Map<String, dynamic> ps) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.black,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        leading: Icon(
          Icons.videogame_asset,
          color: Colors.blueAccent,
          size: 35,
        ),
        title: Text(
          'PS ${ps['id']}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono',
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          '${ps['type']}',
          style: TextStyle(
            color: Colors.grey[600],
            fontFamily: 'RobotoMono',
          ),
        ),
        trailing: Text(
          bookingStatus[ps['id']]! ? 'Terboking' : 'Kosong',
          style: TextStyle(
            color: bookingStatus[ps['id']]! ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return _getPSPage(ps['id'], ps['type']);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _getPSPage(int id, String type) {
    switch (id) {
      case 1:
        return PS1Page(
          id: id,
          type: type,
          onBookingStatusChanged: (isBooked) =>
              updateBookingStatus(id, isBooked),
        );
      case 2:
        return PS2Page(
          id: id,
          type: type,
          onBookingStatusChanged: (isBooked) =>
              updateBookingStatus(id, isBooked),
        );
      case 3:
        return PS3Page(
          id: id,
          type: type,
          onBookingStatusChanged: (isBooked) =>
              updateBookingStatus(id, isBooked),
        );
      case 4:
        return PS4Page(
          id: id,
          type: type,
          onBookingStatusChanged: (isBooked) =>
              updateBookingStatus(id, isBooked),
        );
      case 5:
        return PS5Page(
          id: id,
          type: type,
          onBookingStatusChanged: (isBooked) =>
              updateBookingStatus(id, isBooked),
        );
      case 6:
        return PS6Page(
          id: id,
          type: type,
          onBookingStatusChanged: (isBooked) =>
              updateBookingStatus(id, isBooked),
        );
      case 7:
        return PS7Page(
          id: id,
          type: type,
          onBookingStatusChanged: (isBooked) =>
              updateBookingStatus(id, isBooked),
        );
      case 8:
        return PS8Page(
          id: id,
          type: type,
          onBookingStatusChanged: (isBooked) =>
              updateBookingStatus(id, isBooked),
        );
      case 9:
        return PS9Page(
          id: id,
          type: type,
          onBookingStatusChanged: (isBooked) =>
              updateBookingStatus(id, isBooked),
        );
      case 10:
        return PS10Page(
          id: id,
          type: type,
          onBookingStatusChanged: (isBooked) =>
              updateBookingStatus(id, isBooked),
        );
      default:
        return PS1Page(
          id: id,
          type: type,
          onBookingStatusChanged: (isBooked) =>
              updateBookingStatus(id, isBooked),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> psList = [
      {'id': 1, 'type': 'PS3'},
      {'id': 2, 'type': 'PS3'},
      {'id': 3, 'type': 'PS3'},
      {'id': 4, 'type': 'PS3'},
      {'id': 5, 'type': 'PS3'},
      {'id': 6, 'type': 'PS3'},
      {'id': 7, 'type': 'PS4'},
      {'id': 8, 'type': 'PS4'},
      {'id': 9, 'type': 'PS4'},
      {'id': 10, 'type': 'PS4'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar PS',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono',
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: psList.length,
          itemBuilder: (context, index) {
            final ps = psList[index];
            return _buildPSCard(ps);
          },
        ),
      ),
    );
  }
}
