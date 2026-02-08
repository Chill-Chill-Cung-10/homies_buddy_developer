# NotificationScreen Implementation

## Overview
Instagram-style dedicated notification screen that displays a scrollable list of user notifications with unread indicators, timestamps, and deep linking support.

## Features

### 1. **Screen Navigation**
- Accessed via notification bell icon in Community screen app bar
- Uses `Navigator.push` for navigation
- Back arrow button in top-left returns to Community screen
- Full-screen experience (not an overlay/modal)

### 2. **App Bar Design**
- **Back Arrow**: Icon button with `Icons.arrow_back` (left aligned)
- **Title**: "Notifications" text in h2 style
- **Style**: Transparent background, no elevation
- **Color Scheme**: Icon uses `AppColors.iconColor`

### 3. **Notification List**
- **Scrollable**: ListView with separator
- **Item Separator**: Thin divider line between notifications
- **Empty State**: Shows when no notifications exist
  - Bell icon (64px)
  - "No notifications yet" heading
  - Descriptive subtext

### 4. **Notification Item Design**

Each notification displays:
- **Actor Avatar** (48px circle) - cached network image
- **Message**: "[ActorName] [action]" format
  - Actor name in bold (600 weight)
  - Action text from NotificationType
- **Content Preview** (optional): 2-line max with ellipsis
- **Timestamp**: Relative format using `notification.timeAgo`
- **Unread Indicator**: Orange dot (8px) when `isRead == false`

### 5. **Unread/Read Styling**

**Unread notifications** (`isRead == false`):
- Light pink background: `AppColors.primaryPink` with 15% opacity
- Orange dot indicator on the right
- Visually distinct from read notifications

**Read notifications** (`isRead == true`):
- Transparent background
- No indicator dot
- Same text styling but less emphasis

### 6. **Interaction Behavior**

**On Tap**:
1. Notification is marked as read immediately
2. UI updates to remove highlight and indicator
3. Navigates using `notification.deepLink` (currently shows SnackBar)
4. State persists during session

### 7. **Timestamp Formatting**

Uses `NotificationModel.timeAgo` extension:
- **< 1 minute**: "Vừa xong"
- **< 60 minutes**: "X phút trước"
- **< 24 hours**: "X giờ trước"
- **Yesterday**: "Hôm qua" (implicitly 1 day)
- **< 7 days**: "X ngày trước"
- **> 7 days**: "DD/MM/YYYY" formatted date

## Design System

### Colors
- **Background**: `AppColors.backgroundLight`
- **Unread Highlight**: `AppColors.primaryPink` (15% alpha)
- **Read Background**: `Colors.transparent`
- **Text Primary**: `AppColors.textPrimary`
- **Text Secondary**: `AppColors.textHint`
- **Unread Dot**: `AppColors.accentOrange`
- **Divider**: `AppColors.textHint` (10% alpha)

### Typography
- **Screen Title**: `AppTextStyles.h2`
- **Actor Name**: `AppTextStyles.bodyMedium` (bold, 600 weight)
- **Action Text**: `AppTextStyles.bodyMedium`
- **Content Preview**: `AppTextStyles.bodySmall` (gray)
- **Timestamp**: `AppTextStyles.bodySmall` (11px, gray)

### Spacing
- **Item Padding**: Horizontal 16px, Vertical 16px
- **Avatar Size**: 48px diameter (24px radius)
- **Avatar Spacing**: 12px gap
- **Content Spacing**: 4px between elements

## File Structure

```
lib/features/community/
├── presentation/
│   ├── community_screen.dart          # Bell icon navigation
│   ├── notification_screen.dart       # Main screen
│   └── widgets/
│       ├── notification_item.dart     # List item widget
│       └── widgets.dart               # Barrel file
└── mockdata/
    └── notification_mock_data.dart    # Mock notifications
```

## Usage

### Navigation from Community Screen

```dart
// In community_screen.dart AppBar actions
IconButton(
  icon: const Icon(Icons.notifications),
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NotificationScreen(),
      ),
    );
  },
)
```

