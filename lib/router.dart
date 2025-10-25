import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signup_screen.dart';

final class AppRoutes {
  static const home    = '/';
  static const login   = '/login';
  static const signup  = '/signup';
  static const profile = '/profile';

  static Route<dynamic> onGenerate(RouteSettings s) {
    switch (s.name) {
      case home:    return _page(const HomeScreen());
      case login:   return _page(const LoginScreen());
      case signup:  return _page(const SignupScreen());
      case profile: return _page(const ProfileScreen());
      default:      return _page(const HomeScreen());
    }
  }

  static MaterialPageRoute _page(Widget child) =>
      MaterialPageRoute(builder: (_) => child);
}
