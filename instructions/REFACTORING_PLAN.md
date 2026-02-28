# 📋 KẾ HOẠCH REFACTOR & PHÂN CHIA CODE — Homies Buddy

> **Ngày tạo:** 28/02/2026  
> **Mục tiêu:** Phân tích toàn bộ codebase, đề xuất refactor để tăng **reusability**, **maintainability**, và **scalability**.

---

## 📊 TỔNG QUAN HIỆN TRẠNG

### Thống kê codebase

| Thư mục | Số file Dart | Tổng dòng (ước tính) | Ghi chú |
|---------|-------------|----------------------|---------|
| `lib/core/` | 24 file | ~1,300 dòng | 12 file rỗng (placeholder) |
| `lib/data/` | 23 file | ~900 dòng | Gồm cả generated `.freezed.dart`, `.g.dart` |
| `lib/features/auth/` | 28 file | ~2,100 dòng | Gồm cả generated files |
| `lib/features/chat/` | 14 file | ~1,250 dòng | |
| `lib/features/community/` | 12 file | ~2,900 dòng | Nhiều file lớn 500+ dòng |
| `lib/features/help/` | 8 file | ~1,380 dòng | 1 file 643 dòng |
| `lib/features/home/` | 11 file | ~1,350 dòng | |
| `lib/features/navigation/` | 1 file | 47 dòng | |
| `lib/features/profile/` | 1 file | 73 dòng | Placeholder |
| `lib/features/notifications/` | 0 file | 0 dòng | Thư mục rỗng |
| **Tổng** | **~122 file** | **~11,300 dòng** | |

### Top 10 file lớn nhất cần refactor

| # | File | Dòng | Vấn đề chính |
|---|------|------|-------------|
| 1 | `core/widgets/common_widgets.dart` | **742** | 10+ widget không liên quan trong 1 file |
| 2 | `features/help/screens/ask_for_help_screen.dart` | **643** | Screen + animation widget + media logic |
| 3 | `features/community/screens/personal_profile_screen.dart` | **603** | Monolithic, 18+ methods build UI |
| 4 | `features/community/widgets/comment_overlay.dart` | **584** | Comment item + input + preview cùng file |
| 5 | `features/community/widgets/social_post_card.dart` | **574** | Media carousel + header + footer + mentions |
| 6 | `features/auth/screens/change_password_screen.dart` | **538** | InputDecoration lặp lại 3 lần |
| 7 | `features/auth/screens/register_screen.dart` | **335** | InputDecoration copy-paste từ login |
| 8 | `features/chat/screens/chat_detail_setting_screen.dart` | **313** | Mixed Vietnamese/English, dialog logic |
| 9 | `features/home/widgets/user_moments_box/card_notes_item.dart` | **306** | Acceptable nhưng có thể tối ưu |
| 10 | `features/community/mockdata/profile_mock_data.dart` | **278** | Pet + User + Post data trộn lẫn |

---

## 🚨 CÁC VẤN ĐỀ NGHIÊM TRỌNG

### 1. TRÙNG LẶP CLASS NAME — `AppColors`

**Vị trí:**
- `lib/core/theme/app_colors.dart` (29 dòng) — màu pastel/beige
- `lib/core/constants/app_colors.dart` (82 dòng) — màu primary/status/gradient

**Vấn đề:** 2 class cùng tên `AppColors` với **giá trị khác nhau** cho `textPrimary`, `textSecondary`. Import sai file sẽ gây bug UI silent.

### 2. TRÙNG LẶP FILE NAME — `notification_service.dart`

**Vị trí:**
- `lib/core/services/notification_service.dart` (rỗng)
- `lib/core/storage/notification_service.dart` (rỗng)

**Vấn đề:** Khi implement sẽ gây nhầm lẫn import. Service logic không thuộc `storage/`.

### 3. TRÙNG LẶP CLASS — `PasswordRequirement`

**Vị trí:**
- `lib/features/auth/data/models/change_password_request.dart`
- `lib/features/auth/data/models/register_request.dart`

**Vấn đề:** Barrel file dùng `hide` để workaround nhưng fragile. Cần extract ra file riêng.

### 4. TRÙNG LẶP `UserModel`

