import 'dart:async';
import 'package:flutter/material.dart';

/// Typing animation effect - characters appear gradually
class TypingAnimationText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final VoidCallback? onComplete;
  final Duration charDelay;

  const TypingAnimationText({
    super.key,
    required this.text,
    this.style,
    this.onComplete,
    this.charDelay = const Duration(milliseconds: 35),
  });

  @override
  State<TypingAnimationText> createState() => _TypingAnimationTextState();
}

class _TypingAnimationTextState extends State<TypingAnimationText> {
  String _displayedText = '';
  int _charIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.charDelay, (timer) {
      if (_charIndex < widget.text.length) {
        setState(() {
          _charIndex++;
          _displayedText = widget.text.substring(0, _charIndex);
        });
      } else {
        timer.cancel();
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_displayedText, style: widget.style);
  }
}
