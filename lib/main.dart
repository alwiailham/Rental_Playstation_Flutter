import 'package:flutter/material.dart';
import 'package:rental_ps/home.dart';
import 'package:rental_ps/login.dart';
import 'package:rental_ps/profile.dart';
import 'package:rental_ps/ps.dart';
import 'package:rental_ps/tambah_game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/ps': (context) => PSPage(),
        '/tambah_game': (context) => TambahGamePage(),
      },
      debugShowCheckedModeBanner: false,  // Menonaktifkan banner debug
    );
  }
}