**Vị trí:**
- `lib/data/models/user_model.dart` (freezed, 72 dòng) — dùng cho community
- `lib/features/auth/data/models/user_model.dart` (freezed, 60 dòng) — dùng cho auth

**Vấn đề:** 2 UserModel khác fields. Khi integrate API sẽ conflict.

### 5. HÀM `_formatCount()` LẶP LẠI 3 LẦN

**Vị trí:**
- `personal_profile_screen.dart`
- `social_post_card.dart`
- `comment_overlay.dart`

**Vấn đề:** Logic giống hệt (format 1000 → "1K") nhưng copy-paste. Fix bug 1 chỗ sẽ quên 2 chỗ còn lại.

---

## 🔧 KẾ HOẠCH REFACTOR CHI TIẾT

---

### PHASE 1: Core Layer — Dọn dẹp & Hợp nhất (Ưu tiên CAO)

#### 1.1 Hợp nhất `AppColors` → 1 file duy nhất

**Hành động:**
```
TRƯỚC:
  lib/core/theme/app_colors.dart       ← XÓA
  lib/core/constants/app_colors.dart    ← GIỮ LẠI, bổ sung

SAU:
  lib/core/constants/app_colors.dart    ← File duy nhất chứa TẤT CẢ màu
```

- Merge tất cả `Color` constants vào `lib/core/constants/app_colors.dart`
- Xóa `lib/core/theme/app_colors.dart`
- Xóa ~30 dòng commented-out colors trong file giữ lại
- Update tất cả import references

#### 1.2 Tách `common_widgets.dart` (742 dòng) → 6 file

**Hành động:**
```
TRƯỚC:
  lib/core/widgets/common_widgets.dart  (742 dòng, 10+ widget)

SAU:
  lib/core/widgets/
    ├── buttons/
    │   └── custom_button.dart          ← CustomButton, ButtonType enum
    ├── text_fields/
    │   ├── custom_text_field.dart       ← CustomTextField
    │   └── password_text_field.dart     ← PasswordTextField
    ├── dialogs/
    │   └── custom_dialog.dart           ← CustomDialog (showSuccess, showError, showConfirmation)
    ├── feedback/
    │   ├── loading_overlay.dart         ← LoadingOverlay
    │   ├── empty_state_widget.dart      ← EmptyStateWidget
    │   └── blinking_cursor.dart         ← BlinkingCursor
    ├── cards/
    │   └── info_card.dart               ← InfoCard
    ├── media/
    │   └── media_picker_bottom_sheet.dart ← MediaPickerBottomSheet
    └── widgets.dart                     ← Barrel export file
```

**Lợi ích:** Import chỉ widget cần dùng, giảm build time, dễ test từng widget.

#### 1.3 Tách padding khỏi `AppShapes` → `AppSpacing`

**Hành động:**
- Di chuyển `paddingXS`, `paddingS`, `paddingM`, `paddingL`, `paddingXL` từ `AppShapes` sang `AppSpacing`
- `AppShapes` chỉ giữ border radius, card dimensions, nav bar dimensions
- Rename nếu cần để tránh trùng tên

#### 1.4 Kết nối `AppTypography` vào `AppTextStyles`

**Hành động:**
- `AppTextStyles` sử dụng `AppTypography.primaryFont` thay vì hardcode font family
- `AppTextStyles` sử dụng `AppTypography.letterSpacing`, `titleWeight`, `bodyWeight`
- Xóa `reactionsWeight` commented-out

#### 1.5 Tạo utility functions dùng chung

**Hành động:**
```
TẠO MỚI:
  lib/core/utils/
    ├── formatters.dart      ← _formatCount() → formatCount() (public, reusable)
    │                           _formatTime() → formatTime()
    │                           _limitWords() → limitWords()
    ├── validators.dart      ← Email, password validation logic dùng chung
    └── extensions.dart      ← String extensions, DateTime extensions
```

**Lợi ích:** Xóa 3 bản copy `_formatCount()`, 2 bản copy `_formatTime()`.

#### 1.6 Dọn dẹp placeholder files

