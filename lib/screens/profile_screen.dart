import 'package:flutter/material.dart';
import 'package:lab_2/widgets/app_scaffold.dart';
import 'package:lab_2/widgets/app_text_field.dart';
import 'package:lab_2/widgets/primary_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final name = TextEditingController(text: 'User Name');
  final bio = TextEditingController(text: 'Movie enjoyer');

  @override
  void dispose() {
    name.dispose();
    bio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Profile',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
          const SizedBox(height: 16),
          AppTextField(controller: name, label: 'Display name'),
          const SizedBox(height: 12),
          AppTextField(controller: bio, label: 'Bio'),
          const SizedBox(height: 16),
          PrimaryButton(onPressed: () {}, text: 'Save'),
        ],
      ),
    );
  }
}
