# Flutter Clean Architecture — Convention Guide

> **Stack:** Flutter + Riverpod + Supabase/Firebase  
> **Pattern:** Feature-first + Clean Architecture  
> **Last updated:** 2026-03-08

---

## 1. Cấu Trúc Thư Mục

Mỗi feature **bắt buộc** có đủ 3 layer:

```
lib/
├── core/
│   ├── constants/
│   ├── errors/              # Failure, AppException
│   ├── extensions/
│   └── utils/
├── data/
│   ├── models/              # Shared models dùng nhiều feature
│   └── repositories/        # Shared repos
└── features/
    └── <feature_name>/
        ├── data/
        │   ├── datasources/
        │   │   ├── <feature>_remote_datasource.dart
        │   │   └── <feature>_local_datasource.dart
        │   ├── models/      # DataModel (fromMap/toMap)
        │   └── repositories/ # Impl của abstract repo
        ├── domain/
        │   ├── entities/    # Pure Dart entity, không import Flutter/Firebase
        │   ├── repositories/ # Abstract interface
        │   └── usecases/    # Mỗi file = 1 usecase
        └── presentation/
            ├── screens/
            ├── widgets/
            └── providers/   # Riverpod Notifier
```

---

## 2. Naming Convention

| Loại | Rule | Ví dụ |
|------|------|-------|
| File | `snake_case` | `auth_repository.dart` |
| Class | `PascalCase` | `AuthRepository` |
| DataModel | suffix `Model` | `UserModel` |
| Domain Entity | không suffix | `User` |
| UseCase | động từ + noun | `GetCurrentUser`, `UpdateProfile` |
| Provider | suffix `Provider` | `authStateProvider` |
| Notifier | suffix `Notifier` | `ProfileNotifier` |
| Table constant | `PascalCase` class | `ProfileTable.name` |
| Column constant | `camelCase` static | `ProfileTable.avatarUrl` |

---

## 3. Layer Rules (Quan Trọng Nhất)

```
Presentation → Domain ← Data
```

### ✅ Domain layer
- **Không được** import `flutter`, `firebase`, `supabase`, `dio`
- Chỉ chứa: Entity, Abstract Repository Interface, UseCase
- UseCase nhận params, trả về `Either<Failure, T>`

### ✅ Data layer
- Implement interface từ `domain/`
- Model phải có `fromMap`, `toMap`, `copyWith`
- Datasource chịu trách nhiệm gọi Supabase/Firebase trực tiếp
- Repository impl chỉ gọi datasource, không gọi client trực tiếp

### ✅ Presentation layer
- Provider/Notifier **không được** import Supabase/Firebase
- Chỉ gọi qua UseCase hoặc Repository Interface
- State chỉ chứa: data, isLoading, errorMessage

---

## 4. State Management (Riverpod)

### ProfileState pattern chuẩn
```dart
class ProfileState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
  }) =>
      ProfileState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage, // null = clear error
      );

  factory ProfileState.initial() => const ProfileState();
  factory ProfileState.loading() => const ProfileState(isLoading: true);
  factory ProfileState.error(String msg) => ProfileState(errorMessage: msg);
  factory ProfileState.loaded(User user) => ProfileState(user: user);
}
```

### Notifier pattern chuẩn
```dart
class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;

  ProfileNotifier({
    required GetProfileUseCase getProfile,
    required UpdateProfileUseCase updateProfile,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        super(ProfileState.initial());

  Future<void> loadProfile(String userId) async {
    state = ProfileState.loading();
    final result = await _getProfile(userId);
    result.fold(
      (failure) => state = ProfileState.error(failure.message),
      (user) => state = ProfileState.loaded(user),
    );
  }
}
```

---

## 5. Error Handling

- Dùng `fpdart` hoặc `dartz` — **không dùng try/catch rải rác ở provider**
- Mọi lỗi từ datasource → bọc trong `Failure` class
- Provider chỉ nhận `Either<Failure, T>`, không xử lý exception

```dart
// ✅ Đúng
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
```

---

## 6. Database Constants

Không hardcode string tên bảng/cột — khai báo tập trung:

```dart
// ✅ Đúng
abstract class ProfileTable {
  static const String name = 'user_profile';
  static const String id = 'id';
  static const String username = 'username';
  static const String fullName = 'full_name';
  static const String avatarUrl = 'avatar_url';
  static const String coverUrl = 'cover_url';
  static const String followerCount = 'follower_count';
  static const String followingCount = 'following_count';
  static const String updatedAt = 'updated_at';
}
```

---

## 7. Model Convention

Mọi Model **bắt buộc** có đủ:

```dart
class UserModel {
  final String id;
  final String? username;
  // ...

  const UserModel({required this.id, this.username});

  // ✅ Bắt buộc
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map[ProfileTable.id] as String? ?? '',
      username: map[ProfileTable.username] as String?,
    );
  }

  // ✅ Bắt buộc
  Map<String, dynamic> toMap() => {
    ProfileTable.id: id,
    ProfileTable.username: username,
  };

  // ✅ Bắt buộc
  UserModel copyWith({String? id, String? username}) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
    );
  }

  // ✅ Nên có
  User toEntity() => User(id: id, username: username);
}
```

---

## 8. Code Quality Rules

| Rule | Giới hạn |
|------|---------|
| Số dòng mỗi file | Tối đa **300 lines** |
| Số dòng mỗi function | Tối đa **30 lines** |
| Kiểu dữ liệu | Không dùng `dynamic` hoặc `var` bừa bãi |
| String DB | Không hardcode — dùng constants |
| Import model | Chỉ dùng **1 UserModel** per layer, không alias 2 cái |
| Logger | Không dùng `debugPrint` — dùng `logger` package |
| Null check | Không dùng `?fullName` syntax sai — dùng `if (x != null)` |

---

## 9. Logging

```dart
// ❌ Sai
debugPrint('✅ Profile loaded: ${user.id}');
debugPrint('❌ Failed: $e');

// ✅ Đúng — dùng package logger
final _logger = Logger('ProfileNotifier');
_logger.info('Profile loaded: ${user.id}');
_logger.warning('Failed to load profile', error: e);
```

---

## 10. Checklist Trước Khi Commit

- [ ] Không có `print()` hoặc `debugPrint()` trong production code
- [ ] Không có `TODO` cũ chưa xử lý
- [ ] Widget/Provider không chứa Supabase/Firebase import
- [ ] Đã handle đủ 3 state: loading / error / success
- [ ] Model có đủ `fromMap`, `toMap`, `copyWith`
- [ ] Tên bảng/cột DB dùng constants, không hardcode
- [ ] Không import 2 model cùng loại với alias
- [ ] Mỗi UseCase nằm trong file riêng
- [ ] Error dùng `Either<Failure, T>`, không try/catch ở provider

---

## 11. Ví Dụ Cấu Trúc Feature Profile

```
features/profile/
├── data/
│   ├── datasources/
│   │   └── profile_remote_datasource.dart   # Gọi Supabase trực tiếp
│   ├── models/
│   │   └── user_model.dart                  # fromMap, toMap, toEntity
│   └── repositories/
│       └── profile_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── user.dart                        # Pure Dart
│   ├── repositories/
│   │   └── profile_repository.dart          # Abstract interface
│   └── usecases/
│       ├── get_profile_usecase.dart
│       └── update_profile_usecase.dart
└── presentation/
    ├── providers/
    │   └── profile_providers.dart           # Chỉ state + notifier
    ├── screens/
    │   └── profile_screen.dart
    └── widgets/
        ├── profile_header.dart
        └── profile_avatar.dart
```