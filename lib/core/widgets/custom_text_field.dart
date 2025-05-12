import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueSetter? onChanged;
  final bool isPassword;
  final bool enabled;
  const CustomTextField({
    super.key,
    this.inputType,
    this.controller,
    this.onChanged,
    this.isPassword = false,
    required this.label,
    this.enabled = true, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextFormField(
          validator: validator,
          enabled: enabled,
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(color: Colors.grey),
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
          ),
        ),
      ],
    );
  }
}