**Hành động:**
- Xóa 12 file rỗng trong `config/`, `network/`, `services/`, `storage/`
- Chỉ tạo lại khi thực sự implement
- Xóa thư mục rỗng: `data/datasources/local/`, `data/datasources/remote/`, `core/network/interceptors/`, `core/assets/animations/`, `features/notifications/`
- Xóa `lib/core/storage/notification_service.dart` (duplicate) 

---

### PHASE 2: Feature Auth — Giảm duplication (Ưu tiên CAO)

#### 2.1 Tạo `AuthInputField` widget tái sử dụng

**Hành động:**
```
TẠO MỚI:
  lib/features/auth/presentation/widgets/
    ├── auth_input_field.dart      ← Bọc InputDecoration chung (~30 dòng)
    ├── auth_password_field.dart   ← InputField + toggle visibility
    ├── auth_submit_button.dart    ← Nút submit với loading state
    ├── auth_screen_layout.dart    ← Layout chung: header + body + footer links
    └── widgets.dart               ← Barrel export
```

**Lợi ích:**
- `login_screen.dart`: 249 → ~120 dòng
- `register_screen.dart`: 335 → ~150 dòng
- `forgot_password_screen.dart`: 261 → ~100 dòng
- `change_password_screen.dart`: 538 → ~250 dòng

**Tổng tiết kiệm:** ~500+ dòng duplicate code.

#### 2.2 Extract `PasswordRequirement` → file riêng

**Hành động:**
```
TẠO MỚI:
  lib/features/auth/data/models/password_requirement.dart

XÓA khỏi:
  change_password_request.dart  (xóa class PasswordRequirement)
  register_request.dart         (xóa class PasswordRequirement)
  models.dart                   (xóa `hide PasswordRequirement`)
```

#### 2.3 Hợp nhất `UserModel`

**Hành động:**
- Giữ `lib/data/models/user_model.dart` làm **single source of truth**
- Tạo `AuthUser` (subset) trong `features/auth/` nếu cần lightweight version
- Hoặc dùng extension để thêm auth-specific fields

#### 2.4 Di chuyển `demo_auth_screens.dart`

**Hành động:**
- Di chuyển `lib/features/auth/presentation/demo_auth_screens.dart` → `test/` hoặc `example/`
- Không nên để demo/test code trong production source

---

### PHASE 3: Feature Community — Tách widget lớn (Ưu tiên CAO)

#### 3.1 Tách `personal_profile_screen.dart` (603 dòng)

**Hành động:**
```
TRƯỚC:
  screens/personal_profile_screen.dart  (603 dòng, 18 methods)

SAU:
  screens/personal_profile_screen.dart  (~150 dòng, orchestrator)
  widgets/profile/
    ├── profile_hero_header.dart         ← _buildHeroHeader, _buildCoverImage,
    │                                       _buildGradientOverlay, _buildHeroContent,
    │                                       _buildScrollIndicator, _buildBackButton
    ├── profile_stats_section.dart       ← _buildProfileStats, _buildStatItem,
    │                                       _buildFollowButton
    ├── profile_buddies_section.dart     ← _buildBuddiesSection, _buildBuddyItem
    └── profile_post_feed.dart           ← _buildPostFeed
```

#### 3.2 Tách `social_post_card.dart` (574 dòng)

**Hành động:**
```
TRƯỚC:
  widgets/social_post_card.dart  (574 dòng)

SAU:
  widgets/post/
    ├── social_post_card.dart        ← Main card (~150 dòng, compose sub-widgets)
    ├── post_header.dart             ← _buildHeader, _buildAuthorNameWithMentions
    ├── post_media_carousel.dart     ← _buildMedia, _buildSingleMedia,
    │                                   _buildMediaCarousel, _buildMediaContent,
    │                                   _buildCarouselIndicators
    ├── post_footer.dart             ← _buildFooter, _getPrivacyIcon
    └── post_content.dart            ← _buildContent (hashtag/mention rendering)
```

#### 3.3 Tách `comment_overlay.dart` (584 dòng)

**Hành động:**
```
TRƯỚC:
  widgets/comment_overlay.dart  (584 dòng)

SAU:
  widgets/comments/
    ├── comment_overlay.dart         ← Main overlay + showCommentOverlay() (~200 dòng)
    ├── comment_item.dart            ← _buildCommentItem → CommentItem widget
    ├── comment_input_section.dart   ← _buildCommentInputSection
    ├── comment_post_preview.dart    ← _buildPostPreview
    └── comment_sort_option.dart     ← CommentSortOption enum (hiện nằm trong mockdata!)
```

