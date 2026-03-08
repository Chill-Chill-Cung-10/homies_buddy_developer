import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Reusable input field for moments/posts
/// Can be customized and used in various contexts
class MomentsInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onAddPressed;
  final VoidCallback onSendPressed;
  final String hintText;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final double height;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final String sendIconPath;
  final bool enabled;

  const MomentsInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onAddPressed,
    required this.onSendPressed,
    this.hintText = 'Type something...',
    this.backgroundColor = const Color(0xFFFFF8F0),
    this.iconColor = const Color(0xFF5D4037),
    this.textColor = const Color(0xFF5D4037),
    this.height = 48,
    this.borderRadius,
    this.boxShadow,
    this.sendIconPath = 'assets/images/icons/send_button_icon.svg',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: Colors.brown.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: Row(
        children: [
          // Add circle button
          IconButton(
            onPressed: enabled ? onAddPressed : null,
            icon: Icon(Icons.add_circle, color: iconColor, size: 28),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),

          // Text input
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: iconColor.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                isDense: true,
              ),
            ),
          ),

          // Send button
          IconButton(
            onPressed: enabled ? onSendPressed : null,
            icon: SvgPicture.asset(
              sendIconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}
