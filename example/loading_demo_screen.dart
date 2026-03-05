import 'package:flutter/material.dart';
import 'package:homies_buddy_developer/core/constants/app_colors.dart';
import 'package:homies_buddy_developer/core/constants/app_text_styles.dart';
import 'package:homies_buddy_developer/core/constants/app_spacing.dart';
import 'package:homies_buddy_developer/core/widgets/feedback/shimmer_loading.dart';
import 'package:homies_buddy_developer/core/widgets/feedback/loading_indicator.dart';
import 'package:homies_buddy_developer/core/widgets/feedback/loading_overlay.dart';
import 'package:homies_buddy_developer/core/widgets/feedback/loading_screen.dart';

/// [Demo] — Loading States Demo Screen
/// 
/// Demonstrates all loading widgets and states:
/// - Shimmer loading (lazy loading)
/// - Loading indicators (various styles)
/// - Loading overlay
/// - Full screen loading
/// - Loading buttons
class LoadingDemoScreen extends StatefulWidget {
  const LoadingDemoScreen({super.key});

  @override
  State<LoadingDemoScreen> createState() => _LoadingDemoScreenState();
}

class _LoadingDemoScreenState extends State<LoadingDemoScreen> {
  bool _showOverlay = false;
  bool _shimmerLoading = true;
  bool _buttonLoading = false;
  bool _showFullScreenLoading = false;

  void _toggleOverlay() {
    setState(() => _showOverlay = !_showOverlay);
    if (_showOverlay) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showOverlay = false);
      });
    }
  }

  void _toggleShimmer() {
    setState(() => _shimmerLoading = !_shimmerLoading);
  }

  void _simulateButtonLoading() {
    setState(() => _buttonLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _buttonLoading = false);
    });
  }

  void _showFullScreenLoadingDemo() {
    setState(() => _showFullScreenLoading = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showFullScreenLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showFullScreenLoading) {
      return const LoadingScreen(
        message: 'Đang tải dữ liệu...\nVui lòng đợi trong giây lát',
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: Text(
          'Loading States Demo',
          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: LoadingOverlay(
        isLoading: _showOverlay,
        loadingText: 'Đang xử lý...',
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.m),
          children: [
            // Section 1: Loading Indicators
            _buildSectionHeader('1. Loading Indicators'),
            _buildCard(
              child: Column(
                children: [
                  _buildIndicatorRow(
                    'Circular',
                    const LoadingIndicator(
                      type: LoadingIndicatorType.circular,
                      size: 32,
                    ),
                  ),
                  const Divider(height: AppSpacing.xl),
                  _buildIndicatorRow(
                    'Dots',
                    const LoadingIndicator(
                      type: LoadingIndicatorType.dots,
                      size: 40,
                    ),
                  ),
                  const Divider(height: AppSpacing.xl),
                  _buildIndicatorRow(
                    'Bouncing Balls',
                    const LoadingIndicator(
                      type: LoadingIndicatorType.bouncingBalls,
                      size: 40,
                    ),
                  ),
                  const Divider(height: AppSpacing.xl),
                  _buildIndicatorRow(
                    'Rotating Squares',
                    const LoadingIndicator(
                      type: LoadingIndicatorType.rotatingSquares,
                      size: 40,
                    ),
                  ),
                  const Divider(height: AppSpacing.xl),
                  _buildIndicatorRow(
                    'Linear',
                    const LoadingIndicator(
                      type: LoadingIndicatorType.linear,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section 2: Shimmer Loading (Lazy Loading)
            _buildSectionHeader('2. Shimmer Loading (Lazy Loading)'),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Toggle Shimmer',
                        style: AppTextStyles.bodyMedium,
                      ),
                      Switch(
                        value: _shimmerLoading,
                        onChanged: (_) => _toggleShimmer(),
                        activeThumbColor: AppColors.primaryGreen,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ShimmerLoading(
                    isLoading: _shimmerLoading,
                    child: Column(
                      children: [
                        const ShimmerListItem(),
                        const SizedBox(height: AppSpacing.m),
                        const ShimmerCard(height: 180),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section 3: Loading Overlay
            _buildSectionHeader('3. Loading Overlay'),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overlay che phủ toàn bộ màn hình khi đang xử lý.',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton(
                    onPressed: _toggleOverlay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      'Show Overlay (3s)',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section 4: Loading Buttons
            _buildSectionHeader('4. Loading Buttons'),
            _buildCard(
              child: Column(
                children: [
                  LoadingButton(
                    label: 'Submit',
                    isLoading: _buttonLoading,
                    onPressed: _simulateButtonLoading,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  LoadingButton(
                    label: 'Disabled',
                    isLoading: false,
                    onPressed: null,
                    backgroundColor: AppColors.textHint,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section 5: Full Screen Loading
            _buildSectionHeader('5. Full Screen Loading'),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loading screen cho app initialization hoặc major transitions.',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton(
                    onPressed: _showFullScreenLoadingDemo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentOrange,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      'Show Full Screen Loading (3s)',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Section 6: Skeleton Loading
            _buildSectionHeader('6. Skeleton Loading Screen'),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Full screen skeleton cho lazy loading content.',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SkeletonLoadingScreen(
                            itemCount: 8,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      'View Skeleton Screen',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Code Examples
            _buildSectionHeader('📖 Usage Examples'),
            _buildCard(
              color: AppColors.cardBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCodeExample(
                    'Shimmer Loading:',
                    'ShimmerLoading(\n'
                        '  isLoading: true,\n'
                        '  child: ShimmerCard(),\n'
                        ')',
                  ),
                  const Divider(height: AppSpacing.l),
                  _buildCodeExample(
                    'Loading Overlay:',
                    'LoadingOverlay(\n'
                        '  isLoading: _isLoading,\n'
                        '  loadingText: "Processing...",\n'
                        '  child: YourContent(),\n'
                        ')',
                  ),
                  const Divider(height: AppSpacing.l),
                  _buildCodeExample(
                    'Loading Button:',
                    'LoadingButton(\n'
                        '  label: "Submit",\n'
                        '  isLoading: _isLoading,\n'
                        '  onPressed: () {},\n'
                        ')',
                  ),
                  const Divider(height: AppSpacing.l),
                  _buildCodeExample(
                    'Full Screen:',
                    'LoadingScreen(\n'
                        '  message: "Loading...",\n'
                        ')',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Text(
        title,
        style: AppTextStyles.h3.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child, Color? color}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: color ?? AppColors.backgroundPost,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildIndicatorRow(String label, Widget indicator) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium,
        ),
        indicator,
      ],
    );
  }

  Widget _buildCodeExample(String title, String code) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.textHint.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            code,
            style: AppTextStyles.bodySmall.copyWith(
              fontFamily: 'monospace',
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
