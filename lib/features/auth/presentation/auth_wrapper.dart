import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../navigation/presentation/main_navigation_screen.dart';
import 'providers/auth_providers.dart';
import 'screens/login_screen.dart';
import 'screens/profile_setup_gate_screen.dart';

/// Auth Wrapper - Routes user based on authentication state
///
/// Shows:
/// - Loading spinner while checking auth state
/// - LoginScreen if not authenticated
/// - MainNavigationScreen if authenticated
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final needsProfileSetup = ref.watch(authNeedsProfileSetupProvider);

    return authState.when(
      initial: () => _buildLoadingScreen(),
      loading: () => _buildLoadingScreen(),
      authenticated: (user, _, _) => needsProfileSetup
          ? const ProfileSetupGateScreen()
          : const MainNavigationScreen(),
      unauthenticated: () => const LoginScreen(),
      error: (message, _) => _buildErrorScreen(context, ref, message),
    );
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      backgroundColor: AppColors.backgroundPeach,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primaryPink,
            ),
            SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context, WidgetRef ref, String message) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPeach,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.errorRed,
              ),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.read(authStateProvider.notifier).resetState();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
