/// Auth Domain Layer — Barrel Export
///
/// Import file này để access toàn bộ auth domain layer:
/// ```dart
/// import 'package:homies_buddy_developer/features/auth/domain/domain.dart';
/// ```
library;

// Entities
export 'entities/auth_user.dart';

// Repositories (Abstract interfaces)
export 'repositories/auth_repository.dart';

// UseCases
export 'usecases/usecases.dart';
