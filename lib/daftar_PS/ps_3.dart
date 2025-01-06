import 'package:flutter/material.dart';
import 'dart:async';

class TimerManager {
  static final TimerManager _instance = TimerManager._internal();
  factory TimerManager() => _instance;

  Timer? _timer;
  int elapsedTime = 0;
  bool isRunning = false;
  final List<VoidCallback> _listeners = [];

  TimerManager._internal();

  void startTimer() {
    if (isRunning) return;
    isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedTime++;
      _notifyListeners();
    });
  }

  void stopTimer() {
    _timer?.cancel();
    isRunning = false;
    _notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    elapsedTime = 0;
    isRunning = false;
    _notifyListeners();
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}

class PS3Page extends StatefulWidget {
  final int id;
  final String type;
  final Function(bool) onBookingStatusChanged;

  const PS3Page({
    Key? key,
    required this.id,
    required this.type,
    required this.onBookingStatusChanged,
  }) : super(key: key);

  @override
  _PS3PageState createState() => _PS3PageState();
}

class _PS3PageState extends State<PS3Page> {
  final TimerManager _timerManager = TimerManager();
  final int _tarifPerJam = 10000;

  @override
  void initState() {
    super.initState();
    _timerManager.addListener(_updateState);

    // Sinkronisasi status awal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_timerManager.isRunning) {
        widget.onBookingStatusChanged(true);
      }
    });
  }

  @override
  void dispose() {
    _timerManager.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showBillingDialog() {
    final int totalTime = _timerManager.elapsedTime; // Total waktu dalam detik
    final int totalCost = (totalTime / 3600 * _tarifPerJam).ceil(); // Total biaya
    final double perMinuteCost = _tarifPerJam / 60; // Tarif per menit

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.account_balance_wallet, color: Colors.greenAccent),
            SizedBox(width: 10),
            Text(
              'Biaya Penyewaan',
              style: TextStyle(fontFamily: 'RobotoMono', fontWeight: FontWeight.bold, color: Colors.greenAccent),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.grey[900],
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Waktu Main: ${totalTime ~/ 3600}j ${((totalTime % 3600) ~/ 60)}m ${totalTime % 60}s',
                style: TextStyle(fontSize: 18, fontFamily: 'RobotoMono', color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Total Biaya: Rp${totalCost.toString()}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'RobotoMono', color: Colors.greenAccent),
              ),
              SizedBox(height: 10),
              Text(
                'Tarif per Menit: Rp${perMinuteCost.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16, fontFamily: 'RobotoMono', color: Colors.white70),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.white),
              SizedBox(height: 10),
              Text(
                'Terima kasih telah menggunakan layanan kami!',
                style: TextStyle(fontSize: 16, fontFamily: 'RobotoMono', color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(fontFamily: 'RobotoMono', color: Colors.greenAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'PlayStation 3', // Diubah dari PlayStation 1 ke PlayStation 3
          style: TextStyle(fontFamily: 'RobotoMono', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Kembali ke halaman utama
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Ganti dengan Image.network untuk menggunakan gambar dari URL
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://cdn.pixabay.com/photo/2021/10/07/20/46/playstation-6689793_960_720.jpg'), // Ganti dengan URL gambar PlayStation
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay dengan warna hitam transparan untuk meningkatkan kontras teks
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          // Konten utama
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Menampilkan waktu yang telah berlalu
                Text(
                  'Waktu Berlalu: ${_timerManager.elapsedTime ~/ 3600}j ${((_timerManager.elapsedTime % 3600) ~/ 60)}m ${_timerManager.elapsedTime % 60}s',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 20),

                // Tombol untuk mulai dan berhenti timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _timerManager.isRunning
                          ? null
                          : () {
                              _timerManager.startTimer();
                              widget.onBookingStatusChanged(true);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Mulai Timer',
                        style: TextStyle(fontSize: 18, fontFamily: 'RobotoMono'),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _timerManager.isRunning
                          ? () {
                              _timerManager.stopTimer();
                              widget.onBookingStatusChanged(false);
                              _showBillingDialog(); // Menampilkan dialog biaya
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Berhenti Timer',
                        style: TextStyle(fontSize: 18, fontFamily: 'RobotoMono'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Tombol untuk mereset timer
                ElevatedButton(
                  onPressed: () {
                    _timerManager.resetTimer();
                    widget.onBookingStatusChanged(false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Reset Timer',
                    style: TextStyle(fontSize: 18, fontFamily: 'RobotoMono'),
                  ),
                ),
                SizedBox(height: 30),

                // Menampilkan status booking
                Text(
                  _timerManager.isRunning ? 'Terboking' : 'Kosong',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _timerManager.isRunning ? Colors.green : Colors.red,
                  ),
                ),
                SizedBox(height: 20),

                // Keterangan tarif
                Text(
                  'Tarif: Rp. 10.000 per jam',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
