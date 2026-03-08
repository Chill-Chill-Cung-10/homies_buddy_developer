import '../data/models/models.dart';

/// Chat Mock Data
///
/// Provides sample data for conversations and messages
class ChatMockData {
  // Current user ID
  static const String currentUserId = 'user_01';

  // Mock conversations
  static final List<Conversation> mockConversations = [
    Conversation(
      id: 'conv_01',
      participantIds: ['user_01', 'user_02'],
      participantName: 'Salahhh Home with Mickeyy',
      participantAvatar: 'https://picsum.photos/800/450?random=10',
      lastMessage: 'Hey! How is your garden doing? 🌻',
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
    ),
    Conversation(
      id: 'conv_02',
      participantIds: ['user_01', 'user_03'],
      participantName: 'Cozy Corner Cottage',
      participantAvatar: 'https://picsum.photos/150/150?random=102',
      lastMessage: 'Thanks for the help yesterday!',
      lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv_03',
      participantIds: ['user_01', 'user_04'],
      participantName: 'Sunny Valley Home',
      participantAvatar: 'https://picsum.photos/150/150?random=103',
      lastMessage: 'Can you water my plants this weekend?',
      lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
      unreadCount: 1,
    ),
    Conversation(
      id: 'conv_04',
      participantIds: ['user_01', 'user_05'],
      participantName: 'Peaceful Haven',
      participantAvatar: 'https://picsum.photos/150/150?random=104',
      lastMessage: 'The flowers are blooming beautifully! 🌸',
      lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv_05',
      participantIds: ['user_01', 'user_06'],
      participantName: 'Meadow House',
      participantAvatar: 'https://picsum.photos/150/150?random=105',
      lastMessage: 'See you at the community garden!',
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv_06',
      participantIds: ['user_01', 'user_07'],
      participantName: 'Garden Grove',
      participantAvatar: 'https://picsum.photos/150/150?random=106',
      lastMessage: 'Just harvested some tomatoes 🍅',
      lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
      unreadCount: 0,
    ),
  ];

  // Mock messages for conversation 'conv_01'
  static final List<Message> mockMessages = [
    Message(
      id: 'msg_01',
      conversationId: 'conv_01',
      senderId: 'user_02',
      content: 'Hey! How are you doing?',
      type: MessageType.text,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      status: MessageStatus.seen,
    ),
    Message(
      id: 'msg_02',
      conversationId: 'conv_01',
      senderId: 'user_01',
      content: "I'm great! Just finished planting some new flowers 🌷",
      type: MessageType.text,
      createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 55)),
      status: MessageStatus.seen,
    ),
    Message(
      id: 'msg_03',
      conversationId: 'conv_01',
      senderId: 'user_02',
      content: 'That sounds wonderful! Which flowers did you plant?',
      type: MessageType.text,
      createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
      status: MessageStatus.seen,
    ),
    Message(
      id: 'msg_04',
      conversationId: 'conv_01',
      senderId: 'user_01',
      content: 'Mostly tulips and daisies. They should bloom in a few weeks!',
      type: MessageType.text,
      createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
      status: MessageStatus.seen,
    ),
    Message(
      id: 'msg_05',
      conversationId: 'conv_01',
      senderId: 'user_01',
      content:
          'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=400',
      type: MessageType.image,
      createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 40)),
      status: MessageStatus.seen,
    ),
    Message(
      id: 'msg_06',
      conversationId: 'conv_01',
      senderId: 'user_02',
      content: 'Beautiful! I love the colors 💐',
      type: MessageType.text,
      createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
      status: MessageStatus.seen,
    ),
    Message(
      id: 'msg_07',
      conversationId: 'conv_01',
      senderId: 'user_02',
      content: 'Hey! How is your garden doing? 🌻',
      type: MessageType.text,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      status: MessageStatus.delivered,
    ),
  ];

  // Active homes (for story-style avatars)
  static final List<Map<String, String>> activeHomes = [
    {
      'id': 'user_02',
      'name': 'Salahhh',
      'avatar': 'https://picsum.photos/800/450?random=10',
    },
    {
      'id': 'user_08',
      'name': 'Rose',
      'avatar': 'https://picsum.photos/150/150?random=102',
    },
    {
      'id': 'user_09',
      'name': 'Lily',
      'avatar': 'https://picsum.photos/150/150?random=103',
    },
    {
      'id': 'user_10',
      'name': 'Daisy',
      'avatar': 'https://picsum.photos/150/150?random=104',
    },
    {
      'id': 'user_11',
      'name': 'Peony',
      'avatar': 'https://picsum.photos/150/150?random=105',
    },
  ];

  /// Get total unread count across all conversations
  static int getTotalUnreadCount() {
    return mockConversations.fold(0, (sum, conv) => sum + conv.unreadCount);
  }

  /// Get messages for a specific conversation
  static List<Message> getMessagesForConversation(String conversationId) {
    // For demo purposes, return mock messages for conv_01
    if (conversationId == 'conv_01') {
      return mockMessages;
    }
    return [];
  }

  /// Mark conversation as read
  static void markConversationAsRead(String conversationId) {
    final index = mockConversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      mockConversations[index] = mockConversations[index].copyWith(
        unreadCount: 0,
      );
    }
  }
}
