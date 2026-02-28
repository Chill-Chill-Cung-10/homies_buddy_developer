# User Moments Box - Reusable Components

## 📁 Cấu trúc thư mục

```
lib/features/home/presentation/widgets/user_moments_box/
├── user_moments_box.dart              # Main widget (entry point)
├── typing_text_button.dart            # ✅ Reusable typing animation button
├── moments_input_field.dart           # ✅ Reusable input field
├── media_grid_item.dart               # ✅ Reusable media grid item
├── media_preview_grid.dart            # ✅ Reusable media grid
└── moments_modal_content.dart         # Modal content

lib/core/widgets/common_widgets.dart   # Shared across entire app
├── BlinkingCursor                     # ✅ Moved here - cursor animation
└── MediaPickerBottomSheet             # ✅ Moved here - media picker
```

## 🔄 Các Components có thể tái sử dụng

### 1. **BlinkingCursor** ⭐ (Moved to common_widgets)
**File:** `lib/core/widgets/common_widgets.dart`

Widget cursor nhấp nháy cho hiệu ứng typing. Có thể dùng ở bất kỳ đâu cần hiệu ứng typing animation.

**Sử dụng:**
```dart
import 'package:homies_buddy_developer/core/widgets/common_widgets.dart';

BlinkingCursor(
  color: Colors.blue,
  fontSize: 18,
  character: '|', // Có thể thay đổi ký tự
)
```

**Use cases:**
- Chat input với typing indicator
- Search box với animation
- Loading text effects
- Terminal/console simulations

---

### 2. **TypingTextButton**
**File:** `typing_text_button.dart`

Button với hiệu ứng typing animation tự động chạy qua nhiều text. Rất linh hoạt và customizable.

**Sử dụng:**
```dart
TypingTextButton(
  onTap: () => print('Tapped'),
  texts: [
    'Welcome...',
    'Get started...',
    'Create something...',
  ],
  typingSpeed: 60,          // milliseconds
  erasingSpeed: 35,         // milliseconds
  pauseDuration: 1800,      // milliseconds
  backgroundColor: Color(0xFFFFF8F0),
  textColor: Colors.brown,
  height: 48,
)
```

**Use cases:**
- Placeholder animations trong search/input
- Promotional banners với rotating text
- Onboarding screens
- Marketing CTAs với multiple messages

---

### 3. **MomentsInputField**
**File:** `moments_input_field.dart`

Input field đầy đủ tính năng với add button và send button. Có thể customize hoàn toàn.

**Sử dụng:**
```dart
MomentsInputField(
  controller: _controller,
  focusNode: _focusNode,
  onAddPressed: () => _pickFile(),
  onSendPressed: () => _sendMessage(),
  hintText: 'Type here...',
  backgroundColor: Colors.white,
  height: 48,
)
```

**Use cases:**
- Chat input fields
- Comment boxes
- Post creation inputs
- Message composers

---

### 4. **MediaPickerBottomSheet** ⭐ (Moved to common_widgets)
**File:** `lib/core/widgets/common_widgets.dart`

Bottom sheet để chọn photo hoặc video. Có static method để dễ dàng sử dụng.

**Sử dụng:**
```dart
import 'package:homies_buddy_developer/core/widgets/common_widgets.dart';

// Cách 1: Static method (đơn giản nhất)
final result = await MediaPickerBottomSheet.show(context);
if (result == 'photo') {
  // Pick photos
} else if (result == 'video') {
  // Pick video
}

// Cách 2: Custom widget
showModalBottomSheet(
  context: context,
  builder: (ctx) => MediaPickerBottomSheet(
    photoLabel: 'Chọn ảnh',
    videoLabel: 'Chọn video',
    onPhotoTap: () => Navigator.pop(ctx, 'photo'),
    onVideoTap: () => Navigator.pop(ctx, 'video'),
  ),
);
```

**Use cases:**
- Bất kỳ feature nào cần pick media
- Profile picture selection
- Post/story creation
- Message attachments
- Product image uploads

---

### 5. **MediaGridItem**
**File:** `media_grid_item.dart`

Widget hiển thị một media item (photo/video) với remove button.

**Sử dụng:**
```dart
MediaGridItem(
  file: xFile,
  onRemove: () => _removeMedia(index),
  showRemoveButton: true,
  removeButtonColor: Colors.black54,
  borderRadius: BorderRadius.circular(12),
)
```

**Use cases:**
- Media galleries
- Image/video previews
- Attachment lists
- Product image management

---

### 6. **MediaPreviewGrid**
**File:** `media_preview_grid.dart`

