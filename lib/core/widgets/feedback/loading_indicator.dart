import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_spacing.dart';

/// [Loading Widget] — Various loading indicators.
/// 
/// Collection of different loading indicator styles:
/// - Circular (default)
/// - Linear progress
/// - Dots animation
/// - Bouncing balls
/// - Rotating squares

enum LoadingIndicatorType {
  circular,
  linear,
  dots,
  bouncingBalls,
  rotatingSquares,
}

class LoadingIndicator extends StatelessWidget {
  final LoadingIndicatorType type;
  final Color? color;
  final double size;
  final String? message;

  const LoadingIndicator({
    super.key,
    this.type = LoadingIndicatorType.circular,
    this.color,
    this.size = 40,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? AppColors.primaryGreen;

    Widget indicator;
    switch (type) {
      case LoadingIndicatorType.circular:
        indicator = _CircularIndicator(color: indicatorColor, size: size);
        break;
      case LoadingIndicatorType.linear:
        indicator = _LinearIndicator(color: indicatorColor);
        break;
      case LoadingIndicatorType.dots:
        indicator = _DotsIndicator(color: indicatorColor, size: size);
        break;
      case LoadingIndicatorType.bouncingBalls:
        indicator = _BouncingBallsIndicator(color: indicatorColor, size: size);
        break;
      case LoadingIndicatorType.rotatingSquares:
        indicator = _RotatingSquaresIndicator(color: indicatorColor, size: size);
        break;
    }

    if (message == null) {
      return indicator;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        const SizedBox(height: AppSpacing.m),
        Text(
          message!,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Circular progress indicator
class _CircularIndicator extends StatelessWidget {
  final Color color;
  final double size;

  const _CircularIndicator({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: 3,
      ),
    );
  }
}

/// Linear progress indicator
class _LinearIndicator extends StatelessWidget {
  final Color color;

  const _LinearIndicator({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        backgroundColor: color.withValues(alpha: 0.2),
      ),
    );
  }
}

/// Animated dots indicator
class _DotsIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const _DotsIndicator({
    required this.color,
    required this.size,
  });

  @override
  State<_DotsIndicator> createState() => _DotsIndicatorState();
}

class _DotsIndicatorState extends State<_DotsIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = (_controller.value - delay).clamp(0.0, 1.0);
            final scale = (Curves.easeInOut.transform(value) * 0.5) + 0.5;

            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.1),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size * 0.25,
                  height: widget.size * 0.25,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Bouncing balls indicator
class _BouncingBallsIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const _BouncingBallsIndicator({
    required this.color,
    required this.size,
  });

  @override
  State<_BouncingBallsIndicator> createState() =>
      _BouncingBallsIndicatorState();
}

class _BouncingBallsIndicatorState extends State<_BouncingBallsIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.15;
            final value = ((_controller.value - delay) % 1.0);
            final bounce = (Curves.easeInOut.transform(value) - 0.5).abs() * 2;

            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.1),
              child: Transform.translate(
                offset: Offset(0, -widget.size * 0.5 * bounce),
                child: Container(
                  width: widget.size * 0.25,
                  height: widget.size * 0.25,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(
                      alpha: 0.6 + (bounce * 0.4),
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Rotating squares indicator
class _RotatingSquaresIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const _RotatingSquaresIndicator({
    required this.color,
    required this.size,
  });

  @override
  State<_RotatingSquaresIndicator> createState() =>
      _RotatingSquaresIndicatorState();
}

class _RotatingSquaresIndicatorState extends State<_RotatingSquaresIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            children: List.generate(4, (index) {
              final angle = (_controller.value * 2 * 3.14159) + (index * 3.14159 / 2);
              final radius = widget.size * 0.3;
              final x = radius * (1 + (index % 2 == 0 ? 1 : -1) * 0.7);
              final y = radius * (1 + (index < 2 ? 1 : -1) * 0.7);

              return Positioned(
                left: x,
                top: y,
                child: Transform.rotate(
                  angle: angle,
                  child: Container(
                    width: widget.size * 0.25,
                    height: widget.size * 0.25,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(
                        alpha: 0.5 + (_controller.value * 0.5),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

/// Button with loading state
class LoadingButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;

  const LoadingButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.textPrimary,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                label,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: textColor ?? Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
