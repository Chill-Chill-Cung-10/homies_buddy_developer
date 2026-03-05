# Lazy Loading Quick Reference
## Homies Buddy Developer

---

## 🗺️ Code Location Map

```
lib/
├── core/
│   ├── mixins/
│   │   └── pagination_mixin.dart          ⭐ NEW - Tái sử dụng cho pagination
│   └── widgets/
│       ├── loading_indicators.dart        ⭐ NEW - Loading states & indicators
│       └── optimized_image.dart           ⭐ NEW - Image optimization
│
├── features/
│   ├── community/
│   │   └── presentation/
│   │       ├── community_screen.dart                      🔴 P0 - CRITICAL
│   │       ├── community_screen_lazy_loading_example.dart ⭐ EXAMPLE
│   │       ├── screens/
│   │       │   └── personal_profile_screen.dart           🟡 P1 - HIGH
│   │       └── widgets/
│   │           ├── comment_overlay.dart                   🟢 P2 - MEDIUM
│   │           └── social_post_card.dart                  ⚠️ Update images
│   │
│   ├── chat/
│   │   └── presentation/
│   │       └── screens/
│   │           ├── chat_list_screen.dart      🔴 P0 - CRITICAL
│   │           └── chat_detail_screen.dart    🔴 P0 - CRITICAL
│   │
│   ├── notifications/
│   │   └── presentation/
│   │       └── screens/
│   │           └── notification_screen.dart   🟡 P1 - HIGH
│   │
│   ├── help/
│   │   └── presentation/
│   │       └── screens/
│   │           └── ask_for_help_screen.dart   🟡 P1 - HIGH
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── home_screen.dart           🟢 P2 - MEDIUM
│   │       └── widgets/
│   │           ├── background_animation_widget.dart 🟢 Optimize
│   │           ├── pet_animation_widget.dart        🟢 Optimize
│   │           └── user_moments_box/
│   │               └── user_moments_box.dart        🟢 Add pagination
│   │
│   └── navigation/
│       └── presentation/
│           └── main_navigation_screen.dart    🟢 P2 - OPTIONAL
│
└── data/
    └── repositories/
        ├── post_repository.dart        ✅ Đã có pagination support
        ├── comment_repository.dart     ✅ Đã có pagination support
        └── notification_repository.dart ✅ Đã có pagination support
```

---

## 🎯 Priority Matrix

### P0 - CRITICAL (Làm ngay - Week 1-2)
```
┌─────────────────────────────────────────────────────────┐
│ 🔴 COMMUNITY FEED                                       │
│    Current: Load all posts at once                     │
│    Target:  10 posts/page, infinite scroll             │
│    Impact:  ⭐⭐⭐⭐⭐ (Most used feature)                │
├─────────────────────────────────────────────────────────┤
│ 🔴 CHAT DETAIL                                          │
│    Current: Load all messages                          │
│    Target:  50 messages, load more on scroll           │
│    Impact:  ⭐⭐⭐⭐⭐ (Very laggy for long chats)      │
├─────────────────────────────────────────────────────────┤
│ 🔴 IMAGE OPTIMIZATION                                   │
│    Current: Full size images                           │
│    Target:  Progressive loading, thumbnails            │
│    Impact:  ⭐⭐⭐⭐⭐ (Bandwidth & memory)             │
└─────────────────────────────────────────────────────────┘
```

### P1 - HIGH (Làm sớm - Week 3-4)
```
┌─────────────────────────────────────────────────────────┐
│ 🟡 PERSONAL PROFILE                                     │
│    Current: All posts loaded                           │
│    Target:  Paginated posts                            │
│    Impact:  ⭐⭐⭐⭐ (Heavy users)                      │
├─────────────────────────────────────────────────────────┤
│ 🟡 NOTIFICATIONS                                        │
│    Current: All notifications                          │
│    Target:  20/page pagination                         │
│    Impact:  ⭐⭐⭐⭐ (Accumulates over time)           │
├─────────────────────────────────────────────────────────┤
│ 🟡 CHAT LIST                                            │
│    Current: All conversations                          │
│    Target:  Virtual scrolling                          │
│    Impact:  ⭐⭐⭐ (Users with many chats)             │
└─────────────────────────────────────────────────────────┘
```

