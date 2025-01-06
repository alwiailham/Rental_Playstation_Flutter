import 'package:flutter/material.dart';
import 'package:rental_ps/home.dart';
import 'package:rental_ps/ps.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blueAccent, // Warna tema PlayStation
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
            icon: Icon(Icons.gamepad),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PSPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black, // Latar belakang hitam untuk tema PlayStation
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('lib/assets/alwia.jpg'), // Ganti dengan gambar profil
            ),
            SizedBox(height: 10),
            Text(
              'John Doe', // Nama pengguna
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'PlayStation Enthusiast', // Deskripsi singkat
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[900],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileInfoRow(
                      icon: Icons.email,
                      title: 'Email',
                      value: 'johndoe@example.com',
                    ),
                    Divider(color: Colors.grey),
                    ProfileInfoRow(
                      icon: Icons.phone,
                      title: 'Phone',
                      value: '+123 456 7890',
                    ),
                    Divider(color: Colors.grey),
                    ProfileInfoRow(
                      icon: Icons.location_city,
                      title: 'Location',
                      value: 'PlayStation City',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  ProfileInfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        SizedBox(width: 10),
        Text(
          '$title: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
