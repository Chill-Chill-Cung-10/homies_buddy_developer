# Session Guard - Quick Reference

## 🚀 Quick Start

### 1. Apply SessionGuard to Repository

```dart
import '../../core/mixins/session_guard_mixin.dart';

class YourRepository with SessionGuardMixin {
  
  // Protected operation (requires auth)
  Future<T> protectedOp() => guardedRequest(
    () async { /* logic */ },
    requiresAuth: true,
    operationName: 'protectedOp',
  );
  
  // Public operation (no auth required)
  Future<T> publicOp() => guardedRequest(
    () async { /* logic */ },
    requiresAuth: false,
    operationName: 'publicOp',
  );
  
  // Protected stream
  Stream<T> watchData() => guardedStream(
    () => dataStream,
    requiresAuth: true,
  );
}
```

## 🛡️ Session Guard Methods

| Method | Description | Returns |
|--------|-------------|---------|
| `guardedRequest()` | Wrap Future operation | `Future<T>` |
| `guardedStream()` | Wrap Stream operation | `Stream<T>` |
| `guardedBatch()` | Multiple operations | `Future<List<T>>` |
| `isUserAuthenticated()` | Quick auth check | `Future<bool>` |
| `checkSessionStatus()` | Get session status | `Future<SessionStatus>` |

## 📊 Session Status

```dart
enum SessionStatus {
  valid,      // Session OK
  expired,    // Token expired
  invalid,    // Session corrupted
  noSession,  // Not logged in
}
```

## ⚡ Common Patterns

### Pattern 1: CRUD Operations

```dart
class PostRepository with SessionGuardMixin {
  // Read - Public
  Future<Post?> getPost(String id) => guardedRequest(
    () => _fetchPost(id),
    requiresAuth: false,
  );
  
  // Create - Auth required
  Future<void> createPost(Post post) => guardedRequest(
    () => _createPost(post),
    requiresAuth: true,
  );
  
  // Update - Auth required
  Future<void> updatePost(Post post) => guardedRequest(
    () => _updatePost(post),
    requiresAuth: true,
  );
  
  // Delete - Auth required
  Future<void> deletePost(String id) => guardedRequest(
    () => _deletePost(id),
    requiresAuth: true,
  );
}
```

### Pattern 2: Stream Operations

```dart
// Watch user's own data - Auth required
Stream<List<Post>> watchMyPosts() => guardedStream(
  () => firestore.collection('posts')
      .where('userId', isEqualTo: currentUserId)
      .snapshots(),
  requiresAuth: true,
);

// Watch public feed - No auth
Stream<List<Post>> watchPublicFeed() => guardedStream(
  () => firestore.collection('posts')
      .where('privacy', isEqualTo: 'public')
      .snapshots(),
  requiresAuth: false,
);
```

### Pattern 3: Batch Operations

```dart
Future<void> updateUserProfile({
  String? name,
  String? avatar,
  String? bio,
}) => guardedRequest(
  () async {
    await Future.wait([
      if (name != null) _updateName(name),
      if (avatar != null) _updateAvatar(avatar),
      if (bio != null) _updateBio(bio),
    ]);
  },
  requiresAuth: true,
  operationName: 'updateUserProfile',
);
```

## 🚨 Error Handling

```dart
try {
  await repository.secureOperation();
} on AuthFailure catch (e) {
  switch (e.code) {
    case 'unauthenticated':
      // Redirect to login
      break;
    case 'session-expired':
      // Refresh or re-login
      break;
    case 'unauthorized':
      // Show permission error
      break;
  }
} catch (e) {
  // Handle other errors
}
```

## ✅ Checklist for New Repository

- [ ] Import `session_guard_mixin.dart`
- [ ] Add `with SessionGuardMixin` to class
- [ ] Wrap write operations with `guardedRequest(requiresAuth: true)`
- [ ] Wrap read operations with `guardedRequest(requiresAuth: false)` if public
- [ ] Wrap streams with `guardedStream()`
- [ ] Add `operationName` for debugging
- [ ] Test with invalid/expired session

## 🎯 When to Use

| Use SessionGuard | Don't Use |
|------------------|-----------|
| ✅ API calls | ❌ Local calculations |
| ✅ Database queries | ❌ UI rendering |
| ✅ File uploads | ❌ State management |
| ✅ User data access | ❌ Pure functions |
| ✅ Social interactions | ❌ Utils/helpers |

## 🔍 Debug Tips

Enable debug prints to see session checks:

```dart
// Already enabled in SessionGuard
debugPrint('🛡️ SessionGuard: $operationName - Session valid');
```

Look for these logs:
- `🛡️` Session check in progress
- `✅` Session valid
- `⚠️` Token refresh
- `🚫` Auth failed
- `❌` Error occurred

## 📝 Notes

- Firebase ID tokens expire after **1 hour**
- Auto-refresh happens automatically
- Session stored in **encrypted storage**
- Works offline with cached tokens
- Public operations = better performance

---

**Quick tip:** Most read operations should be `requiresAuth: false` and most write operations should be `requiresAuth: true`.
