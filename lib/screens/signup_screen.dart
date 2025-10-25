import 'package:flutter/material.dart';
import 'package:lab_2/router.dart';
import 'package:lab_2/widgets/app_scaffold.dart';
import 'package:lab_2/widgets/app_text_field.dart';
import 'package:lab_2/widgets/auth_layout.dart';
import 'package:lab_2/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Sign up',
      child: AuthLayout(
        title: 'Create account',
        children: [
          AppTextField(controller: name, label: 'Name'),
          const SizedBox(height: 12),
          AppTextField(controller: email, label: 'Email'),
          const SizedBox(height: 12),
          AppTextField(controller: pass, label: 'Password', obscure: true),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Sign up',
            onPressed: () => Navigator.pushReplacementNamed(
              context,
              AppRoutes.home,
            ),
          ),
        ],
      ),
    );
  }
}
