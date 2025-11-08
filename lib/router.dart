import 'package:flutter/material.dart';
import 'package:lab_3/screens/login_screen.dart';
import 'package:lab_3/screens/signup_screen.dart';
import 'package:lab_3/screens/home_screen.dart';
import 'package:lab_3/screens/profile_screen.dart';
import 'package:lab_3/screens/movies_screen.dart';
import 'package:lab_3/screens/movie_details_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const profile = '/profile';
  static const movies = '/movies';
  static const movieDetails = '/movie';

  /// ✅ Саме це поле й підхоплює твій `main.dart`
  static Route<dynamic>? onGenerate(RouteSettings s) {
    switch (s.name) {
      case login:   return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:  return MaterialPageRoute(builder: (_) => const SignupScreen());
      case home:    return MaterialPageRoute(builder: (_) => const HomeScreen());
      case profile: return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case movies:  return MaterialPageRoute(builder: (_) => const MoviesScreen());
      case movieDetails:
        final id = s.arguments as int;
        return MaterialPageRoute(builder: (_) => MovieDetailsScreen(id: id));
    }
    return null;
  }
}
