# 🏡 HOMIES BUDDY - PROJECT IMPLEMENTATION PLAN

> Kế hoạch chi tiết để implement ứng dụng Homies Buddy từ đầu đến cuối

## 📊 BUSINESS REQUIREMENTS ANALYSIS

### **Tab Home** 🏠
1. ✅ Create home với custom style (Unity Engine)
2. ✅ Add pets to home
3. ✅ Combine home với SharedOwner (co-parenting)
4. ✅ Upload posts (image/video/GIF) cho từng pet
5. ✅ Share content to community (video 10-15s,  image max 10MB)
6. ✅ Notifications cho special days & followers
7. ✅ Chat với friends (send images/videos)
8. ✅ Health Screening Records với periodic reminders
9. ✅ Real-time pet interactions cho SharedOwners (WebSocket)

### **Tab Community** 👥
1. ✅ Like, comment posts
2. ✅ Share posts to external social media (Facebook/Instagram)

### **Tab Ask For Help** 🤖
1. ✅ Mimi AI Agent - Animal care assistant
2. ✅ Knowledge base cho pet nurturing

---

## 🎯 IMPLEMENTATION PHASES

## **PHASE 0: PROJECT SETUP & INFRASTRUCTURE** (Week 1)

### 0.1 Dependencies Installation
```yaml
# pubspec.yaml - Core Dependencies
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.9           # ✅ Đã có
  
  # Routing
  go_router: ^12.1.3                 # ✅ Đã có
  
  # Networking
  dio: ^5.4.0                        # ❌ Thêm
  retrofit: ^4.0.3                   # ❌ Thêm
  
  # Local Storage
  hive: ^2.2.3                       # ❌ Thêm
  hive_flutter: ^1.1.0               # ❌ Thêm
  shared_preferences: ^2.2.2         # ❌ Thêm
  
  # Firebase
  firebase_core: ^2.24.2             # ❌ Thêm
  firebase_auth: ^4.15.3             # ❌ Thêm
  cloud_firestore: ^4.13.6           # ❌ Thêm
  firebase_storage: ^11.5.6          # ❌ Thêm
  firebase_messaging: ^14.7.9        # ❌ Thêm
  
  # Real-time Communication
  socket_io_client: ^2.0.3+1         # ❌ Thêm (WebSocket)
  
  # Media
  image_picker: ^1.0.5               # ❌ Thêm
  video_player: ^2.8.1               # ❌ Thêm
  cached_network_image: ^3.3.0       # ✅ Đã có
  image_cropper: ^5.0.1              # ❌ Thêm
  flutter_image_compress: ^2.1.0     # ❌ Thêm
  
  # Unity Integration
  flutter_unity_widget: ^2022.2.0    # ❌ Thêm
  
  # AI/Chat
  flutter_chat_ui: ^1.6.10           # ❌ Thêm
  dash_chat_2: ^0.0.18               # ❌ Thêm
  
  # Utilities
  intl: ^0.18.1                      # ❌ Thêm
  timeago: ^3.6.0                    # ❌ Thêm
  share_plus: ^7.2.1                 # ❌ Thêm
  url_launcher: ^6.2.2               # ❌ Thêm
  flutter_local_notifications: ^16.3.0  # ❌ Thêm
  permission_handler: ^11.1.0        # ❌ Thêm

dev_dependencies:
  # Code Generation
  build_runner: ^2.4.7               # ❌ Thêm
  retrofit_generator: ^7.0.8         # ❌ Thêm
  json_serializable: ^6.7.1          # ❌ Thêm
  hive_generator: ^2.0.1             # ❌ Thêm
```

### 0.2 Backend Setup Decision
**Option 1: Firebase (Recommended for MVP)**
- Pros: Fast setup, no DevOps, real-time sync, authentication built-in
- Cons: Limited complex queries, vendor lock-in

