# Mock Data Synchronization

## Overview
Hệ thống tự động đồng bộ số lượng comments giữa `Post.commentCount` và comments thực tế trong `CommentMockData`.

## Cách hoạt động

### 1. Auto-Sync Comment Count

```dart
class CommunityMockData {
  /// Getter tự động tính toán commentCount từ CommentMockData
  static List<Post> get mockPosts => _mockPosts.map((post) {
    return post.copyWith(
      commentCount: CommentMockData.getCommentCountForPost(post.postId),
    );
  }).toList();
}
```

### 2. Helper Method

```dart
class CommentMockData {
  /// Đếm số lượng comments thực tế cho một post
  static int getCommentCountForPost(String postId) {
    return _allComments.where((c) => c.postId == postId).length;
  }
}
```

## Lợi ích

✅ **Tự động đồng bộ**: Không cần update thủ công `commentCount`  
✅ **Single source of truth**: Comments trong `CommentMockData` là nguồn chính xác duy nhất  
✅ **Dễ bảo trì**: Thêm/xóa comments tự động cập nhật count  
✅ **Tránh lỗi**: Không còn tình trạng count không khớp với dữ liệu thực

## Số liệu hiện tại

| Post ID | Author | Comment Count | Comments |
|---------|--------|---------------|----------|
| 1 | Salahhh Home | 4 | c1_1, c1_2, c1_3, c1_4 |
| 2 | Buddy the Golden | 3 | c2_1, c2_2, c2_3 |
| 3 | Luna & Max | 4 | c3_1, c3_2, c3_3, c3_4 |
| 4 | Charlie the Corgi | 0 | - |
| 5 | Milo the Cat | 0 | - |

## Cách thêm comments mới

### Bước 1: Thêm comment vào CommentMockData

```dart
Comment(
  commentId: 'c4_1',
  postId: '4', // Post ID tương ứng
  authorId: 'user11',
  authorName: 'New User',
  authorAvatar: 'https://picsum.photos/150/150?random=111',
  contentText: 'This is a new comment!',
  createdAt: DateTime.now(),
  reactCount: 0,
  isReactedByMe: false,
),
```

### Bước 2: Không cần làm gì thêm! 🎉

Comment count sẽ **tự động cập nhật** khi app chạy.

## Testing

```dart
// Kiểm tra sync
final posts = CommunityMockData.mockPosts;
final post1 = posts.firstWhere((p) => p.postId == '1');
final actualComments = CommentMockData.getCommentsForPost('1');

print(post1.commentCount); // 4
print(actualComments.length); // 4
// ✅ Luôn khớp nhau!
```

## Notes

- `commentCount` trong `_mockPosts` chỉ là placeholder (để dễ đọc code)
- Giá trị thực tế được tính toán runtime từ `CommentMockData`
- Mỗi lần gọi `CommunityMockData.mockPosts` sẽ tính toán lại count
- Performance tốt vì chỉ filter array nhỏ (mock data)

## Future: Real Backend

Khi tích hợp backend thực:
1. API trả về post với `commentCount` từ database
2. API riêng để fetch comments theo `postId`
3. Cơ chế này vẫn áp dụng tương tự cho local caching
