import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shapes.dart';

/// [Refactored] Phase 2.1 — Widget TextFormField tái sử dụng cho Auth screens.
///
/// Hỗ trợ 2 style: [AuthFieldStyle.card] (login/register) và
/// [AuthFieldStyle.surface] (forgot/change password).
enum AuthFieldStyle { card, surface }

class AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool enabled;
  final AuthFieldStyle style;

  const AuthInputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.style = AuthFieldStyle.card,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      enabled: enabled,
      style: const TextStyle(fontSize: 16),
      decoration: _buildDecoration(),
    );
  }

  InputDecoration _buildDecoration() {
    switch (style) {
      case AuthFieldStyle.card:
        return InputDecoration(
          labelText: labelText,
          hintText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          prefixIcon: Icon(prefixIcon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: AppShapes.card,
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppShapes.card,
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppShapes.card,
            borderSide:
                const BorderSide(color: AppColors.textPrimary, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        );

      case AuthFieldStyle.surface:
        return InputDecoration(
          labelText: labelText,
          labelStyle:
              const TextStyle(fontSize: 16, color: AppColors.textPrimary),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 16),
          prefixIcon: Icon(prefixIcon, color: Colors.black, size: 24),
          filled: true,
          fillColor: AppColors.surfaceColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          border: OutlineInputBorder(
            borderRadius: AppShapes.button,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppShapes.button,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppShapes.button,
            borderSide:
                const BorderSide(color: AppColors.textPrimary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppShapes.button,
            borderSide:
                const BorderSide(color: AppColors.errorRed, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppShapes.button,
            borderSide:
                const BorderSide(color: AppColors.errorRed, width: 2),
          ),
        );
    }
  }
}