### Direct Navigation

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const NotificationScreen(),
  ),
);
```

## Models

### NotificationModel

Used from `lib/data/models/notification_model.dart`:

```dart
NotificationModel(
  notificationId: String,
  actorId: String,
  actorName: String,
  actorAvatar: String,
  type: NotificationType,
  createdAt: DateTime,
  isRead: bool,
  postId: String,
  commentId: String?,
  deepLink: String,
  contentPreview: String?,
)
```

### NotificationType Enum

Supported notification types:
- `react` - "đã thích bài viết của bạn"
- `comment` - "đã bình luận bài viết của bạn"
- `follow` - "đã theo dõi bạn"
- `mention` - "đã nhắc đến bạn"
- `share` - "đã chia sẻ bài viết của bạn"

## Mock Data

### Helper Methods

```dart
// Get all notifications
NotificationMockData.getAllNotifications()

// Get only unread
NotificationMockData.getUnreadNotifications()

// Get unread count (for badge)
NotificationMockData.getUnreadCount()

// Mark as read
NotificationMockData.markAsRead(notificationId)
```

### Current Mock Data

- **Total**: 13 notifications
- **Unread**: 4 notifications (recent ones)
- **Read**: 9 notifications (older ones)
- **Types**: All notification types represented
- **Time Range**: From 5 minutes ago to 10 days ago

## State Management

### Internal State
- `_notifications`: List<NotificationModel>
- Updates on screen init and after marking as read
- Re-fetches from mock data to get latest state

### Mark as Read Flow
1. User taps notification
2. `NotificationMockData.markAsRead()` called
3. State updated via `_loadNotifications()`
4. UI re-renders with updated styling
5. Navigation occurs (via deepLink)

## Deep Linking

### Supported DeepLink Patterns

```dart
'/community/post/:postId'              // Navigate to post detail
'/community/post/:postId/comment/:commentId'  // Navigate to comment
'/profile/:userId'                     // Navigate to user profile
```

### Implementation (TODO)

Currently shows SnackBar with deepLink. Real implementation would:
1. Parse deepLink string
2. Extract parameters (postId, commentId, userId)
3. Navigate to appropriate screen
4. Scroll to specific content if needed

## Performance Considerations

- **Cached Avatars**: Uses `CachedNetworkImageProvider`
- **ListView.separated**: Efficient scrolling with separators
- **setState Optimization**: Only updates when needed
- **Mock Data**: In-memory, instant access

## Accessibility

- Back button with clear tap target
- Readable text contrast ratios
- Semantic labels for icons
- Touch targets meet minimum size (48dp)

## Empty State

Displayed when `_notifications.isEmpty`:
- Center-aligned content
- Bell icon (outlined, 64px, gray with 50% opacity)
- "No notifications yet" headline
- Supporting text explaining functionality
- Friendly, non-alarming tone

## Integration with Community Tab

### Bell Icon Badge (Future Enhancement)
```dart
// Add badge showing unread count
Badge(
  label: Text('${NotificationMockData.getUnreadCount()}'),
  child: const Icon(Icons.notifications),
)
```

## Notification Types & Icons

Each type has associated color and meaning:
- **React** (Pink): Someone liked your content
- **Comment** (Blue): New comment on your post
- **Follow** (Green): New follower
- **Mention** (Orange): Tagged in content
- **Share** (Purple): Content shared

## Testing

### Mock Scenarios
1. **All Read**: Comment out unread notifications
2. **All Unread**: Set all `isRead: false`
3. **Empty State**: Use empty list `[]`
4. **Single Item**: Test with one notification
5. **Many Items**: Test scrolling with 50+ items

## Future Enhancements

- [ ] Real-time notifications via Firebase/WebSocket
- [ ] Pull-to-refresh gesture
- [ ] Swipe-to-delete actions
- [ ] Mark all as read button
- [ ] Filter by notification type
- [ ] Notification preferences/settings
- [ ] Push notification integration
- [ ] Unread count badge on bell icon
- [ ] Deep link navigation implementation
- [ ] Notification grouping by date
- [ ] Load more pagination
- [ ] Sound/vibration on new notification

## Known Limitations

- Mock data only (no backend)
- No real-time updates
- DeepLink navigation not implemented (shows SnackBar)
- No persistence after app restart
- No notification delete/clear functionality
- No search or filter options

## Dependencies

- `flutter` - Core framework
- `cached_network_image` - Avatar caching
- Uses existing models and design system
- No additional packages required

## Screenshot Behavior Match

Follows Instagram notification page:
- ✅ Full-screen navigation
- ✅ Back button in app bar
- ✅ Scrollable list
- ✅ Avatar + message + time
- ✅ Unread visual distinction
- ✅ Tap to mark as read
- ✅ Clean minimal design
- ✅ Content preview support
