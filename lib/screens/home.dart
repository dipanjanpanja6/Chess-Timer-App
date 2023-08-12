import 'package:flutter/material.dart';

class ChessClockScreen extends StatefulWidget {
  const ChessClockScreen({super.key});

  @override
  State<ChessClockScreen> createState() => _ChessClockScreenState();
}

class _ChessClockScreenState extends State<ChessClockScreen> {
  late DateTime _player1StartTime;
  late DateTime _player2StartTime;
  Duration _player1Time = const Duration(minutes: 5);
  Duration _player2Time = const Duration(minutes: 5);
  bool _isPlayer1Active = true;
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: _isPlayer1Active ? 2 : 1,
              child: RotatedBox(
                  quarterTurns: 2,
                  child: GestureDetector(
                      onTap: () {
                        if (!_isRunning) {
                          setState(() {
                            _isPlayer1Active = true;
                          });
                          startTimer();
                        }
                      },
                      child: buildPlayerTimer(_isPlayer1Active, _player1Time)))),
          Container(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: _isRunning ? null : startTimer, icon: const Icon(Icons.play_arrow)),
                  const SizedBox(width: 20),
                  IconButton(onPressed: _isRunning ? stopTimer : null, icon: const Icon(Icons.stop)),
                  const SizedBox(width: 20),
                  IconButton(onPressed: resetTimer, icon: const Icon(Icons.refresh)),
                ],
              ),
            ),
          ),
          Expanded(
              flex: _isPlayer1Active ? 1 : 2,
              child: GestureDetector(
                  onTap: () {
                    if (!_isRunning) {
                      setState(() {
                        _isPlayer1Active = false;
                      });
                      startTimer();
                    }
                  },
                  child: buildPlayerTimer(!_isPlayer1Active, _player2Time))),
        ],
      ),
    );
  }

  Widget buildPlayerTimer(bool isActive, Duration time) {
    return Container(
      color: isActive ? Colors.blue : Colors.transparent, // Set the background color
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isActive ? 'Player 1' : 'Player 2', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Text(formatDuration(time), style: const TextStyle(fontSize: 48)),
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
      Future.delayed(const Duration(seconds: 1), runTimer);
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
      _player1Time = const Duration(minutes: 5);
      _player2Time = const Duration(minutes: 5);
      _player1StartTime = DateTime.now();
      _player2StartTime = DateTime.now();
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
