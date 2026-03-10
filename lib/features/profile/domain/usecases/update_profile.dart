import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

/// Update Profile UseCase
class UpdateProfile {
  final ProfileRepository _repository;

  const UpdateProfile(this._repository);

  Future<Either<Failure, ProfileEntity>> call({
    String? fullName,
    String? username,
    String? avatarUrl,
    String? coverUrl,
    String? headline,
    String? bio,
    String? location,
  }) async {
    // Input validation
    if (username != null && username.trim().isNotEmpty) {
      final trimmedUsername = username.trim();
      if (trimmedUsername.length < 3) {
        return Left(ValidationFailure('Username phải có ít nhất 3 ký tự'));
      }
      if (!_isValidUsername(trimmedUsername)) {
        return Left(ValidationFailure('Username chỉ được chứa chữ cái, số và gạch dưới'));
      }
    }

    if (fullName != null && fullName.trim().isEmpty) {
      return Left(ValidationFailure('Họ tên không được để trống'));
    }

    return _repository.updateProfile(
      fullName: fullName?.trim(),
      username: username?.trim(),
      avatarUrl: avatarUrl,
      coverUrl: coverUrl,
      headline: headline?.trim(),
      bio: bio?.trim(),
      location: location?.trim(),
    );
  }

  bool _isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username);
  }
}
