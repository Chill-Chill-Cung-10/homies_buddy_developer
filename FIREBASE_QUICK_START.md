# 🎯 FIREBASE BACKEND - QUICK START

Quick reference cho việc sử dụng Firebase backend đã setup.

---

## 📂 Cấu trúc Files đã tạo

```
homies_buddy_developer/
│
├── lib/
│   ├── firebase_options.dart              # Firebase config (auto-gen)
│   │
│   ├── core/
│   │   ├── services/
│   │   │   ├── firebase_service.dart      # Firebase instances
│   │   │   └── storage_service.dart       # Upload/download media
│   │   │
│   │   └── providers/
│   │       ├── core_providers.dart        # Service providers
│   │       ├── user_providers.dart        # User state management
│   │       ├── post_providers.dart        # Post state management
│   │       └── comment_notification_providers.dart
│   │
│   └── data/
│       └── repositories/
│           ├── user_repository.dart       # User CRUD & follow
│           ├── post_repository.dart       # Post CRUD & react
│           ├── comment_repository.dart    # Comment CRUD
│           └── notification_repository.dart
│
├── functions/                              # Cloud Functions (Node.js)
│   ├── src/
│   │   └── index.ts                       # All functions
│   ├── package.json
│   └── tsconfig.json
│
├── firestore.rules                         # Database security rules
├── storage.rules                           # Storage security rules
├── firebase.json                           # Firebase config (auto-gen)
│
└── FIREBASE_SETUP_GUIDE.md                 # Full setup guide
```

---

## ⚡ Quick Commands

### Deploy Everything
```bash
# Deploy all services
firebase deploy

# Deploy specific services
firebase deploy --only functions
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
```

### Run Local Emulators
```bash
firebase emulators:start
```

### View Logs
```bash
firebase functions:log --limit 50
```

### Flutter
```bash
# Get dependencies
flutter pub get

# Run app
flutter run
```

---

## 🔥 Common Usage Patterns

### 1. Get Current User Profile
```dart
final userAsync = ref.watch(currentUserProfileProvider);
```

### 2. Get Community Feed
```dart
final postsAsync = ref.watch(communityFeedProvider);
```

### 3. Create Post
```dart
final postActions = ref.read(postActionsProvider);
await postActions.createPost(
  contentText: 'Hello world!',
  mediaFiles: [...],
);
```

### 4. Toggle React
```dart
final postActions = ref.read(postActionsProvider);
await postActions.toggleReact(postId);
```

### 5. Follow User
```dart
final userActions = ref.read(userActionsProvider);
await userActions.followUser(targetUserId);
```

### 6. Upload Avatar
```dart
final storageService = ref.read(storageServiceProvider);
final avatarUrl = await storageService.uploadAvatar(image, userId);
```

### 7. Create Comment
```dart
final commentActions = ref.read(commentActionsProvider);
await commentActions.createComment(postId, 'Nice post!');
```

---

## 📊 Firestore Collections

| Collection | Document ID | Subcollections |
|---|---|---|
| `users` | userId | `followers`, `following`, `notifications` |
| `posts` | auto-generated | `comments`, `reacts` |
| `usernames` | username | - |

---

## 🔒 Security Rules Summary

### Firestore
- ✅ Anyone authenticated can **read** user profiles & public posts
- ✅ Only owner can **update** their profile
- ✅ Only author can **update/delete** their posts
- ❌ Cloud Functions write notifications (users can't)

### Storage
- ✅ Anyone can **read** avatars/covers (public)
- ✅ Only owner can **write** their avatar/cover
- ✅ Authenticated users can **write** post media
- 📏 Max size: 10MB images, 100MB videos

---

## ⚙️ Environment Setup Checklist

- [x] Install Node.js >= 18
- [x] Install Firebase CLI (`npm i -g firebase-tools`)
- [x] Install FlutterFire CLI (`dart pub global activate flutterfire_cli`)
- [x] Login Firebase (`firebase login`)
- [ ] Run `flutterfire configure` to generate config
- [ ] Run `flutter pub get`
- [ ] Update `main.dart` to initialize Firebase
- [ ] Deploy functions (`cd functions && npm run build && cd .. && firebase deploy --only functions`)
- [ ] Deploy rules (`firebase deploy --only firestore:rules,storage:rules`)

---

## 🚨 Troubleshooting

| Issue | Solution |
|---|---|
| PERMISSION_DENIED | Check if user authenticated & Security Rules |
| Index required | Click link in error to create index |
| Functions not triggering | Check logs: `firebase functions:log` |
| Upload fails | Check file size < 10MB & Storage Rules |
| `firebase_options.dart` placeholder | Run `flutterfire configure` |

---

## 📚 Key Files to Read

1. **[FIREBASE_SETUP_GUIDE.md](FIREBASE_SETUP_GUIDE.md)** - Full setup guide
2. **[lib/core/services/firebase_service.dart](lib/core/services/firebase_service.dart)** - Firebase instances
3. **[lib/data/repositories/user_repository.dart](lib/data/repositories/user_repository.dart)** - User operations
4. **[lib/core/providers/user_providers.dart](lib/core/providers/user_providers.dart)** - User providers
5. **[functions/src/index.ts](functions/src/index.ts)** - Cloud Functions

---

## 🎯 Next Implementation Steps

### Phase 1: Basic Setup ✅ (Done)
- ✅ Firebase dependencies
- ✅ Services & Repositories
- ✅ Providers
- ✅ Cloud Functions
- ✅ Security Rules

### Phase 2: UI Integration (Next)
1. Update `main.dart` to initialize Firebase
2. Replace mock data in `CommunityScreen` với `communityFeedProvider`
3. Replace mock data in `ProfileScreen` với `userProfileProvider`
4. Implement Create Post screen với upload media
5. Implement Comment overlay với Firebase data
6. Add Follow/Unfollow buttons
7. Add notification badge

### Phase 3: Polish
1. Add loading states (skeleton screens)
2. Add error handling
3. Implement pagination (load more)
4. Add pull-to-refresh
5. Optimize images (auto-resize)
6. Setup FCM push notifications

---

**🚀 Ready to deploy! Follow [FIREBASE_SETUP_GUIDE.md](FIREBASE_SETUP_GUIDE.md) for step-by-step instructions.**
