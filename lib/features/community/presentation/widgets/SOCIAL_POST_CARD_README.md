# SocialPostCard Widget

## Overview
A reusable Flutter widget that displays a social media post card in the Community feed, similar to Instagram/Facebook post layouts.

## Features

### 1. **Header Section**
- Circular avatar (40x40) with cached image loading
- Author name (primary text, bold)
- Time ago display (smaller, secondary text)
- Three-dot menu button for post options

### 2. **Content Section**
- Text content with proper spacing
- Supports hashtags and mentions
- Adaptive height based on content

### 3. **Media Section**
- Single image display with aspect ratio preservation
- Carousel for multiple images/videos
- Video thumbnail with play button overlay
- Video duration badge
- Carousel indicators (dots)
- Rounded corners matching app design system

### 4. **Footer Section**
- **Heart/Like Button**: Animated toggle between heart_reactions_off/on
  - Scale animation on tap
  - Count display using Norican font
- **Comment Button**: Shows comment icon + count (Norican font)
- **Privacy Indicator**: Shows post privacy (public/friends/private)

## Design System

### Colors
- **Container Background**: `AppColors.backgroundPost` (white)
- **Text Primary**: `AppColors.textPrimary`
- **Text Secondary**: `AppColors.textHint`
- **Icons**: `AppColors.iconColor`
- **Accent**: `AppColors.accentOrange`

### Shapes
- **Border Radius**: `AppShapes.card` (30px)
- **Padding**: `AppShapes.paddingM` (16px)

### Typography
- **Author Name**: `AppTextStyles.bodyLarge` (bold)
- **Time**: `AppTextStyles.bodySmall`
- **Content**: `AppTextStyles.bodyMedium`
- **Counts**: Norican font (16px)

## Usage

```dart
SocialPostCard(
  post: post,
  onLike: () {
    // Handle like action
  },
  onComment: () {
    // Navigate to comments
  },
  onAvatarTap: () {
    // Navigate to profile
  },
  onPostTap: () {
    // Navigate to post detail
  },
)
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `post` | `Post` | Yes | The post model containing all data |
| `onLike` | `VoidCallback?` | No | Callback when like button is tapped |
| `onComment` | `VoidCallback?` | No | Callback when comment button is tapped |
| `onAvatarTap` | `VoidCallback?` | No | Callback when avatar is tapped |
| `onPostTap` | `VoidCallback?` | No | Callback when post is tapped |

## Dependencies

- `flutter_svg` - For SVG icon rendering
- `cached_network_image` - For efficient image caching
- `carousel_slider` - For media carousel
- Norican font - For count displays

## Animations

### Heart Animation
- Duration: 300ms
- Scale: 1.0 → 1.3 → 1.0
- Curve: easeInOut
- Triggered on like/unlike

## Media Handling

### Supported Types
- **Image**: Full display with aspect ratio
- **Video**: Thumbnail + play button + duration
- **Album**: Carousel with indicators

### Aspect Ratios
- Preserves original media aspect ratio
- Common ratios: 16:9, 9:16, 4:3, 1:1

## State Management

- Uses `StatefulWidget` for internal animation state
- Parent handles data mutations via callbacks
- Supports reactive updates via `Post.copyWith()`

## Files Structure

```
lib/features/community/
├── presentation/
│   ├── community_screen.dart          # Main feed screen
│   └── widgets/
│       ├── social_post_card.dart      # Post card widget
│       └── widgets.dart               # Barrel file
├── mockdata/
│   └── community_mock_data.dart       # Mock posts for testing
└── data/
    └── models.dart                     # Data models
```

## Integration

The `SocialPostCard` is integrated into `CommunityScreen` with:
- RefreshIndicator for pull-to-refresh
- ListView.builder for efficient rendering
- Mock data for testing
- FAB for creating new posts

## Future Enhancements

- [ ] Video player integration
- [ ] Image zoom/preview
- [ ] Long-press context menu
- [ ] Reactions (beyond like)
- [ ] Nested comments
- [ ] Share functionality
- [ ] Bookmark/Save post
- [ ] Report/Block options
