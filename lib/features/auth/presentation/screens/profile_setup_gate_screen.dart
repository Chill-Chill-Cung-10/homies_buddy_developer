import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../profile/presentation/screens/profile_edit_screen.dart';
import '../providers/auth_providers.dart';

/// Shown when Firebase auth is valid but the app profile is missing in Supabase.
class ProfileSetupGateScreen extends ConsumerStatefulWidget {
  const ProfileSetupGateScreen({super.key});

  @override
  ConsumerState<ProfileSetupGateScreen> createState() =>
      _ProfileSetupGateScreenState();
}

class _ProfileSetupGateScreenState
    extends ConsumerState<ProfileSetupGateScreen> {
  bool _isRefreshing = false;

  Future<void> _openProfileSetup() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
    );

    if (!mounted) return;

    setState(() => _isRefreshing = true);
    await ref.read(authStateProvider.notifier).refreshAuthState();
    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  Future<void> _signOut() async {
    await ref.read(authActionsProvider).signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPeach,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppShapes.paddingL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  size: 72,
                  color: AppColors.primaryPink,
                ),
                const SizedBox(height: 20),
                Text(
                  'Complete your profile',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your Firebase session is valid, but your app profile is missing. Complete your profile to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isRefreshing ? null : _openProfileSetup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppShapes.button,
                      ),
                    ),
                    child: _isRefreshing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Set up profile'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _isRefreshing ? null : _signOut,
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
