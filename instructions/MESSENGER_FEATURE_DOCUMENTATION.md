# Feature Messenger (Chat) - Tài liệu Kiến trúc & Logic Xử lý

> Tài liệu mô tả toàn bộ kiến trúc, logic xử lý, data flow, và phương pháp triển khai của feature Messenger trong ứng dụng Homies Buddy.

---

## 1. Tổng quan Kiến trúc

### 1.1. Cấu trúc thư mục

```
lib/features/chat/
├── data/
│   └── models/
│       ├── models.dart                  # Barrel export file
│       ├── conversation_model.dart      # Model cuộc hội thoại
│       ├── message_model.dart           # Model tin nhắn
│       ├── message_receipt_model.dart   # Model biên nhận tin nhắn
│       ├── message_status.dart          # Enum trạng thái tin nhắn
│       └── message_type.dart            # Enum loại tin nhắn
├── mockdata/
│   └── chat_mock_data.dart              # Dữ liệu giả lập
└── presentation/
    ├── screens/
    │   ├── chat_list_screen.dart         # Màn hình danh sách hội thoại
    │   ├── chat_detail_screen.dart       # Màn hình chi tiết tin nhắn
    │   └── chat_detail_setting_screen.dart # Màn hình cài đặt hội thoại
    └── widgets/
        ├── widgets.dart                  # Barrel export file
        ├── active_home_avatar.dart       # Widget avatar active (story-style)
        ├── chat_input_field.dart         # Widget ô nhập tin nhắn
        ├── conversation_card.dart        # Widget card hội thoại
        ├── message_bubble.dart           # Widget bong bóng tin nhắn
        └── message_status_indicator.dart # Widget chỉ báo trạng thái
```

### 1.2. Design Pattern

- **Feature-first architecture**: Tách riêng `data`, `mockdata`, `presentation`
- **Barrel exports**: Sử dụng file `models.dart` và `widgets.dart` để gom import
- **StatefulWidget + setState**: Quản lý state cục bộ tại mỗi screen
- **Callback pattern**: Truyền callback giữa các widget/screen (ví dụ `onConversationUpdated`)
- **copyWith pattern**: Các model đều implement `copyWith()` để tạo bản sao immutable

---

## 2. Data Layer - Models

### 2.1. Conversation (conversation_model.dart)

Model đại diện cho một cuộc hội thoại giữa các user/home.

| Field | Type | Mô tả |
|---|---|---|
| `id` | `String` | ID duy nhất cuộc hội thoại (e.g. `conv_01`) |
| `participantIds` | `List<String>` | Danh sách ID các user tham gia |
| `participantName` | `String` | Tên hiển thị gốc (tên Home) |
| `participantAvatar` | `String` | URL/path avatar |
| `lastMessage` | `String` | Nội dung tin nhắn cuối cùng |
| `lastUpdated` | `DateTime` | Thời gian cập nhật cuối |
| `unreadCount` | `int` | Số tin nhắn chưa đọc |
| `nickname` | `String?` | Biệt danh do user đặt (nullable) |
| `mutedUntil` | `DateTime?` | Thời điểm hết mute (nullable) |

**Computed properties:**
- `displayName`: Trả về `nickname` nếu có, ngược lại trả `participantName`
- `isMuted`: So sánh `mutedUntil` với `DateTime.now()` để xác định trạng thái mute
- `hasUnread`: `unreadCount > 0`

**copyWith đặc biệt:**
- `clearNickname: true` → set `nickname = null`
- `clearMute: true` → set `mutedUntil = null`

### 2.2. Message (message_model.dart)

Model đại diện cho một tin nhắn đơn lẻ.

| Field | Type | Mô tả |
|---|---|---|
| `id` | `String` | ID duy nhất tin nhắn (e.g. `msg_01`) |
| `conversationId` | `String` | ID cuộc hội thoại chứa tin nhắn |
| `senderId` | `String` | ID người gửi |
| `content` | `String` | Nội dung (text hoặc URL ảnh) |
| `type` | `MessageType` | Loại tin nhắn (text/image) |
| `createdAt` | `DateTime` | Thời điểm tạo |
| `status` | `MessageStatus` | Trạng thái gửi/nhận |

### 2.3. MessageReceipt (message_receipt_model.dart)

Model tracking biên nhận tin nhắn (khi nào delivered, khi nào seen).

