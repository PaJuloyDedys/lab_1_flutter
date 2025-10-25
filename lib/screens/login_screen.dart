import 'package:flutter/material.dart';
import 'package:lab_2/router.dart';
import 'package:lab_2/widgets/app_scaffold.dart';
import 'package:lab_2/widgets/app_text_field.dart';
import 'package:lab_2/widgets/auth_layout.dart';
import 'package:lab_2/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Sign in',
      child: AuthLayout(
        title: 'Welcome back 👋',
        children: [
          AppTextField(controller: email, label: 'Email'),
          const SizedBox(height: 12),
          AppTextField(controller: pass, label: 'Password', obscure: true),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Sign in',
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
            child: const Text('Create an account'),
          ),
        ],
      ),
    );
  }
}
