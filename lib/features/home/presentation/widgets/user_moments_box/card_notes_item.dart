import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_shapes.dart';
import '../../../../../data/models/moment_note_model.dart';

/// Card Note Item - Hiển thị một ghi chú cá nhân trong user moments list
///
/// Bao gồm: avatar, tên, timestamp, nội dung text, media grid
class CardNoteItem extends StatelessWidget {
  final MomentNote note;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onTap;

  const CardNoteItem({
    super.key,
    required this.note,
    this.onAvatarTap,
    this.onTap,
  });

  /// Format DateTime -> "2:40 PM 02/28/2026"
  String _formatTimestamp(DateTime dateTime) {
    final timeFormat = DateFormat('h:mm a');
    final dateFormat = DateFormat('MM/dd/yyyy');
    return '${timeFormat.format(dateTime)} ${dateFormat.format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppShapes.paddingM),
        padding: const EdgeInsets.all(AppShapes.paddingM),
        decoration: BoxDecoration(
          color: AppColors.backgroundPost,
          borderRadius: AppShapes.card,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: avatar + name + timestamp
            _buildHeader(),

            // Text content
            if (note.hasText) ...[
              const SizedBox(height: 12),
              _buildTextContent(),
            ],

            // Media content
            if (note.hasMedia) ...[
              const SizedBox(height: 12),
              _buildMediaContent(),
            ],
          ],
        ),
      ),
    );
  }

  /// Header row: avatar, author name, timestamp
  Widget _buildHeader() {
    return Row(
      children: [
        // Avatar
        GestureDetector(
          onTap: onAvatarTap,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: note.authorAvatarUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 40,
                height: 40,
                color: AppColors.surfaceColor,
                child: const Icon(
                  Icons.person,
                  size: 20,
                  color: AppColors.textHint,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 40,
                height: 40,
                color: AppColors.surfaceColor,
                child: const Icon(
                  Icons.person,
                  size: 20,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Name + Timestamp
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.authorName,
                style: AppTextStyles.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                _formatTimestamp(note.createdAt),
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Text content section
  Widget _buildTextContent() {
    return Text(note.textContent, style: AppTextStyles.bodyLarge);
  }

  /// Media content - hiển thị grid ảnh/video
  Widget _buildMediaContent() {
    final mediaCount = note.mediaUrls.length;

    if (mediaCount == 1) {
      return _buildSingleMedia(note.mediaUrls.first);
    }

    if (mediaCount == 2) {
      return Row(
        children: [
          Expanded(child: _buildMediaTile(note.mediaUrls[0], height: 180)),
          const SizedBox(width: 4),
          Expanded(child: _buildMediaTile(note.mediaUrls[1], height: 180)),
        ],
      );
    }

    if (mediaCount == 3) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildMediaTile(note.mediaUrls[0], height: 200),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              children: [
                _buildMediaTile(note.mediaUrls[1], height: 98),
                const SizedBox(height: 4),
                _buildMediaTile(note.mediaUrls[2], height: 98),
              ],
            ),
          ),
        ],
      );
    }

    // 4+ images: 2x2 grid with "+N" overlay
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildMediaTile(note.mediaUrls[0], height: 120)),
            const SizedBox(width: 4),
            Expanded(child: _buildMediaTile(note.mediaUrls[1], height: 120)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(child: _buildMediaTile(note.mediaUrls[2], height: 120)),
            const SizedBox(width: 4),
            Expanded(
              child: mediaCount > 4
                  ? _buildMediaTileWithOverlay(
                      note.mediaUrls[3],
                      height: 120,
                      remainingCount: mediaCount - 4,
                    )
                  : _buildMediaTile(note.mediaUrls[3], height: 120),
            ),
          ],
        ),
      ],
    );
  }

  /// Single media - full width
  Widget _buildSingleMedia(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 220,
          color: AppColors.surfaceColor,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.textHint,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 220,
          color: AppColors.surfaceColor,
          child: const Icon(
            Icons.broken_image_outlined,
            size: 40,
            color: AppColors.textHint,
          ),
        ),
      ),
    );
  }

  /// Media tile for grid layout
  Widget _buildMediaTile(String url, {required double height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: height,
          color: AppColors.surfaceColor,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.textHint,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: height,
          color: AppColors.surfaceColor,
          child: const Icon(
            Icons.broken_image_outlined,
            size: 28,
            color: AppColors.textHint,
          ),
        ),
      ),
    );
  }

  /// Media tile with "+N" overlay for remaining photos
  Widget _buildMediaTileWithOverlay(
    String url, {
    required double height,
    required int remainingCount,
  }) {
    return Stack(
      children: [
        _buildMediaTile(url, height: height),
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Text(
                  '+$remainingCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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