### P2 - MEDIUM (Có thể làm sau - Week 5-6)
```
┌─────────────────────────────────────────────────────────┐
│ 🟢 HOME SCREEN                                          │
│    Current: All loaded immediately                     │
│    Target:  Lazy load animations & moments             │
│    Impact:  ⭐⭐⭐ (Nice to have)                       │
├─────────────────────────────────────────────────────────┤
│ 🟢 COMMENT OVERLAY                                      │
│    Current: All comments loaded                        │
│    Target:  20 comments, load more                     │
│    Impact:  ⭐⭐ (Only popular posts)                  │
└─────────────────────────────────────────────────────────┘
```

---

## 📊 Implementation Pattern

### Pattern 1: Simple List Pagination
```dart
class _MyScreenState extends State<MyScreen> 
    with PaginationMixin<Item, MyScreen> {
  
  @override
  Future<void> loadInitialItems() async {
    // Load first 10 items
  }
  
  @override
  Future<void> loadMoreItems() async {
    // Load next 10 items
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,  // From mixin
      itemCount: items.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          return BottomLoadingIndicator();
        }
        return YourItemWidget(items[index]);
      },
    );
  }
}
```

### Pattern 2: Optimized Images
```dart
// Before
CachedNetworkImage(
  imageUrl: post.imageUrl,
)

// After
OptimizedImage(
  imageUrl: post.imageUrl,
  thumbnailUrl: post.thumbnailUrl,
  memCacheWidth: 800,
)
```

### Pattern 3: Chat Message Pagination
```dart
class _ChatDetailState extends State<ChatDetail> {
  List<Message> _messages = [];
  bool _hasEarlier = true;
  
  void _onScroll() {
    if (_scrollController.position.pixels <= 100 && _hasEarlier) {
      _loadEarlierMessages();
    }
  }
  
  Future<void> _loadEarlierMessages() async {
    // Load 50 earlier messages
    // Maintain scroll position!
  }
}
```

---

## 🛠️ Common Code Snippets

### Snippet 1: Add PaginationMixin
```dart
// 1. Add mixin
class _MyScreenState extends State<MyScreen>
    with PaginationMixin<Post, MyScreen> {
  
  // 2. Configure
  @override
  int get itemsPerPage => 10;
  
  // 3. Implement loading
  @override
  Future<void> loadInitialItems() async {
    setState(() => isLoading = true);
    try {
      final data = await repository.fetch(page: 0, limit: itemsPerPage);
      setState(() {
        items.addAll(data);
        hasMore = data.length >= itemsPerPage;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }
  
  @override
  Future<void> loadMoreItems() async {
    // Similar to loadInitialItems
  }
}
```

### Snippet 2: Add Loading States
```dart
Widget _buildBody() {
  // Initial loading
  if (isLoading && items.isEmpty) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (_, __) => PostCardSkeleton(),
    );
  }
  
  // Empty state
  if (items.isEmpty) {
    return EmptyStateWidget(title: 'No items');
  }
  
  // List with items
  return ListView.builder(
    controller: scrollController,
    itemCount: items.length + (isLoading ? 1 : hasMore ? 0 : 1),
    itemBuilder: (context, index) {
      if (index >= items.length) {
        return isLoading 
          ? BottomLoadingIndicator()
          : EndOfListWidget();
      }
      return ItemWidget(items[index]);
    },
  );
}
```

### Snippet 3: Replace Images
```dart
// Find & Replace in files:

// Pattern 1: Simple CachedNetworkImage
CachedNetworkImage(
  imageUrl: url,
  fit: BoxFit.cover,
)

// Replace with:
OptimizedImage(
  imageUrl: url,
  memCacheWidth: 800,
)

// Pattern 2: Avatar
CachedNetworkImage(
  imageUrl: avatarUrl,
  imageBuilder: (context, provider) => CircleAvatar(...)
)

// Replace with:
OptimizedAvatar(
  imageUrl: avatarUrl,
  size: 40,
)
```

