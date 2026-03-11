import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../community/mockdata/profile_mock_data.dart';
import '../../../community/presentation/screens/personal_profile_screen.dart';
import '../../data/models/conversation_model.dart';
import '../../data/repositories/chat_repository.dart';

/// Chat Detail Setting Screen — Firebase-backed
///
/// Không còn dùng ChatMockData. Mọi thay đổi (nickname, mute) đều
/// được persist qua [ChatRepository] và propagate lên parent qua callback.
class ChatDetailSettingScreen extends StatefulWidget {
  final Conversation conversation;
  final ChatRepository repository;
  final ValueChanged<Conversation> onConversationUpdated;

  const ChatDetailSettingScreen({
    super.key,
    required this.conversation,
    required this.repository,
    required this.onConversationUpdated,
  });

  @override
  State<ChatDetailSettingScreen> createState() =>
      _ChatDetailSettingScreenState();
}

class _ChatDetailSettingScreenState extends State<ChatDetailSettingScreen> {
  late Conversation _conversation;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
  }

  Future<void> _updateConversation(Conversation updated) async {
    setState(() => _conversation = updated);
    widget.onConversationUpdated(updated);

    // Persist to Firestore
    if (updated.nickname != widget.conversation.nickname) {
      await widget.repository.updateNickname(
        conversationId: updated.id,
        nickname: updated.nickname,
      );
    }
    if (updated.mutedUntil != widget.conversation.mutedUntil) {
      await widget.repository.updateMutedUntil(
        conversationId: updated.id,
        mutedUntil: updated.mutedUntil,
      );
    }
  }

  void _navigateToProfile() {
    final participantId = _conversation.participantIds.firstWhere(
      (id) => id != widget.repository.hashCode.toString(),
      orElse: () => _conversation.participantIds.last,
    );
    final userId = participantId.replaceAll(RegExp(r'_0'), '');
    final user = ProfileMockData.getUserByAuthorId(userId);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PersonalProfileScreen(user: user)),
    );
  }

  Future<void> _showMuteDialog() async {
    if (_conversation.isMuted) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Tắt thông báo',
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600)),
          content: Text('Thông báo đang được tắt. Bạn muốn bật lại?',
              style: AppTextStyles.bodyMedium),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Huỷ',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Bật lại',
                  style: TextStyle(color: AppColors.accentOrange)),
            ),
          ],
        ),
      );
      if (confirm == true) {
        await _updateConversation(_conversation.copyWith(mutedUntil: null));
      }
      return;
    }

    _MuteDuration? selected = _MuteDuration.oneHour;
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Tắt thông báo',
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _MuteDuration.values.map((d) {
              return RadioListTile<_MuteDuration>(
                value: d,
                groupValue: selected,
                onChanged: (v) => setDialogState(() => selected = v),
                activeColor: AppColors.accentOrange,
                title: Text(d.label, style: AppTextStyles.bodyMedium),
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Huỷ',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                if (selected != null) {
                  await _updateConversation(
                      _conversation.copyWith(mutedUntil: selected!.until));
                }
              },
              child: Text('OK',
                  style: TextStyle(
                      color: AppColors.accentOrange,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showNicknameDialog() async {
    final controller =
        TextEditingController(text: _conversation.nickname ?? '');
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Đặt biệt danh',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: _conversation.participantName,
            hintStyle: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.backgroundPost.withOpacity(0.6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Huỷ',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final newNick = controller.text.trim();
              await _updateConversation(_conversation.copyWith(
                  nickname: newNick.isEmpty ? null : newNick));
            },
            child: Text('OK',
                style: TextStyle(
                    color: AppColors.accentOrange,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPost.withOpacity(0.95),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Thông tin cuộc trò chuyện',
            style: AppTextStyles.bodyMedium
                .copyWith(fontWeight: FontWeight.w600)),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.cardGradient),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          child: Column(
            children: [
              const SizedBox(height: 32),
              _buildAvatarSection(),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textSecondary.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildOptionTile(
                        icon: Icons.person_outline_rounded,
                        label: 'Xem hồ sơ',
                        subtitle: _conversation.participantName,
                        onTap: _navigateToProfile,
                        showDivider: true,
                      ),
                      _buildOptionTile(
                        icon: _conversation.isMuted
                            ? Icons.notifications_off_rounded
                            : Icons.notifications_none_rounded,
                        label: 'Thông báo',
                        subtitle: _conversation.isMuted
                            ? 'Đang tắt đến ${_muteUntilText()}'
                            : 'Đang bật',
                        onTap: _showMuteDialog,
                        showDivider: true,
                      ),
                      _buildOptionTile(
                        icon: Icons.edit_outlined,
                        label: 'Biệt danh',
                        subtitle: _conversation.nickname?.isNotEmpty == true
                            ? _conversation.nickname!
                            : 'Chưa đặt biệt danh',
                        onTap: _showNicknameDialog,
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accentOrange, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentOrange.withOpacity(0.2),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: _conversation.participantAvatar.startsWith('http')
                ? Image.network(_conversation.participantAvatar,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _avatarFallback())
                : Image.asset(_conversation.participantAvatar,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _avatarFallback()),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _conversation.displayName,
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        if (_conversation.nickname?.isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Text(
            _conversation.participantName,
            style: AppTextStyles.caption
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(showDivider ? 0 : 20),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon,
                        color: AppColors.accentOrange, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label,
                            style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text(subtitle,
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      color: AppColors.textSecondary, size: 20),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
                height: 1,
                color: AppColors.textSecondary.withOpacity(0.12)),
          ),
      ],
    );
  }

  Widget _avatarFallback() => Container(
        color: AppColors.backgroundPost,
        child:
            Icon(Icons.person, color: AppColors.textSecondary, size: 40),
      );

  String _muteUntilText() {
    final until = _conversation.mutedUntil;
    if (until == null) return '';
    if (until.year >= 9999) return 'khi bật lại';
    final diff = until.difference(DateTime.now());
    if (diff.inHours >= 1) return '${diff.inHours}h nữa';
    return '${diff.inMinutes} phút nữa';
  }
}

enum _MuteDuration {
  oneHour('1 giờ'),
  fourHours('4 giờ'),
  eightHours('8 giờ'),
  forever('Cho đến khi bật lại');

  final String label;
  const _MuteDuration(this.label);

  DateTime get until {
    final now = DateTime.now();
    return switch (this) {
      _MuteDuration.oneHour => now.add(const Duration(hours: 1)),
      _MuteDuration.fourHours => now.add(const Duration(hours: 4)),
      _MuteDuration.eightHours => now.add(const Duration(hours: 8)),
      _MuteDuration.forever => DateTime(9999),
    };
  }
}
