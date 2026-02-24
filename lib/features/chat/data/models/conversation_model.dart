/// Conversation Model
/// 
/// Represents a conversation between users/homes
class Conversation {
  final String id;
  final List<String> participantIds;
  final String participantName;  // Home name
  final String participantAvatar; // Home avatar
  final String lastMessage;
  final DateTime lastUpdated;
  final int unreadCount;
  final String? nickname;       // Custom nickname set by current user
  final DateTime? mutedUntil;   // Null = not muted, DateTime.max = muted forever

  const Conversation({
    required this.id,
    required this.participantIds,
    required this.participantName,
    required this.participantAvatar,
    required this.lastMessage,
    required this.lastUpdated,
    required this.unreadCount,
    this.nickname,
    this.mutedUntil,
  });

  /// Display name: nickname if set, otherwise participantName
  String get displayName => nickname?.isNotEmpty == true ? nickname! : participantName;

  /// Whether this conversation is currently muted
  bool get isMuted {
    if (mutedUntil == null) return false;
    return mutedUntil!.isAfter(DateTime.now());
  }

  Conversation copyWith({
    String? id,
    List<String>? participantIds,
    String? participantName,
    String? participantAvatar,
    String? lastMessage,
    DateTime? lastUpdated,
    int? unreadCount,
    String? nickname,
    DateTime? mutedUntil,
    bool clearNickname = false,
    bool clearMute = false,
  }) {
    return Conversation(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      participantName: participantName ?? this.participantName,
      participantAvatar: participantAvatar ?? this.participantAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      unreadCount: unreadCount ?? this.unreadCount,
      nickname: clearNickname ? null : (nickname ?? this.nickname),
      mutedUntil: clearMute ? null : (mutedUntil ?? this.mutedUntil),
    );
  }

  bool get hasUnread => unreadCount > 0;
}