**Option 2: Custom Backend (Node.js/NestJS + MongoDB)**
- Pros: Full control, complex queries, scalable
- Cons: Requires DevOps, more time

**DECISION: Start with Firebase → Migrate to custom backend later**

### 0.3 Project Structure Refinement
```
lib/
├── core/ # Infrastructure
│   ├── config/ # Global config
│   │   ├── firebase_config.dart
│   │   ├── app_config.dart
│   │   └── environment.dart
│   ├── network/ # Nơi tập trung giao tiếp với world
│   │   ├── api_client.dart # Wrapper của Dio: base config,timeout
│   │   ├── api_endpoints.dart # Tích hợp tất cả URL 
│   │   ├── interceptors/ # Auth token, refresh token,logging & error
│   │   └── websocket_service.dart # Realtime 
│   ├── storage/ # 
│   │   ├── hive_service.dart
│   │   ├── secure_storage.dart
│   │   └── cache_manager.dart
│   └── services/
│       ├── notification_service.dart
│       ├── permission_service.dart
│       └── analytics_service.dart
│
├── data/
│   ├── models/                     # Business models
│   ├── repositories/               # Data repositories
│   └── datasources/
│       ├── remote/                 # API calls
│       └── local/                  # Local DB
│
└── features/
    ├── auth/                       # Authentication
    ├── home/                       # Home + Pet management
    ├── community/                  # Social feed
    ├── help/                       # Mimi AI
    ├── chat/                       # Direct messaging
    ├── profile/                    # User profile
    └── notifications/              # Notification center
```

---

## **PHASE 1: AUTHENTICATION & USER MANAGEMENT** (Week 2-3)

### 1.1 Database Models
```dart
// lib/data/models/user_model.dart
@HiveType(typeId: 0)
class User {
  @HiveField(0) final String userId;
  @HiveField(1) final String name;
  @HiveField(2) final String email;
  @HiveField(3) final String? avatar;
  @HiveField(4) final UserPreferences preferences;
  @HiveField(5) final List<String> friendIds;
  @HiveField(6) final List<String> followerIds;
  @HiveField(7) final List<String> blockIds;
  @HiveField(8) final DateTime createdAt;
}

// lib/data/models/account_model.dart
class Account {
  final String accountId;
  final String email;
  final String passwordHash;
  final Map<String, dynamic> userSettings;
}
```

### 1.2 Authentication Flow
```dart
// lib/features/auth/data/repositories/auth_repository.dart
class AuthRepository {
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(String email, String password, String name);
  Future<User> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Stream<User?> get authStateChanges;
}

// lib/features/auth/presentation/providers/auth_provider.dart
final authRepositoryProvider = Provider<AuthRepository>(...);
final authStateProvider = StreamProvider<User?>(...);
final currentUserProvider = Provider<User?>(...);
```

### 1.3 UI Pages
- [ ] Login Page (email/password + Google)
- [ ] Register Page
- [ ] Forgot Password Page
- [ ] Email Verification Page
- [ ] Welcome/Onboarding (giới thiệu app)

**Deliverable**: User có thể đăng ký, đăng nhập, đăng xuất

---

## **PHASE 2: HOME TAB - BASIC IMPLEMENTATION** (Week 4-5)

### 2.1 Home & Pet Models
```dart
// lib/features/home/domain/models/home_model.dart
@HiveType(typeId: 1)
class Home {
  @HiveField(0) final String homeId;
  @HiveField(1) final String styleTheme;      // "modern", "cottage", "garden"
  @HiveField(2) final String ownerId;
  @HiveField(3) final List<String> sharedOwnerIds;
  @HiveField(4) final List<Pet> pets;
  @HiveField(5) final DateTime createdAt;
}

// lib/features/home/domain/models/pet_model.dart
@HiveType(typeId: 2)
class Pet {
  @HiveField(0) final String petId;
  @HiveField(1) final String name;
  @HiveField(2) final String species;         // "dog", "cat", "bird"
  @HiveField(3) final String? avatar;
  @HiveField(4) final String? gender;
  @HiveField(5) final int? age;
  @HiveField(6) final CareExperienceLevel careLevel;
  @HiveField(7) final MimiGuideMode guideMode;  // "guided", "fast_track"
  @HiveField(8) final List<HealthScreeningRecord> healthRecords;
  @HiveField(9) final DateTime createdAt;
}

// lib/features/home/domain/models/health_record.dart
class HealthScreeningRecord {
  final String recordId;
  final String petId;
  final HealthScreeningType type;  // "memory", "health", "social", "reminder"
  final DateTime scheduledDate;
  final bool isCompleted;
  final String? notes;
}
```

