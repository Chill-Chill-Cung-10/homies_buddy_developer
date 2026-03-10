import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Sign Out UseCase
class SignOut {
  final AuthRepository _repository;

  const SignOut(this._repository);

  Future<Either<Failure, Unit>> call() {
    return _repository.signOut();
  }
}
