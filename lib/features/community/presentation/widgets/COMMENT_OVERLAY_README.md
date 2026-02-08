# CommentOverlay Widget

## Overview
An Instagram-style comment overlay widget that displays as a modal bottom sheet, showing post preview, comment input, filter options, and a scrollable list of comments.

## Features

### 1. **Modal Bottom Sheet**
- Covers 90% of screen height
- Semi-transparent dark background
- Rounded top corners (30px radius)
- Drag handle at top for dismissal
- Background feed remains visible but dimmed
- Tap outside to dismiss

### 2. **Post Preview Section**
- **Reuses `SocialPostCard` widget for consistency**
- Full post display with all features:
  - Header with avatar, author name, time, privacy icon, and menu button
  - Post text content with hashtags and mentions
  - Full media support:
    - Single images with aspect ratio preservation
    - **Album carousel** with swipeable images and indicators
    - **Video thumbnails** with play button and duration badge
  - Like and comment count row with icons
- All carousel and video interactions work as expected
- Interactions (like, comment, avatar tap) disabled in overlay to avoid conflicts
- Maintains exact same styling as feed cards

### 3. **Comment Input Section**
- Text input field with rounded background
- Placeholder: "Your Comment..."
- Material 3 send icon button (orange accent)
- Keyboard-aware (pushes input upward)
- Submit on enter/return key
- Auto-unfocus after sending

### 4. **Filter Dropdown**
- Sort comments by:
  - **Latest comments** (newest first)
  - **Most reacted** (highest react count)
  - **Oldest comments** (oldest first)
- Dropdown button with border styling
- Automatically re-sorts list on selection

### 5. **Comments List**
- Scrollable list of all comments
- Each comment shows:
  - Commenter avatar (36x36)
  - Commenter name (bold)
  - Comment text in rounded bubble
  - Heart react button (toggleable)
  - React count ("Thích [count]")
  - Time ago display
- Empty state with icon and message
- Smooth scrolling with post preview

### 6. **Comment Item Design**
- Horizontal layout: Avatar + Content bubble
- Rounded bubble background (surfaceColor)
- Comment meta row below bubble:
  - Heart icon (filled/unfilled based on state)
  - "Thích [count]" text (red when reacted)
  - Time ago text (gray)
- Tap heart to toggle react

## Design System

### Colors
- **Background**: `AppColors.backgroundPost` (white)
- **Surface (bubbles)**: `AppColors.surfaceColor`
- **Text Primary**: `AppColors.textPrimary`
- **Text Hint**: `AppColors.textHint`
- **Accent**: `AppColors.accentOrange`
- **React Active**: `AppColors.errorRed`

### Shapes
- **Sheet Border Radius**: 30px (top only)
- **Bubble Border Radius**: 18px
- **Input Border Radius**: 18px
- **Padding**: 16px (standard)

### Typography
- **Author Name**: `AppTextStyles.bodyLarge` (600 weight)
- **Time**: `AppTextStyles.bodySmall` (gray)
- **Comment Text**: `AppTextStyles.bodyMedium`
- **Meta Text**: `AppTextStyles.bodySmall`

## Usage