### 2.2 Home Management Features
```dart
// lib/features/home/data/repositories/home_repository.dart
class HomeRepository {
  Future<Home> createHome(String userId, String styleTheme);
  Future<Home> getHome(String homeId);
  Future<void> updateHomeStyle(String homeId, String styleTheme);
  Future<void> addSharedOwner(String homeId, String userId);
  Future<void> removeSharedOwner(String homeId, String userId);
  Stream<Home> watchHomeRealtime(String homeId);  // WebSocket
}

// lib/features/home/data/repositories/pet_repository.dart
class PetRepository {
  Future<Pet> addPet(String homeId, Pet pet);
  Future<void> updatePet(String petId, Pet pet);
  Future<void> deletePet(String petId);
  Future<List<Pet>> getPetsByHome(String homeId);
  Future<void> addHealthRecord(String petId, HealthScreeningRecord record);
}
```

### 2.3 Unity Integration (Placeholder → Full)
```dart
// lib/features/home/presentation/pages/home_page.dart
// Step 1: Replace placeholder với UnityWidget
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class HomePage extends ConsumerWidget {
  UnityWidgetController? _unityController;

  void _onUnityCreated(UnityWidgetController controller) {
    _unityController = controller;
    // Load garden state from backend
    _loadGardenState();
  }

  void _onUnityMessage(dynamic message) {
    // Handle messages from Unity (tap pet, plant, etc.)
    final action = message['action'];
    if (action == 'petTapped') {
      _handlePetTapped(message['petId']);
    }
  }

  // Send data to Unity
  void _sendToUnity(String method, dynamic data) {
    _unityController?.postMessage(
      'GameManager',
      method,
      jsonEncode(data),
    );
  }
}
```

### 2.4 UI Implementation
- [ ] Home Selection Page (chọn style theme)
- [ ] Add Pet Page (form with image picker)
- [ ] Pet Profile Page (view/edit pet details)
- [ ] Combine Home Page (tìm và kết nối với user khác)
- [ ] Unity Garden View (tích hợp Unity WebGL)

**Deliverable**: User tạo home, thêm pets, xem garden cơ bản

---

## **PHASE 3: POST & MEDIA MANAGEMENT** (Week 6-7)

### 3.1 Post Models
```dart
// lib/features/home/domain/models/post_model.dart
@HiveType(typeId: 3)
class Post {
  @HiveField(0) final String postId;
  @HiveField(1) final String petId;
  @HiveField(2) final String ownerId;
  @HiveField(3) final PostType type;         // "image", "video", "gif"
  @HiveField(4) final String? fileUrl;
  @HiveField(5) final int? fileSize;         // bytes
  @HiveField(6) final DateTime createdAt;
  @HiveField(7) final bool isSharedToCommunity;
}

enum PostType { image, video, gif }
```

