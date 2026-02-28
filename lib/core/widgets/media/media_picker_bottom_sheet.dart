import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

/// [Refactored] Phase 1.2 — Tách từ common_widgets.dart.
///
/// Bottom sheet để chọn media (ảnh / video).
/// Sử dụng ở bất cứ đâu cần chọn media:
/// ```dart
/// final result = await MediaPickerBottomSheet.show(context);
/// if (result == 'photo') { ... }
/// ```
class MediaPickerBottomSheet extends StatelessWidget {
  final VoidCallback? onPhotoTap;
  final VoidCallback? onVideoTap;
  final String photoLabel;
  final String videoLabel;
  final IconData photoIcon;
  final IconData videoIcon;

  const MediaPickerBottomSheet({
    super.key,
    this.onPhotoTap,
    this.onVideoTap,
    this.photoLabel = 'Choose Photo',
    this.videoLabel = 'Choose Video',
    this.photoIcon = Icons.photo_library,
    this.videoIcon = Icons.videocam,
  });

  /// Hiển thị bottom sheet và trả về lựa chọn ('photo' hoặc 'video').
  static Future<String?> show(
    BuildContext context, {
    String photoLabel = 'Choose Photo',
    String videoLabel = 'Choose Video',
    IconData photoIcon = Icons.photo_library,
    IconData videoIcon = Icons.videocam,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(photoIcon, color: Colors.brown.shade600),
                title: Text(
                  photoLabel,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                onTap: () => Navigator.pop(ctx, 'photo'),
              ),
              ListTile(
                leading: Icon(videoIcon, color: Colors.brown.shade600),
                title: Text(
                  videoLabel,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                onTap: () => Navigator.pop(ctx, 'video'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(photoIcon, color: Colors.brown.shade600),
              title: Text(
                photoLabel,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              onTap: onPhotoTap,
            ),
            ListTile(
              leading: Icon(videoIcon, color: Colors.brown.shade600),
              title: Text(
                videoLabel,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              onTap: onVideoTap,
            ),
          ],
        ),
      ),
    );
  }
}
