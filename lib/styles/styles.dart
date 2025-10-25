import 'package:flutter/material.dart';

final themeColor = Colors.indigo;
const pageMaxWidth = 560.0;

final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
  useMaterial3: true,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);

const pagePadding = EdgeInsets.all(16);

TextStyle get h1 => const TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
TextStyle get body => const TextStyle(fontSize: 16);
