import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';

/// Abstract Profile Repository — Domain Layer Interface
///
/// Không import Firebase/Supabase. Implementation nằm ở data layer.
abstract class ProfileRepository {
  // ═══════════════════════════════════════════════════════════════════════════
  // READ OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get current user profile
  Future<Either<Failure, ProfileEntity>> getCurrentUserProfile();

  /// Get profile by user ID
  Future<Either<Failure, ProfileEntity>> getProfileById(String userId);

  /// Get profile by username
  Future<Either<Failure, ProfileEntity>> getProfileByUsername(String username);

  // ═══════════════════════════════════════════════════════════════════════════
  // UPDATE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Update profile fields
  Future<Either<Failure, ProfileEntity>> updateProfile({
    String? fullName,
    String? username,
    String? avatarUrl,
    String? coverUrl,
    String? headline,
    String? bio,
    String? location,
  });

  /// Update avatar
  Future<Either<Failure, String>> updateAvatar(String localFilePath);

  /// Update cover image
  Future<Either<Failure, String>> updateCover(String localFilePath);

  // ═══════════════════════════════════════════════════════════════════════════
  // SOCIAL OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Follow a user
  Future<Either<Failure, Unit>> followUser(String userId);

  /// Unfollow a user
  Future<Either<Failure, Unit>> unfollowUser(String userId);

  /// Check if current user follows another user
  Future<Either<Failure, bool>> isFollowing(String userId);
}