#### 3.4 Chuyển `CommentSortOption` enum

**Hành động:**
- Di chuyển từ `mockdata/comment_mock_data.dart` → `data/models/enums/comment_sort_option.dart` hoặc `widgets/comments/comment_sort_option.dart`
- Đây là domain concept, không phải mock data

#### 3.5 Tách `profile_mock_data.dart` (278 dòng)

**Hành động:**
```
TRƯỚC:
  mockdata/profile_mock_data.dart  (278 dòng — pet + user + post)

SAU:
  mockdata/
    ├── mock_users.dart         ← User data + lookup
    ├── mock_pets.dart          ← Pet profiles
    └── mock_user_posts.dart    ← User-specific posts
```

#### 3.6 Di chuyển `notification_screen.dart` → feature riêng

**Hành động:**
```
TRƯỚC:
  features/community/presentation/notification_screen.dart

SAU:
  features/notifications/
    ├── presentation/
    │   ├── screens/
    │   │   └── notification_screen.dart
    │   └── widgets/
    │       └── notification_item.dart   ← (di chuyển từ community/widgets/)
    └── data/
        └── notification_mock_data.dart  ← (di chuyển từ community/mockdata/)
```

**Lý do:** Notification là feature độc lập, không nên nằm trong community.

---

### PHASE 4: Feature Help — Tách screen lớn nhất (Ưu tiên TRUNG BÌNH)

#### 4.1 Tách `ask_for_help_screen.dart` (643 dòng)

**Hành động:**
```
TRƯỚC:
  screens/ask_for_help_screen.dart  (643 dòng)

SAU:
  screens/ask_for_help_screen.dart  (~200 dòng, orchestrator)
  widgets/
    ├── bouncing_dots.dart           ← _BouncingDots animation widget
    ├── help_welcome_message.dart    ← _buildWelcomeMessage
    ├── help_new_chat_view.dart      ← _buildNewChatView + _buildSuggestionCards
    ├── help_active_chat_view.dart   ← _buildActiveChatView
    ├── help_input_area.dart         ← _buildInputArea + _buildAttachedImagesPreview
    └── help_typing_indicator.dart   ← _buildTypingIndicator
```

#### 4.2 Xóa `help_screen.dart` placeholder

**Hành động:**
- Xóa `help_screen.dart` (51 dòng, chỉ có TODO)
- Hoặc redirect → `ask_for_help_screen.dart`

---

### PHASE 5: Feature Chat — Chuẩn hóa (Ưu tiên TRUNG BÌNH)

#### 5.1 Chuẩn hóa Chat models → Freezed

**Hành động:**
- Convert `conversation_model.dart` (hand-written) → Freezed
- Convert `message_model.dart` (hand-written) → Freezed
- Convert `message_receipt_model.dart` (hand-written) → Freezed
- Thêm `fromJson`/`toJson` cho tất cả

**Lý do:** Auth models dùng Freezed, community models dùng Freezed, nhưng chat models lại hand-written → inconsistent.

#### 5.2 Chuẩn hóa `MomentNote` model → Freezed

**Hành động:**
- Convert `lib/data/models/moment_note_model.dart` (plain class) → Freezed
- Thêm `fromJson`/`toJson`

#### 5.3 Tách `chat_detail_setting_screen.dart` (313 dòng)

**Hành động:**
```
TRƯỚC:
  screens/chat_detail_setting_screen.dart  (313 dòng)

SAU:
  screens/chat_detail_setting_screen.dart  (~150 dòng)
  widgets/
    ├── chat_avatar_section.dart       ← _buildAvatarSection
    ├── chat_option_tile.dart          ← _buildOptionTile (reusable)
    ├── mute_dialog.dart               ← _showMuteDialog, _MuteDuration enum
    └── nickname_dialog.dart           ← _showNicknameDialog
```

---

### PHASE 6: Feature Home — Cải thiện nhỏ (Ưu tiên THẤP)

#### 6.1 Extract hardcoded colors → `AppColors`

