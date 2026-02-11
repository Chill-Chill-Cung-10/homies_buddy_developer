/// Chat Message Model for Ask For Help screen
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String> imageUrls;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imageUrls = const [],
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    List<String>? imageUrls,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}

/// Conversation history item
class ConversationHistory {
  final String id;
  final String title;
  final String preview;
  final DateTime lastMessageAt;
  final List<ChatMessage> messages;

  const ConversationHistory({
    required this.id,
    required this.title,
    required this.preview,
    required this.lastMessageAt,
    this.messages = const [],
  });
}

/// Help suggestion card data
class HelpSuggestion {
  final String id;
  final String title;
  final IconType iconType;

  const HelpSuggestion({
    required this.id,
    required this.title,
    required this.iconType,
  });
}

/// Icon types for help suggestions (to avoid importing flutter in model)
enum IconType {
  plant,
  pet,
  health,
  training,
  nutrition,
  grooming,
}
