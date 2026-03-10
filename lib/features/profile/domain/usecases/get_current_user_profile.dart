import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

/// Get Current User Profile UseCase
class GetCurrentUserProfile {
  final ProfileRepository _repository;

  const GetCurrentUserProfile(this._repository);

  Future<Either<Failure, ProfileEntity>> call() {
    return _repository.getCurrentUserProfile();
  }
}
