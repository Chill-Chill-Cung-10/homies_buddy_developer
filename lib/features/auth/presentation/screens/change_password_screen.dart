import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/password_validator.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_submit_button.dart';

/// [Refactored] Phase 2.1 — Change Password Screen with Firebase Auth integration
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  // Password requirements state
  PasswordValidationResult _passwordValidation = const PasswordValidationResult(
    hasMinLength: false,
    hasUppercase: false,
    hasLowercase: false,
    hasNumber: false,
    hasSpecialChar: false,
  );

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_checkPasswordRequirements);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Check password requirements in real-time using shared validator
  void _checkPasswordRequirements() {
    final password = _newPasswordController.text;
    setState(() {
      _passwordValidation = PasswordValidator.validate(password);
    });
  }

  /// Validate current password
  String? _validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your current password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validate new password
  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }
    if (value == _currentPasswordController.text) {
      return 'New password must be different from current password';
    }
    if (!_passwordValidation.isValid) {
      return 'Password does not meet requirements';
    }
    return null;
  }

  /// Validate confirm password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Handle update password
  Future<void> _handleUpdatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authActions = ref.read(authActionsProvider);
    final success = await authActions.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to change password. Please check your current password.'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  /// Show success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.button),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.successGreen, size: 28),
            SizedBox(width: AppSpacing.s),
            Text('Success!', style: AppTextStyles.h3),
          ],
        ),
        content: const Text(
          'Your password has been changed successfully.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Back to previous screen
            },
            child: const Text('OK', style: AppTextStyles.buttonMedium),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Change Password', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppShapes.paddingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.m),

                // Current Password Field
                AuthPasswordField(
                  controller: _currentPasswordController,
                  labelText: 'Current Password',
                  hintText: 'Enter your current password',
                  validator: _validateCurrentPassword,
                  enabled: !_isLoading,
                  style: AuthFieldStyle.surface,
                ),

                const SizedBox(height: AppSpacing.l),

                // New Password Field
                AuthPasswordField(
                  controller: _newPasswordController,
                  labelText: 'New Password',
                  hintText: 'Enter your new password',
                  validator: _validateNewPassword,
                  enabled: !_isLoading,
                  style: AuthFieldStyle.surface,
                ),

                const SizedBox(height: AppSpacing.l),

                // Confirm New Password Field
                AuthPasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm New Password',
                  hintText: 'Re-enter your new password',
                  validator: _validateConfirmPassword,
                  textInputAction: TextInputAction.done,
                  enabled: !_isLoading,
                  style: AuthFieldStyle.surface,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Password Requirements Card
                Container(
                  padding: const EdgeInsets.all(AppShapes.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: AppShapes.button,
                    border: Border.all(color: AppColors.primaryPeach, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Password Requirements:',
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: AppSpacing.m),
                      _buildRequirementItem(
                        'At least 8 characters',
                        _passwordValidation.hasMinLength,
                      ),
                      _buildRequirementItem(
                        'One uppercase letter (A-Z)',
                        _passwordValidation.hasUppercase,
                      ),
                      _buildRequirementItem(
                        'One lowercase letter (a-z)',
                        _passwordValidation.hasLowercase,
                      ),
                      _buildRequirementItem('One number (0-9)', _passwordValidation.hasNumber),
                      _buildRequirementItem(
                        'One special character (!@#\$%^&*)',
                        _passwordValidation.hasSpecialChar,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Update Password Button
                AuthSubmitButton(
                  label: 'Update Password',
                  isLoading: _isLoading,
                  onPressed: _handleUpdatePassword,
                ),

                const SizedBox(height: AppSpacing.l),

                // Security tip
                Container(
                  padding: const EdgeInsets.all(AppShapes.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withOpacity(0.3),
                    borderRadius: AppShapes.button,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.security,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: Text(
                          'For your security, make sure to use a strong and unique password.',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build requirement item widget
  Widget _buildRequirementItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 20,
            color: isMet ? AppColors.successGreen : AppColors.textHint,
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isMet ? AppColors.successGreen : AppColors.textSecondary,
                decoration: isMet ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