| Field | Type | Mô tả |
|---|---|---|
| `messageId` | `String` | ID tin nhắn |
| `userId` | `String` | ID user nhận |
| `deliveredAt` | `DateTime?` | Thời điểm tin được giao |
| `seenAt` | `DateTime?` | Thời điểm tin được đọc |

> **Lưu ý:** Model này hiện tại đã define nhưng chưa được sử dụng trong logic — chuẩn bị cho tích hợp backend/realtime sau này.

### 2.4. MessageStatus (message_status.dart)

```
sending  → Đang gửi (hiện spinner)
sent     → Đã gửi tới server (hiện 1 tick ✓)
delivered → Đã giao tới người nhận (hiện 2 tick ✓✓)
seen     → Đã đọc (hiện 2 tick ✓✓ màu cam)
failed   → Gửi thất bại (hiện icon lỗi đỏ)
```

### 2.5. MessageType (message_type.dart)

```
text  → Tin nhắn văn bản
image → Tin nhắn hình ảnh (content = URL ảnh)
```

---

## 3. Mock Data Layer

### 3.1. ChatMockData (chat_mock_data.dart)

Cung cấp dữ liệu giả lập cho toàn bộ feature chat.

**Dữ liệu static:**
- `currentUserId = 'user_01'` — ID user hiện tại
- `mockConversations` — 6 cuộc hội thoại mẫu với thời gian tương đối (`DateTime.now().subtract(...)`)
- `mockMessages` — 7 tin nhắn mẫu cho conversation `conv_01` (bao gồm cả text và image)
- `activeHomes` — 5 avatar active (dạng story)

**Phương thức:**

| Method | Logic |
|---|---|
| `getTotalUnreadCount()` | Dùng `fold()` để tính tổng `unreadCount` của tất cả conversations |
| `getMessagesForConversation(id)` | Trả về `mockMessages` nếu `id == 'conv_01'`, ngược lại trả `[]` |
| `markConversationAsRead(id)` | Tìm conversation theo `indexWhere()`, gọi `copyWith(unreadCount: 0)` |

> **Lưu ý quan trọng:** `mockConversations` là `final List` (mutable list) nên có thể thay đổi phần tử bên trong. Khi tích hợp backend, cần chuyển sang state management (Provider/Riverpod/Bloc).

---

## 4. Presentation Layer - Screens

### 4.1. ChatListScreen (chat_list_screen.dart)

**Vai trò:** Màn hình chính hiển thị danh sách tất cả cuộc hội thoại.

**Điểm truy cập:** Được navigate từ `CommunityScreen` qua icon chat trên AppBar.

#### State Management

```dart
List<Conversation> _allConversations      // Toàn bộ conversations
List<Conversation> _filteredConversations  // Conversations sau khi lọc
TextEditingController _searchController    // Controller tìm kiếm
String _searchQuery                        // Query tìm kiếm hiện tại
```

#### Lifecycle

```
initState()
  ├── _loadConversations()    → Load data từ ChatMockData
  └── _searchController.addListener(_onSearchChanged)  → Lắng nghe search

dispose()
  ├── _searchController.removeListener()
  └── _searchController.dispose()
```

#### Logic Tìm kiếm (_onSearchChanged)

```
Input: query text từ search bar
Process:
  1. Trim & toLowerCase query
  2. Nếu query rỗng → hiện toàn bộ conversations
  3. Nếu có query → filter theo 3 tiêu chí (OR):
     - displayName chứa query
     - participantName chứa query  
     - lastMessage chứa query
Output: setState() cập nhật _filteredConversations
```

#### Logic Navigate vào Chat Detail

```
Khi tap vào ConversationCard:
  1. Gọi ChatMockData.markConversationAsRead(id) → reset unreadCount = 0
  2. Navigator.push → ChatDetailScreen(conversation)
  3. Sau khi pop trở lại (.then callback):
     - _loadConversations() → reload data mới nhất
     - _onSearchChanged() → reapply search filter nếu đang active
```

#### UI Components

```
Scaffold
├── AppBar
│   └── Title: "Messages"
└── Body (Container with cardGradient)
    ├── Search Bar
    │   ├── TextField với hint "Search conversations..."
    │   ├── Prefix: Icon search
    │   └── Suffix: Icon close (chỉ hiện khi có query)
    └── Expanded
        └── RefreshIndicator
            ├── Empty state (khi không có kết quả)
            │   ├── Icon search_off
            │   └── Text "No conversations found"
            └── ListView.builder
                └── ConversationCard (cho mỗi conversation)
```

