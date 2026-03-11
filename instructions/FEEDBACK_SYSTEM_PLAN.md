# 📝 FEEDBACK SYSTEM - THIẾT KẾ & IMPLEMENTATION PLAN

> Plan thiết kế chi tiết cho tính năng Feedback trong Homies Buddy
> 
> **Ngày tạo:** 10/03/2026  
> **Trạng thái:** Planning Phase

---

## 🎯 MỤC TIÊU & PHẠM VI

### Mục tiêu chính
1. **Thu thập phản hồi từ người dùng** về trải nghiệm sử dụng ứng dụng
2. **Report nội dung không phù hợp** (posts, comments, users)
3. **Gợi ý cải tiến** từ cộng đồng
4. **Hỗ trợ khách hàng** trực tiếp qua feedback channel

### Loại Feedback được hỗ trợ

| Loại | Mô tả | Priority |
|------|-------|----------|
| **App Feedback** | Phản hồi chung về ứng dụng | P0 - Must Have |
| **Bug Report** | Báo lỗi kỹ thuật với screenshots | P0 - Must Have |
| **Feature Request** | Đề xuất tính năng mới | P1 - Should Have |
| **Content Report** | Report posts/comments vi phạm | P0 - Must Have |
| **User Report** | Report user có hành vi không phù hợp | P1 - Should Have |
| **Rating & Review** | Đánh giá app trên store | P2 - Nice to Have |

---

## 📊 PHÂN TÍCH YÊU CẦU

### Functional Requirements

#### 1. App Feedback Form
- [ ] Người dùng có thể truy cập feedback form từ **Profile Tab > Settings**
- [ ] Các trường nhập liệu:
  - Loại feedback (dropdown)
  - Tiêu đề (required, 5-100 ký tự)
  - Nội dung chi tiết (required, 10-1000 ký tự)
  - Email liên hệ (optional, prefilled từ profile)
  - Đính kèm ảnh/video (optional, tối đa 5 files)
  - Device info (auto-collected: OS, app version, device model)
- [ ] Validate input trước khi submit
- [ ] Loading state khi submit
- [ ] Success/Error feedback

#### 2. Content Report System
- [ ] Nút "Report" trên posts, comments
- [ ] Quick report reasons:
  - Spam
  - Nội dung không phù hợp
  - Bạo lực/hình ảnh gây khó chịu
  - Thông tin sai sự thật
  - Khác (nhập chi tiết)
- [ ] Confirmation dialog trước khi report
- [ ] Ẩn nội dung đã report cho user (local)
- [ ] Không cho user report cùng 1 content nhiều lần

#### 3. User Report System
- [ ] Report user từ profile page
- [ ] Reasons: Harassment, Fake account, Inappropriate content, Spam
- [ ] Optional: Block user sau khi report

#### 4. Admin Dashboard (Future - Out of scope for MVP)
- [ ] View all feedbacks
- [ ] Filter by type, status, date
- [ ] Reply to feedback
- [ ] Mark as resolved/spam

### Non-Functional Requirements
- **Performance:** Submit feedback trong < 3 giây
- **Availability:** 99.5% uptime
- **Security:** Validate & sanitize input, prevent spam
- **Privacy:** Không expose reporter identity cho bị report
- **Scalability:** Hỗ trợ 10,000 feedbacks/tháng

---

## 🗄️ DATABASE DESIGN

### 1. Firestore Collections

#### Collection: `feedbacks`
```typescript
{
  id: string;                    // Auto-generated
  userId: string;                // User ID (indexed)
  type: FeedbackType;            // enum: app_feedback, bug_report, feature_request
  title: string;                 // 5-100 chars
  content: string;               // 10-1000 chars
  email?: string;                // Optional contact email
  attachments: string[];         // URLs from Firebase Storage
  deviceInfo: {
    platform: 'iOS' | 'Android'; // OS platform
    osVersion: string;           // e.g., "iOS 16.3"
    appVersion: string;          // e.g., "1.2.5"
    deviceModel: string;         // e.g., "iPhone 14 Pro"
  };
  status: FeedbackStatus;        // enum: pending, in_review, resolved, spam
  adminReply?: string;           // Admin's response
  createdAt: Timestamp;
  updatedAt: Timestamp;
  resolvedAt?: Timestamp;
}
```

