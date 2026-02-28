import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/common_widgets.dart';

/// A button with typing animation effect
/// Can be reused for any typing text animation needs
class TypingTextButton extends StatefulWidget {
  final VoidCallback onTap;
  final List<String> texts;
  final int typingSpeed;
  final int erasingSpeed;
  final int pauseDuration;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsets? padding;
  final TextStyle? textStyle;

  const TypingTextButton({
    super.key,
    required this.onTap,
    required this.texts,
    this.typingSpeed = 60,
    this.erasingSpeed = 35,
    this.pauseDuration = 1800,
    this.backgroundColor = const Color(0xFFFFF8F0),
    this.textColor = const Color(0xFF5D4037),
    this.height = 48,
    this.borderRadius,
    this.boxShadow,
    this.padding,
    this.textStyle,
  });

  @override
  State<TypingTextButton> createState() => _TypingTextButtonState();
}

class _TypingTextButtonState extends State<TypingTextButton> {
  int _textIndex = 0;
  String _displayText = '';
  bool _isTyping = true;
  int _charIndex = 0;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  void startAnimation() {
    _startTypingAnimation();
  }

  void stopAnimation() {
    _typingTimer?.cancel();
  }

  void _startTypingAnimation() {
    _typingTimer?.cancel();
    _charIndex = 0;
    _isTyping = true;
    _displayText = '';
    _tick();
  }

  void _tick() {
    _typingTimer = Timer(
      Duration(
          milliseconds: _isTyping ? widget.typingSpeed : widget.erasingSpeed),
      () {
        if (!mounted) return;

        final currentFullText = widget.texts[_textIndex];

        if (_isTyping) {
          if (_charIndex < currentFullText.length) {
            _charIndex++;
            setState(() {
              _displayText = currentFullText.substring(0, _charIndex);
            });
            _tick();
          } else {
            _typingTimer = Timer(Duration(milliseconds: widget.pauseDuration),
                () {
              if (!mounted) return;
              _isTyping = false;
              _tick();
            });
          }
        } else {
          if (_charIndex > 0) {
            _charIndex--;
            setState(() {
              _displayText = currentFullText.substring(0, _charIndex);
            });
            _tick();
          } else {
            _textIndex = (_textIndex + 1) % widget.texts.length;
            _isTyping = true;
            _typingTimer = Timer(const Duration(milliseconds: 400), () {
              if (!mounted) return;
              _tick();
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: widget.height,
        padding: widget.padding ??
            const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
          boxShadow: widget.boxShadow ??
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
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: _displayText,
                        style: widget.textStyle ??
                            TextStyle(
                              fontSize: 16,
                              color: widget.textColor,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: BlinkingCursor(
                          color: widget.textColor,
                          fontSize: widget.textStyle?.fontSize ?? 16,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
