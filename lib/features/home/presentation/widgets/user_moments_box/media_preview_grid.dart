import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/app_colors.dart';
import 'media_grid_item.dart';

/// Reusable media preview grid widget
/// Can be used anywhere that needs to display a grid of selected media
class MediaPreviewGrid extends StatelessWidget {
  final List<XFile> mediaFiles;
  final Function(int) onRemoveMedia;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final String? title;
  final EdgeInsets? padding;
  final bool showTitle;

  const MediaPreviewGrid({
    super.key,
    required this.mediaFiles,
    required this.onRemoveMedia,
    this.crossAxisCount = 3,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    this.title,
    this.padding,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    if (mediaFiles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          Padding(
            padding: padding ?? const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title ?? 'Attachments (${mediaFiles.length})',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
          ),
          itemCount: mediaFiles.length,
          itemBuilder: (context, index) {
            return MediaGridItem(
              file: mediaFiles[index],
              onRemove: () => onRemoveMedia(index),
            );
          },
        ),
      ],
    );
  }
}
