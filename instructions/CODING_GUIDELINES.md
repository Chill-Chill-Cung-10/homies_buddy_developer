# 📐 CODING GUIDELINES — Homies Buddy

> **Mục đích:** Hướng dẫn cho AI (và developer) viết code **đúng chỗ, đúng quy tắc** ngay từ đầu, không cần refactor lại.  
> **Cập nhật:** 28/02/2026

---

## 1. CẤU TRÚC THƯ MỤC HIỆN TẠI

```
lib/
├── main.dart                         ← Entry point duy nhất
│
├── core/                             ← DÙNG CHUNG TOÀN APP (không thuộc feature nào)
│   ├── constants/
│   │   ├── app_assets.dart           ← Đường dẫn asset (images, icons, fonts)
│   │   ├── app_colors.dart           ← MỌI màu sắc (file DUY NHẤT cho color)
│   │   ├── app_shadows.dart          ← BoxShadow presets
│   │   ├── app_shapes.dart           ← Border radius, icon sizes, card dimensions
│   │   ├── app_spacing.dart          ← Spacing & padding constants
│   │   ├── app_text_styles.dart      ← TextStyle presets (dùng AppTypography)
│   │   └── app_typography.dart       ← Font family, font weight, letter spacing
│   │
│   ├── theme/
│   │   └── app_theme.dart            ← ThemeData chính
│   │
│   ├── utils/
│   │   └── formatters.dart           ← formatCount(), limitWords(), formatRelativeTime(), formatTimeHHmm()
│   │
│   ├── storage/                      ← Local storage helpers (SharedPreferences, SecureStorage)
│   │
│   └── widgets/                      ← Widget dùng chung NHIỀU feature
│       ├── buttons/
│       │   └── custom_button.dart
│       ├── text_fields/
│       │   ├── custom_text_field.dart
│       │   └── password_text_field.dart
│       ├── dialogs/
│       │   └── custom_dialog.dart
│       ├── feedback/
│       │   ├── loading_overlay.dart
│       │   ├── empty_state_widget.dart
│       │   └── blinking_cursor.dart
│       ├── cards/
│       │   └── info_card.dart
│       ├── media/
│       │   └── media_picker_bottom_sheet.dart
│       ├── navigation_provider.dart
│       ├── spinning_nav_button.dart
│       └── widgets.dart              ← Barrel export (import file này để dùng tất cả)
│
├── data/                             ← DATA LAYER — models & enums dùng chung
│   ├── models/
│   │   ├── user_model.dart           ← SINGLE SOURCE OF TRUTH cho social profile
│   │   ├── post_model.dart           ← Freezed model
│   │   ├── comment_model.dart        ← Freezed model
│   │   ├── notification_model.dart   ← Freezed model
│   │   ├── pet_profile_model.dart    ← Freezed model
│   │   ├── pet_owner_model.dart      ← Freezed model
│   │   ├── media_file_model.dart     ← Freezed model
│   │   ├── moment_note_model.dart    ← Plain class (chưa Freezed)
│   │   └── enums/
│   │       ├── media_type.dart
│   │       ├── notification_type.dart
│   │       ├── post_privacy.dart
│   │       └── enums.dart            ← Barrel export
│   │
│   └── repositories/                 ← Tương lai: Repository pattern
│
└── features/                         ← MỖI feature là 1 thư mục độc lập
    ├── auth/
    │   ├── data/models/              ← Models riêng cho auth (login request, auth state...)
    │   ├── presentation/
    │   │   ├── screens/              ← login, register, forgot_password, change_password
    │   │   └── widgets/              ← auth_input_field, auth_password_field, auth_submit_button
    │   └── services/                 ← Auth logic
    │
    ├── chat/
    │   ├── data/models/              ← conversation_model, message_model (hand-written)
    │   ├── mockdata/                 ← Mock data cho chat
    │   └── presentation/
    │       ├── screens/
    │       └── widgets/
    │
    ├── community/
    │   ├── data/models/              ← Models riêng cho community (comment_sort_option)
    │   ├── mockdata/                 ← community_mock_data, comment_mock_data, profile → mock_users/pets/posts
    │   └── presentation/
    │       ├── screens/              ← community_screen, personal_profile_screen
    │       ├── community_screen.dart ← Main feed (import trực tiếp, không trong screens/)
    │       └── widgets/
    │           ├── social_post_card.dart   ← Orchestrator (~90 dòng)
    │           ├── comment_overlay.dart    ← Orchestrator (~210 dòng)
    │           ├── post/                   ← Sub-widgets cho SocialPostCard
    │           │   ├── post_header.dart
    │           │   ├── post_content.dart
    │           │   ├── post_media_carousel.dart
    │           │   └── post_footer.dart
    │           ├── comments/               ← Sub-widgets cho CommentOverlay
    │           │   ├── comment_item.dart
    │           │   ├── comment_input_section.dart
    │           │   └── comment_post_preview.dart
    │           └── profile/                ← Sub-widgets cho PersonalProfileScreen
    │               ├── profile_hero_header.dart
    │               ├── profile_stats_section.dart
    │               ├── profile_buddies_section.dart
    │               └── profile_post_feed.dart
    │
    ├── help/
    │   ├── data/ & mockdata/
    │   └── presentation/
    │       ├── screens/
    │       └── widgets/
    │
    ├── home/
    │   ├── mock_data/
    │   └── presentation/
    │       ├── screens/
    │       └── widgets/
    │
    ├── navigation/
    │   └── presentation/
    │
    ├── notifications/                ← Feature riêng (tách từ community)
    │   ├── data/
    │   │   └── notification_mock_data.dart
    │   └── presentation/
    │       ├── screens/
    │       │   └── notification_screen.dart
    │       └── widgets/
    │           └── notification_item.dart
    │
    └── profile/
        └── presentation/
            └── screens/
```