### 3.2 Media Upload Service
```dart
// lib/core/services/media_service.dart
class MediaService {
  // Image upload (max 10MB)
  Future<String> uploadImage(File file, {
    required String petId,
    int maxSizeInMB = 10,
  }) async {
    // 1. Validate size
    final fileSizeInMB = file.lengthSync() / (1024 * 1024);
    if (fileSizeInMB > maxSizeInMB) {
      throw Exception('Image must be less than ${maxSizeInMB}MB');
    }
    
    // 2. Compress image
    final compressed = await _compressImage(file);
    
    // 3. Upload to Firebase Storage
    final ref = FirebaseStorage.instance
        .ref()
        .child('pets/$petId/images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    
    await ref.putFile(compressed);
    return await ref.getDownloadURL();
  }

  // Video upload (10-15s, auto-trim)
  Future<String> uploadVideo(File file, {
    required String petId,
    int maxDurationInSeconds = 15,
  }) async {
    // 1. Validate duration
    final duration = await _getVideoDuration(file);
    if (duration > maxDurationInSeconds) {
      // Auto trim to 15s
      file = await _trimVideo(file, maxDurationInSeconds);
    }
    
    // 2. Compress video
    final compressed = await _compressVideo(file);
    
    // 3. Upload
    final ref = FirebaseStorage.instance
        .ref()
        .child('pets/$petId/videos/${DateTime.now().millisecondsSinceEpoch}.mp4');
    
    final uploadTask = ref.putFile(compressed);
    
    // Track progress
    uploadTask.snapshotEvents.listen((snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      // Update UI progress
    });
    
    await uploadTask;
    return await ref.getDownloadURL();
  }

  // GIF upload
  Future<String> uploadGif(File file, {required String petId});
  
  // Helper methods
  Future<File> _compressImage(File file);
  Future<File> _compressVideo(File file);
  Future<File> _trimVideo(File file, int maxSeconds);
  Future<int> _getVideoDuration(File file);
}
```

### 3.3 Post Repository
```dart
// lib/features/home/data/repositories/post_repository.dart
class PostRepository {
  Future<Post> createPost({
    required String petId,
    required File mediaFile,
    required PostType type,
    bool shareToCommunitysponse = false,
  });
  
  Future<List<Post>> getPostsByPet(String petId);
  Future<void> deletePost(String postId);
  
  // Share to community
  Future<void> shareToCommunity(String postId);
}
```

### 3.4 UI Implementation
- [ ] Create Post Page (image/video/GIF picker)
- [ ] Post Preview Page (before upload)
- [ ] Upload Progress Indicator
- [ ] Pet Timeline Page (xem posts của 1 pet)
- [ ] Media Viewer (fullscreen image/video player)

**Deliverable**: User upload và xem posts cho pets

---

## **PHASE 4: COMMUNITY TAB - FULL IMPLEMENTATION** (Week 8-9)

### 4.1 Community Post Model
```dart
// lib/features/community/domain/models/community_post.dart
@HiveType(typeId: 4)
class CommunityPost {
  @HiveField(0) final String postId;
  @HiveField(1) final String originalPostId;  // Link to pet post
  @HiveField(2) final Post petPost;
  @HiveField(3) final List<Reaction> reactions;
  @HiveField(4) final List<Comment> comments;
  @HiveField(5) final int shareCount;
  @HiveField(6) final DateTime publishedAt;
}

// Reaction types: sad, love, angry, laugh, smirking
enum ReactionType { sad, love, angry, laugh, smirking }
```

### 4.2 Community Features
```dart
// lib/features/community/data/repositories/community_repository.dart
class CommunityRepository {
  // Feed
  Future<List<CommunityPost>> getFeed({int page = 0, int limit = 20});
  Future<CommunityPost> getPostDetail(String postId);
  
  // Interactions
  Future<void> addReaction(String postId, ReactionType type);
  Future<void> removeReaction(String postId, ReactionType type);
  Future<Comment> addComment(String postId, String content);
  Future<void> deleteComment(String commentId);
  
  // External share
  Future<void> shareToFacebook(String postId);
  Future<void> shareToInstagram(String postId);
}
```

