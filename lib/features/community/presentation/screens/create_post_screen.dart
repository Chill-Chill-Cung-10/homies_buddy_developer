/// Create Post Screen — Screen for creating new community posts
///
/// Features:
/// - Text content input with hashtag and mention support
/// - Media upload (images/videos)
/// - Privacy selector
/// - Post button
library;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/system_notification_popup.dart';
import '../../../../data/models/post_model.dart';
import '../../../../data/models/media_file_model.dart';
import '../../../../data/models/enums/post_privacy.dart';
import '../../../../data/models/enums/media_type.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

/// Create Post Screen
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _contentController = TextEditingController();
  final _contentFocusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  final StorageService _storageService = StorageService();
  
  // State
  bool _isLoading = false;
  PostPrivacy _selectedPrivacy = PostPrivacy.public;
  final List<XFile> _selectedMedia = [];
  
  // Limits
  static const int maxContentLength = 5000;
  static const int maxMediaFiles = 10;

  @override
  void initState() {
    super.initState();
    // Auto-focus on content field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _contentFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  // ─── Media Picking ───

  Future<void> _pickImages() async {
    if (_selectedMedia.length >= maxMediaFiles) {
      SystemNotificationPopup.warning(
        context,
        message: 'Maximum $maxMediaFiles media files allowed',
      );
      return;
    }

    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (images.isNotEmpty) {
        final remaining = maxMediaFiles - _selectedMedia.length;
        final toAdd = images.take(remaining).toList();
        
        setState(() {
          _selectedMedia.addAll(toAdd);
        });

        if (images.length > remaining) {
          if (mounted) {
            SystemNotificationPopup.warning(
              context,
              message: 'Only added $remaining images. Maximum is $maxMediaFiles',
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        SystemNotificationPopup.error(context, message: 'Failed to pick images: $e');
      }
    }
  }

  Future<void> _pickVideo() async {
    if (_selectedMedia.length >= maxMediaFiles) {
      SystemNotificationPopup.warning(
        context,
        message: 'Maximum $maxMediaFiles media files allowed',
      );
      return;
    }

    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null) {
        setState(() {
          _selectedMedia.add(video);
        });
      }
    } catch (e) {
      if (mounted) {
        SystemNotificationPopup.error(context, message: 'Failed to pick video: $e');
      }
    }
  }

  Future<void> _takePhoto() async {
    if (_selectedMedia.length >= maxMediaFiles) {
      SystemNotificationPopup.warning(
        context,
        message: 'Maximum $maxMediaFiles media files allowed',
      );
      return;
    }

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (photo != null) {
        setState(() {
          _selectedMedia.add(photo);
        });
      }
    } catch (e) {
      if (mounted) {
        SystemNotificationPopup.error(context, message: 'Failed to take photo: $e');
      }
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _selectedMedia.removeAt(index);
    });
  }

  // ─── Content Parsing ───

  List<String> _extractHashtags(String text) {
    final regex = RegExp(r'#(\w+)');
    return regex.allMatches(text).map((match) => match.group(1)!).toList();
  }

  List<String> _extractMentions(String text) {
    final regex = RegExp(r'@(\w+)');
    return regex.allMatches(text).map((match) => match.group(1)!).toList();
  }

  // ─── Validation ───

  bool get _canPost {
    final hasContent = _contentController.text.trim().isNotEmpty;
    final hasMedia = _selectedMedia.isNotEmpty;
    return (hasContent || hasMedia) && !_isLoading;
  }

  String? _validatePost() {
    final content = _contentController.text.trim();
    
    if (content.isEmpty && _selectedMedia.isEmpty) {
      return 'Please add some content or media';
    }
    
    if (content.length > maxContentLength) {
      return 'Content is too long. Maximum is $maxContentLength characters';
    }
    
    if (_selectedMedia.length > maxMediaFiles) {
      return 'Too many media files. Maximum is $maxMediaFiles';
    }
    
    return null;
  }

  // ─── Post Creation ───

  Future<void> _handleCreatePost() async {
    final error = _validatePost();
    if (error != null) {
      SystemNotificationPopup.error(context, message: error);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final profileState = ref.read(profileStateProvider);
      final user = profileState.user;
      
      if (user == null) {
        throw Exception('User not found');
      }

      final postId = const Uuid().v4();
      final content = _contentController.text.trim();
      final hashtags = _extractHashtags(content);
      final mentions = _extractMentions(content);

      // Upload media files
      List<MediaFile> mediaFiles = [];
      if (_selectedMedia.isNotEmpty) {
        final uploadResults = await _storageService.uploadPostMedia(
          postId,
          _selectedMedia,
        );

        for (int i = 0; i < uploadResults.length; i++) {
          final result = uploadResults[i];
          final file = _selectedMedia[i];
          final isVideo = _isVideoFile(file.path);
          
          mediaFiles.add(MediaFile(
            id: const Uuid().v4(),
            postId: postId,
            mediaUrl: result.mediaUrl,
            thumbnailUrl: result.thumbnailUrl,
            mediaType: isVideo ? MediaType.video : MediaType.image,
            mediaAspectRatio: 1.0, // Will be calculated on server
            width: 0, // Will be calculated on server
            height: 0, // Will be calculated on server
            durationSeconds: isVideo ? 0 : null,
          ));
        }
      }

      // Create post object
      final post = Post(
        postId: postId,
        authorId: user.id,
        authorName: user.fullName,
        authorAvatar: user.avatarUrl,
        contentText: content,
        hashtags: hashtags,
        mentions: mentions,
        mediaFiles: mediaFiles,
        reactsCount: 0,
        commentCount: 0,
        privacy: _selectedPrivacy,
        createdAt: DateTime.now(),
      );

      // TODO: Save post to database (Supabase/Firebase)
      // For now, just simulate success
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        SystemNotificationPopup.success(
          context,
          message: 'Post created successfully!',
        );
        Navigator.of(context).pop(post);
      }
    } catch (e) {
      if (mounted) {
        SystemNotificationPopup.error(
          context,
          message: 'Failed to create post: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _isVideoFile(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.mp4') || 
           ext.endsWith('.mov') || 
           ext.endsWith('.avi') ||
           ext.endsWith('.mkv');
  }

  // ─── Privacy Selection ───

  void _showPrivacyPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppShapes.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Who can see this post?', style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.l),
              
              // Public option
              _buildPrivacyOption(
                icon: Icons.public,
                title: 'Public',
                subtitle: 'Everyone can see this post',
                privacy: PostPrivacy.public,
              ),
              
              const SizedBox(height: AppSpacing.m),
              
              // Friends option
              _buildPrivacyOption(
                icon: Icons.people,
                title: 'Friends',
                subtitle: 'Only your friends can see this post',
                privacy: PostPrivacy.friends,
              ),
              
              const SizedBox(height: AppSpacing.m),
              
              // Private option
              _buildPrivacyOption(
                icon: Icons.lock,
                title: 'Only me',
                subtitle: 'Only you can see this post',
                privacy: PostPrivacy.private,
              ),
              
              const SizedBox(height: AppSpacing.m),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required PostPrivacy privacy,
  }) {
    final isSelected = _selectedPrivacy == privacy;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPrivacy = privacy;
        });
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppShapes.paddingM),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryGreen.withOpacity(0.1) 
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.textHint,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryGreen),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileStateProvider);
    final user = profileState.user;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Create Post', style: AppTextStyles.h3),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppShapes.paddingM),
            child: TextButton(
              onPressed: _canPost ? _handleCreatePost : null,
              style: TextButton.styleFrom(
                backgroundColor: _canPost 
                    ? AppColors.primaryGreen 
                    : AppColors.textHint.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppShapes.paddingL,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Post',
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppShapes.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info and privacy selector
                  Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryPeach,
                        backgroundImage: (user?.avatarUrl != null && 
                                         user!.avatarUrl.isNotEmpty)
                            ? CachedNetworkImageProvider(user.avatarUrl)
                            : null,
                        child: (user?.avatarUrl == null || user!.avatarUrl.isEmpty)
                            ? Icon(
                                Icons.person,
                                color: AppColors.textHint,
                              )
                            : null,
                      ),
                      
                      const SizedBox(width: AppSpacing.m),
                      
                      // Name and privacy
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName ?? 'Anonymous',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: _isLoading ? null : _showPrivacyPicker,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPeach.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getPrivacyIcon(_selectedPrivacy),
                                      size: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _selectedPrivacy.displayName,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.l),
                  
                  // Content input
                  TextField(
                    controller: _contentController,
                    focusNode: _contentFocusNode,
                    enabled: !_isLoading,
                    maxLines: null,
                    minLines: 5,
                    maxLength: maxContentLength,
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textHint,
                      ),
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  
                  // Character counter
                  if (_contentController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.s),
                      child: Text(
                        '${_contentController.text.length}/$maxContentLength',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: _contentController.text.length > maxContentLength * 0.9
                              ? AppColors.errorRed
                              : AppColors.textHint,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: AppSpacing.l),
                  
                  // Media preview
                  if (_selectedMedia.isNotEmpty)
                    _buildMediaPreview(),
                ],
              ),
            ),
          ),
          
          // Bottom action bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  IconData _getPrivacyIcon(PostPrivacy privacy) {
    switch (privacy) {
      case PostPrivacy.public:
        return Icons.public;
      case PostPrivacy.friends:
        return Icons.people;
      case PostPrivacy.private:
        return Icons.lock;
    }
  }

  Widget _buildMediaPreview() {
    if (_selectedMedia.length == 1) {
      return _buildSingleMediaPreview(_selectedMedia[0], 0);
    }
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _selectedMedia.length == 2 ? 2 : 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _selectedMedia.length,
      itemBuilder: (context, index) {
        return _buildMediaThumbnail(_selectedMedia[index], index);
      },
    );
  }

  Widget _buildSingleMediaPreview(XFile file, int index) {
    final isVideo = _isVideoFile(file.path);
    
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isVideo
                ? Container(
                    color: Colors.black87,
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Image.file(
                    File(file.path),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        
        // Remove button
        Positioned(
          top: 8,
          right: 8,
          child: _buildRemoveButton(index),
        ),
        
        // Video indicator
        if (isVideo)
          const Positioned(
            bottom: 8,
            left: 8,
            child: Icon(
              Icons.videocam,
              color: Colors.white,
              size: 20,
            ),
          ),
      ],
    );
  }

  Widget _buildMediaThumbnail(XFile file, int index) {
    final isVideo = _isVideoFile(file.path);
    
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isVideo
                ? Container(
                    color: Colors.black87,
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Image.file(
                    File(file.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
          ),
        ),
        
        // Remove button
        Positioned(
          top: 4,
          right: 4,
          child: _buildRemoveButton(index, small: true),
        ),
      ],
    );
  }

  Widget _buildRemoveButton(int index, {bool small = false}) {
    return GestureDetector(
      onTap: _isLoading ? null : () => _removeMedia(index),
      child: Container(
        padding: EdgeInsets.all(small ? 4 : 6),
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close,
          color: Colors.white,
          size: small ? 14 : 18,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppShapes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          top: BorderSide(
            color: AppColors.textHint.withOpacity(0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Add photo button
            _buildActionButton(
              icon: Icons.photo_library,
              label: 'Photo',
              onTap: _isLoading ? null : _pickImages,
            ),
            
            const SizedBox(width: AppSpacing.m),
            
            // Take photo button
            _buildActionButton(
              icon: Icons.camera_alt,
              label: 'Camera',
              onTap: _isLoading ? null : _takePhoto,
            ),
            
            const SizedBox(width: AppSpacing.m),
            
            // Add video button
            _buildActionButton(
              icon: Icons.videocam,
              label: 'Video',
              onTap: _isLoading ? null : _pickVideo,
            ),
            
            const Spacer(),
            
            // Media count
            if (_selectedMedia.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryPeach.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_selectedMedia.length}/$maxMediaFiles',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: onTap != null 
                  ? AppColors.primaryGreen 
                  : AppColors.textHint,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: onTap != null 
                    ? AppColors.textSecondary 
                    : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
