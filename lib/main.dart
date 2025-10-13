import 'package:flutter/material.dart';
import 'styles/styles.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 1 Flutter',
      theme: appTheme, // з styles.dart
      home: const HomeScreen(),
    );
  }
}