**Hành động:**
- `calendar_item.dart`: `Color(0xFFF2D6B3)`, `Color(0xFFFFF8F0)` → `AppColors.calendarAccent`, `AppColors.calendarBg`
- `exp_item.dart`: `Color(0xFFFFF4E8)`, `Color(0xFFE6B98A)` → `AppColors.expBarBg`, `AppColors.expBarFill`
- `help_suggestion_card.dart`: 6 hardcoded colors → `AppColors.suggestionGreen`, etc.
- `active_home_avatar.dart`: `Color(0xFF4A5568)` → `AppColors.avatarFallback`

#### 6.2 Extract calendar logic

**Hành động:**
- `calendar_item.dart`: Tách `_generateDays()`, `_monthName()` → `core/utils/date_utils.dart`
- Fix bug: arrow buttons thay đổi **day** thay vì **month**

---

### PHASE 7: Internationalization — i18n (Ưu tiên THẤP)

#### 7.1 Extract hardcoded strings

**Vị trí hardcoded Vietnamese:**
- `social_post_card.dart` → `'cùng với'`
- `comment_overlay.dart` → `'Thích'`
- `chat_detail_setting_screen.dart` → `'Tắt thông báo'`, `'Huỷ'`, `'Biệt danh'`

**Hành động:**
```
TẠO MỚI:
  lib/core/l10n/
    ├── app_strings.dart         ← Tất cả string constants
    ├── app_strings_vi.dart      ← Vietnamese translations
    └── app_strings_en.dart      ← English translations (tương lai)
```

---

### PHASE 8: Architecture — State Management & DI (Ưu tiên cho TƯƠNG LAI)

#### 8.1 Abstract mock data → Repository pattern

**Hành động:**
```
TRƯỚC:  Screen → MockData (trực tiếp gọi static method)
SAU:    Screen → Provider/BLoC → Repository → DataSource (Mock hoặc API)
```

**Tạo repositories:**
```
lib/data/repositories/
  ├── post_repository.dart
  ├── comment_repository.dart
  ├── notification_repository.dart
  ├── user_repository.dart
  ├── chat_repository.dart
  └── help_repository.dart

lib/data/datasources/
  ├── local/
  │   └── mock_data_source.dart    ← Wrap tất cả mock data
  └── remote/
      └── api_data_source.dart     ← Tương lai: gọi API thật
```

#### 8.2 Thêm State Management

**Đề xuất:** Riverpod hoặc BLoC (dựa trên team preference)

```
Mỗi feature thêm:
  features/xxx/
    ├── providers/        ← Riverpod providers
    │   └── xxx_provider.dart
    └── presentation/
        ├── screens/
        └── widgets/
```

---

## 📁 CẤU TRÚC THƯ MỤC ĐỀ XUẤT SAU REFACTOR