**Indexes:**
- `userId` (for user's feedback history)
- `type` + `status` (for filtering)
- `createdAt` (for sorting)

---

#### Collection: `content_reports`
```typescript
{
  id: string;                    // Auto-generated
  reporterId: string;            // User who reports (indexed)
  contentType: 'post' | 'comment'; // Type of content
  contentId: string;             // Post/Comment ID (indexed)
  contentAuthorId: string;       // Author của nội dung bị report
  reason: ReportReason;          // enum: spam, inappropriate, violence, misinformation, other
  details?: string;              // Chi tiết (nếu chọn "other")
  status: ReportStatus;          // pending, reviewed, action_taken, dismissed
  actionTaken?: string;          // E.g., "Content removed", "Warning sent"
  reviewedBy?: string;           // Admin ID
  createdAt: Timestamp;
  reviewedAt?: Timestamp;
}
```

**Indexes:**
- `reporterId` + `contentId` (composite - prevent duplicate reports)
- `contentId` + `status` (for checking report count)
- `status` (for admin queue)

---

#### Collection: `user_reports`
```typescript
{
  id: string;
  reporterId: string;
  reportedUserId: string;        // User bị report (indexed)
  reason: UserReportReason;      // harassment, fake_account, spam, other
  details?: string;
  status: ReportStatus;
  createdAt: Timestamp;
  reviewedAt?: Timestamp;
}
```

**Indexes:**
- `reporterId` + `reportedUserId` (prevent duplicates)
- `reportedUserId` + `status` (count reports per user)

---

### 2. Firestore Rules
```javascript
// feedbacks collection
match /feedbacks/{feedbackId} {
  allow read: if request.auth != null && 
              (request.auth.uid == resource.data.userId || 
               request.auth.token.admin == true);
  allow create: if request.auth != null && 
                request.resource.data.userId == request.auth.uid;
  allow update: if request.auth.token.admin == true; // Only admin
}

// content_reports collection
match /content_reports/{reportId} {
  allow read: if request.auth.token.admin == true; // Admin only
  allow create: if request.auth != null && 
                request.resource.data.reporterId == request.auth.uid &&
                !exists(/databases/$(database)/documents/content_reports/$(request.auth.uid + '_' + request.resource.data.contentId));
}

// user_reports collection
match /user_reports/{reportId} {
  allow read: if request.auth.token.admin == true;
  allow create: if request.auth != null && 
                request.resource.data.reporterId == request.auth.uid;
}
```

---

## 🎨 UI/UX DESIGN

### 1. App Feedback Screen

**Vị trí:** Profile Tab > Settings > "Gửi phản hồi"

**Layout:**
```
┌─────────────────────────────────────────┐
│  ← Gửi Phản Hồi               [Close]   │ ← AppBar
├─────────────────────────────────────────┤
│                                         │
│  📋 Loại phản hồi *                     │
│  [Dropdown: Phản hồi chung       ▼]    │
│                                         │
│  📝 Tiêu đề *                           │
│  [TextField: Nhập tiêu đề...]          │
│                                         │
│  💬 Nội dung chi tiết *                 │
│  ┌─────────────────────────────────┐   │
│  │ [TextField: Mô tả chi tiết...]  │   │
│  │                                 │   │
│  │ (multiline, 10-1000 chars)      │   │
│  └─────────────────────────────────┘   │
│                                         │
│  📧 Email liên hệ (không bắt buộc)      │
│  [TextField: user@email.com]           │
│                                         │
│  📷 Đính kèm ảnh/video                  │
│  [Image Picker Grid]                    │
│  ┌───┬───┬───┬───┬───┐                 │
│  │ + │ 📷│ 📷│   │   │ (max 5)         │
│  └───┴───┴───┴───┴───┘                 │
│                                         │
│  ℹ️  Thông tin thiết bị được gửi kèm    │
│     để hỗ trợ khắc phục lỗi             │
│                                         │
│  [        GỬI PHẢN HỒI (Orange)     ]  │ ← Filled Button
│                                         │
└─────────────────────────────────────────┘
```

**States:**
- **Loading:** Circular progress in button, disable inputs
- **Success:** Show SnackBar "Cảm ơn phản hồi của bạn!" → Navigate back
- **Error:** Show SnackBar "Có lỗi xảy ra, vui lòng thử lại"

---

### 2. Content Report Flow

**Entry Points:**
- 3-dot menu trên `SocialPostCard`
- 3-dot menu trên comment item

**Flow:**
```
User taps "Report" 
    ↓
Show AlertDialog:
┌─────────────────────────────────┐
│  Báo cáo nội dung               │
│                                 │
│  Vì sao bạn báo cáo?            │
│  ○ Spam                         │
│  ○ Nội dung không phù hợp       │
│  ○ Bạo lực                      │
│  ○ Thông tin sai                │
│  ● Khác (nhập lý do)            │
│                                 │
│  [TextField if "Khác"]          │
│                                 │
│  [Hủy]  [Gửi báo cáo (Red)]    │
└─────────────────────────────────┘
    ↓
Submit to Firestore
    ↓
Success → SnackBar "Đã gửi báo cáo, chúng tôi sẽ xem xét"
    ↓
Ẩn content cho user (local state)
```

---

### 3. User Report Flow

**Entry Point:** User Profile Screen > 3-dot menu

**Dialog:**
```
┌─────────────────────────────────┐
│  Báo cáo người dùng             │
│                                 │
│  Lý do:                         │
│  ○ Quấy rối                     │
│  ○ Tài khoản giả mạo            │
│  ○ Nội dung không phù hợp       │
│  ○ Spam                         │
│                                 │
│  ☐ Chặn người dùng này          │
│                                 │
│  [Hủy]  [Báo cáo (Red)]        │
└─────────────────────────────────┘
```

---

### 4. In-App Rating Prompt (Optional)

**Trigger:** Sau 7 ngày sử dụng + đã tạo >= 3 posts

```
┌─────────────────────────────────┐
│  💚 Bạn thích Homies Buddy?     │
│                                 │
│  Đánh giá giúp chúng tôi cải   │
│  thiện ứng dụng                 │
│                                 │
│  ⭐⭐⭐⭐⭐ (tap to rate)         │
│                                 │
│  [Để sau]  [Đánh giá ngay]     │
└─────────────────────────────────┘
```

**Logic:**
- Nếu >= 4 sao: Redirect to App Store/Play Store
- Nếu < 4 sao: Mở feedback form trong app

---

## 🏗️ ARCHITECTURE & IMPLEMENTATION

### Folder Structure
```
lib/
└── features/
    └── feedback/
        ├── data/
        │   ├── models/
        │   │   ├── feedback_model.dart           # App feedback model
        │   │   ├── content_report_model.dart     # Content report model
        │   │   ├── user_report_model.dart        # User report model
        │   │   ├── device_info_model.dart        # Device metadata
        │   │   └── models.dart                   # Barrel export
        │   ├── repositories/
        │   │   ├── feedback_repository.dart      # Firestore operations
        │   │   └── device_info_service.dart      # Get device info
        │   └── enums/
        │       ├── feedback_type.dart
        │       ├── feedback_status.dart
        │       ├── report_reason.dart
        │       └── report_status.dart
        ├── presentation/
        │   ├── screens/
        │   │   ├── app_feedback_screen.dart      # Main feedback form
        │   │   └── feedback_history_screen.dart  # User's past feedbacks
        │   ├── widgets/
        │   │   ├── feedback_form.dart            # Reusable form widget
        │   │   ├── report_dialog.dart            # Content/User report dialog
        │   │   ├── rating_prompt_dialog.dart     # In-app rating
        │   │   └── attachment_picker.dart        # Image picker grid
        │   └── providers/
        │       ├── feedback_provider.dart        # State management
        │       └── report_provider.dart          # Report state
        └── README.md                             # Feature documentation
```

---

## 📝 MODEL DEFINITIONS

### 1. FeedbackModel
```dart
// lib/features/feedback/data/models/feedback_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/feedback_type.dart';
import '../enums/feedback_status.dart';
import 'device_info_model.dart';

part 'feedback_model.freezed.dart';
part 'feedback_model.g.dart';

@freezed
class FeedbackModel with _$FeedbackModel {
  const factory FeedbackModel({
    required String id,
    required String userId,
    required FeedbackType type,
    required String title,
    required String content,
    String? email,
    @Default([]) List<String> attachments,
    required DeviceInfoModel deviceInfo,
    @Default(FeedbackStatus.pending) FeedbackStatus status,
    String? adminReply,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? resolvedAt,
  }) = _FeedbackModel;

  factory FeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackModelFromJson(json);

  /// Convert Firestore DocumentSnapshot to FeedbackModel
  factory FeedbackModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeedbackModel.fromJson({
      'id': doc.id,
      ...data,
      'createdAt': (data['createdAt'] as Timestamp).toDate().toIso8601String(),
      'updatedAt': (data['updatedAt'] as Timestamp).toDate().toIso8601String(),
      if (data['resolvedAt'] != null)
        'resolvedAt': (data['resolvedAt'] as Timestamp).toDate().toIso8601String(),
    });
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Firestore auto-generates ID
    json['createdAt'] = Timestamp.fromDate(createdAt);
    json['updatedAt'] = Timestamp.fromDate(updatedAt);
    if (resolvedAt != null) {
      json['resolvedAt'] = Timestamp.fromDate(resolvedAt!);
    }
    return json;
  }
}

extension FeedbackModelX on FeedbackModel {
  /// Lấy status label tiếng Việt
  String get statusLabel => switch (status) {
    FeedbackStatus.pending => 'Đang chờ',
    FeedbackStatus.inReview => 'Đang xem xét',
    FeedbackStatus.resolved => 'Đã giải quyết',
    FeedbackStatus.spam => 'Spam',
  };

  /// Kiểm tra xem feedback có được resolved chưa
  bool get isResolved => status == FeedbackStatus.resolved;

  /// Time ago string
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    
    if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()} tháng trước';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} ngày trước';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} giờ trước';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
```

---

### 2. ContentReportModel
```dart
// lib/features/feedback/data/models/content_report_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/report_reason.dart';
import '../enums/report_status.dart';

part 'content_report_model.freezed.dart';
part 'content_report_model.g.dart';

@freezed
class ContentReportModel with _$ContentReportModel {
  const factory ContentReportModel({
    required String id,
    required String reporterId,
    required String contentType, // 'post' or 'comment'
    required String contentId,
    required String contentAuthorId,
    required ReportReason reason,
    String? details,
    @Default(ReportStatus.pending) ReportStatus status,
    String? actionTaken,
    String? reviewedBy,
    required DateTime createdAt,
    DateTime? reviewedAt,
  }) = _ContentReportModel;

  factory ContentReportModel.fromJson(Map<String, dynamic> json) =>
      _$ContentReportModelFromJson(json);

  factory ContentReportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ContentReportModel.fromJson({
      'id': doc.id,
      ...data,
      'createdAt': (data['createdAt'] as Timestamp).toDate().toIso8601String(),
      if (data['reviewedAt'] != null)
        'reviewedAt': (data['reviewedAt'] as Timestamp).toDate().toIso8601String(),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    json['createdAt'] = Timestamp.fromDate(createdAt);
    if (reviewedAt != null) {
      json['reviewedAt'] = Timestamp.fromDate(reviewedAt!);
    }
    return json;
  }
}

extension ContentReportModelX on ContentReportModel {
  /// Unique composite ID để prevent duplicate reports
  String get compositeId => '${reporterId}_$contentId';

  /// Lấy reason label tiếng Việt
  String get reasonLabel => switch (reason) {
    ReportReason.spam => 'Spam',
    ReportReason.inappropriate => 'Nội dung không phù hợp',
    ReportReason.violence => 'Bạo lực',
    ReportReason.misinformation => 'Thông tin sai',
    ReportReason.other => 'Khác',
  };
}
```

---

### 3. DeviceInfoModel
```dart
// lib/features/feedback/data/models/device_info_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info_model.freezed.dart';
part 'device_info_model.g.dart';

@freezed
class DeviceInfoModel with _$DeviceInfoModel {
  const factory DeviceInfoModel({
    required String platform,      // 'iOS' or 'Android'
    required String osVersion,      // e.g., "iOS 16.3"
    required String appVersion,     // e.g., "1.2.5"
    required String deviceModel,    // e.g., "iPhone 14 Pro"
  }) = _DeviceInfoModel;

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoModelFromJson(json);
}
```

---

### 4. Enums
```dart
// lib/features/feedback/data/enums/feedback_type.dart
enum FeedbackType {
  @JsonValue('app_feedback')
  appFeedback,
  
  @JsonValue('bug_report')
  bugReport,
  
  @JsonValue('feature_request')
  featureRequest,
}

// lib/features/feedback/data/enums/feedback_status.dart
enum FeedbackStatus {
  @JsonValue('pending')
  pending,
  
  @JsonValue('in_review')
  inReview,
  
  @JsonValue('resolved')
  resolved,
  
  @JsonValue('spam')
  spam,
}

// lib/features/feedback/data/enums/report_reason.dart
enum ReportReason {
  @JsonValue('spam')
  spam,
  
  @JsonValue('inappropriate')
  inappropriate,
  
  @JsonValue('violence')
  violence,
  
  @JsonValue('misinformation')
  misinformation,
  
  @JsonValue('other')
  other,
}

// lib/features/feedback/data/enums/report_status.dart
enum ReportStatus {
  @JsonValue('pending')
  pending,
  
  @JsonValue('reviewed')
  reviewed,
  
  @JsonValue('action_taken')
  actionTaken,
  
  @JsonValue('dismissed')
  dismissed,
}
```

---

## 🔌 REPOSITORY LAYER

### FeedbackRepository
```dart
// lib/features/feedback/data/repositories/feedback_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/feedback_model.dart';
import '../../data/models/content_report_model.dart';
import '../../data/models/user_report_model.dart';
import '../../core/services/firebase_service.dart';
import '../../core/mixins/session_guard_mixin.dart';

/// Feedback Repository - Quản lý feedbacks & reports
///
/// Handles:
/// - Create/Get app feedbacks
/// - Create content reports
/// - Create user reports
///
/// 🛡️ Protected with SessionGuardMixin
class FeedbackRepository with SessionGuardMixin {
  final FirebaseService _firebaseService = FirebaseService.instance;

  // ==================== APP FEEDBACKS ====================

  /// Submit app feedback với validation
  Future<void> submitFeedback(FeedbackModel feedback) async {
    return guardedOperation(
      () async {
        // Validate
        if (feedback.title.length < 5 || feedback.title.length > 100) {
          throw Exception('Tiêu đề phải từ 5-100 ký tự');
        }
        if (feedback.content.length < 10 || feedback.content.length > 1000) {
          throw Exception('Nội dung phải từ 10-1000 ký tự');
        }

        // Submit to Firestore
        await _firebaseService.firestore
            .collection('feedbacks')
            .add(feedback.toFirestore());
      },
      requiresAuth: true,
    );
  }

  /// Get feedbacks của user hiện tại
  Stream<List<FeedbackModel>> getUserFeedbacks() {
    return guardedStream(
      () {
        final userId = _firebaseService.currentUser?.uid;
        if (userId == null) throw Exception('Not authenticated');

        return _firebaseService.firestore
            .collection('feedbacks')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => FeedbackModel.fromFirestore(doc))
                .toList());
      },
      requiresAuth: true,
    );
  }

  // ==================== CONTENT REPORTS ====================

  /// Report một post hoặc comment
  Future<void> reportContent(ContentReportModel report) async {
    return guardedOperation(
      () async {
        final userId = _firebaseService.currentUser?.uid;
        if (userId == null) throw Exception('Not authenticated');

        // Check duplicate report (composite key)
        final existingReports = await _firebaseService.firestore
            .collection('content_reports')
            .where('reporterId', isEqualTo: userId)
            .where('contentId', isEqualTo: report.contentId)
            .limit(1)
            .get();

        if (existingReports.docs.isNotEmpty) {
          throw Exception('Bạn đã báo cáo nội dung này rồi');
        }

        // Create report
        await _firebaseService.firestore
            .collection('content_reports')
            .add(report.toFirestore());
      },
      requiresAuth: true,
    );
  }

  /// Check xem user đã report content chưa
  Future<bool> hasReportedContent(String contentId) async {
    return guardedOperation(
      () async {
        final userId = _firebaseService.currentUser?.uid;
        if (userId == null) return false;

        final reports = await _firebaseService.firestore
            .collection('content_reports')
            .where('reporterId', isEqualTo: userId)
            .where('contentId', isEqualTo: contentId)
            .limit(1)
            .get();

        return reports.docs.isNotEmpty;
      },
      requiresAuth: false,
    );
  }

  // ==================== USER REPORTS ====================

  /// Report một user
  Future<void> reportUser(UserReportModel report) async {
    return guardedOperation(
      () async {
        final userId = _firebaseService.currentUser?.uid;
        if (userId == null) throw Exception('Not authenticated');

        // Không cho report chính mình
        if (report.reportedUserId == userId) {
          throw Exception('Không thể báo cáo chính mình');
        }

        // Check duplicate
        final existingReports = await _firebaseService.firestore
            .collection('user_reports')
            .where('reporterId', isEqualTo: userId)
            .where('reportedUserId', isEqualTo: report.reportedUserId)
            .limit(1)
            .get();

        if (existingReports.docs.isNotEmpty) {
          throw Exception('Bạn đã báo cáo người dùng này rồi');
        }

        // Create report
        await _firebaseService.firestore
            .collection('user_reports')
            .add(report.toFirestore());
      },
      requiresAuth: true,
    );
  }

  /// Check xem đã report user chưa
  Future<bool> hasReportedUser(String userId) async {
    return guardedOperation(
      () async {
        final currentUserId = _firebaseService.currentUser?.uid;
        if (currentUserId == null) return false;

        final reports = await _firebaseService.firestore
            .collection('user_reports')
            .where('reporterId', isEqualTo: currentUserId)
            .where('reportedUserId', isEqualTo: userId)
            .limit(1)
            .get();

        return reports.docs.isNotEmpty;
      },
      requiresAuth: false,
    );
  }
}
```

---

### DeviceInfoService
```dart
// lib/features/feedback/data/repositories/device_info_service.dart
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/device_info_model.dart';

/// Service để lấy thông tin thiết bị & app version
class DeviceInfoService {
  static final DeviceInfoService _instance = DeviceInfoService._internal();
  factory DeviceInfoService() => _instance;
  DeviceInfoService._internal();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// Lấy thông tin thiết bị hiện tại
  Future<DeviceInfoModel> getDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appVersion = packageInfo.version;

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      return DeviceInfoModel(
        platform: 'iOS',
        osVersion: 'iOS ${iosInfo.systemVersion}',
        appVersion: appVersion,
        deviceModel: iosInfo.utsname.machine,
      );
    } else if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      return DeviceInfoModel(
        platform: 'Android',
        osVersion: 'Android ${androidInfo.version.release}',
        appVersion: appVersion,
        deviceModel: '${androidInfo.manufacturer} ${androidInfo.model}',
      );
    } else {
      return DeviceInfoModel(
        platform: 'Unknown',
        osVersion: 'Unknown',
        appVersion: appVersion,
        deviceModel: 'Unknown',
      );
    }
  }
}
```

---

## 🎭 PRESENTATION LAYER

### 1. AppFeedbackScreen
```dart
// lib/features/feedback/presentation/screens/app_feedback_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/feedback_model.dart';
import '../../data/enums/feedback_type.dart';
import '../providers/feedback_provider.dart';

class AppFeedbackScreen extends ConsumerStatefulWidget {
  const AppFeedbackScreen({super.key});

  @override
  ConsumerState<AppFeedbackScreen> createState() => _AppFeedbackScreenState();
}

class _AppFeedbackScreenState extends ConsumerState<AppFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _emailController = TextEditingController();

  FeedbackType _selectedType = FeedbackType.appFeedback;
  final List<String> _attachments = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await ref.read(feedbackProvider.notifier).submitFeedback(
        type: _selectedType,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        email: _emailController.text.trim().isEmpty 
            ? null 
            : _emailController.text.trim(),
        attachments: _attachments,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cảm ơn phản hồi của bạn! 💚'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gửi Phản Hồi'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Feedback Type Dropdown
            DropdownButtonFormField<FeedbackType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: '📋 Loại phản hồi',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: FeedbackType.appFeedback,
                  child: Text('Phản hồi chung'),
                ),
                DropdownMenuItem(
                  value: FeedbackType.bugReport,
                  child: Text('Báo lỗi'),
                ),
                DropdownMenuItem(
                  value: FeedbackType.featureRequest,
                  child: Text('Đề xuất tính năng'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '📝 Tiêu đề *',
                hintText: 'Nhập tiêu đề ngắn gọn...',
                border: OutlineInputBorder(),
              ),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập tiêu đề';
                }
                if (value.trim().length < 5) {
                  return 'Tiêu đề phải có ít nhất 5 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Content Field
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: '💬 Nội dung chi tiết *',
                hintText: 'Mô tả chi tiết vấn đề hoặc đề xuất...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 6,
              maxLength: 1000,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập nội dung';
                }
                if (value.trim().length < 10) {
                  return 'Nội dung phải có ít nhất 10 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Email Field (Optional)
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: '📧 Email liên hệ (không bắt buộc)',
                hintText: 'your@email.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Email không hợp lệ';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // TODO: Attachment Picker
            // AttachmentPicker(
            //   attachments: _attachments,
            //   onAttachmentsChanged: (attachments) {
            //     setState(() => _attachments = attachments);
            //   },
            // ),
            // const SizedBox(height: 16),

            // Info Text
            const Card(
              color: Color(0xFFFFF4E6),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Thông tin thiết bị được gửi kèm để hỗ trợ khắc phục lỗi',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            FilledButton(
              onPressed: _isSubmitting ? null : _submitFeedback,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFFFF8C42),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'GỬI PHẢN HỒI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 2. ReportDialog
```dart
// lib/features/feedback/presentation/widgets/report_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/enums/report_reason.dart';
import '../providers/report_provider.dart';

/// Dialog để report content (post/comment)
class ReportDialog extends ConsumerStatefulWidget {
  final String contentType; // 'post' or 'comment'
  final String contentId;
  final String contentAuthorId;

  const ReportDialog({
    super.key,
    required this.contentType,
    required this.contentId,
    required this.contentAuthorId,
  });

  @override
  ConsumerState<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends ConsumerState<ReportDialog> {
  ReportReason _selectedReason = ReportReason.spam;
  final _detailsController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    // Validate
    if (_selectedReason == ReportReason.other && 
        _detailsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập lý do chi tiết'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref.read(reportProvider.notifier).reportContent(
        contentType: widget.contentType,
        contentId: widget.contentId,
        contentAuthorId: widget.contentAuthorId,
        reason: _selectedReason,
        details: _detailsController.text.trim().isEmpty 
            ? null 
            : _detailsController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context, true); // Return true = reported successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã gửi báo cáo, chúng tôi sẽ xem xét'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context, false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Báo cáo nội dung'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vì sao bạn báo cáo nội dung này?',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            RadioListTile<ReportReason>(
              title: const Text('Spam'),
              value: ReportReason.spam,
              groupValue: _selectedReason,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedReason = value);
                }
              },
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<ReportReason>(
              title: const Text('Nội dung không phù hợp'),
              value: ReportReason.inappropriate,
              groupValue: _selectedReason,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedReason = value);
                }
              },
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<ReportReason>(
              title: const Text('Bạo lực/Gây khó chịu'),
              value: ReportReason.violence,
              groupValue: _selectedReason,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedReason = value);
                }
              },
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<ReportReason>(
              title: const Text('Thông tin sai sự thật'),
              value: ReportReason.misinformation,
              groupValue: _selectedReason,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedReason = value);
                }
              },
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<ReportReason>(
              title: const Text('Khác (nhập lý do)'),
              value: ReportReason.other,
              groupValue: _selectedReason,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedReason = value);
                }
              },
              contentPadding: EdgeInsets.zero,
            ),
            if (_selectedReason == ReportReason.other) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  hintText: 'Nhập lý do chi tiết...',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                maxLines: 2,
                maxLength: 200,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submitReport,
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          child: _isSubmitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Báo cáo'),
        ),
      ],
    );
  }
}
```

---

## 🔌 STATE MANAGEMENT (Riverpod)

### FeedbackProvider
```dart
// lib/features/feedback/presentation/providers/feedback_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/feedback_model.dart';
import '../../data/repositories/feedback_repository.dart';
import '../../data/repositories/device_info_service.dart';
import '../../data/enums/feedback_type.dart';
import '../../data/enums/feedback_status.dart';
import '../../core/services/firebase_service.dart';

