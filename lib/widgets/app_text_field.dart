import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscure = false,
    this.textInputAction,
    this.onSubmitted,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String label;
  final bool obscure;

  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final Iterable<String>? autofillHints;

  @override
  State<AppTextField> createState() => _S();
}

class _S extends State<AppTextField> {
  bool _hide = true;

  @override
  void initState() {
    super.initState();
    _hide = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscure ? _hide : false,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      autofillHints: widget.autofillHints,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.obscure
            ? IconButton(
          icon: Icon(_hide ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _hide = !_hide),
        )
            : null,
      ),
    );
  }
}