```dart
// Method 1: Using helper function
showCommentOverlay(context, post);

// Method 2: Manual showModalBottomSheet
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => CommentOverlay(post: post),
);
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `post` | `Post` | Yes | The post model containing all data |

## Integration with SocialPostCard

The overlay now **reuses the `SocialPostCard` widget** for the post preview section, ensuring:
- **Visual consistency** with feed cards
- **Full media support** including carousels and video thumbnails
- **Reduced code duplication** and easier maintenance
- **Same styling** and design system adherence

```dart
// In CommentOverlay widget
Widget _buildPostPreview() {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppShapes.paddingM, 
      vertical: AppShapes.paddingS
    ),
    child: SocialPostCard(
      post: widget.post,
      // Disable interactions to avoid conflicts
      onLike: null,
      onComment: null,
      onAvatarTap: null,
      onPostTap: null,
    ),
  );
}
```

### Post Interactions in Overlay
- Like/comment interactions are **disabled** in the post preview
- Users interact with the post through dedicated comment input section
- Prevents conflict between post card actions and overlay navigation

## State Management

### Internal State
- `_commentController`: TextEditingController for input
- `_commentFocusNode`: FocusNode for keyboard management
- `_comments`: List of Comment objects (sorted)
- `_selectedSortOption`: Current sort filter

### Comment Reactions
- Tapping heart toggles `isReactedByMe` state
- Updates `reactCount` accordingly (+1 or -1)
- Visual feedback with color change

## Mock Data

Comments are loaded from `CommentMockData.getCommentsForPost(postId)`:

```dart
CommentMockData.getCommentsForPost('1'); // Returns comments for post ID '1'
```

Comments are automatically sorted using `CommentMockData.sortComments()`.

## Interactions

### Scrolling
- Post preview + comments scroll together as single scrollable content
- Uses `SingleChildScrollView` with `ListView.builder` (shrinkWrap)
- Background feed does NOT scroll when overlay is open

### Keyboard Handling
- Keyboard pushes comment input upward automatically
- Input field stays visible above keyboard
- Submit sends comment and dismisses keyboard

### Comment Sending
- Validates input is not empty
- Shows SnackBar confirmation
- Clears input field
- Unfocuses keyboard

### Comment Reacting
- Tap heart icon or "Thích" text to react
- Immediate visual feedback (color change)
- Count updates in real-time
- State persists during session

## Empty State

When no comments exist:
- Shows comment icon (48px, gray)
- "No comments yet" heading
- "Be the first to comment!" subtext
- Centered vertically with padding (comment reactions)
- `cached_network_image` - For efficient avatar caching
- **`SocialPostCard`** - Reused for post preview display
- Norican font - For count displays

```
lib/features/community/
├── presentation/
│   ├── community_screen.dart          # Calls showCommentOverlay
│   └── widgets/
│       ├── social_post_card.dart      # Triggers overlay on comment tap
│       ├── comment_overlay.dart       # Comment overlay widget
│       └── widgets.dart               # Barrel file
├── mockdata/
│   ├── community_mock_data.dart       # Mock posts
│   └── comment_mock_data.dart         # Mock comments
└── data/
    └── models.dart                     # Data models
```

## Dependencies

- `flutter_svg` - For SVG icon rendering
- `cached_network_image` - For efficient avatar/image caching
- Norican font - For count displays (inherited from post)

## Comment Model

The overlay uses the existing `Comment` model from `lib/data/models/comment_model.dart`:

```dart
Comment(
  commentId: String,
  postId: String,
  authorId: String,
  authorName: String,
  authorAvatar: String,
  contentText: String,
  createdAt: DateTime,
  updatedAt: DateTime?,
  reactCount: int,
  isReactedByMe: bool,
)
```

## Sort Options Enum

```dart
enum CommentSortOption {
  latest('Latest comments'),
  mostReacted('Most reacted'),
  oldest('Oldest comments');
}
```

## Animations

- Modal bottom sheet slide-up animation (built-in)
- Smooth scrolling transitions
- No custom animations beyond defaults

## Accessibility

- Proper semantic labels for icons
- Keyboard navigation support
- Tap targets meet minimum size requirements
- Contrast ratios meet WCAG standards

## Future Enhancements

- [ ] Reply to comments (nested comments)
- [ ] Edit/delete own comments
- [ ] Long-press context menu
- [ ] Mention suggestions (@username)
- [ ] Media in comments (images/GIFs)
- [ ] Load more pagination
- [ ] Real-time updates (WebSocket)
- [ ] Report/block functionality
- [ ] Pin comments
- [ ] Comment reactions (beyond like)

## Performance Considerations
**Reuses `SocialPostCard` widget** instead of duplicating code
- Uses `shrinkWrap: true` for nested ListView (acceptable for limited items)
- `NeverScrollableScrollPhysics` prevents scroll conflict
- Cached network images reduce load time
- Efficient state updates with `setState`
- Carousel and video components handled by `SocialPostCard
- Efficient state updates with `setState`

## Known Limitations

- Mock data only (no backend integration)
- No pagination (loads all comments at once)
- No real-time updates
- No nested replies
- Comments don't persist after closing overlay
