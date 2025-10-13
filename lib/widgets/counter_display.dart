// lib/widgets/counter_display.dart
import 'package:flutter/material.dart';
import 'package:lab_1/styles/styles.dart';

class CounterDisplay extends StatelessWidget {
  const CounterDisplay({
    super.key,
    required this.counter, // required спочатку
    this.message,
  });

  final int counter;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Лічильник: $counter', style: AppTextStyles.counter),
        if (message != null) ...[
          const SizedBox(height: 8),
          Text(message!, style: AppTextStyles.message),
        ],
      ],
    );
  }
}
