# Loading Widgets Documentation

Tài liệu hướng dẫn sử dụng các loading widgets trong Homies Buddy app.

## 📦 Các Widget Có Sẵn

### 1. **ShimmerLoading** - Lazy Loading
Widget tạo hiệu ứng shimmer (ánh sáng di chuyển) cho placeholder khi đang tải content.

**Sử dụng:**
```dart
import 'package:homies_buddy_developer/core/widgets/widgets.dart';

ShimmerLoading(
  isLoading: _isLoading,
  child: ShimmerCard(height: 200),
)
```

**Các widget placeholder có sẵn:**
- `ShimmerBox` - Box placeholder đơn giản
- `ShimmerListItem` - Item placeholder cho danh sách
- `ShimmerCard` - Card placeholder

### 2. **LoadingScreen** - Full Screen Loading
Loading screen toàn màn hình cho app initialization hoặc transitions lớn.

**Sử dụng:**
```dart
LoadingScreen(
  message: 'Đang tải dữ liệu...\nVui lòng đợi trong giây lát',
  showLogo: true,
)
```

**Properties:**
- `message`: Text hiển thị dưới loading indicator
- `showLogo`: Hiển thị logo app (default: true)
- `logo`: Custom logo widget
- `backgroundColor`: Màu nền

### 3. **LoadingIndicator** - Các Loại Loading Indicators
Collection của nhiều loại loading indicators với animations khác nhau.

**Types:**
- `LoadingIndicatorType.circular` - Circular progress (default)
- `LoadingIndicatorType.linear` - Linear progress bar
- `LoadingIndicatorType.dots` - Animated dots
- `LoadingIndicatorType.bouncingBalls` - Bouncing balls animation
- `LoadingIndicatorType.rotatingSquares` - Rotating squares

**Sử dụng:**
```dart
LoadingIndicator(
  type: LoadingIndicatorType.dots,
  color: AppColors.primaryGreen,
  size: 40,
  message: 'Đang xử lý...',
)
```

### 4. **LoadingOverlay** - Overlay Loading
Overlay che phủ toàn bộ UI khi đang xử lý.

**Sử dụng:**
```dart
LoadingOverlay(
  isLoading: _isProcessing,
  loadingText: 'Đang xử lý yêu cầu...',
  child: YourContentWidget(),
)
```

### 5. **LoadingButton** - Button với Loading State
Button tự động hiển thị loading indicator khi đang xử lý.

**Sử dụng:**
```dart
LoadingButton(
  label: 'Submit',
  isLoading: _isSubmitting,
  onPressed: _handleSubmit,
  backgroundColor: AppColors.primaryGreen,
)
```

### 6. **SkeletonLoadingScreen** - Skeleton Screen
Full screen skeleton loading cho lazy loading content pages.

**Sử dụng:**
```dart
SkeletonLoadingScreen(
  itemCount: 5,
  itemBuilder: (context, index) {
    return CustomSkeletonItem();
  },
)
```

## 🎯 Use Cases & Best Practices

### Use Case 1: Initial Data Load
```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool _isLoading = true;
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    // Fetch data
    final items = await fetchItems();
    
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show shimmer loading
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ShimmerLoading(
            isLoading: true,
            child: ShimmerCard(),
          );
        },
      );
    }

    // Show actual data
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return ItemCard(item: _items[index]);
      },
    );
  }
}
```

### Use Case 2: Pull to Refresh
```dart
class _MyScreenState extends State<MyScreen> {
  bool _isRefreshing = false;
  
  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);
    
    await fetchData();
    
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isRefreshing,
      loadingText: 'Đang làm mới...',
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(...),
      ),
    );
  }
}
```

### Use Case 3: Load More (Pagination)
```dart
class _MyScreenState extends State<MyScreen> {
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  
  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMoreData) return;
    
    setState(() => _isLoadingMore = true);
    
    final newItems = await fetchMoreItems();
    
    setState(() {
      _items.addAll(newItems);
      _isLoadingMore = false;
      _hasMoreData = newItems.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >= 
            scrollInfo.metrics.maxScrollExtent - 200) {
          _loadMore();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: _items.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return Center(
              child: _isLoadingMore
                ? LoadingIndicator(
                    type: LoadingIndicatorType.dots,
                  )
                : SizedBox.shrink(),
            );
          }
          return ItemCard(item: _items[index]);
        },
      ),
    );
  }
}
```

### Use Case 4: Form Submission
```dart
class _FormScreenState extends State<FormScreen> {
  bool _isSubmitting = false;
  
  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    
    try {
      await submitForm();
      // Show success message
    } catch (e) {
      // Show error message
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Form fields...
        
        LoadingButton(
          label: 'Submit',
          isLoading: _isSubmitting,
          onPressed: _handleSubmit,
        ),
      ],
    );
  }
}
```

## 🎨 Customization

### Custom Shimmer Colors
```dart
ShimmerLoading(
  isLoading: true,
  baseColor: AppColors.cardBackground,
  highlightColor: AppColors.backgroundLight,
  child: YourWidget(),
)
```

### Custom Loading Indicator Size & Color
```dart
LoadingIndicator(
  type: LoadingIndicatorType.bouncingBalls,
  color: AppColors.accentOrange,
  size: 50,
)
```

### Custom Loading Screen with Logo
```dart
LoadingScreen(
  message: 'Initializing app...',
  logo: Image.asset('assets/images/logo.png'),
  backgroundColor: AppColors.primaryPeach,
)
```

## 🚀 Demo Screens

Xem các demo screens để hiểu rõ hơn về cách sử dụng:

1. **LoadingDemoScreen** - Demo tất cả các loading widgets
   - File: `example/loading_demo_screen.dart`
   - Hiển thị tất cả types của loading indicators
   - Interactive demo với switches và buttons

2. **DataFetchingDemoScreen** - Demo thực tế với data fetching
   - File: `example/data_fetching_demo_screen.dart`
   - Initial loading với shimmer
   - Pull-to-refresh với overlay
   - Load more pagination
   - Empty state & error handling

## 📱 Running Demos

Để chạy demo screens, add route vào navigation:

```dart
// In your main.dart or router
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => LoadingDemoScreen(),
  ),
);
```

Hoặc:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DataFetchingDemoScreen(),
  ),
);
```

## 🎯 Tips & Best Practices

1. **Shimmer cho Initial Load**: Sử dụng shimmer loading cho lần đầu load data để UX tốt hơn.

2. **Overlay cho Actions**: Dùng LoadingOverlay khi user thực hiện action (submit form, delete, etc.)

3. **Indicator tại Bottom**: Load more pagination nên dùng small indicator ở cuối list.

4. **Consistent Colors**: Sử dụng colors từ AppColors để đồng nhất với design system.

5. **Loading Messages**: Luôn cung cấp message rõ ràng cho user biết đang xử lý gì.

6. **Timeout**: Consider adding timeout cho long-running operations.

7. **Error Handling**: Luôn handle errors và show EmptyStateWidget với retry button.

## 📚 Related Files

- `lib/core/widgets/feedback/shimmer_loading.dart`
- `lib/core/widgets/feedback/loading_screen.dart`
- `lib/core/widgets/feedback/loading_indicator.dart`
- `lib/core/widgets/feedback/loading_overlay.dart`
- `lib/core/widgets/feedback/empty_state_widget.dart`
- `example/loading_demo_screen.dart`
- `example/data_fetching_demo_screen.dart`

---

Created: March 4, 2026
Updated: March 4, 2026