---

## 2. NGUYÊN TẮC ĐẶT FILE — "FILE NÀO ĐẶT Ở ĐÂU?"

### 2.1 Quyết định nhanh: dùng flowchart này

```
Tạo file mới? → Hỏi:

1. Nó có dùng chung ≥2 features không?
   ├─ CÓ → đặt trong core/ hoặc data/
   │   ├─ Là Color/Shape/Spacing/TextStyle? → core/constants/
   │   ├─ Là utility function? → core/utils/
   │   ├─ Là Widget dùng chung? → core/widgets/<category>/
   │   ├─ Là data model? → data/models/
   │   └─ Là enum? → data/models/enums/
   │
   └─ KHÔNG → đặt trong features/<tên_feature>/
       ├─ Là Screen (full page)? → features/<feature>/presentation/screens/
       ├─ Là Widget nhỏ? → features/<feature>/presentation/widgets/
       ├─ Là Widget con của widget lớn? → features/<feature>/presentation/widgets/<parent>/
       ├─ Là Model chỉ feature đó dùng? → features/<feature>/data/models/
       ├─ Là Mock data? → features/<feature>/mockdata/
       └─ Là Service/Logic? → features/<feature>/services/
```

### 2.2 Các quy tắc cụ thể

| Loại file | Đặt ở đâu | Ví dụ |
|-----------|-----------|-------|
| Màu sắc | `core/constants/app_colors.dart` (THÊM VÀO, KHÔNG tạo file mới) | `AppColors.newColor` |
| Border radius, kích thước | `core/constants/app_shapes.dart` | `AppShapes.newRadius` |
| Spacing, padding | `core/constants/app_spacing.dart` | `AppSpacing.newSpacing` |
| TextStyle | `core/constants/app_text_styles.dart` | `AppTextStyles.newStyle` |
| Font config | `core/constants/app_typography.dart` | `AppTypography.newFont` |
| Đường dẫn asset | `core/constants/app_assets.dart` | `AppAssets.newImage` |
| Format số, thời gian | `core/utils/formatters.dart` | `formatNewThing()` |
| Widget dùng lại toàn app | `core/widgets/<category>/new_widget.dart` | Thêm export vào `widgets.dart` |
| Data model dùng chung | `data/models/new_model.dart` | Dùng Freezed |
| Enum dùng chung | `data/models/enums/new_enum.dart` | Thêm export vào `enums.dart` |
| Screen mới cho feature | `features/<feature>/presentation/screens/` | |
| Widget riêng cho feature | `features/<feature>/presentation/widgets/` | |
| Mock data | `features/<feature>/mockdata/` | Class static methods |

