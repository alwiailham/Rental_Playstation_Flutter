import 'dart:async';

class TimerManager {
  int _elapsedTime = 0; // Waktu yang telah berlalu dalam detik
  bool _isRunning = false;
  Timer? _timer;
  final StreamController<int> _elapsedTimeController = StreamController<int>.broadcast();

  late bool isRunning;

  Stream<int> get elapsedTimeStream => _elapsedTimeController.stream;

  void startTimer() {
    if (_isRunning) return;

    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedTime++;
      _elapsedTimeController.add(_elapsedTime);
    });
  }

  void stopTimer() {
    if (!_isRunning) return;

    _isRunning = false;
    _timer?.cancel();
  }

  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    _elapsedTime = 0;
    _elapsedTimeController.add(_elapsedTime);
  }

  int get elapsedTime => _elapsedTime;

  void dispose() {
    _timer?.cancel();
    _elapsedTimeController.close();
  }
}
