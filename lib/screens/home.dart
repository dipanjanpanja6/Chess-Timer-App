import 'package:flutter/material.dart';

class ChessClockScreen extends StatefulWidget {
  const ChessClockScreen({super.key});

  @override
  State<ChessClockScreen> createState() => _ChessClockScreenState();
}

class _ChessClockScreenState extends State<ChessClockScreen> {
  late DateTime _player1StartTime;
  late DateTime _player2StartTime;
  Duration _player1Time = Duration(minutes: 5);
  Duration _player2Time = Duration(minutes: 5);
  bool _isPlayer1Active = true;
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Clock'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isPlayer1Active ? 'Player 1' : 'Player 2',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              formatDuration(_isPlayer1Active ? _player1Time : _player2Time),
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : startTimer,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isRunning ? stopTimer : null,
                  child: const Text('Stop'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void startTimer() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
        if (_isPlayer1Active) {
          _player1StartTime = DateTime.now();
        } else {
          _player2StartTime = DateTime.now();
        }
      });

      runTimer();
    }
  }

  void runTimer() {
    setState(() {
      final now = DateTime.now();
      if (_isPlayer1Active) {
        _player1Time = _player1Time - (now.difference(_player1StartTime));
      } else {
        _player2Time = _player2Time - (now.difference(_player2StartTime));
      }

      if (_player1Time.isNegative || _player2Time.isNegative) {
        _isRunning = false;
      }
    });

    if (_isRunning) {
      Future.delayed(Duration(seconds: 1), runTimer);
    } else {
      switchPlayers();
    }
  }

  void stopTimer() {
    setState(() {
      _isRunning = false;
      if (_isPlayer1Active) {
        _player1StartTime = DateTime.now();
      } else {
        _player2StartTime = DateTime.now();
      }
    });
  }

  void resetTimer() {
    setState(() {
      _isRunning = false;
      _player1Time = Duration(minutes: 5);
      _player2Time = Duration(minutes: 5);
      _player1StartTime = null;
      _player2StartTime = null;
      _isPlayer1Active = true;
    });
  }

  void switchPlayers() {
    setState(() {
      _isPlayer1Active = !_isPlayer1Active;
    });
  }

  String formatDuration(Duration duration) {
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}
