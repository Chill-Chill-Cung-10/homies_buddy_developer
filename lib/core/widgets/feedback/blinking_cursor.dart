import 'package:flutter/material.dart';

/// [Refactored] Phase 1.2 — Tách từ common_widgets.dart.
///
/// Widget con trỏ nhấp nháy (blinking cursor) cho hiệu ứng đánh máy.
/// Có thể dùng lại bất cứ đâu cần animation typing.
class BlinkingCursor extends StatefulWidget {
  final Color color;
  final double fontSize;
  final String character;

  const BlinkingCursor({
    super.key,
    required this.color,
    this.fontSize = 16,
    this.character = '|',
  });

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);
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
        return Opacity(
          opacity: _controller.value,
          child: Text(
            widget.character,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w600,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}
