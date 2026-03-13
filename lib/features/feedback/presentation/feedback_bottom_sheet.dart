import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/system_notification_popup.dart';
import '../data/feedback_providers.dart';

const _kGoogleFormUrl = 'https://forms.gle/3hPVddx1AjTPwrZd6';

class FeedbackBottomSheet extends ConsumerStatefulWidget {
  final String userId;
  final BuildContext parentContext;

  const FeedbackBottomSheet({
    super.key,
    required this.userId,
    required this.parentContext,
  });

  static Future<void> show(
    BuildContext context, {
    required String userId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FeedbackBottomSheet(
        userId: userId,
        parentContext: context,
      ),
    );
  }

  @override
  ConsumerState<FeedbackBottomSheet> createState() =>
      _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends ConsumerState<FeedbackBottomSheet>
    with SingleTickerProviderStateMixin {
  static const List<Map<String, String>> _moods = [
    {'emoji': '😑', 'label': 'Tệ'},
    {'emoji': '🤔', 'label': 'Tạm ổn'},
    {'emoji': '😊', 'label': 'Tốt'},
    {'emoji': '💓', 'label': 'Yêu thích!'},
    {'emoji': '🥰', 'label': 'Tuyệt đỉnh'},
  ];

  int? _selectedMood;
  bool _isSubmitting = false;
  bool _isDisposed = false;
  DateTime? _lastSelectionHapticAt;
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    // Delay forward() tới sau frame đầu để tránh crash khi widget chưa fully mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && mounted) {
        _animController.forward();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animController.stop();
    _animController.dispose();
    super.dispose();
  }

  void _handleMoodSelected(int index) {
    if (_isDisposed || !mounted) return;
    if (_selectedMood == index || _isSubmitting) return;

    final now = DateTime.now();
    final shouldTriggerHaptic =
        _lastSelectionHapticAt == null ||
        now.difference(_lastSelectionHapticAt!) >
            const Duration(milliseconds: 80);

    if (shouldTriggerHaptic) {
      HapticFeedback.selectionClick();
      _lastSelectionHapticAt = now;
    }

    if (mounted) {
      setState(() => _selectedMood = index);
    }
  }

  Future<void> _submit() async {
    if (_isDisposed || !mounted) return;

    if (_selectedMood == null) {
      HapticFeedback.lightImpact();
      SystemNotificationPopup.warning(
        context,
        message: 'Hãy đánh giá trải nghiệm của bạn',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (mounted) setState(() => _isSubmitting = true);
    HapticFeedback.mediumImpact();

    try {
      await ref.read(feedbackProvider.notifier).submitFeedback(
            userId: widget.userId,
            moodIndex: _selectedMood!,
            moodLabel: _moods[_selectedMood!]['label']!,
          );

      if (_isDisposed || !mounted) return;

      SystemNotificationPopup.success(
        widget.parentContext,
        message: 'Cảm ơn vì đã phản hồi!',
      );
      Navigator.pop(context);
    } catch (_) {
      if (_isDisposed || !mounted) return;

      if (mounted) setState(() => _isSubmitting = false);
      SystemNotificationPopup.error(
        context,
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> _skip() async {
    if (_isDisposed || !mounted || _isSubmitting) return;

    await ref
        .read(feedbackProvider.notifier)
        .skipFeedback(userId: widget.userId);

    if (!_isDisposed && mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _openGoogleForm() async {
    if (_isDisposed || !mounted) return;

    HapticFeedback.selectionClick();
    final uri = Uri.parse(_kGoogleFormUrl);
    try {
      final didLaunch = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!didLaunch && mounted) {
        SystemNotificationPopup.warning(
          context,
          message: 'Không mở được form. Vui lòng thử lại sau.',
        );
      }
    } catch (_) {
      if (mounted) {
        SystemNotificationPopup.error(
          context,
          message: 'Không mở được form. Vui lòng kiểm tra kết nối mạng.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Color(0x14A855F7),
              blurRadius: 40,
              offset: Offset(0, -8),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          16,
          24,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DragPill(),
            const SizedBox(height: 24),
            const _Header(),
            const SizedBox(height: 20),
            _MoodRow(
              moods: _moods,
              selected: _selectedMood,
              onSelect: _handleMoodSelected,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Divider(color: Color(0xFFF3E8FF), thickness: 1),
            ),
            _FormLinkCard(onTap: _openGoogleForm),
            const SizedBox(height: 16),
            _ActionButtons(
              isSubmitting: _isSubmitting,
              onSkip: _skip,
              onSubmit: _submit,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DragPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E0F5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFC084FC), Color(0xFF818CF8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x30A855F7),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Text('💗', style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(width: 12),
        // Expanded thay vì Column tự do — fix overflow
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                const TextSpan(
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(text: 'Share your '),
                    TextSpan(
                      text: 'vibe',
                      style: TextStyle(color: Color(0xFFA855F7)),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              const Text(
                'Bạn cảm thấy app chúng tôi như thế nào?',
                style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MoodRow extends StatelessWidget {
  final List<Map<String, String>> moods;
  final int? selected;
  final ValueChanged<int> onSelect;

  const _MoodRow({
    required this.moods,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(moods.length, (index) {
        final isActive = selected == index;

        return GestureDetector(
          onTap: () => onSelect(index),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                // Đổi sang easeOutCubic — tránh overshoot gây rebuild loop khi dispose nhanh
                curve: Curves.easeOutCubic,
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0x30A855F7)
                      : const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFFA855F7)
                        : const Color(0xFFE9D5FF),
                    width: 1.5,
                  ),
                  boxShadow: isActive
                      ? const [
                          BoxShadow(
                            color: Color(0x20A855F7),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    moods[index]['emoji']!,
                    style: TextStyle(fontSize: isActive ? 20 : 18),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                moods[index]['label']!,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? const Color(0xFFA855F7)
                      : const Color(0xFFC4B5FD),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _FormLinkCard extends StatelessWidget {
  final VoidCallback onTap;

  const _FormLinkCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFAF5FF), Color(0xFFEFF6FF)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE9D5FF), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE9D5FF), Color(0xFFDDD6FE)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('📋', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Want to share more?',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4C1D95),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Chỉ 2 phút thôi, hãy giúp tôi cùng cải thiện sản phẩm 🥰',
                    style: TextStyle(fontSize: 11, color: Color(0xFFC4B5FD)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFFA855F7),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onSkip;
  final VoidCallback onSubmit;

  const _ActionButtons({
    required this.isSubmitting,
    required this.onSkip,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: isSubmitting ? null : onSkip,
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE9D5FF), width: 1.5),
              ),
              child: Center(
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 13,
                    color: isSubmitting
                        ? const Color(0xFFD8B4FE)
                        : const Color(0xFFA78BFA),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: isSubmitting ? null : onSubmit,
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSubmitting
                      ? [const Color(0xFFD8B4FE), const Color(0xFFBAC5FB)]
                      : [const Color(0xFFA855F7), const Color(0xFF818CF8)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: isSubmitting
                    ? null
                    : const [
                        BoxShadow(
                          color: Color(0x35A855F7),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
              ),
              child: Center(
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Đã feedback!',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}