import 'package:flutter/material.dart';
import 'package:homies_buddy_developer/core/constants/app_shapes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_assets.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_submit_button.dart';

/// [Refactored] Phase 2.1 — Sử dụng AuthInputField, AuthPasswordField,
/// AuthSubmitButton thay vì hardcode InputDecoration.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _acceptedTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
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
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
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

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      if (!_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept Terms & Conditions'),
            backgroundColor: AppColors.errorRed,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // TODO: Implement actual registration logic with service
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        
        // Navigate to login or home
        Navigator.pop(context);
      });
    }
  }

  void _navigateToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                        child: const Icon(Icons.eco, size: 60, color: AppColors.primaryGreen),
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
                  validator: _validateFullName,
                ),
                
                const SizedBox(height: AppShapes.paddingM),
                
                // Email Field
                AuthInputField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                
                const SizedBox(height: AppShapes.paddingM),
                
                // Password Field
                AuthPasswordField(
                  controller: _passwordController,
                  validator: _validatePassword,
                ),
                
                const SizedBox(height: AppShapes.paddingM),
                
                // Confirm Password Field
                AuthPasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  validator: _validateConfirmPassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: _handleRegister,
                ),
                
                const SizedBox(height: AppShapes.paddingM),
                
                // Terms & Conditions Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptedTerms = value ?? false;
                        });
                      },
                      activeColor: AppColors.primaryGreen,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
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
                  label: 'Sign Up',
                  isLoading: _isLoading,
                  onPressed: _handleRegister,
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
                      onPressed: _navigateToLogin,
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
                      padding: const EdgeInsets.symmetric(horizontal: AppShapes.paddingM),
                      child: Text('OR', style: AppTextStyles.caption),
                    ),
                    Expanded(child: Divider(color: AppColors.textHint)),
                  ],
                ),
                
                const SizedBox(height: AppShapes.paddingL),
                
                // Google Sign Up
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : () {
                    // TODO: Implement Google Sign Up
                  },
                  icon: const Icon(Icons.g_mobiledata, size: 24, color: AppColors.textPrimary),
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