---

### 4.2. ChatDetailScreen (chat_detail_screen.dart)

**Vai trò:** Màn hình hiển thị tin nhắn trong một cuộc hội thoại cụ thể.

#### State Management

```dart
List<Message> _messages              // Danh sách tin nhắn
Conversation _conversation           // Conversation hiện tại (có thể update)
ScrollController _scrollController   // Controller scroll tin nhắn
```

#### Lifecycle

```
initState()
  ├── _conversation = widget.conversation
  ├── _messages = ChatMockData.getMessagesForConversation(id)
  └── WidgetsBinding.addPostFrameCallback → _scrollToBottom()

dispose()
  └── _scrollController.dispose()
```

#### Logic Gửi tin nhắn (_sendMessage)

```
Input: String content
Validation: Trim → nếu rỗng thì return

Flow:
  1. Tạo Message mới:
     - id = 'msg_${timestamp}'  (unique ID dựa trên milliseconds)
     - senderId = currentUserId
     - type = MessageType.text
     - status = MessageStatus.sending
  
  2. setState() → thêm message vào _messages list
  
  3. Simulate gửi tin nhắn (giả lập network):
     - Sau 500ms: status → MessageStatus.sent
     - Sau 1000ms: status → MessageStatus.delivered
     
  4. Sau 100ms: _scrollToBottom() → cuộn xuống tin nhắn mới nhất
```

**Chi tiết animation gửi tin:**
```
T+0ms    : [sending]   → Hiện spinner nhỏ
T+500ms  : [sent]      → Hiện 1 tick ✓
T+1000ms : [delivered]  → Hiện 2 tick ✓✓
```

#### Logic Auto-scroll (_scrollToBottom)

```dart
if (_scrollController.hasClients) {
  _scrollController.animateTo(
    maxScrollExtent,
    duration: 300ms,
    curve: Curves.easeOut,
  );
}
```
- Gọi khi: initState (sau frame render), gửi tin nhắn mới
- Check `hasClients` để tránh crash khi controller chưa attach

#### Logic Navigate Settings

```
Tap avatar/tên trên AppBar hoặc icon "..." → Push ChatDetailSettingScreen
Callback onConversationUpdated: nhận conversation đã update → setState
```

#### UI Structure

```
Scaffold
├── AppBar
│   ├── Leading: Back button (arrow_back_ios)
│   ├── Title: GestureDetector (tap → settings)
│   │   ├── ClipOval Avatar (36x36)
│   │   ├── Display name (bold)
│   │   └── "active now" (cam)
│   └── Actions: Icon more_vert → settings
└── Body (Container with cardGradient)
    ├── Expanded
    │   ├── Empty state: "No messages yet\nStart the conversation!"
    │   └── ListView.builder
    │       └── MessageBubble(message, isMe)
    └── ChatInputField
        ├── onSendMessage → _sendMessage
        └── onAttachMedia → SnackBar "coming soon"
```

---

### 4.3. ChatDetailSettingScreen (chat_detail_setting_screen.dart)

**Vai trò:** Màn hình cài đặt cho cuộc hội thoại: xem profile, mute, nickname.

#### State Management

```dart
Conversation _conversation  // Conversation đang cài đặt
```

#### Logic Update Conversation (_updateConversation)

```
Input: Conversation updated
Process:
  1. Tìm index trong ChatMockData.mockConversations theo id
  2. Nếu tìm thấy → thay thế phần tử tại index
  3. setState() cập nhật _conversation local
  4. Gọi widget.onConversationUpdated(updated) → thông báo cho ChatDetailScreen
```

#### Logic Navigate Profile (_navigateToProfile)

```
1. Lấy participantId = ID đầu tiên khác currentUserId trong participantIds
2. Chuyển đổi format: 'user_02' → 'user2' (bỏ '_0')
3. Gọi ProfileMockData.getUserByAuthorId(userId)
4. Navigate → PersonalProfileScreen(user)
```

> **Lưu ý:** Conversion `user_02 → user2` là workaround cho sự khác biệt format ID giữa chat mock data và profile mock data.

#### Logic Mute Notifications (_showMuteDialog)

