import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/post_repository.dart';
import '../../data/repositories/comment_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../services/firebase_service.dart';
import '../services/storage_service.dart';

// =============================================================================
// SERVICE PROVIDERS - Singleton instances
// =============================================================================

/// Firebase Service provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService.instance;
});

/// Storage Service provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// =============================================================================
// REPOSITORY PROVIDERS
// =============================================================================

/// User Repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

/// Post Repository provider
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

/// Comment Repository provider
final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepository();
});

/// Notification Repository provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

// =============================================================================
// CURRENT USER PROVIDER
// =============================================================================

/// Current authenticated user ID
final currentUserIdProvider = Provider<String?>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return firebaseService.currentUserId;
});

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  return userId != null;
});
