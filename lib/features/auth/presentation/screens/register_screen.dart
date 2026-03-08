import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../../core/utils/password_validator.dart';
import '../../../../core/widgets/system_notification_popup.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_submit_button.dart';

/// [Refactored] Phase 2.1 — Register Screen with Firebase Auth integration
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _selectedDateOfBirth;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_.]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, dots and underscores';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // Use shared password validator for consistent rules
    if (!PasswordValidator.isValid(value)) {
      return 'Password does not meet requirements';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateDateOfBirth() {
    if (_selectedDateOfBirth == null) {
      return 'Please select your date of birth';
    }
    final age = DateTime.now().difference(_selectedDateOfBirth!).inDays ~/ 365;
    if (age < 13) {
      return 'You must be at least 13 years old';
    }
    return null;
  }

  Future<void> _showDatePicker() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Select your date of birth',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate date of birth
    final dateError = _validateDateOfBirth();
    if (dateError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(dateError),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept Terms & Conditions'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    final authActions = ref.read(authActionsProvider);
    await authActions.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullName: _fullNameController.text.trim(),
      username: _usernameController.text.trim(),
      dateOfBirth: _selectedDateOfBirth,
    );

    // Check for errors after sign up attempt
    final authState = ref.read(authStateProvider);
    if (authState.isError && mounted) {
      SystemNotificationPopup.error(
        context,
        message: authState.errorMessage ?? 'Registration failed',
      );
    } else if (authState.isAuthenticated && mounted) {
      // Sign out the newly created user
      await authActions.signOut();

      // Show success message
      if (mounted) {
        SystemNotificationPopup.success(
          context,
          message: 'Account created successfully! Please sign in.',
        );
      }

      // Navigate back to login screen
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _navigateToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppShapes.paddingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppShapes.paddingXL),

                // Logo
                Center(
                  child: Image.asset(
                    AppAssets.logo,
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPeach,
                          borderRadius: AppShapes.icon,
                        ),
                        child: const Icon(
                          Icons.eco,
                          size: 60,
                          color: AppColors.primaryGreen,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppShapes.paddingXL),

                // Title
                Text(
                  'Create Amicute Account',
                  style: AppTextStyles.h1,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppShapes.paddingS),

                // Subtitle
                Text(
                  'Prepare to get into pets world',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppShapes.paddingXL),

                // Full Name Field
                AuthInputField(
                  controller: _fullNameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icons.person_outline,
                  enabled: !isLoading,
                  validator: _validateFullName,
                ),

                const SizedBox(height: AppShapes.paddingM),

                // Username Field
                AuthInputField(
                  controller: _usernameController,
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  prefixIcon: Icons.alternate_email,
                  enabled: !isLoading,
                  validator: _validateUsername,
                ),

                const SizedBox(height: AppShapes.paddingM),

                // Email Field
                AuthInputField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isLoading,
                  validator: _validateEmail,
                ),

                const SizedBox(height: AppShapes.paddingM),

                // Password Field
                AuthPasswordField(
                  controller: _passwordController,
                  enabled: !isLoading,
                  validator: _validatePassword,
                ),

                const SizedBox(height: AppShapes.paddingM),

                // Confirm Password Field
                AuthPasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  enabled: !isLoading,
                  validator: _validateConfirmPassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: _handleRegister,
                ),

                const SizedBox(height: AppShapes.paddingM),

                // Date of Birth Field
                GestureDetector(
                  onTap: isLoading ? null : _showDatePicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppShapes.paddingM,
                      vertical: AppShapes.paddingM,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppShapes.button,
                      border: Border.all(
                        color: _selectedDateOfBirth == null
                            ? AppColors.textHint
                            : AppColors.primaryGreen,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cake_outlined,
                          color: _selectedDateOfBirth == null
                              ? AppColors.textHint
                              : AppColors.primaryGreen,
                        ),
                        const SizedBox(width: AppShapes.paddingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date of Birth',
                                style: AppTextStyles.caption.copyWith(
                                  color: _selectedDateOfBirth == null
                                      ? AppColors.textHint
                                      : AppColors.primaryGreen,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedDateOfBirth == null
                                    ? 'Select your date of birth'
                                    : '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: _selectedDateOfBirth == null
                                      ? AppColors.textHint
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: _selectedDateOfBirth == null
                              ? AppColors.textHint
                              : AppColors.primaryGreen,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppShapes.paddingM),

                // Terms & Conditions Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _acceptedTerms = value ?? false;
                              });
                            },
                      activeColor: AppColors.primaryGreen,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: isLoading
                            ? null
                            : () {
                                setState(() {
                                  _acceptedTerms = !_acceptedTerms;
                                });
                              },
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.bodySmall,
                            children: [
                              const TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppShapes.paddingL),

                // Register Button
                AuthSubmitButton(
                  label: isLoading ? 'Creating account...' : 'Sign Up',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _handleRegister,
                ),

                const SizedBox(height: AppShapes.paddingL),

                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTextStyles.bodyMedium,
                    ),
                    TextButton(
                      onPressed: isLoading ? null : _navigateToLogin,
                      child: Text(
                        'Sign In',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppShapes.paddingL),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.textHint)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppShapes.paddingM,
                      ),
                      child: Text('OR', style: AppTextStyles.caption),
                    ),
                    Expanded(child: Divider(color: AppColors.textHint)),
                  ],
                ),

                const SizedBox(height: AppShapes.paddingL),

                // Google Sign Up
                ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () {
                          // TODO: Implement Google Sign Up
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Google Sign Up coming soon!'),
                            ),
                          );
                        },
                  icon: const Icon(
                    Icons.g_mobiledata,
                    size: 24,
                    color: AppColors.textPrimary,
                  ),
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppShapes.button,
                      side: const BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                ),

                const SizedBox(height: AppShapes.paddingXL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
