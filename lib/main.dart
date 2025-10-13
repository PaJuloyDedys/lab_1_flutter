import 'package:flutter/material.dart';
import 'package:lab_1/styles/styles.dart';
import 'package:lab_1/screens/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 1 Flutter',
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}
