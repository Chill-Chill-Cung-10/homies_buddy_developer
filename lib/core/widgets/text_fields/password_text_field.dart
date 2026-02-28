import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'custom_text_field.dart';

/// [Refactored] Phase 1.2 — Tách từ common_widgets.dart.
///
/// TextField cho mật khẩu với nút toggle hiện/ẩn password.
/// Bọc [CustomTextField] với thêm logic visibility.
class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputAction? textInputAction;

  const PasswordTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.enabled = true,
    this.textInputAction,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      obscureText: _obscureText,
      validator: widget.validator,
      enabled: widget.enabled,
      textInputAction: widget.textInputAction,
      prefixIcon: Icons.lock_outline,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