---

## 📈 Performance Targets

```
┌──────────────────────┬──────────┬──────────┬─────────────┐
│ Metric               │ Before   │ Target   │ Priority    │
├──────────────────────┼──────────┼──────────┼─────────────┤
│ Initial Load Time    │ 5-8s     │ < 2s     │ 🔴 Critical │
│ Memory Usage         │ 300-500MB│ < 200MB  │ 🔴 Critical │
│ Scroll FPS           │ 30-45fps │ 60fps    │ 🔴 Critical │
│ Network Data (Feed)  │ 20MB     │ < 12MB   │ 🟡 High     │
│ Battery Impact       │ High     │ Medium   │ 🟢 Medium   │
└──────────────────────┴──────────┴──────────┴─────────────┘
```

---

## 🧪 Testing Commands

```bash
# Run app in profile mode
flutter run --profile

# Launch DevTools
flutter pub global run devtools

# Measure performance
flutter drive --target=test_driver/perf_test.dart

# Memory profiling
flutter run --profile --trace-startup

# Network simulation (3G)
# Use Chrome DevTools > Network tab > Throttling

# Specific device test
flutter run -d <device-id> --profile
```

---

## 🐛 Debug Checklist

When something goes wrong:

```
□ Check console for errors
□ Verify scroll controller attached
□ Check hasMore flag
□ Verify item count calculation
□ Check for duplicate items
□ Verify scroll position maintained
□ Check memory leaks (dispose)
□ Test offline mode
□ Check error handling
□ Verify loading states
```

---

## 💡 Pro Tips

### Tip 1: Scroll Position
Khi load thêm items ở đầu list (chat messages), maintain scroll position:
```dart
final oldOffset = scrollController.offset;
final oldMaxExtent = scrollController.position.maxScrollExtent;
// Load items
final newMaxExtent = scrollController.position.maxScrollExtent;
scrollController.jumpTo(oldOffset + (newMaxExtent - oldMaxExtent));
```

### Tip 2: Preload Strategy
Preload images của 2-3 items tiếp theo:
```dart
void _preloadNextImages() {
  for (int i = currentIndex + 1; i < currentIndex + 3; i++) {
    if (i < items.length) {
      preloadImage(context, items[i].imageUrl);
    }
  }
}
```

### Tip 3: Debounce Search
Avoid filtering on every keystroke:
```dart
Timer? _debounce;

void _onSearchChanged(String query) {
  _debounce?.cancel();
  _debounce = Timer(Duration(milliseconds: 300), () {
    _performSearch(query);
  });
}
```

### Tip 4: Cache Strategy
```dart
// Cache recent data locally
SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setString('cached_posts', jsonEncode(posts));

// Load from cache first, then fetch fresh
final cached = prefs.getString('cached_posts');
if (cached != null) {
  setState(() => items = decode(cached));
}
fetchFreshData();
```

---

## 🔗 Essential Links

- **Full Plan**: [LAZY_LOADING_IMPLEMENTATION_PLAN.md](./LAZY_LOADING_IMPLEMENTATION_PLAN.md)
- **Vietnamese Summary**: [LAZY_LOADING_SUMMARY_VI.md](./LAZY_LOADING_SUMMARY_VI.md)
- **Checklist**: [LAZY_LOADING_CHECKLIST.md](./LAZY_LOADING_CHECKLIST.md)
- **Mixin Code**: [pagination_mixin.dart](./lib/core/mixins/pagination_mixin.dart)
- **Loading Widgets**: [loading_indicators.dart](./lib/core/widgets/loading_indicators.dart)
- **Optimized Images**: [optimized_image.dart](./lib/core/widgets/optimized_image.dart)
- **Example**: [community_screen_lazy_loading_example.dart](./lib/features/community/presentation/community_screen_lazy_loading_example.dart)

---

## 📞 Need Help?

- Review the example implementation
- Check Flutter DevTools performance tab
- Read Firebase pagination docs
- Ask team for code review

---

**Print this page for quick reference! 📄**