---

## 3. NGUYÊN TẮC VIẾT CODE

### 3.1 Constants — KHÔNG BAO GIỜ hardcode

```dart
// ❌ SAI — hardcode color
Container(color: Color(0xFFF5D5C8))

// ✅ ĐÚNG — dùng AppColors
Container(color: AppColors.primaryPeach)

// ❌ SAI — hardcode padding
padding: EdgeInsets.all(16.0)

// ✅ ĐÚNG — dùng AppSpacing
padding: EdgeInsets.all(AppSpacing.paddingM)

// ❌ SAI — hardcode border radius
borderRadius: BorderRadius.circular(30)

// ✅ ĐÚNG — dùng AppShapes
borderRadius: AppShapes.card

// ❌ SAI — hardcode TextStyle
TextStyle(fontFamily: 'Nunito', fontSize: 14)

// ✅ ĐÚNG — dùng AppTextStyles
style: AppTextStyles.bodyMedium
```

### 3.2 AppColors — File DUY NHẤT cho màu

- **CHỈ CÓ 1 FILE:** `lib/core/constants/app_colors.dart`
- KHÔNG ĐƯỢC tạo file `app_colors.dart` thứ 2 ở đâu
- Muốn thêm màu? → Thêm `static const Color` vào file đã có
- Nhóm màu theo section: Primary, Pastel, Background, Text, Status, Gradient, Border

### 3.3 AppSpacing vs AppShapes — Phân biệt rõ

| Class | Chứa gì | Ví dụ |
|-------|---------|-------|
| `AppSpacing` | Khoảng cách, padding, margin | `paddingM`, `xs`, `l` |
| `AppShapes` | Border radius, icon sizes, dimensions | `cardRadius`, `iconM`, `navBarHeight` |

> **Lưu ý:** `AppShapes.paddingXS/S/M/L/XL` vẫn tồn tại nhưng **@Deprecated**. Code mới phải dùng `AppSpacing.paddingXS/S/M/L/XL`.

### 3.4 AppTextStyles + AppTypography — Luôn dùng cùng nhau

- `AppTypography` = font family, font weight, letter spacing (config gốc)
- `AppTextStyles` = TextStyle hoàn chỉnh (dùng `AppTypography` bên trong)
- Code UI chỉ cần import `AppTextStyles`, KHÔNG import `AppTypography` trực tiếp
- Muốn customize? → `AppTextStyles.bodyMedium.copyWith(color: AppColors.xxx)`

### 3.5 Utility functions — Dùng chung, KHÔNG copy-paste

```dart
// ❌ SAI — viết hàm private format lại trong widget
String _formatCount(int count) { ... }

// ✅ ĐÚNG — import từ core/utils
import 'package:homies_buddy_developer/core/utils/formatters.dart';
formatCount(1500); // → "1.5K"
```

**Các hàm đã có sẵn:**
- `formatCount(int)` — 1000 → "1K", 1500000 → "1.5M"
- `limitWords(String, int)` — Cắt chuỗi theo số từ tối đa
- `formatRelativeTime(DateTime)` — "5m ago", "2h ago", "3d ago"
- `formatTimeHHmm(DateTime)` — "14:30"

### 3.6 Widget core — Import qua barrel export

