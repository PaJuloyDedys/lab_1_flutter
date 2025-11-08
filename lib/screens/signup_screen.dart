import 'package:flutter/material.dart';
import 'package:lab_3/router.dart';
import 'package:lab_3/widgets/app_scaffold.dart';
import 'package:lab_3/widgets/app_text_field.dart';
import 'package:lab_3/widgets/auth_layout.dart';
import 'package:lab_3/widgets/primary_button.dart';
import 'package:lab_3/services.dart' as di;
import 'package:lab_3/domain/user.dart';
import 'package:lab_3/features/validators.dart';
import 'package:lab_3/data/local/local_auth_repo.dart' show hashPassword;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _S();
}

class _S extends State<SignupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  String? _err;
  bool _busy = false;

  Future<void> _signup() async {
    setState(() => _busy = true);
    _err = null;

    final en = validateName(name.text);
    final ee = validateEmail(email.text);
    final ep = validatePassword(pass.text);
    if ([en, ee, ep].any((e) => e != null)) {
      setState(() { _err = (en ?? ee) ?? ep; _busy = false; });
      return;
    }
    try {
      final hash = hashPassword(pass.text);
      await di.auth.register(User(email: email.text, name: name.text, hash: hash));
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
    } catch (ex) {
      setState(() => _err = ex.toString().replaceFirst('Exception: ', ''));
    }
    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext c) {
    return AppScaffold(
      title: 'Sign up',
      showAppBar: false,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: AutofillGroup(
          child: AuthLayout(
            title: 'Create account',
            subtitle: 'Start building your watchlist in seconds',
            children: [
              if (_err != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_err!, style: TextStyle(color: Theme.of(c).colorScheme.error)),
                ),
              AppTextField(
                controller: name, label: 'Name',
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: email, label: 'Email',
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: pass, label: 'Password', obscure: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _signup(),
                autofillHints: const [AutofillHints.newPassword],
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                onPressed: _busy ? () {} : _signup,
                text: _busy ? 'Please wait...' : 'Sign up',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
