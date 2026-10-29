import 'package:alberaperfume/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData prefixIcon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onSuffixIconPressed;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final AutovalidateMode autovalidateMode;

  const CustomFormTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.onSuffixIconPressed,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppTheme.gold,
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      autovalidateMode: autovalidateMode,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: AppTheme.gold),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: onSuffixIconPressed,
              )
            : null,
        filled: true,
        fillColor: AppTheme.ink,
        hintStyle: const TextStyle(color: AppTheme.gold),
        labelStyle: const TextStyle(color: AppTheme.gold),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.brown[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.brown[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.gold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
}
