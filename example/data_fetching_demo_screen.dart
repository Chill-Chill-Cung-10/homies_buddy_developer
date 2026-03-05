import 'dart:async';
import 'package:flutter/material.dart';
import 'package:homies_buddy_developer/core/constants/app_colors.dart';
import 'package:homies_buddy_developer/core/constants/app_text_styles.dart';
import 'package:homies_buddy_developer/core/constants/app_spacing.dart';
import 'package:homies_buddy_developer/core/widgets/feedback/shimmer_loading.dart';
import 'package:homies_buddy_developer/core/widgets/feedback/loading_overlay.dart';
import 'package:homies_buddy_developer/core/widgets/feedback/loading_indicator.dart';
import 'package:homies_buddy_developer/core/widgets/feedback/empty_state_widget.dart';

/// [Demo] — Practical Data Fetching Example
/// 
/// Demonstrates realistic usage of loading states when fetching data:
/// - Initial loading (shimmer)
/// - Refresh loading (overlay)
/// - Load more loading (indicator at bottom)
/// - Empty state
/// - Error state with retry

class DataFetchingDemoScreen extends StatefulWidget {
  const DataFetchingDemoScreen({super.key});

  @override
  State<DataFetchingDemoScreen> createState() => _DataFetchingDemoScreenState();
}

class _DataFetchingDemoScreenState extends State<DataFetchingDemoScreen> {
  bool _isInitialLoading = true;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  bool _hasError = false;
  List<String> _items = [];
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isInitialLoading = true;
      _hasError = false;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _items = List.generate(10, (i) => 'Item ${i + 1}');
        _isInitialLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _isRefreshing = true;
      _hasError = false;
    });

    // Simulate refresh API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _items = List.generate(10, (i) => 'Refreshed Item ${i + 1}');
        _isRefreshing = false;
        _hasMoreData = true;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() => _isLoadingMore = true);

    // Simulate load more API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        final currentLength = _items.length;
        _items.addAll(
          List.generate(5, (i) => 'Item ${currentLength + i + 1}'),
        );
        _isLoadingMore = false;
        
        // Simulate no more data after 20 items
        if (_items.length >= 20) {
          _hasMoreData = false;
        }
      });
    }
  }

  void _simulateError() {
    setState(() {
      _hasError = true;
      _isInitialLoading = false;
      _items = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: Text(
          'Data Fetching Demo',
          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.error_outline),
            onPressed: _simulateError,
            tooltip: 'Simulate Error',
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isRefreshing,
        loadingText: 'Đang làm mới dữ liệu...',
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // Initial loading state with shimmer
    if (_isInitialLoading) {
      return ListView.builder(
        itemCount: 5,
        padding: const EdgeInsets.all(AppSpacing.m),
        itemBuilder: (context, index) {
          return ShimmerLoading(
            isLoading: true,
            child: const ShimmerCard(height: 120),
          );
        },
      );
    }

    // Error state
    if (_hasError) {
      return EmptyStateWidget(
        icon: Icons.error_outline,
        title: 'Có lỗi xảy ra',
        message: 'Không thể tải dữ liệu. Vui lòng thử lại.',
        actionLabel: 'Thử lại',
        onAction: _loadInitialData,
      );
    }

    // Empty state
    if (_items.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.inbox_outlined,
        title: 'Chưa có dữ liệu',
        message: 'Danh sách hiện tại đang trống.',
        actionLabel: 'Tải lại',
        onAction: _loadInitialData,
      );
    }

    // Data loaded - show list with pull-to-refresh and load more
    return RefreshIndicator(
      onRefresh: _refresh,
      color: AppColors.primaryGreen,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200 &&
              !_isLoadingMore &&
              _hasMoreData) {
            _loadMore();
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.m),
          itemCount: _items.length + (_hasMoreData ? 1 : 0),
          itemBuilder: (context, index) {
            // Load more indicator at bottom
            if (index == _items.length) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Center(
                  child: _isLoadingMore
                      ? const LoadingIndicator(
                          type: LoadingIndicatorType.dots,
                          size: 40,
                        )
                      : const SizedBox.shrink(),
                ),
              );
            }

            // Regular item
            return _buildListItem(_items[index], index);
          },
        ),
      ),
    );
  }

  Widget _buildListItem(String item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.backgroundPost,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _getColorForIndex(index),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'This is a sample description for $item',
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${index + 1} phút trước',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Action button
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: AppColors.textSecondary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      AppColors.primaryGreen,
      AppColors.accentOrange,
      AppColors.primaryPink,
      AppColors.pastelBlue,
      AppColors.pastelYellow,
    ];
    return colors[index % colors.length];
  }
}
