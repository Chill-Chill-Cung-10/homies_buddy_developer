# Session Guard System - Tài liệu Hướng dẫn

## 📋 Tổng quan

Hệ thống Session Guard đảm bảo rằng **mỗi request từ bất kỳ tab/screen nào đều được kiểm tra session validity** trước khi thực thi. Điều này giúp:

- ✅ Bảo vệ dữ liệu người dùng
- ✅ Tự động refresh token khi sắp hết hạn
- ✅ Force logout khi session invalid
- ✅ Ngăn chặn unauthorized access

## 🏗️ Kiến trúc

### 1. SessionService
**File:** `lib/core/services/session_service.dart`

Quản lý secure storage cho session data:
- User ID
- Access Token (Firebase ID Token)
- Refresh Token
- Expiration Time

```dart
// Lưu session
await SessionService.instance.saveSession(
  userId: 'user123',
  accessToken: 'token...',
  refreshToken: 'refresh...',
  expiresAt: DateTime.now().add(Duration(hours: 1)),
);

// Lấy session
final session = await SessionService.instance.getSession();

// Xóa session
await SessionService.instance.clearSession();
```

### 2. SessionGuard
**File:** `lib/core/services/session_guard.dart`

Core logic để validate session:
- Kiểm tra Firebase Auth state
- Verify stored session
- Match user IDs
- Check token expiration
- Auto-refresh token nếu cần

```dart
// Check session (throws AuthFailure nếu invalid)
await SessionGuard.instance.checkSession();

// Validate session (không throw exception)
final status = await SessionGuard.instance.validateSession();
// SessionStatus: valid, expired, invalid, noSession

// Check is authenticated (quick check)
final isAuth = await SessionGuard.instance.isAuthenticated();
```

### 3. SessionGuardMixin
**File:** `lib/core/mixins/session_guard_mixin.dart`

Mixin để áp dụng session protection vào repositories:

```dart
class MyRepository with SessionGuardMixin {
  // Protected request - check session before executing
  Future<Data> getData() async {
    return guardedRequest(
      () async {
        // Your repository logic here
        return await firestore.collection('data').get();
      },
      requiresAuth: true, // Default
      operationName: 'getData', // For logging
    );
  }

  // Protected stream
  Stream<List<Data>> watchData() {
    return guardedStream(
      () => firestore.collection('data').snapshots(),
      requiresAuth: true,
      operationName: 'watchData',
    );
  }

  // Batch operations
  Future<List<Result>> batchOperations() async {
    return guardedBatch([
      () => operation1(),
      () => operation2(),
      () => operation3(),
    ]);
  }
}
```

## 🔐 Các Repository đã được bảo vệ

Các repositories sau đã được apply SessionGuardMixin:

### ✅ UserRepository
- `getUserById()` - Public (không yêu cầu auth)
- `getUserStream()` - Public
- `createUserProfile()` - 🛡️ Requires auth
- `updateUserProfile()` - 🛡️ Requires auth
- `followUser()` - 🛡️ Requires auth
- Và các methods khác...

### ✅ PostRepository
- `getFeed()` - Public
- `getUserPosts()` - Public
- `createPost()` - 🛡️ Requires auth
- `updatePost()` - 🛡️ Requires auth
- `deletePost()` - 🛡️ Requires auth
- `reactToPost()` - 🛡️ Requires auth

### ✅ CommentRepository
- `getComments()` - Public
- `createComment()` - 🛡️ Requires auth
- `updateComment()` - 🛡️ Requires auth
- `deleteComment()` - 🛡️ Requires auth

### ✅ NotificationRepository
- `getNotifications()` - 🛡️ Requires auth
- `markAsRead()` - 🛡️ Requires auth
- `deleteNotification()` - 🛡️ Requires auth

## 📝 Cách sử dụng

### Thêm SessionGuard vào Repository mới

```dart
import '../../core/mixins/session_guard_mixin.dart';

class NewRepository with SessionGuardMixin {
  
  // Method yêu cầu authentication
  Future<Data> secureOperation() async {
    return guardedRequest(
      () async {
        // Your logic here
      },
      requiresAuth: true,
      operationName: 'secureOperation',
    );
  }

  // Public method không cần auth
  Future<Data> publicOperation() async {
    return guardedRequest(
      () async {
        // Your logic here
      },
      requiresAuth: false, // Public operation
      operationName: 'publicOperation',
    );
  }

  // Stream operation
  Stream<Data> watchData() {
    return guardedStream(
      () => dataStream,
      requiresAuth: true,
      operationName: 'watchData',
    );
  }
}
```

