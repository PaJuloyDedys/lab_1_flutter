import 'package:flutter/material.dart';
import 'package:lab_3/styles/styles.dart'; // заміни lab_2 на name з pubspec.yaml, якщо інший

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.showAppBar = true,
    this.actions,
  });

  final String title;
  final Widget child;
  final bool showAppBar;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: pageMaxWidth),
        child: Padding(padding: pagePadding, child: child),
      ),
    );

    return Scaffold(
      appBar: showAppBar ? AppBar(title: Text(title), actions: actions) : null,
      body: SafeArea(child: content),
    );
  }
}