**Trường hợp 1: Đang muted → Hỏi bật lại**
```
1. Hiện AlertDialog xác nhận
2. Nếu confirm → _updateConversation(copyWith(clearMute: true))
3. Nếu cancel → không làm gì
```

**Trường hợp 2: Chưa mute → Chọn thời lượng**
```
Hiện AlertDialog với RadioListTile:
  ├── 1 giờ   → DateTime.now() + 1h
  ├── 4 giờ   → DateTime.now() + 4h
  ├── 8 giờ   → DateTime.now() + 8h
  └── Mãi mãi → DateTime(9999)

Khi OK: _updateConversation(copyWith(mutedUntil: selected.until))
```

**Hiển thị thời gian mute (_muteUntilText):**
```
- Nếu year >= 9999 → "khi bật lại"
- Nếu còn >= 1 giờ → "{n}h nữa"
- Ngược lại → "{n} phút nữa"
```

#### Logic Nickname (_showNicknameDialog)

```
1. Hiện AlertDialog với TextField
   - Giá trị ban đầu = nickname hiện tại (hoặc rỗng)
   - Hint = participantName gốc
2. Khi OK:
   - Nếu text rỗng → clearNickname: true (xóa nickname)
   - Nếu có text → copyWith(nickname: newNick)
3. TextEditingController KHÔNG dispose thủ công → tránh crash animation dialog
```

#### UI Structure

```
Scaffold
├── AppBar: "Cài đặt cuộc trò chuyện" (centered)
└── Body (SingleChildScrollView)
    ├── Avatar Section
    │   ├── ClipOval Avatar (90x90, border cam 3px)
    │   ├── Display name (bold, h3)
    │   └── Original name (nếu có nickname, caption)
    └── Options Card (Container rounded 20px)
        ├── "Xem hồ sơ" → Navigate profile
        │   └── Subtitle: participantName
        ├── "Thông báo" → Mute dialog
        │   └── Subtitle: "Đang bật" / "Đang tắt đến {time}"
        └── "Biệt danh" → Nickname dialog
            └── Subtitle: nickname / "Chưa đặt biệt danh"
```

---

## 5. Presentation Layer - Widgets

### 5.1. ConversationCard (conversation_card.dart)

**Vai trò:** Card hiển thị một cuộc hội thoại trong danh sách.

**Dependencies:** Package `timeago` để format thời gian (e.g. "5m", "2h")

**Visual logic:**
```
Nếu hasUnread:
  - Background opacity 0.95 (đậm hơn)
  - Avatar có border cam
  - Tên bold w600
  - Message text đậm hơn
  - Thời gian màu cam, bold
  - Hiện badge số unread (nền cam, text trắng)

Nếu đã đọc:
  - Background opacity 0.7 (nhạt hơn)
  - Avatar không border
  - Tên w500
  - Message text nhạt
  - Thời gian màu textSecondary
  - Không hiện badge
```

**Layout:**
```
Row
├── Avatar (56x56, ClipOval)
│   ├── Network image (nếu URL bắt đầu http)
│   └── Asset image (ngược lại)  
├── Column (Expanded)
│   ├── Display name (maxLines: 1, ellipsis)
│   └── Last message (maxLines: 2, ellipsis)
└── Column (end-aligned)
    ├── Time (timeago format, locale: en_short)
    └── Unread badge (nếu có)
```

### 5.2. MessageBubble (message_bubble.dart)

**Vai trò:** Bong bóng tin nhắn trong chat detail.

**Dependencies:** Package `intl` để format thời gian (HH:mm)

**Visual logic:**
```
Nếu isMe (tin của mình):
  - Align phải
  - Margin left 48px (đẩy sang phải)
  - Background: accentOrange opacity 0.15
  - Corner: bottomRight = 4px (góc nhọn)
  - Hiện MessageStatusIndicator

Nếu không phải mình:
  - Align trái
  - Margin right 48px (đẩy sang trái)
  - Background: backgroundPost opacity 0.9
  - Corner: bottomLeft = 4px (góc nhọn)
  - KHÔNG hiện status indicator
```

**Xử lý theo MessageType:**
```
text:
  → Text widget với style bodyMedium, line-height 1.4

image:
  → Image.network với width 200
  → loadingBuilder: Container 200x200 + CircularProgressIndicator
  → errorBuilder: Container 200x200 + Icon broken_image
```

