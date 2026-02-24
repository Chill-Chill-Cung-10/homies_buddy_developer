import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/conversation_model.dart';
import '../../mockdata/chat_mock_data.dart';
import '../widgets/widgets.dart';
import 'chat_detail_screen.dart';

/// Chat List Screen
/// 
/// Displays list of conversations in a cozy, home-style interface
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Conversation> _allConversations = [];
  late List<Conversation> _filteredConversations;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadConversations();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadConversations() {
    _allConversations = ChatMockData.mockConversations;
    _filteredConversations = List<Conversation>.from(_allConversations);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredConversations = List<Conversation>.from(_allConversations);
      } else {
        _filteredConversations = _allConversations.where((conv) {
          return conv.displayName.toLowerCase().contains(query) ||
              conv.participantName.toLowerCase().contains(query) ||
              conv.lastMessage.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Messages',
              style: AppTextStyles.h2.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
        ),
        child: Column(
          children: [
            // Search Bar
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
                  decoration: InputDecoration(
                    hintText: 'Search conversations...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.close, color: AppColors.textSecondary, size: 20),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),

            // Conversations List
            Expanded(
              child: RefreshIndicator(
                color: AppColors.accentOrange,
                onRefresh: () async {
                  // TODO: Implement refresh
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() {});
                },
                child: _filteredConversations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 56, color: AppColors.textSecondary.withOpacity(0.4)),
                            const SizedBox(height: 12),
                            Text(
                              'No conversations found',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: _filteredConversations.length,
                  itemBuilder: (context, index) {
                    final conversation = _filteredConversations[index];
                    return ConversationCard(
                      conversation: conversation,
                      onTap: () {
                        // Mark as read when opening
                        ChatMockData.markConversationAsRead(conversation.id);
                        
                        // Navigate to chat detail
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatDetailScreen(
                              conversation: conversation,
                            ),
                          ),
                        ).then((_) {
                          // Refresh list after returning to pick up any updates (nickname, etc.)
                          setState(() {
                            _loadConversations();
                            _onSearchChanged(); // Reapply search filter if active
                          });
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
