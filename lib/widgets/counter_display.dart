import 'package:flutter/material.dart';
import 'package:lab_1/styles/styles.dart';

// Невеличкий “презентаційний” віджет (аналог dumb component у React)
class CounterDisplay extends StatelessWidget {
  const CounterDisplay({super.key, required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Лічильник', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Text('$value', key: ValueKey(value), style: counterTextStyle),
        ),
      ],
    );
  }
}
