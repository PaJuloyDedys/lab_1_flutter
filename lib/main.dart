import 'package:flutter/material.dart';
import 'router.dart';
import 'styles/styles.dart';

void main() => runApp(const MovieWatchlistApp());

class MovieWatchlistApp extends StatelessWidget {
  const MovieWatchlistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Watchlist',
      theme: appTheme,
      onGenerateRoute: AppRoutes.onGenerate,
      initialRoute: AppRoutes.login, // або AppRoutes.home, як вирішиш
      debugShowCheckedModeBanner: false,
    );
  }
}
