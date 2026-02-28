
import 'package:flutter/material.dart';
import 'package:homies_buddy_developer/core/constants/app_assets.dart';
import 'package:homies_buddy_developer/core/constants/app_colors.dart';
import 'package:homies_buddy_developer/core/constants/app_shapes.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_submit_button.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'change_password_screen.dart';

/// [Refactored] Phase 2.1 — Sử dụng AuthInputField, AuthPasswordField,
/// AuthSubmitButton thay vì hardcode InputDecoration.
class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPeach,
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppShapes.paddingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // UI
              // Logo
              const SizedBox(height: 40),
              Image.asset(
                AppAssets.mascotBackRemoved,
                height: 100,
                width: 100
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'Welcome to Amicute World!',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Where pets connect hearts',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),
              
              // Email TextField
              AuthInputField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Password TextField
              AuthPasswordField(
                controller: _passwordController,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 8),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Login Button
              AuthSubmitButton(
                label: 'Login',
                onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login successful! (Demo Mode)'),
                          backgroundColor: AppColors.successGreen,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Future.delayed(const Duration(seconds: 1), () {
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangePasswordScreen(),
                            ),
                          );
                        }
                      });
                    }
                  },
              ),

              const SizedBox(height: 16),

              // Sign Up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 24),

              // Google Sign In
                ElevatedButton.icon(
                onPressed: () {
                  // TODO: Google Sign In
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

              const SizedBox(height: 12),
            ],
          ))
      ))
    );
  }
}