### 4.3 External Social Media Integration
```dart
// lib/core/services/social_share_service.dart
class SocialShareService {
  // Facebook Share
  Future<void> shareToFacebook({
    required String imageUrl,
    required String caption,
  }) async {
    // Use share_plus package or Facebook SDK
    final url = 'https://www.facebook.com/sharer/sharer.php?u=$imageUrl';
    await launchUrl(Uri.parse(url));
  }

  // Instagram Share (deep link)
  Future<void> shareToInstagram({
    required File imageFile,
    required String caption,
  }) async {
    // Save to gallery first
    await _saveToGallery(imageFile);
    
    // Open Instagram
    const instagramUrl = 'instagram://library';
    await launchUrl(Uri.parse(instagramUrl));
  }
}
```

### 4.4 UI Pages
- [x] Community Feed Page (✅ đã có)
- [ ] Post Detail Page (với comments)
- [ ] Comment Section Widget
- [ ] Share Dialog (chọn platform)
- [ ] User Profile in Community

**Deliverable**: Full community với like, comment, share

---

## **PHASE 5: CHAT & REAL-TIME FEATURES** (Week 10-11)

### 5.1 Chat Models
```dart
// lib/features/chat/domain/models/chat_model.dart
@HiveType(typeId: 5)
class Chat {
  @HiveField(0) final String chatId;
  @HiveField(1) final List<String> participantIds;
  @HiveField(2) final Message? lastMessage;
  @HiveField(3) final DateTime updatedAt;
}

// lib/features/chat/domain/models/message_model.dart
@HiveType(typeId: 6)
class Message {
  @HiveField(0) final String messageId;
  @HiveField(1) final String chatId;
  @HiveField(2) final String senderId;
  @HiveField(3) final String receiverId;
  @HiveField(4) final String? textContent;
  @HiveField(5) final MessageContentType? contentType;
  @HiveField(6) final String? fileUrl;
  @HiveField(7) final int? fileSize;
  @HiveField(8) final DateTime timestamp;
  @HiveField(9) final bool isRead;
}

enum MessageContentType { text, image, video, gif }
```

### 5.2 Real-time Communication (WebSocket)
```dart
// lib/core/network/websocket_service.dart
class WebSocketService {
  late IO.Socket _socket;

  void connect(String userId) {
    _socket = IO.io('wss://your-backend.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'userId': userId},
    });

    _socket.connect();

    // Listen to events
    _socket.on('newMessage', _handleNewMessage);
    _socket.on('petInteraction', _handlePetInteraction);
    _socket.on('userOnline', _handleUserOnline);
  }

  void sendMessage(Message message) {
    _socket.emit('sendMessage', message.toJson());
  }

  void emitPetInteraction(String petId, String action) {
    _socket.emit('petInteraction', {
      'petId': petId,
      'action': action,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Stream<Message> get messageStream => _messageController.stream;
  Stream<PetInteraction> get petInteractionStream => _interactionController.stream;
}
```

### 5.3 Chat Repository
```dart
// lib/features/chat/data/repositories/chat_repository.dart
class ChatRepository {
  // Chat management
  Future<Chat> createChat(List<String> participantIds);
  Future<List<Chat>> getUserChats(String userId);
  
  // Messaging
  Future<Message> sendTextMessage(String chatId, String text);
  Future<Message> sendImageMessage(String chatId, File image);
  Future<Message> sendVideoMessage(String chatId, File video);
  Stream<List<Message>> watchMessages(String chatId);
  Future<void> markAsRead(String messageId);
}
```

### 5.4 Real-time Pet Interaction (for SharedOwners)
```dart
// lib/features/home/presentation/providers/realtime_provider.dart
final realtimePetInteractionProvider = StreamProvider.family<PetInteraction, String>(
  (ref, homeId) {
    final wsService = ref.watch(webSocketServiceProvider);
    return wsService.petInteractionStream
        .where((interaction) => interaction.homeId == homeId);
  },
);

// UI: Show toast when SharedOwner interacts
Consumer(
  builder: (context, ref, child) {
    ref.listen(realtimePetInteractionProvider(homeId), (prev, next) {
      if (next.hasValue) {
        final interaction = next.value!;
        _showInteractionToast('${interaction.userName} is playing with ${interaction.petName}');
      }
    });
    return YourWidget();
  },
)
```