```dart
// ❌ SAI — import từng file riêng lẻ
import 'package:homies_buddy_developer/core/widgets/buttons/custom_button.dart';
import 'package:homies_buddy_developer/core/widgets/dialogs/custom_dialog.dart';

// ✅ ĐÚNG — import barrel
import 'package:homies_buddy_developer/core/widgets/widgets.dart';
```

Khi tạo widget mới trong `core/widgets/`, **PHẢI** thêm dòng export vào `widgets.dart`.

---

## 4. NGUYÊN TẮC TỔ CHỨC WIDGET

### 4.1 Quy tắc giới hạn kích thước

| Loại | Giới hạn | Hành động nếu vượt |
|------|---------|-------------------|
| Screen | ≤ 200 dòng | Tách build methods → sub-widget files |
| Widget | ≤ 200 dòng | Tách thành widget con đặt trong subfolder |
| Model | ≤ 100 dòng | Tách thành nhiều file nếu data không liên quan |
| Mock data | ≤ 150 dòng | Tách theo entity: mock_users, mock_pets, mock_posts |

### 4.2 Pattern: Screen làm orchestrator

Screen **CHỈ** chứa:
- State management (setState, controllers)
- Navigation logic
- Compose sub-widgets

```dart
// ✅ Screen mẫu (~120 dòng max)
class MyScreen extends StatefulWidget { ... }

class _MyScreenState extends State<MyScreen> {
  // State variables + controllers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyHeader(data: _data),           // Sub-widget
          MyContent(items: _items),         // Sub-widget
          MyFooter(onAction: _handleAction), // Sub-widget
        ],
      ),
    );
  }

  void _handleAction() { ... }
}
```

### 4.3 Pattern: Tách widget → subfolder theo parent

Khi widget lớn cần tách, tạo **subfolder cùng tên** chứa sub-widgets:

```
widgets/
├── social_post_card.dart          ← Orchestrator (compose post/*)
└── post/                          ← Sub-widgets
    ├── post_header.dart
    ├── post_content.dart
    ├── post_media_carousel.dart
    └── post_footer.dart
```

**Quy ước đặt tên:** `<parent>_<phần>.dart` hoặc `<phần>.dart` nếu đã trong subfolder.

### 4.4 StatelessWidget vs StatefulWidget

- Nếu widget **không có state riêng** (animation, input, index) → `StatelessWidget`
- Nếu state **chỉ thuộc về phần con** (VD: carousel index, animation) → Move state sang sub-widget, parent thành `StatelessWidget`
- Ví dụ: `SocialPostCard` là `StatelessWidget` vì animation nằm trong `PostFooter`, carousel index nằm trong `PostMediaCarousel`

---

## 5. NGUYÊN TẮC DATA MODEL

### 5.1 UserModel — HAI model khác nhau, mục đích khác nhau

| Model | Vị trí | Dùng cho | Fields |
|-------|--------|---------|--------|
| `UserModel` (social) | `lib/data/models/user_model.dart` | Community feed, profile, post | id, username, avatar, bio, posts, pets, followers, homies, role... |
| `UserModel` (auth) | `lib/features/auth/data/models/user_model.dart` | Auth state, login response | id, email, username, avatar, isVerified... |

> **SINGLE SOURCE OF TRUTH** cho social profile là `lib/data/models/user_model.dart`.  
> Auth model là lightweight version chỉ cho authentication state.

### 5.2 Tạo model mới → Dùng Freezed

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
    @Default('') String description,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) => _$MyModelFromJson(json);
}
```

Sau khi tạo, chạy: `dart run build_runner build`

### 5.3 Enum dùng chung → `data/models/enums/`

```dart
// Tạo file: lib/data/models/enums/my_enum.dart
enum MyEnum { value1, value2, value3 }

