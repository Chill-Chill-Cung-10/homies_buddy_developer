import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'navigation_provider.dart';

/// Data class for a navigation destination.
class NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// A spinning icon button that expands into a vertical dropdown of
/// navigation destinations.
///
/// **Behaviour:**
/// - Tap → button spins 360° and four destination icons drop-down.
/// - The icon for the current screen is highlighted.
/// - Tapping a destination navigates immediately and collapses the menu.
/// - Tapping outside the menu closes it with a reverse spin.
///
/// The widget reads navigation state from [NavigationProvider] when
/// [currentIndex] / [onNavigate] are not supplied explicitly.
class SpinningNavButton extends StatefulWidget {
  /// Explicit current tab index. Falls back to [NavigationProvider].
  final int? currentIndex;

  /// Explicit navigation callback. Falls back to [NavigationProvider].
  final ValueChanged<int>? onNavigate;

  /// Icon colour for the main button (defaults to white for dark backgrounds).
  final Color iconColor;

  /// Highlight colour for the selected navigation item.
  final Color highlightColor;

  const SpinningNavButton({
    super.key,
    this.currentIndex,
    this.onNavigate,
    this.iconColor = Colors.white,
    this.highlightColor = const Color(0xFFB5D4A8), // AppColors.primaryGreen
  });

  /// The four fixed navigation destinations.
  static const List<NavItem> navItems = [
    NavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
    NavItem(
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      label: 'Community',
    ),
    NavItem(icon: Icons.help_outline, selectedIcon: Icons.help, label: 'Help'),
    NavItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  State<SpinningNavButton> createState() => _SpinningNavButtonState();
}

class _SpinningNavButtonState extends State<SpinningNavButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  // ── Resolved values (explicit or from provider) ──────────────────────
  int get _currentIndex {
    if (widget.currentIndex != null) return widget.currentIndex!;
    return NavigationProvider.maybeOf(context)?.currentIndex ?? 0;
  }

  ValueChanged<int>? get _onNavigate {
    return widget.onNavigate ?? NavigationProvider.maybeOf(context)?.onNavigate;
  }

  // ── Lifecycle ────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  // ── Menu logic ───────────────────────────────────────────────────────
  void _toggleMenu() {
    _isOpen ? _closeMenu() : _openMenu();
  }

  void _openMenu() {
    setState(() => _isOpen = true);
    _controller.forward();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeMenu() {
    _controller.reverse().then((_) {
      _removeOverlay();
      if (mounted) setState(() => _isOpen = false);
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Navigate to [index] immediately — overlay is removed synchronously so
  /// it never lingers when IndexedStack switches the visible child.
  void _onItemTap(int index) {
    _removeOverlay();
    _controller.reset();
    if (mounted) setState(() => _isOpen = false);
    _onNavigate?.call(index);
  }

  // ── Overlay ──────────────────────────────────────────────────────────
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (_) => AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.value == 0) return const SizedBox.shrink();
          return Stack(
            children: [
              // Semi-transparent barrier
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeMenu,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    color: Colors.black.withOpacity(0.12 * _controller.value),
                  ),
                ),
              ),
              // Dropdown items
              CompositedTransformFollower(
                link: _layerLink,
                targetAnchor: Alignment.bottomCenter,
                followerAnchor: Alignment.topCenter,
                offset: const Offset(0, 8),
                child: _buildDropdownItems(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDropdownItems() {
    final items = SpinningNavButton.navItems;
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (index) {
          final staggerDelay = index / items.length;
          final itemCurve = CurvedAnimation(
            parent: _controller,
            curve: Interval(
              staggerDelay * 0.35,
              0.35 + staggerDelay * 0.65,
              curve: Curves.easeOutBack,
            ),
          );
          return _NavItemWidget(
            item: items[index],
            animation: itemCurve,
            isSelected: index == _currentIndex,
            highlightColor: widget.highlightColor,
            onTap: () => _onItemTap(index),
          );
        }),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _isOpen
                    ? widget.highlightColor.withOpacity(0.9)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: Icon(
                    _isOpen ? Icons.close : Icons.menu,
                    key: ValueKey(_isOpen),
                    color: _isOpen ? Colors.white : widget.iconColor,
                    size: 24,
                  ),
                ),
                onPressed: _toggleMenu,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Private helper widget for each dropdown item ─────────────────────────
class _NavItemWidget extends StatelessWidget {
  final NavItem item;
  final Animation<double> animation;
  final bool isSelected;
  final Color highlightColor;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.item,
    required this.animation,
    required this.isSelected,
    required this.highlightColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final value = animation.value;
        return Transform.translate(
          offset: Offset(0, -16 * (1 - value)),
          child: Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Tooltip(
                  message: item.label,
                  preferBelow: false,
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? highlightColor
                            : AppColors.navBarBackground.withOpacity(0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: isSelected
                            ? Border.all(
                                color: Colors.white.withOpacity(0.6),
                                width: 2,
                              )
                            : null,
                      ),
                      child: Icon(
                        isSelected ? item.selectedIcon : item.icon,
                        color: isSelected ? Colors.white : AppColors.iconColor,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
