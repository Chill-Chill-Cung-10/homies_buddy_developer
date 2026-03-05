import 'package:flutter/material.dart';

/// Mixin tái sử dụng cho pagination và infinite scroll
/// 
/// Cách dùng:
/// ```dart
/// class _MyScreenState extends State<MyScreen> 
///     with PaginationMixin<Post, MyScreen> {
///   
///   @override
///   Future<void> loadInitialItems() async {
///     // Load first page
///   }
///   
///   @override
///   Future<void> loadMoreItems() async {
///     // Load next page
///   }
/// }
/// ```
mixin PaginationMixin<T, S extends StatefulWidget> on State<S> {
  /// Danh sách items đã tải
  final List<T> items = [];
  
  /// Đang tải dữ liệu
  bool isLoading = false;
  
  /// Còn dữ liệu để tải
  bool hasMore = true;
  
  /// Trang hiện tại
  int currentPage = 0;
  
  /// Số items mỗi trang (override được)
  int get itemsPerPage => 10;
  
  /// Scroll controller để detect khi nào cần load more
  final ScrollController scrollController = ScrollController();
  
  /// Threshold để trigger load more (0.0 - 1.0)
  /// 0.8 = load khi scroll 80% của list
  double get loadMoreThreshold => 0.8;
  
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    loadInitialItems();
  }
  
  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
  
  /// Callback khi user scroll
  void _onScroll() {
    if (!scrollController.hasClients) return;
    
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    final threshold = maxScroll * loadMoreThreshold;
    
    // Trigger load more khi:
    // 1. Scroll qua threshold
    // 2. Không đang loading
    // 3. Còn data để tải
    if (currentScroll >= threshold && !isLoading && hasMore) {
      loadMoreItems();
    }
  }
  
  /// Load trang đầu tiên - implement trong widget
  Future<void> loadInitialItems();
  
  /// Load thêm items - implement trong widget
  Future<void> loadMoreItems();
  
  /// Refresh data - pull to refresh
  Future<void> refresh() async {
    setState(() {
      items.clear();
      currentPage = 0;
      hasMore = true;
      isLoading = false;
    });
    await loadInitialItems();
  }
  
  /// Xóa một item khỏi list
  void removeItem(T item) {
    setState(() {
      items.remove(item);
    });
  }
  
  /// Thêm một item vào đầu list (cho real-time updates)
  void prependItem(T item) {
    setState(() {
      items.insert(0, item);
    });
  }
  
  /// Update một item trong list
  void updateItem(T oldItem, T newItem) {
    setState(() {
      final index = items.indexOf(oldItem);
      if (index != -1) {
        items[index] = newItem;
      }
    });
  }
}

/// Example usage:
/// 
/// ```dart
/// class _CommunityScreenState extends State<CommunityScreen>
///     with PaginationMixin<Post, CommunityScreen> {
///   
///   final _postRepository = PostRepository();
///   
///   @override
///   int get itemsPerPage => 10;
///   
///   @override
///   Future<void> loadInitialItems() async {
///     setState(() => isLoading = true);
///     
///     try {
///       final posts = await _postRepository.getFeed(
///         page: 0,
///         limit: itemsPerPage,
///       );
///       
///       setState(() {
///         items.addAll(posts);
///         currentPage = 0;
///         hasMore = posts.length >= itemsPerPage;
///         isLoading = false;
///       });
///     } catch (e) {
///       setState(() => isLoading = false);
///       // Handle error
///     }
///   }
///   
///   @override
///   Future<void> loadMoreItems() async {
///     if (isLoading || !hasMore) return;
///     
///     setState(() => isLoading = true);
///     
///     try {
///       final nextPage = currentPage + 1;
///       final posts = await _postRepository.getFeed(
///         page: nextPage,
///         limit: itemsPerPage,
///       );
///       
///       setState(() {
///         items.addAll(posts);
///         currentPage = nextPage;
///         hasMore = posts.length >= itemsPerPage;
///         isLoading = false;
///       });
///     } catch (e) {
///       setState(() => isLoading = false);
///       // Handle error
///     }
///   }
///   
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: RefreshIndicator(
///         onRefresh: refresh,
///         child: ListView.builder(
///           controller: scrollController,
///           itemCount: items.length + (isLoading ? 1 : 0),
///           itemBuilder: (context, index) {
///             if (index >= items.length) {
///               return const BottomLoadingIndicator();
///             }
///             
///             final post = items[index];
///             return SocialPostCard(post: post);
///           },
///         ),
///       ),
///     );
///   }
/// }
/// ```