### 5.5 UI Implementation
- [ ] Chat List Page
- [ ] Chat Detail Page (messages)
- [ ] Message Input Widget (text + media)
- [ ] Media Size Validator Dialog
- [ ] Realtime Interaction Toast/Banner
- [ ] Online Status Indicators

**Deliverable**: Chat with friends + Realtime pet interactions

---

## **PHASE 6: NOTIFICATIONS & HEALTH SCREENING** (Week 12)

### 6.1 Notification Models
```dart
// lib/features/notifications/domain/models/notification_model.dart
@HiveType(typeId: 7)
class AppNotification {
  @HiveField(0) final String notificationId;
  @HiveField(1) final String targetUserId;
  @HiveField(2) final String? relatedUserId;
  @HiveField(3) final String? relatedPostId;
  @HiveField(4) final NotificationType type;
  @HiveField(5) final String message;
  @HiveField(6) final bool isRead;
  @HiveField(7) final DateTime createdAt;
}

enum NotificationType {
  follower,           // Someone followed you
  specialDay,         // Pet birthday, adoption anniversary
  healthReminder,     // Health screening reminder
  commentReply,       // Someone replied to your comment
  postLike,           // Someone liked your post
}
```

### 6.2 Notification Service
```dart
// lib/core/services/notification_service.dart
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  Future<void> initialize() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _notificationsPlugin.initialize(initializationSettings);
  }

  // Local notification
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'homies_buddy_channel',
      'Homies Buddy',
      importance: Importance.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    
    await _notificationsPlugin.show(0, title, body, details, payload: payload);
  }

  // Push notification (FCM)
  Future<void> setupPushNotifications(String userId) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    // Save token to backend
    await _saveTokenToBackend(userId, fcmToken);
    
    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Schedule periodic health reminders
  Future<void> scheduleHealthReminder({
    required String petId,
    required DateTime scheduledDate,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      petId.hashCode,
      'Health Check Reminder',
      'Time to check ${pet.name}\'s health! 🩺',
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(...),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
```

### 6.3 Health Screening Scheduler
```dart
// lib/features/home/data/services/health_scheduler_service.dart
class HealthSchedulerService {
  // Create periodic reminders
  Future<void> scheduleHealthScreening({
    required String petId,
    required Duration period,  // e.g., Duration(days: 30)
  }) async {
    final now = DateTime.now();
    final nextDate = now.add(period);
    
    final record = HealthScreeningRecord(
      recordId: Uuid().v4(),
      petId: petId,
      type: HealthScreeningType.health,
      scheduledDate: nextDate,
      isCompleted: false,
    );
    
    await _petRepository.addHealthRecord(petId, record);
    await _notificationService.scheduleHealthReminder(
      petId: petId,
      scheduledDate: nextDate,
    );
  }

  // Check and reset at end of period
  Future<void> checkAndResetPeriod() async {
    final pets = await _petRepository.getAllPets();
    
    for (final pet in pets) {
      for (final record in pet.healthRecords) {
        if (!record.isCompleted && record.scheduledDate.isBefore(DateTime.now())) {
          // Send overdue notification
          await _notificationService.showLocalNotification(
            title: 'Missed Health Check!',
            body: 'You missed ${pet.name}\'s health screening. Please complete it!',
          );
        }
      }
    }
  }
}
```

### 6.4 UI Implementation
- [ ] Notification Center Page
- [ ] Notification Badge (unread count)
- [ ] Health Reminder Dialog
- [ ] Health Screening Checklist Page
- [ ] Special Day Celebration Animation

**Deliverable**: Full notification system + Health reminders

---

## **PHASE 7: MIMI AI AGENT** (Week 13-14)

