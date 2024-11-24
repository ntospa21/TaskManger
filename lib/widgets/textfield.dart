import 'package:flutter/material.dart';

enum TextFieldType { simple, password }

class SBTextField extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final TextFieldType fieldType;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final String? Function(String?)? onChanged;

  const SBTextField(
      {super.key,
      required this.controller,
      required this.name,
      this.fieldType = TextFieldType.simple,
      this.textCapitalization = TextCapitalization.none,
      required this.inputType,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    bool obscureText = false;
    switch (fieldType) {
      case TextFieldType.simple:
        obscureText = false;
        break;
      case TextFieldType.password:
        obscureText = true;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        textCapitalization: textCapitalization,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: name,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
