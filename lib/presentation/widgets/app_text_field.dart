
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visionscan/vision.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;

  const AppTextField({
    super.key,
    required this.controller,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines,
    this.enabled = true,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      enabled: enabled,
      style: context.bodyLarge,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppTheme.colors.text)
            : null,
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: context.bodyMediumLarge.copyWith(
          color: AppTheme.colors.text.withAlpha(100),
        ),
        filled: true,
        fillColor: AppTheme.colors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
