import 'package:flutter/material.dart';

class AppShadows {
  static const light = BoxShadow(
    offset: Offset(0, 4),
    blurRadius: 12,
    color: Color.fromRGBO(255, 255, 255, 0.7),
  );

  static const dark = BoxShadow(
    offset: Offset(0, 6),
    blurRadius: 18,
    color: Color.fromRGBO(160, 120, 90, 0.18),
  );

  static const softNeumorphic = [light, dark];
}
