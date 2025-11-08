import 'package:flutter/material.dart';
import 'package:lab_3/router.dart';
import 'package:lab_3/widgets/app_scaffold.dart';
import 'package:lab_3/widgets/app_text_field.dart';
import 'package:lab_3/widgets/auth_layout.dart';
import 'package:lab_3/widgets/primary_button.dart';
import 'package:lab_3/services.dart' as di;
import 'package:lab_3/features/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _S();
}

class _S extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  String? _err;
  bool _busy = false;

  Future<void> _login() async {
    setState(() => _busy = true);
    _err = null;
    final e = validateEmail(email.text);
    final p = pass.text.length >= 6 ? null : 'Min 6 chars';
    if (e != null || p != null) {
      setState(() { _err = e ?? p; _busy = false; });
      return;
    }
    try {
      await di.auth.login(email.text, pass.text);
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (ex) {
      setState(() => _err = ex.toString().replaceFirst('Exception: ', ''));
    }
    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext c) {
    return AppScaffold(
      title: 'Login',
      showAppBar: false,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: AutofillGroup(
          child: AuthLayout(
            title: 'Welcome back',
            subtitle: 'Sign in to manage your watchlist',
            children: [
              if (_err != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_err!, style: TextStyle(color: Theme.of(c).colorScheme.error)),
                ),
              AppTextField(
                controller: email, label: 'Email',
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: pass, label: 'Password', obscure: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _login(),
                autofillHints: const [AutofillHints.password],
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                onPressed: _busy ? () {} : _login,
                text: _busy ? 'Please wait...' : 'Sign in',
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
                child: const Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