### 7.1 Mimi AI Models
```dart
// lib/features/help/domain/models/mimi_conversation.dart
@HiveType(typeId: 8)
class MimiConversation {
  @HiveField(0) final String conversationId;
  @HiveField(1) final String userId;
  @HiveField(2) final String userProfile;
  @HiveField(3) final List<MimiMessage> messages;
  @HiveField(4) final DateTime createdAt;
}

// lib/features/help/domain/models/mimi_message.dart
@HiveType(typeId: 9)
class MimiMessage {
  @HiveField(0) final String messageId;
  @HiveField(1) final String role;  // "user" or "assistant"
  @HiveField(2) final String content;
  @HiveField(3) final DateTime timestamp;
}
```

### 7.2 AI Service Integration
```dart
// lib/features/help/data/services/mimi_ai_service.dart
class MimiAIService {
  final Dio _dio;

  // Option 1: Use OpenAI GPT-4 with custom knowledge base
  Future<String> askMimi({
    required String userQuery,
    required String userProfile,  // Pet info for context
    List<MimiMessage>? conversationHistory,
  }) async {
    // 1. Build context from knowledge base
    final knowledgeContext = await _getRelevantKnowledge(userQuery);
    
    // 2. Build messages with context
    final messages = [
      {
        'role': 'system',
        'content': '''You are Mimi, a friendly AI pet care assistant. 
        You help users with animal nurturing questions.
        User's pets: $userProfile
        Knowledge base: $knowledgeContext
        Always be warm, encouraging, and provide actionable advice.'''
      },
      ...(conversationHistory?.map((m) => m.toJson()) ?? []),
      {'role': 'user', 'content': userQuery},
    ];

    // 3. Call OpenAI API
    final response = await _dio.post(
      'https://api.openai.com/v1/chat/completions',
      data: {
        'model': 'gpt-4',
        'messages': messages,
        'temperature': 0.7,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $OPENAI_API_KEY',
      }),
    );

    return response.data['choices'][0]['message']['content'];
  }

  // Option 2: Use custom fine-tuned model
  Future<String> askMimiCustomModel(String query) async {
    final response = await _dio.post(
      'https://your-backend.com/api/mimi/ask',
      data: {'query': query},
    );
    return response.data['answer'];
  }

  Future<String> _getRelevantKnowledge(String query) async {
    // Search knowledge base for relevant info
    // Can use vector similarity search (Pinecone, Milvus)
  }
}
```

### 7.3 Knowledge Base Setup
```dart
// lib/features/help/domain/models/knowledge_item.dart
class KnowledgeItem {
  final String id;
  final String category;      // "dog_health", "cat_nutrition", etc.
  final String title;
  final String content;
  final List<String> tags;
  final DateTime updatedAt;
}

// Initial knowledge base (can expand)
final knowledgeBase = [
  KnowledgeItem(
    category: 'dog_health',
    title: 'Common Signs of Dog Illness',
    content: '''
    - Loss of appetite
    - Lethargy or decreased activity
    - Vomiting or diarrhea
    - Excessive drinking or urination
    ...
    ''',
    tags: ['health', 'dog', 'symptoms'],
  ),
  // ... more items
];
```

### 7.4 UI Implementation
- [x] Ask for Help Page (✅ đã có placeholder)
- [ ] Mimi Chat Interface (like ChatGPT)
- [ ] Typing Indicator Animation
- [ ] Suggested Questions Chips
- [ ] Knowledge Base Browser
- [ ] Conversation History

**Deliverable**: Working Mimi AI assistant

---

## **PHASE 8: POLISH & OPTIMIZATION** (Week 15-16)

### 8.1 Performance Optimization
- [ ] Image caching optimization
- [ ] Lazy loading for feeds
- [ ] Pagination for all lists
- [ ] Reduce unnecessary rebuilds
- [ ] Optimize Riverpod providers
- [ ] Memory leak detection