```
lib/
├── main.dart
│
├── core/
│   ├── constants/
│   │   ├── app_assets.dart
│   │   ├── app_colors.dart          ← HỢP NHẤT (xóa theme/app_colors.dart)
│   │   ├── app_shadows.dart
│   │   ├── app_shapes.dart          ← Chỉ border radius, dimensions
│   │   ├── app_spacing.dart         ← + padding từ AppShapes
│   │   ├── app_text_styles.dart     ← Dùng AppTypography
│   │   └── app_typography.dart
│   │
│   ├── l10n/
│   │   ├── app_strings.dart         ← MỚI: String constants
│   │   └── app_strings_vi.dart      ← MỚI: Vietnamese
│   │
│   ├── theme/
│   │   └── app_theme.dart
│   │
│   ├── utils/                        ← MỚI
│   │   ├── formatters.dart          ← formatCount(), formatTime(), limitWords()
│   │   ├── validators.dart          ← Email, password validation
│   │   └── extensions.dart          ← String, DateTime extensions
│   │
│   └── widgets/
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
│       └── widgets.dart              ← Barrel export
│
├── data/
│   ├── models/
│   │   ├── user_model.dart           ← SINGLE SOURCE OF TRUTH
│   │   ├── post_model.dart
│   │   ├── comment_model.dart
│   │   ├── notification_model.dart
│   │   ├── pet_profile_model.dart
│   │   ├── pet_owner_model.dart
│   │   ├── media_file_model.dart
│   │   ├── moment_note_model.dart    ← Convert → Freezed
│   │   └── enums/
│   │       ├── media_type.dart
│   │       ├── notification_type.dart
│   │       ├── post_privacy.dart
│   │       ├── comment_sort_option.dart  ← MỚI (từ mockdata)
│   │       └── enums.dart
│   │
│   └── repositories/                 ← TƯƠNG LAI
│       ├── post_repository.dart
│       ├── comment_repository.dart
│       └── ...
│
├── features/
│   ├── auth/
│   │   ├── data/models/
│   │   │   ├── auth_state.dart
│   │   │   ├── login_request.dart
│   │   │   ├── login_response.dart
│   │   │   ├── register_request.dart     ← Xóa PasswordRequirement
│   │   │   ├── change_password_request.dart  ← Xóa PasswordRequirement
│   │   │   ├── forgot_password_request.dart
│   │   │   ├── password_requirement.dart ← MỚI: shared class
│   │   │   └── models.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── login_screen.dart         ← Dùng AuthInputField
│   │       │   ├── register_screen.dart      ← Dùng AuthInputField
│   │       │   ├── forgot_password_screen.dart
│   │       │   └── change_password_screen.dart
│   │       └── widgets/                       ← MỚI
│   │           ├── auth_input_field.dart
│   │           ├── auth_password_field.dart
│   │           ├── auth_submit_button.dart
│   │           ├── auth_screen_layout.dart
│   │           └── widgets.dart
│   │
│   ├── chat/
│   │   ├── data/models/
│   │   │   ├── conversation_model.dart   ← Convert → Freezed
│   │   │   ├── message_model.dart        ← Convert → Freezed
│   │   │   └── ...
│   │   └── presentation/
│   │       ├── screens/
│   │       └── widgets/
│   │           ├── chat_avatar_section.dart    ← MỚI (từ setting screen)
│   │           ├── chat_option_tile.dart       ← MỚI
│   │           ├── mute_dialog.dart            ← MỚI
│   │           ├── nickname_dialog.dart        ← MỚI
│   │           └── ... (existing widgets)
│   │
│   ├── community/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── community_screen.dart
│   │       │   └── personal_profile_screen.dart  ← Giảm → ~150 dòng
│   │       └── widgets/
│   │           ├── profile/                      ← MỚI
│   │           │   ├── profile_hero_header.dart
│   │           │   ├── profile_stats_section.dart
│   │           │   ├── profile_buddies_section.dart
│   │           │   └── profile_post_feed.dart
│   │           ├── post/                          ← MỚI
│   │           │   ├── social_post_card.dart      ← Giảm → ~150 dòng
│   │           │   ├── post_header.dart
│   │           │   ├── post_media_carousel.dart
│   │           │   ├── post_footer.dart
│   │           │   └── post_content.dart
│   │           ├── comments/                      ← MỚI
│   │           │   ├── comment_overlay.dart       ← Giảm → ~200 dòng
│   │           │   ├── comment_item.dart
│   │           │   ├── comment_input_section.dart
│   │           │   └── comment_post_preview.dart
│   │           └── widgets.dart
│   │
│   ├── help/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── ask_for_help_screen.dart  ← Giảm → ~200 dòng
│   │       └── widgets/
│   │           ├── bouncing_dots.dart            ← MỚI (extract)
│   │           ├── help_welcome_message.dart     ← MỚI
│   │           ├── help_new_chat_view.dart       ← MỚI
│   │           ├── help_active_chat_view.dart    ← MỚI
│   │           ├── help_input_area.dart          ← MỚI
│   │           └── ... (existing widgets)
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── screens/
│   │       └── widgets/
│   │
│   ├── navigation/
│   │   └── presentation/
│   │
│   ├── notifications/                            ← MỚI (tách từ community)
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── notification_screen.dart
│   │   │   └── widgets/
│   │   │       └── notification_item.dart
│   │   └── data/
│   │       └── notification_mock_data.dart
│   │
│   └── profile/
│       └── presentation/
│           └── screens/
│               └── profile_screen.dart
```

---

## 📈 DỰ KIẾN KẾT QUẢ SAU REFACTOR

### Giảm kích thước file

