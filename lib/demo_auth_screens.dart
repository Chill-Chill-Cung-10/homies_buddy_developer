import 'package:flutter/material.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/change_password_screen.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'core/constants/app_shapes.dart';
import 'core/constants/app_spacing.dart';

/// Demo screen để test tất cả Authentication screens
/// Chạy: flutter run lib/demo_auth_screens.dart
void main() {
  runApp(const DemoAuthScreensApp());
}

class DemoAuthScreensApp extends StatelessWidget {
  const DemoAuthScreensApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Screens Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryPeach,
          secondary: AppColors.primaryGreen,
          background: AppColors.backgroundLight,
        ),
      ),
      home: const DemoHomeScreen(),
    );
  }
}

class DemoHomeScreen extends StatelessWidget {
  const DemoHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: const Text(
          'Auth Screens Demo',
          style: AppTextStyles.h2,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppShapes.paddingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App icon/logo placeholder
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryPeach,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_person,
                  size: 60,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Title
              const Text(
                'Welcome to\nHomies Buddy',
                style: AppTextStyles.h1,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.m),

              // Subtitle
              Text(
                'Select a screen to preview',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Button 1: Login Screen
              _buildScreenButton(
                context: context,
                label: 'Login Screen',
                icon: Icons.login,
      
                backgroundColor: AppColors.buttonPrimary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.m),

              // Button 2: Register Screen
              _buildScreenButton(
                context: context,
                label: 'Register Screen',
                icon: Icons.person_add,
                backgroundColor: AppColors.buttonSecondary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.m),

              // Button 3: Forgot Password Screen
              _buildScreenButton(
                context: context,
                label: 'Forgot Password Screen',
                icon: Icons.lock_reset,
                backgroundColor: AppColors.primaryPeach,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.m),

              // Button 4: Change Password Screen
              _buildScreenButton(
                context: context,
                label: 'Change Password Screen',
                icon: Icons.vpn_key,
                backgroundColor: AppColors.primaryGreen,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              // Info card
              Container(
                padding: const EdgeInsets.all(AppShapes.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.primaryPink.withOpacity(0.3),
                  borderRadius: AppShapes.button,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: Text(
                        'These screens are UI-only. Service integration will be added later.',
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
    );
  }

  /// Build screen button widget
  static Widget _buildScreenButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: AppColors.textPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.button,
          ),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: AppTextStyles.buttonLarge,
        ),
      ),
    );
  }
}