// Thêm vào barrel: lib/data/models/enums/enums.dart
export 'my_enum.dart';
```

---

## 6. NGUYÊN TẮC MOCK DATA

### 6.1 Mock data đặt ở feature, KHÔNG ở core

```
features/<feature>/mockdata/
├── feature_mock_data.dart        ← Static methods trả về List<Model>
├── mock_users.dart               ← Tách riêng theo entity nếu file > 150 dòng
└── mock_pets.dart
```

### 6.2 Pattern: Static class methods

```dart
class CommunityMockData {
  static List<Post> getPostsForFeed() => _allPosts;
  static Post getPostById(String id) => ...;
  
  static final List<Post> _allPosts = [ ... ];
}
```

### 6.3 Khi mock data quá lớn → Tách theo entity

```dart
// Trước: profile_mock_data.dart (280 dòng — users + pets + posts lẫn nhau)
// Sau:
//   mock_users.dart   — MockUsers class
//   mock_pets.dart     — MockPets class
//   mock_user_posts.dart — MockUserPosts class
//   profile_mock_data.dart — Facade class delegate to above + re-export
```

---

## 7. NGUYÊN TẮC IMPORT

### 7.1 Thứ tự import (theo convention Dart)

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter packages
import 'package:flutter/material.dart';

// 3. Third-party packages
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cached_network_image/cached_network_image.dart';

// 4. Project imports — core
import 'package:homies_buddy_developer/core/constants/app_colors.dart';

// 5. Project imports — relative (trong cùng feature)
import '../widgets/my_widget.dart';
import '../../mockdata/my_mock_data.dart';
```

### 7.2 Import style

- **Trong cùng feature** → dùng relative import: `import '../widgets/...'`
- **Cross-feature** → dùng relative import từ `features/`: `import '../../notifications/...'`
- **Import core** → có thể dùng package hoặc relative tùy ngữ cảnh

### 7.3 Barrel exports

- `core/widgets/widgets.dart` — export tất cả core widgets
- `data/models/enums/enums.dart` — export tất cả enums
- Khi tạo file mới thuộc nhóm có barrel → **PHẢI** thêm export vào barrel file

---

## 8. NGUYÊN TẮC FEATURE MỚI

Khi tạo feature hoàn toàn mới:

```
lib/features/<new_feature>/
├── data/
│   └── models/          ← Models riêng cho feature (nếu có)
├── mockdata/            ← Mock data (nếu chưa có API)
├── presentation/
│   ├── screens/         ← Các screen (full page)
│   └── widgets/         ← Widgets chỉ dùng trong feature này
└── services/            ← Business logic (nếu có)
```

**Checklist khi tạo feature mới:**
1. Tạo cấu trúc thư mục như trên
2. Model dùng chung → đặt trong `lib/data/models/`, KHÔNG trong feature
3. Widget dùng chung → đặt trong `lib/core/widgets/`, KHÔNG trong feature
4. Enum dùng chung → đặt trong `lib/data/models/enums/`
5. Không import ngược từ feature khác nếu có thể tránh

---

## 9. ANTI-PATTERNS — TUYỆT ĐỐI KHÔNG LÀM

| # | Anti-pattern | Hậu quả | Cách đúng |
|---|-------------|---------|-----------|
| 1 | Tạo file `app_colors.dart` thứ 2 | Import nhầm, bug UI silent | Thêm vào file duy nhất có sẵn |
| 2 | Copy-paste utility function vào widget | Fix bug 1 chỗ, quên N chỗ | Import từ `core/utils/` |
| 3 | Screen > 200 dòng | Khó maintain, khó test | Tách sub-widgets vào subfolder |
| 4 | Hardcode color/spacing/font | UI inconsistent | Dùng `AppColors`, `AppSpacing`, `AppTextStyles` |
| 5 | Đặt notification code trong community | Vi phạm feature boundaries | Feature riêng: `features/notifications/` |
| 6 | Model không dùng Freezed | Thiếu copyWith, equality, JSON | Dùng Freezed cho tất cả shared models |
| 7 | Widget core không thêm vào barrel | Import path dài, khó discover | Thêm export vào `widgets.dart` |
| 8 | Trộn mock data nhiều entity vào 1 file | File phình to, khó navigate | Tách theo entity: mock_users, mock_pets |
| 9 | Dùng `AppShapes.paddingX` | Deprecated | Dùng `AppSpacing.paddingX` |
| 10 | Tạo file rỗng placeholder | Rác, gây confuse | Chỉ tạo file khi có code thật |

