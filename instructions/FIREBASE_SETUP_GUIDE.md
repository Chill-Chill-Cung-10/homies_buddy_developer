# 🚀 FIREBASE BACKEND SETUP & DEPLOYMENT GUIDE

Hướng dẫn chi tiết setup Firebase backend cho **Homies Buddy** (Community + Profile features).

---

## 📋 Prerequisites

1. **Node.js** >= 18.x ([Download](https://nodejs.org/))
2. **Firebase CLI** ([Install guide](https://firebase.google.com/docs/cli))
   ```bash
   npm install -g firebase-tools
   ```
3. **FlutterFire CLI** (cho auto-config)
   ```bash
   dart pub global activate flutterfire_cli
   ```
4. **Firebase Account** với project đã tạo trên [Firebase Console](https://console.firebase.google.com/)

---

## 🔥 BƯỚC 1: Tạo Firebase Project

### 1.1. Tạo project trên Firebase Console

1. Vào https://console.firebase.google.com/
2. Click **"Add project"**
3. Nhập tên: `homies-buddy` (hoặc tên khác)
4. Enable **Google Analytics** (optional)
5. Click **"Create project"**

### 1.2. Bật Firestore Database

1. Trong Console, vào **"Firestore Database"**
2. Click **"Create database"**
3. Chọn **"Start in test mode"** (tạm thời - sẽ deploy rules sau)
4. Chọn location: `asia-southeast1` (Singapore - gần VN nhất)
5. Click **"Enable"**

### 1.3. Bật Firebase Storage

1. Vào **"Storage"**
2. Click **"Get started"**
3. Chọn **"Start in test mode"**
4. Chọn location: `asia-southeast1`
5. Click **"Done"**

### 1.4. Bật Authentication

1. Vào **"Authentication"**
2. Click **"Get started"**
3. Enable **"Email/Password"**
4. Enable **"Google"** (nếu dùng Google Sign-In)
5. Thêm support email

---

## 📱 BƯỚC 2: Config Firebase cho Flutter App

### 2.1. Login Firebase CLI

```bash
firebase login
```

### 2.2. Init Firebase trong project

Mở terminal tại root folder project:

```bash
cd d:\ManhProject\homies_buddy_developer
firebase init
```

Chọn các services:
- ☑️ Firestore
- ☑️ Functions
- ☑️ Storage
- ☑️ Emulators (optional - để test local)

**Chọn options:**
- Project: Chọn project vừa tạo (`homies-buddy`)
- Firestore rules: `firestore.rules` (đã có sẵn)
- Firestore indexes: `firestore.indexes.json` (default)
- Functions language: **TypeScript**
- Functions Eslint: **Yes**
- Install dependencies: **Yes**
- Storage rules: `storage.rules` (đã có sẵn)

### 2.3. Auto-generate Firebase config cho Flutter

```bash
flutterfire configure
```

Chọn:
- Project: `homies-buddy`
- Platforms: Android, iOS, Web (chọn tất cả platforms bạn cần)

CLI sẽ tự động:
- Generate file `lib/firebase_options.dart` với cấu hình chính xác
- Config Firebase trong Android/iOS projects

**⚠️ QUAN TRỌNG:** File `firebase_options.dart` bạn đã có là placeholder. Hãy chạy lệnh trên để generate config thật.

---

## 📦 BƯỚC 3: Install Dependencies

### 3.1. Flutter dependencies

```bash
flutter pub get
```

### 3.2. Cloud Functions dependencies

```bash
cd functions
npm install
cd ..
```

---

## 🔧 BƯỚC 4: Update Main.dart

Update file `lib/main.dart` để initialize Firebase:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Auto-generated

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

---

## ☁️ BƯỚC 5: Deploy Cloud Functions

### 5.1. Build TypeScript

```bash
cd functions
npm run build
```

### 5.2. Deploy functions

```bash
firebase deploy --only functions
```

**Functions được deploy:**
- `onReactPost` - Trigger khi react post
- `onUnreactPost` - Trigger khi unreact
- `onCreateComment` - Trigger khi tạo comment
- `onDeleteComment` - Trigger khi xóa comment
- `onFollowUser` - Trigger khi follow user
- `onUnfollowUser` - Trigger khi unfollow
- `onUpdateUserProfile` - Trigger khi update profile
- `sendPushNotification` - Gửi push notification (optional)

### 5.3. Verify deployment

```bash
firebase functions:log
```

---

## 🔒 BƯỚC 6: Deploy Security Rules

### 6.1. Deploy Firestore Rules

```bash
firebase deploy --only firestore:rules
```

### 6.2. Deploy Storage Rules

```bash
firebase deploy --only storage:rules
```

### 6.3. Verify rules

Vào Firebase Console → Firestore Database → Rules để xem rules đã apply.

---

## 🗂️ BƯỚC 7: Tạo Firestore Indexes (nếu cần)

Khi chạy app, nếu gặp lỗi "requires an index", Firebase sẽ log URL để tạo index.

**Hoặc tạo manual:**

File `firestore.indexes.json`:
```json
{
  "indexes": [
    {
      "collectionGroup": "posts",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "privacy", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "posts",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "authorId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```

Deploy indexes:
```bash
firebase deploy --only firestore:indexes
```

---

## 🧪 BƯỚC 8: Test với Firebase Emulators (Optional)

Để test local trước khi deploy production:

### 8.1. Start emulators

```bash
firebase emulators:start
```

Emulators chạy tại:
- Firestore: `http://localhost:8080`
- Functions: `http://localhost:5001`
- Auth: `http://localhost:9099`
- Storage: `http://localhost:9199`
Emulator UI Port: 4000 - default Port

### 8.2. Connect Flutter app to emulators

Update `main.dart`:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // ONLY FOR DEVELOPMENT - Connect to emulators
  if (kDebugMode) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  }
  
  runApp(ProviderScope(child: MyApp()));
}
```

---

## ✅ BƯỚC 9: Verify Setup

### 9.1. Test Authentication

```dart
// Trong Flutter app
final auth = FirebaseAuth.instance;
await auth.createUserWithEmailAndPassword(
  email: 'test@example.com',
  password: 'password123',
);
```

### 9.2. Test Firestore Write

```dart
// Create user profile
await FirebaseFirestore.instance.collection('users').doc(userId).set({
  'username': 'testuser',
  'fullName': 'Test User',
  'avatarUrl': 'https://example.com/avatar.jpg',
  'followerCount': 0,
  'followingCount': 0,
  'createdAt': FieldValue.serverTimestamp(),
});
```

### 9.3. Test Storage Upload

```dart
// Upload avatar
final storageRef = FirebaseStorage.instance.ref('avatars/$userId/avatar.jpg');
await storageRef.putFile(File(imagePath));
final downloadUrl = await storageRef.getDownloadURL();
```

---

## 🎯 BƯỚC 10: Integrate với UI

### 10.1. Update Community Screen

File: `lib/features/community/presentation/community_screen.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/post_providers.dart';

class CommunityScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch community feed từ Firebase
    final postsAsync = ref.watch(communityFeedProvider);
    
    return postsAsync.when(
      data: (posts) => ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return SocialPostCard(post: posts[index]);
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### 10.2. Update Profile Screen

File: `lib/features/profile/presentation/screens/profile_screen.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/user_providers.dart';
import '../../../../core/providers/post_providers.dart';

class ProfileScreen extends ConsumerWidget {
  final String userId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider(userId));
    final postsAsync = ref.watch(userPostsProvider(userId));
    
    return userAsync.when(
      data: (user) {
        if (user == null) return Text('User not found');
        
        return Column(
          children: [
            // Profile header
            ProfileHeader(user: user),
            
            // User's posts
            postsAsync.when(
              data: (posts) => ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) => SocialPostCard(post: posts[index]),
              ),
              loading: () => CircularProgressIndicator(),
              error: (e, s) => Text('Error: $e'),
            ),
          ],
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### 10.3. Create Post với Upload Media

```dart
import '../../../../core/providers/post_providers.dart';
import '../../../../core/services/storage_service.dart';

class CreatePostScreen extends ConsumerWidget {
  Future<void> _submitPost(WidgetRef ref, List<XFile> images) async {
    final storageService = ref.read(storageServiceProvider);
    final postActions = ref.read(postActionsProvider);
    
    // Generate postId trước
    final postId = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Upload media
    final uploadResults = await storageService.uploadPostMedia(postId, images);
    
    // Convert to MediaFile models
    final mediaFiles = uploadResults.map((result) => MediaFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mediaUrl: result.mediaUrl,
      thumbnailUrl: result.thumbnailUrl,
      mediaType: result.isVideo ? MediaType.video : MediaType.image,
      mediaAspectRatio: 16/9,
      width: 1920,
      height: 1080,
    )).toList();
    
    // Create post
    await postActions.createPost(
      contentText: _contentController.text,
      mediaFiles: mediaFiles,
    );
    
    // Navigate back
    Navigator.pop(context);
  }
}
```

---

## 📊 BƯỚC 11: Monitoring & Analytics

### 11.1. Check Firebase Console

- **Firestore:** Xem data realtime
- **Storage:** Xem files uploaded
- **Functions:** Xem logs & metrics
- **Authentication:** Xem users

### 11.2. Enable Error Logging

Update `functions/src/index.ts`:

```typescript
import * as functions from 'firebase-functions';

// Log all errors
functions.logger.error('Error message', { error: e });
```

View logs:
```bash
firebase functions:log
```

---

## 💰 BƯỚC 12: Upgrade Plan (Khi cần)

**Free Spark Plan limits:**
- Firestore: 50K reads/day, 20K writes/day
- Storage: 1GB
- Functions: 125K invocations/day

**Khi vượt quá → Upgrade to Blaze (Pay-as-go):**

1. Vào Firebase Console → Settings → Billing
2. Click **"Upgrade to Blaze"**
3. Setup payment method
4. Set budget alerts (vd: $10/month)

**Student tip:** Apply for [GitHub Student Pack](https://education.github.com/pack) → Free $100 Google Cloud credit.

---

## 🐛 Troubleshooting

### Error: "PERMISSION_DENIED"
→ Check Security Rules, đảm bảo user đã authenticated

### Error: "Index required"
→ Click vào link trong error log để tạo index

### Functions không trigger
→ Check Firebase Console → Functions → Logs
→ Verify function đã deploy: `firebase functions:list`

### Upload image thất bại
→ Check Storage Rules
→ Verify file size < 10MB

---

## 📚 Resources

- [Firebase Docs](https://firebase.google.com/docs)
- [FlutterFire Docs](https://firebase.flutter.dev/)
- [Firestore Data Modeling](https://firebase.google.com/docs/firestore/manage-data/structure-data)
- [Security Rules Guide](https://firebase.google.com/docs/rules)

---

## ✨ Next Steps

1. **Test tất cả flows:** Create post, comment, follow, upload media
2. **Setup FCM Notifications:** Để push realtime notifications
3. **Implement pagination:** Load more posts when scroll
4. **Add loading states:** Skeleton screens, shimmer effects
5. **Error handling:** User-friendly error messages
6. **Optimize images:** Auto resize với Firebase Extension

---

**🎉 Xong! Backend đã sẵn sàng cho Community + Profile features.**

Nếu gặp vấn đề, check Firebase Console logs hoặc Flutter debug console.