final feedbackRepositoryProvider = Provider((ref) => FeedbackRepository());
final deviceInfoServiceProvider = Provider((ref) => DeviceInfoService());

final feedbackProvider = StateNotifierProvider<FeedbackNotifier, AsyncValue<void>>(
  (ref) => FeedbackNotifier(
    ref.watch(feedbackRepositoryProvider),
    ref.watch(deviceInfoServiceProvider),
  ),
);

class FeedbackNotifier extends StateNotifier<AsyncValue<void>> {
  final FeedbackRepository _repository;
  final DeviceInfoService _deviceInfoService;

  FeedbackNotifier(this._repository, this._deviceInfoService) 
      : super(const AsyncValue.data(null));

  Future<void> submitFeedback({
    required FeedbackType type,
    required String title,
    required String content,
    String? email,
    List<String> attachments = const [],
  }) async {
    state = const AsyncValue.loading();

    try {
      final deviceInfo = await _deviceInfoService.getDeviceInfo();
      final userId = FirebaseService.instance.currentUser?.uid;
      if (userId == null) throw Exception('Not authenticated');

      final feedback = FeedbackModel(
        id: '', // Firestore auto-generates
        userId: userId,
        type: type,
        title: title,
        content: content,
        email: email,
        attachments: attachments,
        deviceInfo: deviceInfo,
        status: FeedbackStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _repository.submitFeedback(feedback);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Provider cho danh sách feedbacks của user
final userFeedbacksProvider = StreamProvider<List<FeedbackModel>>((ref) {
  final repository = ref.watch(feedbackRepositoryProvider);
  return repository.getUserFeedbacks();
});
```

---

### ReportProvider
```dart
// lib/features/feedback/presentation/providers/report_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/content_report_model.dart';
import '../../data/enums/report_reason.dart';
import '../../data/enums/report_status.dart';
import '../../data/repositories/feedback_repository.dart';
import '../../core/services/firebase_service.dart';

final reportProvider = StateNotifierProvider<ReportNotifier, AsyncValue<void>>(
  (ref) => ReportNotifier(ref.watch(feedbackRepositoryProvider)),
);

class ReportNotifier extends StateNotifier<AsyncValue<void>> {
  final FeedbackRepository _repository;

  ReportNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> reportContent({
    required String contentType,
    required String contentId,
    required String contentAuthorId,
    required ReportReason reason,
    String? details,
  }) async {
    state = const AsyncValue.loading();

    try {
      final userId = FirebaseService.instance.currentUser?.uid;
      if (userId == null) throw Exception('Not authenticated');

      final report = ContentReportModel(
        id: '',
        reporterId: userId,
        contentType: contentType,
        contentId: contentId,
        contentAuthorId: contentAuthorId,
        reason: reason,
        details: details,
        status: ReportStatus.pending,
        createdAt: DateTime.now(),
      );

      await _repository.reportContent(report);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Check xem user đã report content chưa
  Future<bool> hasReportedContent(String contentId) async {
    return await _repository.hasReportedContent(contentId);
  }
}
```

---

## 🧪 TESTING CHECKLIST

### Unit Tests
- [ ] `FeedbackModel` serialization/deserialization
- [ ] `ContentReportModel` composite ID generation
- [ ] `DeviceInfoService` trả về đúng format
- [ ] `FeedbackRepository.submitFeedback()` validation
- [ ] `FeedbackRepository.hasReportedContent()` logic

### Integration Tests
- [ ] Submit feedback thành công
- [ ] Submit feedback với title ngắn hơn 5 ký tự → fail
- [ ] Submit duplicate content report → fail
- [ ] Report content đã report rồi → show error
- [ ] Block user sau khi report

### UI Tests
- [ ] Render AppFeedbackScreen đúng layout
- [ ] Validate form fields hiển thị error
- [ ] Submit button disabled khi loading
- [ ] SnackBar hiển thị sau khi submit thành công
- [ ] ReportDialog submit thành công → close dialog

### Manual Testing
- [ ] Feedback được lưu vào Firestore
- [ ] Device info được ghi nhận đúng
- [ ] Email validation hoạt động
- [ ] Report dialog hiển thị đúng
- [ ] Không thể report duplicate
- [ ] Admin có thể đọc feedbacks

---

## 📦 DEPENDENCIES CẦN THÊM

```yaml
dependencies:
  # Device Info (đã có)
  device_info_plus: ^9.1.1
  package_info_plus: ^5.0.1
  
  # Image Picker (đã có)
  image_picker: ^1.0.7
  
  # Firebase (đã có)
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  
  # State Management (đã có)
  flutter_riverpod: ^2.4.9
```

---

## 🚀 IMPLEMENTATION ROADMAP

### Phase 1: Core Infrastructure (2-3 ngày)
- [x] Tạo folder structure
- [ ] Define models với Freezed
- [ ] Setup Firestore collections & indexes
- [ ] Implement FeedbackRepository
- [ ] Implement DeviceInfoService
- [ ] Unit tests cho models & repository

### Phase 2: App Feedback UI (2 ngày)
- [ ] Implement AppFeedbackScreen
- [ ] Form validation
- [ ] Submit loading states
- [ ] Success/Error handling
- [ ] Navigation từ Profile > Settings

### Phase 3: Content Report System (1-2 ngày)
- [ ] Implement ReportDialog widget
- [ ] Integrate vào SocialPostCard (3-dot menu)
- [ ] Integrate vào Comment items
- [ ] Check duplicate reports
- [ ] Local hide reported content

### Phase 4: User Report (1 ngày)
- [ ] Report user dialog
- [ ] Integrate vào User Profile screen
- [ ] Block user option

### Phase 5: Testing & Polish (1 ngày)
- [ ] Manual testing
- [ ] Fix bugs
- [ ] Add analytics events
- [ ] Document usage

### Phase 6: Admin Dashboard (Future - Optional)
- [ ] Web admin panel
- [ ] View feedbacks queue
- [ ] Reply to feedbacks
- [ ] Ban/Warn users

**Total Estimate:** 7-9 ngày

---

## 🎯 SUCCESS METRICS

### KPIs
- **Feedback Submission Rate:** >= 5% users submit feedback/tháng
- **Response Time:** Admin reply trong < 48 giờ
- **Report Accuracy:** >= 80% reports có cơ sở
- **User Satisfaction:** >= 4.2⭐ trên App Store/Play Store

### Analytics Events
```dart
// Track feedback submitted
analytics.logEvent(
  name: 'feedback_submitted',
  parameters: {
    'type': 'bug_report',
    'has_attachments': true,
  },
);

// Track content reported
analytics.logEvent(
  name: 'content_reported',
  parameters: {
    'content_type': 'post',
    'reason': 'spam',
  },
);
```

---

## 🔒 SECURITY CONSIDERATIONS

1. **Input Validation:**
   - Sanitize user input để tránh XSS
   - Limit attachment size (< 10MB/file)
   - Validate email format

2. **Rate Limiting:**
   - Maximum 5 feedbacks/user/ngày
   - Maximum 10 reports/user/ngày
   - Prevent spam bots

3. **Privacy:**
   - Reporter identity KHÔNG được expose
   - Admin không thấy reporter email (chỉ thấy feedbackId)
   - Logs không chứa sensitive info

4. **Abuse Prevention:**
   - Auto-detect spam patterns
   - Ban users với > 10 invalid reports
   - Require authentication để report

---

## 📚 TÀI LIỆU THAM KHẢO

**Best Practices:**
- [Google Play In-App Review](https://developer.android.com/guide/playcore/in-app-review)
- [Apple Request Review](https://developer.apple.com/documentation/storekit/requesting-user-reviews)
- [Zendesk Feedback Best Practices](https://www.zendesk.com/blog/user-feedback/)

**UI References:**
- Instagram Report Flow
- Twitter Report System
- Discord Feedback Form

---

## ✅ DEFINITION OF DONE

Feature được coi là hoàn thành khi:
- [ ] Tất cả models đã được implement với Freezed
- [ ] Repository có đầy đủ CRUD operations
- [ ] UI screens render đúng design
- [ ] Form validation hoạt động
- [ ] Firestore rules được set up
- [ ] Unit tests đạt >= 80% coverage
- [ ] Manual testing pass tất cả test cases
- [ ] Documentation được cập nhật
- [ ] Code review approved
- [ ] Deployed lên staging environment

---

**🎉 END OF PLAN**

> Plan này có thể được điều chỉnh dựa trên feedback và requirements thay đổi.  
> Liên hệ team lead nếu cần clarification.
