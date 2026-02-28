/// [Refactored] Phase 3.5 — Split into mock_users.dart, mock_pets.dart,
/// mock_user_posts.dart. This file delegates to those for backward compat.
library;
import '../../../data/models/user_model.dart';
import 'mock_users.dart';

export 'mock_users.dart';
export 'mock_pets.dart';
export 'mock_user_posts.dart';

/// Mock data cho Profile Screen — backward-compatible facade
class ProfileMockData {
  /// Lấy UserModel theo authorId
  static UserModel getUserByAuthorId(String authorId) =>
      MockUsers.getUserByAuthorId(authorId);

  /// Lấy UserModel theo username (cho mention tap)
  static UserModel? getUserByUsername(String username) =>
      MockUsers.getUserByUsername(username);
}