**Phần footer (dưới bubble):**
```
Row
├── Time (HH:mm, fontSize 10)
└── MessageStatusIndicator (chỉ hiện nếu isMe)
```

### 5.3. MessageStatusIndicator (message_status_indicator.dart)

**Vai trò:** Icon/spinner hiển thị trạng thái gửi tin nhắn.

| Status | Widget | Màu sắc |
|---|---|---|
| `sending` | CircularProgressIndicator (10x10, stroke 1.5) | textSecondary 50% |
| `sent` | Icon `check` (14px) | textSecondary 70% |
| `delivered` | Icon `done_all` (14px) | textSecondary 70% |
| `seen` | Icon `done_all` (14px) | accentOrange (cam) |
| `failed` | Icon `error_outline` (14px) | red.shade400 |

### 5.4. ChatInputField (chat_input_field.dart)

**Vai trò:** Ô nhập và gửi tin nhắn ở dưới cùng chat detail.

**State:**
```dart
TextEditingController _controller  // Controller text field
bool _hasText                      // Có text hay không → điều khiển nút gửi
```

**Logic:**
```
- Listener trên _controller → cập nhật _hasText = text.trim().isNotEmpty
- _sendMessage():
  1. Trim text
  2. Nếu không rỗng → gọi widget.onSendMessage(text)
  3. Clear controller
- TextField cho phép multiline (maxLines: null)
- onSubmitted → gửi tin nhắn khi nhấn Enter
```

**Visual logic nút gửi:**
```
Nếu _hasText:
  - Background: accentOrange (đủ màu)
  - onTap active

Nếu không có text:
  - Background: accentOrange opacity 0.3 (mờ)
  - onTap = null (disabled)
```

**Layout:**
```
Container (padding, shadow top)
└── SafeArea
    └── Row
        ├── IconButton add_circle_outline (attach media)
        ├── Expanded TextField (border radius 24)
        └── GestureDetector (nút gửi, circle 44x44)
```

### 5.5. ActiveHomeAvatar (active_home_avatar.dart)

**Vai trò:** Avatar dạng story (gradient border) cho active homes.

> **Lưu ý:** Widget đã được định nghĩa nhưng chưa được sử dụng trong UI hiện tại. Chuẩn bị cho tính năng "Active Stories" trên đầu ChatListScreen.

**Layout:**
```
GestureDetector
└── Column
    ├── Container 64x64 (gradient border orange→pink)
    │   └── Container (white border 3px + avatar AssetImage)
    └── Text name (11px, max 1 line, ellipsis)
```

---

## 6. Data Flow

### 6.1. Flow: Mở danh sách chat

```
CommunityScreen
  → Tap icon chat trên AppBar
  → Navigator.push(ChatListScreen)
  → initState()
  → _loadConversations() ← ChatMockData.mockConversations
  → Build ListView với ConversationCard
```

### 6.2. Flow: Tìm kiếm cuộc hội thoại

```
User gõ text vào SearchBar
  → _searchController.addListener → _onSearchChanged()
  → Filter _allConversations theo displayName / participantName / lastMessage
  → setState() → rebuild ListView với _filteredConversations
  
User xoá text (tap icon X)
  → _searchController.clear()
  → _onSearchChanged() → query rỗng → hiện toàn bộ
```

### 6.3. Flow: Mở conversation → Gửi tin nhắn

```
User tap ConversationCard
  → markConversationAsRead(id)     ← unreadCount = 0
  → Navigator.push(ChatDetailScreen)
  → initState()
  → Load messages từ ChatMockData
  → Auto scroll to bottom
  
User gõ tin nhắn + tap Send
  → ChatInputField.onSendMessage(text)
  → ChatDetailScreen._sendMessage(text)
  → Tạo Message(status: sending)
  → setState() → thêm vào _messages
  → T+500ms: status → sent
  → T+1000ms: status → delivered
  → Auto scroll to bottom

User quay lại ChatListScreen
  → .then() callback
  → _loadConversations() → reload data mới
  → _onSearchChanged() → reapply filter
```

### 6.4. Flow: Đặt nickname

```
ChatDetailScreen → Tap avatar/name/more → ChatDetailSettingScreen
  → Tap "Biệt danh"
  → _showNicknameDialog()
  → User nhập nickname → OK
  → _updateConversation(copyWith(nickname: newNick))
    ├── Update ChatMockData.mockConversations[index]
    ├── setState() local
    └── onConversationUpdated(updated) → ChatDetailScreen setState
  → ChatDetailScreen hiển thị nickname mới trên AppBar
  → Khi pop về ChatListScreen → reload → hiện nickname
```