### 8.2 Error Handling
```dart
// lib/core/errors/app_exception.dart
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error']);
}

class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed']);
}

class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation error']);
}

// Global error handler
void handleError(Object error, StackTrace stack) {
  if (error is AppException) {
    // Show user-friendly message
    showErrorDialog(error.message);
  } else {
    // Log to crashlytics
    FirebaseCrashlytics.instance.recordError(error, stack);
  }
}
```

### 8.3 Testing
```dart
// test/unit/models/user_model_test.dart
void main() {
  group('User Model', () {
    test('should serialize to JSON correctly', () {
      final user = User(...);
      final json = user.toJson();
      expect(json['userId'], user.userId);
    });
  });
}

// test/widget/post_card_test.dart
void main() {
  testWidgets('PostCard displays post content', (tester) async {
    await tester.pumpWidget(PostCard(post: mockPost));
    expect(find.text(mockPost.title), findsOneWidget);
  });
}
```

### 8.4 Final Features
- [ ] Profile editing
- [ ] Settings page
- [ ] About page
- [ ] Privacy policy
- [ ] Terms of service
- [ ] App tour/tutorial
- [ ] Dark mode toggle
- [ ] Language selection

**Deliverable**: Production-ready app

---

## **PHASE 9: DEPLOYMENT** (Week 17)

### 9.1 Pre-deployment Checklist
- [ ] All features tested
- [ ] No critical bugs
- [ ] Performance benchmarks passed
- [ ] Security audit completed
- [ ] Privacy compliance (GDPR, etc.)
- [ ] App store assets ready (screenshots, description)

### 9.2 Build & Release
```bash
# Android
flutter build appbundle --release

# iOS
flutter build ipa --release
```

### 9.3 Store Submission
- [ ] Google Play Console setup
- [ ] App Store Connect setup
- [ ] Beta testing (TestFlight/Internal Testing)
- [ ] Production release

---

## 📊 PROJECT TIMELINE SUMMARY

| Phase | Duration | Features |
|-------|----------|----------|
| Phase 0 | 1 week | Setup & Dependencies |
| Phase 1 | 2 weeks | Authentication & User Management |
| Phase 2 | 2 weeks | Home Tab - Basic (Create home, add pets) |
| Phase 3 | 2 weeks | Post & Media Management (Upload images/videos) |
| Phase 4 | 2 weeks | Community Tab - Full (Like, comment, share) |
| Phase 5 | 2 weeks | Chat & Real-time (Messages + SharedOwner sync) |
| Phase 6 | 1 week | Notifications & Health Screening |
| Phase 7 | 2 weeks | Mimi AI Agent |
| Phase 8 | 2 weeks | Polish & Optimization |
| Phase 9 | 1 week | Deployment |
| **TOTAL** | **17 weeks** | **~4 months** |

---

## 🚀 GETTING STARTED - NEXT STEPS

### Immediate Actions (This Week)
1. ✅ Sửa lỗi compile (DONE)
2. ⏭️ Cập nhật `pubspec.yaml` với all dependencies
3. ⏭️ Setup Firebase project
4. ⏭️ Setup Android/iOS signing
5. ⏭️ Create backend architecture design

### Week 1 Tasks
- [ ] Install all dependencies
- [ ] Setup Firebase (Auth, Firestore, Storage)
- [ ] Create authentication pages UI
- [ ] Implement login/register logic
- [ ] Test authentication flow

---

## 📞 SUPPORT & RESOURCES

- Flutter Docs: https://docs.flutter.dev/
- Firebase: https://firebase.google.com/docs/flutter
- Riverpod: https://riverpod.dev/
- Unity Flutter: https://github.com/juicycleff/flutter-unity-view-widget
- OpenAI API: https://platform.openai.com/docs

---

**Created**: January 29, 2026  
**Status**: ✅ Ready to start Phase 1  
**Last Updated**: January 29, 2026
