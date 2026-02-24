/// Help Chat Model - for Ask For Help assistant chat (bot-human interaction)
/// Renamed from chat_message_model.dart to distinguish from person-to-person messaging
library;

/// Chat message between user and help assistant bot
class HelpChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String> imageUrls;

  const HelpChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imageUrls = const [],
  });

  HelpChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    List<String>? imageUrls,
  }) {
    return HelpChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}

/// Help conversation history item (saved chat sessions with bot)
class HelpConversationHistory {
  final String id;
  final String title;
  final String preview;
  final DateTime lastMessageAt;
  final List<HelpChatMessage> messages;

  const HelpConversationHistory({
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
