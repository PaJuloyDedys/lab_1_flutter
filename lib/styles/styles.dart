import 'package:flutter/material.dart';

final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF6F7FB),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 16),
  ),
);

const pagePadding = EdgeInsets.all(20);

const counterTextStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.w700,
  color: Color(0xFF3730A3),
);

const messageTextStyle = TextStyle(fontSize: 16, color: Colors.black87);

final inputDecoration = InputDecoration(
  labelText: 'Введи число або "Avada Kedavra"',
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  filled: true,
  fillColor: Colors.white,
);

const inputTextStyle = TextStyle(fontSize: 16);

final buttonStyle = FilledButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);