### 6.5. Flow: Mute thông báo

```
ChatDetailSettingScreen → Tap "Thông báo"
  
Case 1 (Chưa mute):
  → _showMuteDialog()
  → Hiện RadioListTile (1h / 4h / 8h / forever)
  → OK → copyWith(mutedUntil: selected.until)
  → Update conversation

Case 2 (Đang mute):
  → _showMuteDialog()
  → Hiện confirm "Bạn muốn bật lại?"
  → "Bật lại" → copyWith(clearMute: true) → mutedUntil = null
```

### 6.6. Flow: Xem profile từ chat

```
ChatDetailSettingScreen → Tap "Xem hồ sơ"
  → _navigateToProfile()
  → Lấy participantId khác currentUserId
  → Convert format: user_02 → user2
  → ProfileMockData.getUserByAuthorId(userId)
  → Navigator.push(PersonalProfileScreen)
```

---

## 7. Design System & Styling

### 7.1. Color Palette (từ AppColors)

| Thành phần | Color | Sử dụng |
|---|---|---|
| Gradient background | `AppColors.cardGradient` | Body tất cả screens |
| Card background | `AppColors.backgroundPost` | Conversation card, bubble đối phương |
| Accent | `AppColors.accentOrange` | Nút gửi, badge unread, avatar border, tick seen |
| Text primary | `AppColors.textPrimary` | Tên, nội dung tin nhắn |
| Text secondary | `AppColors.textSecondary` | Thời gian, hint, caption |

### 7.2. Border Radius

| Component | Radius |
|---|---|
| Search bar | 24px |
| Conversation card | 20px |
| Message bubble | 20px (rounded) / 4px (corner nhọn) |
| Input field | 24px |
| Settings options card | 20px |
| Send button | Circle |
| Avatar | Circle (ClipOval) |

### 7.3. Shadow Pattern

```dart
BoxShadow(
  color: AppColors.textSecondary.withOpacity(0.08),
  blurRadius: 12,
  offset: Offset(0, 4),  // Shadows đều hướng xuống
)
```

---

## 8. Xử lý Edge Cases

### 8.1. Avatar Loading

```
- Kiểm tra URL bắt đầu bằng 'http' → Image.network
- Ngược lại → Image.asset
- errorBuilder → fallback icon person (tất cả widgets)
```

### 8.2. Empty States

```
ChatListScreen:
  - Không có kết quả tìm kiếm → Icon search_off + "No conversations found"

ChatDetailScreen:
  - Không có tin nhắn → "No messages yet\nStart the conversation!"
```

### 8.3. Text Overflow

```
- Conversation card: tên maxLines 1, message maxLines 2, ellipsis
- Chat detail AppBar: tên maxLines 1, ellipsis (Flexible wrap)
- Active home name: maxLines 1, ellipsis
```

### 8.4. ScrollController Safety

```dart
if (_scrollController.hasClients) { ... }
// Kiểm tra trước khi scroll để tránh crash
```

### 8.5. Mounted Check

```dart
Future.delayed(Duration(milliseconds: 500), () {
  if (mounted) { setState(() { ... }); }
});
// Kiểm tra mounted trước khi setState trong async callbacks
```

### 8.6. TextEditingController trong Dialog

```
// KHÔNG dispose thủ công controller trong dialog
// Để garbage collector xử lý, tránh "used after disposed" error
// khi Flutter đang animate dismiss dialog
```

---

## 9. Dependencies & Packages

| Package | Sử dụng |
|---|---|
| `timeago` | Format thời gian relative trong ConversationCard (e.g. "5m", "2h") |
| `intl` | Format thời gian absolute trong MessageBubble (HH:mm) |
| `flutter/material.dart` | Core UI framework |

---

## 10. Kế hoạch Tích hợp Backend (TODO)

### 10.1. Cần thay đổi

