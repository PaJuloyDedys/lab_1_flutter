import 'package:flutter/material.dart';
import 'package:lab_1/widgets/counter_display.dart';
import 'package:lab_1/styles/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  int _counter = 0;
  String _message = '';

  void _handleInput() {
    final text = _controller.text.trim();

    if (text.toLowerCase() == 'avada kedavra') {
      setState(() {
        _counter = 0;
        _message = '💀 Лічильник скинуто.';
      });
    } else {
      final n = int.tryParse(text);
      if (n != null) {
        setState(() {
          _counter += n;
          _message = '➕ Додано $n до лічильника.';
        });
      } else {
        setState(() {
          _message = '⚠️ Введи ціле число або "Avada Kedavra".';
        });
      }
    }

    _controller.clear();
  }

  void _inc() => setState(() => _counter++);
  void _reset() => setState(() => _counter = 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 1 — Interactive Input')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: pagePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CounterDisplay(value: _counter),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  style: inputTextStyle,
                  decoration: inputDecoration,
                  onSubmitted: (_) => _handleInput(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        style: buttonStyle,
                        onPressed: _handleInput,
                        icon: const Icon(Icons.input),
                        label: const Text('Підтвердити'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filledTonal(
                      onPressed: _inc,
                      tooltip: '+1',
                      icon: const Icon(Icons.add),
                    ),
                    const SizedBox(width: 8),
                    IconButton.outlined(
                      onPressed: _reset,
                      tooltip: 'Скинути',
                      icon: const Icon(Icons.restart_alt),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_message, style: messageTextStyle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
