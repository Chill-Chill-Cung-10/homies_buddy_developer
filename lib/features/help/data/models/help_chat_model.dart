import 'package:freezed_annotation/freezed_annotation.dart';

part 'help_chat_model.freezed.dart';
part 'help_chat_model.g.dart';

/// Help Chat Message - Tin nhắn giữa user và Mimi AI bot
/// 
/// Renamed from chat_message_model.dart để phân biệt với person-to-person messaging
@freezed
abstract class HelpChatMessage with _$HelpChatMessage {
  const factory HelpChatMessage({
    required String id,
    
    /// ⭐ **Thêm mới** — Session ID để biết message này thuộc conversation nào
    required String conversationId,
    
    required String text,
    required bool isUser,
    required DateTime timestamp,
    @Default([]) List<String> imageUrls,
  }) = _HelpChatMessage;

  factory HelpChatMessage.fromJson(Map<String, dynamic> json) =>
      _$HelpChatMessageFromJson(json);
}

/// Extension để thêm các helper methods
extension HelpChatMessageX on HelpChatMessage {
  /// Kiểm tra xem là message từ user không
  bool get isFromUser => isUser;

  /// Kiểm tra xem là message từ bot không
  bool get isFromBot => !isUser;

  /// Kiểm tra xem có ảnh đính kèm không
  bool get hasImages => imageUrls.isNotEmpty;

  /// Lấy thời gian dạng "time ago"
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}

/// Help Conversation History - Lịch sử chat sessions với Mimi AI bot
@freezed
abstract class HelpConversationHistory with _$HelpConversationHistory {
  const factory HelpConversationHistory({
    required String id,

    /// ⭐ **Thêm mới** — User ID chủ sở hữu conversation
    required String userId,

    required String title,
    required String preview,
    required DateTime lastMessageAt,
    @Default([]) List<HelpChatMessage> messages,
  }) = _HelpConversationHistory;

  factory HelpConversationHistory.fromJson(Map<String, dynamic> json) =>
      _$HelpConversationHistoryFromJson(json);
}

/// Extension để thêm các helper methods
extension HelpConversationHistoryX on HelpConversationHistory {
  /// Đếm số tin nhắn
  int get messageCount => messages.length;

  /// Lấy message cuối cùng
  HelpChatMessage? get lastMessage =>
      messages.isNotEmpty ? messages.last : null;

  /// Lấy thời gian last message dạng "time ago"
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(lastMessageAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  /// Lấy preview cho danh sách (cắt ngắn)
  String get previewText {
    if (preview.length > 70) {
      return '${preview.substring(0, 70)}...';
    }
    return preview;
  }
}

/// Help Suggestion - Gợi ý trợ giúp
@freezed
abstract class HelpSuggestion with _$HelpSuggestion {
  const factory HelpSuggestion({
    required String id,
    required String title,
    required IconType iconType,
  }) = _HelpSuggestion;

  factory HelpSuggestion.fromJson(Map<String, dynamic> json) =>
      _$HelpSuggestionFromJson(json);
}

/// Icon types for help suggestions (to avoid importing flutter in model)
enum IconType {
  @JsonValue('plant')
  plant,

  @JsonValue('pet')
  pet,

  @JsonValue('health')
  health,

  @JsonValue('training')
  training,

  @JsonValue('nutrition')
  nutrition,

  @JsonValue('grooming')
  grooming;

  /// Display name
  String get displayName {
    switch (this) {
      case IconType.plant:
        return 'Cây cối';
      case IconType.pet:
        return 'Thú cưng';
      case IconType.health:
        return 'Sức khỏe';
      case IconType.training:
        return 'Huấn luyện';
      case IconType.nutrition:
        return 'Dinh dưỡng';
      case IconType.grooming:
        return 'Chăm sóc';
    }
  }

  /// Emoji icon
  String get emoji {
    switch (this) {
      case IconType.plant:
        return '🌱';
      case IconType.pet:
        return '🐾';
      case IconType.health:
        return '🏥';
      case IconType.training:
        return '🎓';
      case IconType.nutrition:
        return '🍖';
      case IconType.grooming:
        return '✂️';
    }
  }
}
