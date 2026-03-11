import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/conversation_model.dart';
import '../../data/repositories/chat_repository.dart';
import '../widgets/widgets.dart';
import 'chat_detail_screen.dart';

/// Chat List Screen — Firebase-backed
///
/// Streams conversations real-time từ Firestore.
class ChatListScreen extends StatefulWidget {
  /// Repository được inject từ bên ngoài (DI / Provider / Riverpod)
  final ChatRepository repository;

  /// ID của current user (từ FirebaseAuth)
  final String currentUserId;

  const ChatListScreen({
    super.key,
    required this.repository,
    required this.currentUserId,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Conversation> _applySearch(List<Conversation> all) {
    if (_searchQuery.isEmpty) return all;
    final q = _searchQuery.toLowerCase();
    return all.where((c) =>
        c.displayName.toLowerCase().contains(q) ||
        c.participantName.toLowerCase().contains(q) ||
        c.lastMessage.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Messages',
          style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.cardGradient),
        child: Column(
          children: [
            // ── Search Bar ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundPost.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _searchController,
                  style: AppTextStyles.bodyMedium,
                  onChanged: (v) => setState(() => _searchQuery = v.trim()),
                  decoration: InputDecoration(
                    hintText: 'Search conversations...',
                    hintStyle: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                    prefixIcon:
                        Icon(Icons.search, color: AppColors.textSecondary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.close,
                                color: AppColors.textSecondary, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),

            // ── Conversations List ─────────────────────────────────
            Expanded(
              child: StreamBuilder<List<Conversation>>(
                stream: widget.repository
                    .watchConversations(widget.currentUserId),
                builder: (context, snapshot) {
                  // Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Lỗi kết nối: ${snapshot.error}',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  final all = snapshot.data ?? [];
                  final filtered = _applySearch(all);

                  // Empty
                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchQuery.isNotEmpty
                                ? Icons.search_off
                                : Icons.chat_bubble_outline,
                            size: 56,
                            color: AppColors.textSecondary.withOpacity(0.4),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No conversations found'
                                : 'No messages yet',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final conversation = filtered[index];
                      return ConversationCard(
                        conversation: conversation,
                        onTap: () async {
                          // Mark as read
                          await widget.repository.markConversationAsRead(
                            conversationId: conversation.id,
                            currentUserId: widget.currentUserId,
                          );

                          if (!context.mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatDetailScreen(
                                conversation: conversation,
                                repository: widget.repository,
                                currentUserId: widget.currentUserId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
