import 'package:flutter/material.dart';
import 'dart:async';

class PS7Page extends StatefulWidget {
  final int id;
  final String type;
  final Function(bool) onBookingStatusChanged;

  const PS7Page({super.key, 
    required this.id,
    required this.type,
    required this.onBookingStatusChanged,
  });

  @override
  _PS7PageState createState() => _PS7PageState();
}

class _PS7PageState extends State<PS7Page> {
  int _elapsedTime = 0;
  bool _isRunning = false;
  Timer? _timer;

  // Memulai timer
  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    widget.onBookingStatusChanged(true); // Update status ke "Terboking"

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });
  }

  // Menghentikan timer
  void _stopTimer() {
    if (!_isRunning) return;

    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });

    widget.onBookingStatusChanged(false); // Update status ke "Kosong"

    final total = (_elapsedTime / 3600 * 10000).ceil();
    final perMinute = total / 60; // Tarif per menit

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Biaya Penyewaan'),
        content: Text(
          'Waktu Main: ${_elapsedTime ~/ 3600}j ${(_elapsedTime % 3600) ~/ 60}m ${_elapsedTime % 60}s\n'
          'Total Biaya (per jam): Rp$total\n'
          'Biaya per Menit: Rp${perMinute.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Reset timer
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _elapsedTime = 0;
      _isRunning = false;
    });

    widget.onBookingStatusChanged(false); // Update status ke "Kosong"
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PlayStation 4',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Menampilkan waktu yang telah berlalu
            Text(
              'Waktu Berlalu: ${_elapsedTime ~/ 3600}j ${(_elapsedTime % 3600) ~/ 60}m ${_elapsedTime % 60}s',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Tombol untuk mulai dan berhenti timer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                  child: Text(
                    'Mulai Timer',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isRunning ? _stopTimer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                  child: Text(
                    'Berhenti Timer',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Tombol untuk mereset timer
            ElevatedButton(
              onPressed: _resetTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              child: Text(
                'Reset Timer',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 30),

            // Menampilkan status booking
            Text(
              _isRunning ? 'Terboking' : 'Kosong',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _isRunning ? Colors.green : Colors.red),
            ),
            SizedBox(height: 20),

            // Keterangan tarif
            Text(
              'Tarif: Rp. 10.000 per jam',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
