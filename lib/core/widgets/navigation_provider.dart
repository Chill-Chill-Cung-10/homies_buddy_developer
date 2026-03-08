import 'package:flutter/material.dart';

/// InheritedWidget that provides navigation state to descendant widgets.
///
/// Wraps the screen tree in [MainNavigationScreen] so any widget
/// (e.g. [SpinningNavButton]) can read [currentIndex] and call [onNavigate]
/// without requiring explicit constructor parameters.
class NavigationProvider extends InheritedWidget {
  final int currentIndex;
  final ValueChanged<int> onNavigate;

  const NavigationProvider({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
    required super.child,
  });

  /// Obtain the nearest [NavigationProvider] ancestor.
  /// Throws if none is found.
  static NavigationProvider of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<NavigationProvider>();
    assert(result != null, 'No NavigationProvider found in context');
    return result!;
  }

  /// Returns null when no [NavigationProvider] ancestor exists.
  static NavigationProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NavigationProvider>();
  }

  @override
  bool updateShouldNotify(NavigationProvider oldWidget) {
    return currentIndex != oldWidget.currentIndex;
  }
}
