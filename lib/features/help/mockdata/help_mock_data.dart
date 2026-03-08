import '../data/models/help_chat_model.dart';

/// Mock data for Ask For Help screen
class HelpMockData {
  /// Welcome message
  static const String welcomeMessage =
      "Hi there! How can I help you grow today?";

  /// Help suggestion cards
  static const List<HelpSuggestion> helpSuggestions = [
    HelpSuggestion(
      id: 'suggestion_1',
      title: 'Watering Your Fern - Every 3 Days',
      iconType: IconType.plant,
    ),
    HelpSuggestion(
      id: 'suggestion_2',
      title: 'Brushing Your Sheep - Daily Connection',
      iconType: IconType.pet,
    ),
    HelpSuggestion(
      id: 'suggestion_3',
      title: 'Pet Health Check - Monthly Tips',
      iconType: IconType.health,
    ),
    HelpSuggestion(
      id: 'suggestion_4',
      title: 'Training Basics - Start Here',
      iconType: IconType.training,
    ),
  ];

  /// Bot auto-responses (simulated AI)
  static String getBotResponse(String userMessage) {
    final lower = userMessage.toLowerCase();

    if (lower.contains('water') ||
        lower.contains('fern') ||
        lower.contains('plant')) {
      return "Great question! 🌿 For ferns, water every 3 days and keep the soil moist but not soggy. "
          "Place them in indirect sunlight and mist the leaves occasionally for best results!";
    }
    if (lower.contains('brush') ||
        lower.contains('sheep') ||
        lower.contains('groom')) {
      return "Brushing your pet regularly is wonderful! 🐑 For daily grooming:\n"
          "• Use a soft-bristle brush\n"
          "• Brush in the direction of fur growth\n"
          "• Check for tangles and mats\n"
          "• Make it a bonding experience!";
    }
    if (lower.contains('health') ||
        lower.contains('check') ||
        lower.contains('vet')) {
      return "Pet health is so important! 🏥 Here are monthly tips:\n"
          "• Check ears, eyes, and teeth\n"
          "• Monitor weight changes\n"
          "• Keep vaccinations up to date\n"
          "• Watch for behavioral changes";
    }
    if (lower.contains('train') || lower.contains('basic')) {
      return "Training is a great journey! 🎯 Start with these basics:\n"
          "• Keep sessions short (5-10 minutes)\n"
          "• Use positive reinforcement\n"
          "• Be consistent with commands\n"
          "• Practice patience and celebrate small wins!";
    }
    if (lower.contains('hello') ||
        lower.contains('hi') ||
        lower.contains('hey')) {
      return "Hello there! 👋 I'm your Homies Buddy assistant. "
          "I can help with plant care, pet grooming, training tips, and more. What would you like to know?";
    }
    if (lower.contains('thank')) {
      return "You're welcome! 😊 Happy to help. Feel free to ask anything else!";
    }
    return "That's a great question! 🤔 I'm here to help with pet care, plant tips, "
        "grooming advice, and training guidance. Could you tell me a bit more about what you need?";
  }

  /// Conversation history mock data
  static List<HelpConversationHistory> get conversationHistories => [
    HelpConversationHistory(
      id: 'conv_1',
      userId: 'current_user',
      title: 'Fern Care Tips',
      preview: 'How often should I water my fern?',
      lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
      messages: [
        HelpChatMessage(
          id: 'msg_1_1',
          conversationId: 'conv_1',
          text: 'How often should I water my fern?',
          isUser: true,
          timestamp: DateTime.now().subtract(
            const Duration(hours: 2, minutes: 5),
          ),
        ),
        HelpChatMessage(
          id: 'msg_1_2',
          conversationId: 'conv_1',
          text: getBotResponse('water fern'),
          isUser: false,
          timestamp: DateTime.now().subtract(
            const Duration(hours: 2, minutes: 4),
          ),
        ),
        HelpChatMessage(
          id: 'msg_1_3',
          conversationId: 'conv_1',
          text: 'Thank you! That helps a lot.',
          isUser: true,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        HelpChatMessage(
          id: 'msg_1_4',
          conversationId: 'conv_1',
          text: getBotResponse('thank'),
          isUser: false,
          timestamp: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 59),
          ),
        ),
      ],
    ),
    HelpConversationHistory(
      id: 'conv_2',
      userId: 'current_user',
      title: 'Pet Training',
      preview: 'How do I start training my puppy?',
      lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
      messages: [
        HelpChatMessage(
          id: 'msg_2_1',
          conversationId: 'conv_2',
          text: 'How do I start training my puppy?',
          isUser: true,
          timestamp: DateTime.now().subtract(
            const Duration(days: 1, minutes: 10),
          ),
        ),
        HelpChatMessage(
          id: 'msg_2_2',
          conversationId: 'conv_2',
          text: getBotResponse('training basics'),
          isUser: false,
          timestamp: DateTime.now().subtract(
            const Duration(days: 1, minutes: 9),
          ),
        ),
      ],
    ),
    HelpConversationHistory(
      id: 'conv_3',
      userId: 'current_user',
      title: 'Health Checkup',
      preview: 'When should I take my cat to the vet?',
      lastMessageAt: DateTime.now().subtract(const Duration(days: 3)),
      messages: [
        HelpChatMessage(
          id: 'msg_3_1',
          conversationId: 'conv_3',
          text: 'When should I take my cat to the vet?',
          isUser: true,
          timestamp: DateTime.now().subtract(
            const Duration(days: 3, minutes: 5),
          ),
        ),
        HelpChatMessage(
          id: 'msg_3_2',
          conversationId: 'conv_3',
          text: getBotResponse('health check vet'),
          isUser: false,
          timestamp: DateTime.now().subtract(
            const Duration(days: 3, minutes: 4),
          ),
        ),
      ],
    ),
  ];
}
