import 'package:chess_timer/screens/home.dart';
import 'package:flutter/material.dart';
// Import WidgetsFlutterBinding

void main() {
  runApp(const ChessClockApp());
}

class ChessClockApp extends StatelessWidget {
  const ChessClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChessClockScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