Grid layout để hiển thị multiple media files với title và remove functionality.

**Sử dụng:**
```dart
MediaPreviewGrid(
  mediaFiles: _selectedFiles,
  onRemoveMedia: (index) => _removeAt(index),
  crossAxisCount: 3,
  title: 'Selected Files (${_selectedFiles.length})',
  showTitle: true,
)
```

**Use cases:**
- Selected files preview
- Image gallery trong forms
- Media management screens
- Upload preview lists

---

### 7. **MomentsModalContent**
**File:** `moments_modal_content.dart`

Full-featured modal content cho việc tạo moments/posts với text input và media selection.

**Sử dụng:**
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => MomentsModalContent(
    imagePicker: ImagePicker(),
    title: 'Create Post',
    hintText: 'What\'s happening?',
    onSend: () => _submitPost(),
    heightFactor: 0.83,
  ),
);
```

**Use cases:**
- Create post/story modals
- Comment with media
- Status updates
- Forum posts
- Social media content creation

---

## 💡 Ví dụ sử dụng trong các tính năng khác

**Important:** `BlinkingCursor` và `MediaPickerBottomSheet` đã được moved vào `common_widgets.dart` để dùng chung cho toàn app:
```dart
import 'package:homies_buddy_developer/core/widgets/common_widgets.dart';
```

### Chat Feature
```dart
import 'package:homies_buddy_developer/core/widgets/common_widgets.dart';

// Trong chat screen
MomentsInputField(
  controller: _chatController,
  focusNode: _chatFocus,
  hintText: 'Type a message...',
  onAddPressed: () async {
    final result = await MediaPickerBottomSheet.show(context);
    if (result != null) _handleMediaPick(result);
  },
  onSendPressed: _sendChatMessage,
)
```

### Profile Picture Upload
```dart
// Chọn ảnh profile
final source = await MediaPickerBottomSheet.show(
  context,
  photoLabel: 'Choose from Gallery',
  videoLabel: 'Take a Photo',
  photoIcon: Icons.photo_library,
  videoIcon: Icons.camera_alt,
);
```

### Search Box với Typing Animation
```dart
TypingTextButton(
  onTap: () => _navigateToSearch(),
  texts: [
    'Search for friends...',
    'Find communities...',
    'Discover content...',
  ],
  backgroundColor: Colors.grey[100],
  textColor: Colors.grey[700],
)
```

### Comment Section
```dart
Column(
  children: [
    MomentsInputField(
      controller: _commentController,
      hintText: 'Add a comment...',
      onSendPressed: _postComment,
      onAddPressed: () {}, // Disable if not needed
    ),
    if (_attachedMedia.isNotEmpty)
      MediaPreviewGrid(
        mediaFiles: _attachedMedia,
        onRemoveMedia: _removeAttachment,
        showTitle: false,
      ),
  ],
)
```

## 🎨 Customization

Tất cả các components đều có nhiều parameters để customize:
- Colors
- Sizes
- Border radius
- Padding/margins
- Text styles
- Icons
- Behaviors

## ✅ Benefits (Lợi ích)

1. **Reusability** - Dùng lại ở nhiều nơi mà không cần duplicate code
2. **Maintainability** - Chỉ cần sửa ở một nơi, tất cả các nơi sử dụng đều được update
3. **Consistency** - UI/UX nhất quán trên toàn app
4. **Testability** - Dễ dàng test từng component riêng biệt
5. **Scalability** - Dễ dàng thêm features mới hoặc modify
6. **Clean Code** - Code gọn gàng, dễ đọc, dễ hiểu

## 📝 Best Practices

1. **Import only what you need** - Chỉ import components bạn cần sử dụng
2. **Customize wisely** - Override defaults khi cần, dùng defaults khi có thể
3. **Keep it simple** - Đừng over-engineer, giữ components đơn giản
4. **Document usage** - Comment rõ ràng khi sử dụng trong context phức tạp
5. **Handle errors** - Luôn xử lý errors khi pick media hoặc validate input

## 🔧 Future Improvements

Đã hoàn thành:
- ✅ Moved `BlinkingCursor` vào `lib/core/widgets/common_widgets.dart` - rất general và dùng nhiều nơi
- ✅ Moved `MediaPickerBottomSheet` vào common widgets - dùng nhiều nơi

Có thể cân nhắc:
- Thêm animation transitions giữa các states
- Thêm validation logic vào input fields
- Support dark mode cho tất cả components
- Thêm accessibility features (screen readers, etc.)
