import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shapes.dart';
import 'auth_input_field.dart';

/// [Refactored] Phase 2.1 — Password field với visibility toggle,
/// tái sử dụng cho tất cả Auth screens.
class AuthPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final bool enabled;
  final AuthFieldStyle style;
  final VoidCallback? onFieldSubmitted;

  const AuthPasswordField({
    super.key,
    required this.controller,
    this.labelText = 'Password',
    this.hintText = 'Enter your password',
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.style = AuthFieldStyle.card,
    this.onFieldSubmitted,
  });

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      enabled: widget.enabled,
      style: const TextStyle(fontSize: 16),
      onFieldSubmitted: widget.onFieldSubmitted != null
          ? (_) => widget.onFieldSubmitted!()
          : null,
      decoration: _buildDecoration(),
    );
  }

  InputDecoration _buildDecoration() {
    final suffixIcon = IconButton(
      icon: Icon(
        _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: widget.style == AuthFieldStyle.surface ? Colors.black : null,
      ),
      onPressed: () => setState(() => _obscure = !_obscure),
    );

    switch (widget.style) {
      case AuthFieldStyle.card:
        return InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          prefixIcon: const Icon(Icons.lock_outlined),
          suffixIcon: suffixIcon,
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
            borderSide: const BorderSide(
              color: AppColors.textPrimary,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
        );

      case AuthFieldStyle.surface:
        return InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 16),
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Colors.black,
            size: 24,
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: AppColors.surfaceColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
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
            borderSide: const BorderSide(
              color: AppColors.textPrimary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppShapes.button,
            borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppShapes.button,
            borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
          ),
        );
    }
  }
}
