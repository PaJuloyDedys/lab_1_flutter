import 'package:flutter/material.dart';
import 'package:lab_2/styles/styles.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: pageMaxWidth),
          child: Padding(padding: pagePadding, child: child),
        ),
      ),
    );
  }
}