| File | Trước | Sau | Giảm |
|------|-------|-----|------|
| `common_widgets.dart` | 742 | Xóa (tách 8 file, mỗi file ~80-100 dòng) | -100% |
| `ask_for_help_screen.dart` | 643 | ~200 | -69% |
| `personal_profile_screen.dart` | 603 | ~150 | -75% |
| `comment_overlay.dart` | 584 | ~200 | -66% |
| `social_post_card.dart` | 574 | ~150 | -74% |
| `change_password_screen.dart` | 538 | ~250 | -54% |
| `register_screen.dart` | 335 | ~150 | -55% |
| `chat_detail_setting_screen.dart` | 313 | ~150 | -52% |

### Code dùng lại được (Reusability)

| Widget/Util mới | Dùng bởi |
|-----------------|----------|
| `AuthInputField` | 4 auth screens |
| `AuthPasswordField` | 3 auth screens |
| `formatCount()` | community, profile, post card, comment |
| `formatTime()` | chat bubble, conversation sidebar |
| `CustomButton` | Auth, community, help, profile |
| `PostMediaCarousel` | social_post_card, personal_profile |
| `PostHeader` | social_post_card, comment_post_preview |
| `CommentItem` | comment_overlay, notification deep link |

### Xóa code chết

| Loại | Số lượng |
|------|---------|
| File rỗng (placeholder) | 12 file |
| Thư mục rỗng | 5 thư mục |
| Commented-out code | ~50 dòng |
| Dead demo file | 1 file (222 dòng) |

---

## ⚡ DEPRECATED API — Cần fix toàn bộ

### `Color.withOpacity()` → `Color.withValues(alpha:)`

**Số file ảnh hưởng:** ~15 file

**File cần update:**
- `login_screen.dart`, `register_screen.dart`, `forgot_password_screen.dart`, `change_password_screen.dart`
- `chat_list_screen.dart`, `chat_detail_screen.dart`, `chat_detail_setting_screen.dart`
- `active_home_avatar.dart`, `chat_input_field.dart`, `conversation_card.dart`
- `message_bubble.dart`, `message_status_indicator.dart`
- `calendar_item.dart`, `exp_item.dart`, `user_moments_box.dart`
- `moments_modal_content.dart`, `moments_input_field.dart`, `typing_text_button.dart`
- `profile_screen.dart`, `demo_auth_screens.dart`

---

## 🗓️ THỨ TỰ THỰC HIỆN ĐỀ XUẤT

| Giai đoạn | Công việc | Ưu tiên | Ước tính |
|-----------|-----------|---------|----------|
| **Phase 1** | Core: Merge AppColors, tách common_widgets, tạo utils | 🔴 Cao | 2-3 ngày |
| **Phase 2** | Auth: Tạo reusable widgets, fix duplicates | 🔴 Cao | 1-2 ngày |
| **Phase 3** | Community: Tách 3 file lớn, tách notifications | 🔴 Cao | 2-3 ngày |
| **Phase 4** | Help: Tách ask_for_help_screen | 🟡 TB | 1 ngày |
| **Phase 5** | Chat: Chuẩn hóa models, tách settings | 🟡 TB | 1-2 ngày |
| **Phase 6** | Home: Extract hardcoded colors | 🟢 Thấp | 0.5 ngày |
| **Phase 7** | i18n: Extract strings | 🟢 Thấp | 1 ngày |
| **Phase 8** | Architecture: Repository + State management | 🔵 Tương lai | 3-5 ngày |
| **Bonus** | Fix `withOpacity()` deprecated | 🟡 TB | 0.5 ngày |

**Tổng ước tính: ~12-18 ngày làm việc** (trải dài theo sprint, không cần làm liên tục)

---

## ⚠️ LƯU Ý KHI REFACTOR

1. **Mỗi Phase là 1 PR riêng** — Không gộp nhiều phase vào 1 PR
2. **Chạy test sau mỗi file tách** — Đảm bảo UI không bị regression
3. **Update imports trước, xóa file cũ sau** — Tránh build break
4. **Giữ barrel export files** — Để import path không đổi cho consumer code
5. **Không refactor + thêm feature cùng lúc** — Tách riêng refactoring commits
6. **Freezed codegen** — Sau khi convert chat models, chạy `dart run build_runner build`
