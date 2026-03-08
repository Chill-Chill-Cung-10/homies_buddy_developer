import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_shapes.dart';
import '../../../../../data/models/moment_note_model.dart';
import '../../../mock_data/mock_moment_notes.dart';
import 'card_notes_item.dart';

/// User Moments Box - Hiển thị danh sách ghi chú cá nhân
///
/// Sử dụng ListView để render danh sách [CardNoteItem]
/// Có thể truyền data thật hoặc dùng mock data để test
class UserMomentsBox extends StatelessWidget {
  final List<MomentNote>? notes;
  final bool useMockData;
  final VoidCallback? onAvatarTap;

  const UserMomentsBox({
    super.key,
    this.notes,
    this.useMockData = true,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayNotes =
        notes ?? (useMockData ? MockMomentNotes.sampleNotes : <MomentNote>[]);

    if (displayNotes.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppShapes.paddingM,
        vertical: AppShapes.paddingS,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayNotes.length,
      itemBuilder: (context, index) {
        return CardNoteItem(
          note: displayNotes[index],
          onAvatarTap: onAvatarTap,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppShapes.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.note_alt_outlined,
              size: 48,
              color: AppColors.textHint.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'No notes yet',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 4),
            Text('Share your first moment!', style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