### Check session trong UI

```dart
// Trong StatefulWidget hoặc Provider
final sessionStatus = await SessionGuard.instance.validateSession();

switch (sessionStatus) {
  case SessionStatus.valid:
    // Session OK - proceed
    break;
  case SessionStatus.expired:
    // Show refresh message
    break;
  case SessionStatus.noSession:
  case SessionStatus.invalid:
    // Redirect to login
    break;
}
```

### Handle session errors

```dart
try {
  await repository.secureOperation();
} on AuthFailure catch (e) {
  switch (e.code) {
    case 'unauthenticated':
      // No session - redirect to login
      break;
    case 'session-expired':
      // Session expired - auto refresh or re-login
      break;
    case 'unauthorized':
      // Permission denied
      break;
  }
}
```

## 🔄 Session Lifecycle

```
App Start
    ↓
Firebase Auth Listener
    ↓
[User signed in] → Save session with expiration (1 hour)
    ↓
[User makes request]
    ↓
SessionGuard.checkSession()
    ├─ Check Firebase Auth state
    ├─ Check stored session
    ├─ Verify user ID match
    ├─ Check token expiration
    └─ [Expired?] → Auto-refresh token
    ↓
[Token invalid?] → Force logout → Clear session → Login screen
    ↓
[Token valid] → Proceed with request
```

## ⚙️ Configuration

### Token Expiration

Firebase ID tokens expire sau **1 giờ**. Session được lưu với thời gian hết hạn:

```dart
// lib/features/auth/presentation/providers/auth_providers.dart
final expiresAt = DateTime.now().add(const Duration(hours: 1));
```

### Auto-refresh

SessionGuard tự động refresh token khi:
- Token sắp hết hạn
- Firebase Auth vẫn valid

```dart
// lib/core/services/session_guard.dart
if (session.isExpired) {
  await _refreshToken(firebaseUser);
}
```

## 🐛 Debug & Logging

SessionGuard cung cấp debug logs chi tiết:

```
🛡️ SessionGuard: getUserById - Session valid, proceeding
✅ SessionGuard: Session valid for user_123
⚠️ SessionGuard: Session expired, attempting refresh...
🔄 SessionGuard: Token refreshed successfully
🚫 SessionGuard: No Firebase user authenticated
❌ SessionGuard: Token verification failed
```

## 📊 Testing

### Unit Tests

```dart
test('should check session before operation', () async {
  // Setup mock session
  when(mockSessionService.getSession())
    .thenAnswer((_) async => mockSession);
  
  // Call repository
  await repository.secureOperation();
  
  // Verify session was checked
  verify(mockSessionGuard.checkSession()).called(1);
});
```

### Integration Tests

```dart
testWidgets('should redirect to login when session invalid', (tester) async {
  // Setup invalid session
  await SessionService.instance.clearSession();
  
  // Try to access protected screen
  await tester.pumpWidget(MyApp());
  await tester.tap(find.byKey(Key('profile')));
  await tester.pumpAndSettle();
  
  // Should be on login screen
  expect(find.byType(LoginScreen), findsOneWidget);
});
```

## ⚡ Performance

- ✅ Session checks sử dụng **local storage** (fast)
- ✅ Token validation sử dụng **Firebase SDK** (cached)
- ✅ Streams chỉ check session **1 lần** khi bắt đầu
- ✅ Batch operations check session **1 lần** cho tất cả

## 🔒 Security Best Practices

1. ✅ **Tokens được encrypt** trong secure storage
2. ✅ **User ID matching** giữa Firebase và session
3. ✅ **Token expiration** được enforce
4. ✅ **Auto-logout** khi session invalid
5. ✅ **No credentials in logs** (production)

## 📚 Tài liệu tham khảo

- [Firebase Auth - ID Tokens](https://firebase.google.com/docs/auth/admin/verify-id-tokens)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [Clean Architecture - Repository Pattern](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Lưu ý:** Hệ thống này đảm bảo rằng **mọi request từ mọi tab/screen đều được kiểm tra session** trước khi thực thi. Nếu cần thêm repositories hoặc services vào hệ thống này, chỉ cần apply `SessionGuardMixin` và wrap operations với `guardedRequest()` hoặc `guardedStream()`.