| Hiện tại | Tương lai |
|---|---|
| `ChatMockData` static data | API service + Repository pattern |
| `setState()` | State management (Provider/Riverpod/Bloc) |
| Simulated message status | WebSocket/Firebase realtime |
| `MessageReceipt` chưa dùng | Tích hợp read receipts realtime |
| `ActiveHomeAvatar` chưa dùng | Tích hợp online status |
| ID conversion workaround | Thống nhất format ID |
| `onAttachMedia` → SnackBar | Image picker + upload service |
| Pull-to-refresh placeholder | API call refresh |

### 10.2. Tính năng chưa triển khai

- [ ] Gửi ảnh (image picker + upload)
- [ ] Active homes stories trên đầu chat list
- [ ] Push notifications cho tin nhắn mới
- [ ] Typing indicator ("đang gõ...")
- [ ] Reply/quote tin nhắn
- [ ] Xoá tin nhắn
- [ ] Group chat
- [ ] Online/offline status realtime
- [ ] Pagination tin nhắn (lazy load)
- [ ] Search trong conversation
- [ ] Swipe actions (mute, delete, pin)

---

## 11. Sơ đồ Navigation

```
CommunityScreen
  │
  ├─ [Tap chat icon] ──→ ChatListScreen
  │                          │
  │                          ├─ [Tap conversation] ──→ ChatDetailScreen
  │                          │                            │
  │                          │                            ├─ [Tap avatar/name/...] ──→ ChatDetailSettingScreen
  │                          │                            │                              │
  │                          │                            │                              ├─ [Xem hồ sơ] ──→ PersonalProfileScreen
  │                          │                            │                              ├─ [Thông báo] ──→ Mute Dialog
  │                          │                            │                              └─ [Biệt danh] ──→ Nickname Dialog
  │                          │                            │
  │                          │                            ├─ [Gửi tin nhắn]
  │                          │                            └─ [Back] ──→ ChatListScreen (reload data)
  │                          │
  │                          └─ [Search] ──→ Filter conversations realtime
  │
  └─ [Back] ──→ CommunityScreen
```

---

## 12. Tóm tắt Kiến trúc Tổng thể

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                       │
│                                                              │
│  Screens:                    Widgets:                        │
│  ┌──────────────────┐       ┌─────────────────────────┐     │
│  │ ChatListScreen    │──────│ ConversationCard         │     │
│  │ ChatDetailScreen  │──────│ MessageBubble            │     │
│  │                   │──────│ ChatInputField           │     │
│  │                   │──────│ MessageStatusIndicator   │     │
│  │ ChatDetailSetting │      │ ActiveHomeAvatar (unused)│     │
│  └──────────────────┘       └─────────────────────────┘     │
│           │                                                  │
│           │ setState() + callbacks                           │
│           ▼                                                  │
├─────────────────────────────────────────────────────────────┤
│                      MOCK DATA LAYER                         │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ ChatMockData                                          │   │
│  │  - mockConversations (List<Conversation>)             │   │
│  │  - mockMessages (List<Message>)                       │   │
│  │  - activeHomes (List<Map>)                            │   │
│  │  - getTotalUnreadCount()                              │   │
│  │  - getMessagesForConversation()                       │   │
│  │  - markConversationAsRead()                           │   │
│  └──────────────────────────────────────────────────────┘   │
│           │                                                  │
│           │ uses                                              │
│           ▼                                                  │
├─────────────────────────────────────────────────────────────┤
│                       DATA LAYER (Models)                    │
│  ┌────────────────┐ ┌──────────────┐ ┌──────────────────┐  │
│  │ Conversation    │ │ Message      │ │ MessageReceipt   │  │
│  │  - id           │ │  - id        │ │  - messageId     │  │
│  │  - participants │ │  - senderId  │ │  - userId        │  │
│  │  - nickname     │ │  - content   │ │  - deliveredAt   │  │
│  │  - mutedUntil   │ │  - type      │ │  - seenAt        │  │
│  │  - displayName  │ │  - status    │ └──────────────────┘  │
│  │  - isMuted      │ │  - createdAt │                       │
│  └────────────────┘ └──────────────┘                        │
│                                                              │
│  ┌──────────────┐  ┌────────────────┐                       │
│  │ MessageType   │  │ MessageStatus  │                       │
│  │  - text       │  │  - sending     │                       │
│  │  - image      │  │  - sent        │                       │
│  └──────────────┘  │  - delivered   │                       │
│                     │  - seen        │                       │
│                     │  - failed      │                       │
│                     └────────────────┘                       │
└─────────────────────────────────────────────────────────────┘
```