---

## 10. DEPENDENCIES HIỆN TẠI

| Package | Version | Dùng cho |
|---------|---------|---------|
| `freezed_annotation` | ^2.4.1 | Model immutable + codegen |
| `freezed` | ^2.5.2 | Code generator |
| `json_annotation` | ^4.8.1 | JSON serialization |
| `cached_network_image` | ^3.4.1 | Cache ảnh từ URL |
| `flutter_svg` | ^2.0.10 | Render SVG icons |
| `carousel_slider` | ^5.0.0 | Media carousel trong post |
| `image_picker` | ^1.1.2 | Chọn ảnh/video |
| `flutter_secure_storage` | ^9.2.3 | Lưu token bảo mật |
| `firebase_core/auth/messaging` | latest | Firebase services |

---

## 11. NAMING CONVENTIONS

| Loại | Convention | Ví dụ |
|------|-----------|-------|
| File name | `snake_case.dart` | `social_post_card.dart` |
| Class name | `PascalCase` | `SocialPostCard` |
| Constant | `camelCase` | `AppColors.primaryPeach` |
| Private method | `_camelCase` | `_handleLike()` |
| Enum value | `camelCase` | `PostPrivacy.public` |
| Subfolder widget | `<context>_<part>.dart` | `post_header.dart`, `comment_item.dart` |
| Mock data class | `Mock<Entity>s` hoặc `<Feature>MockData` | `MockUsers`, `CommunityMockData` |
| Screen file | `<name>_screen.dart` | `login_screen.dart` |
| Widget file | `<name>.dart` hoặc `<name>_widget.dart` | `post_footer.dart` |

---

## 12. COMMENT CONVENTIONS

```dart
/// [Refactored] Phase X.Y — Mô tả ngắn gọn
/// Dòng mô tả chi tiết nếu cần

/// Doc comment cho class/method (3 slashes)
/// Mô tả purpose, params, returns

// Inline comment (2 slashes) — cho logic phức tạp

// ── Section Header ──  (dùng em-dash cho nhóm constants)
```

---

## TÓM TẮT NHANH CHO AI

Khi được yêu cầu viết code trong project này:

1. **Màu mới?** → Thêm vào `core/constants/app_colors.dart`. KHÔNG tạo file mới.
2. **Spacing/padding?** → Dùng `AppSpacing`. KHÔNG dùng `AppShapes.paddingX` (deprecated).
3. **TextStyle?** → Dùng `AppTextStyles.xxx.copyWith(...)`. KHÔNG hardcode font.
4. **Utility function?** → Kiểm tra `core/utils/formatters.dart` trước. Có sẵn thì import, không thì thêm vào đó.
5. **Widget dùng chung?** → Đặt `core/widgets/<category>/`. Thêm vào barrel `widgets.dart`.
6. **Widget riêng feature?** → Đặt `features/<feature>/presentation/widgets/`.
7. **Widget > 200 dòng?** → Tách sub-widgets vào subfolder.
8. **Screen > 200 dòng?** → Screen chỉ orchestrate, tách build methods ra sub-widget files.
9. **Model mới?** → Dùng Freezed. Đặt `data/models/` nếu dùng chung, `features/<f>/data/models/` nếu riêng.
10. **Mock data?** → Đặt `features/<feature>/mockdata/`. Tách file nếu > 150 dòng.
11. **Feature mới?** → Tạo structure: `data/`, `mockdata/`, `presentation/screens/`, `presentation/widgets/`, `services/`.
12. **Notification?** → Là feature riêng tại `features/notifications/`, KHÔNG nằm trong community.
