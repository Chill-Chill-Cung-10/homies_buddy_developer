/// Profile Edit Screen — Edit user profile information
///
/// Features:
/// - Display all user fields (except password)
/// - Avatar and cover photo upload
/// - Save button disabled until changes are made
/// - Real-time validation
library;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/image_upload_service.dart';
import '../../../../core/widgets/system_notification_popup.dart';
import '../providers/profile_providers.dart';
import '../../../auth/presentation/widgets/auth_input_field.dart';

/// Profile Edit Screen
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  final _headlineController = TextEditingController();

  // State
  bool _isLoading = false;
  bool _hasChanges = false;
  XFile? _selectedAvatar;
  XFile? _selectedCover;
  String? _currentAvatarUrl;
  String? _currentCoverUrl;

  // Original values for comparison
  String _originalFullName = '';
  String _originalUsername = '';
  String _originalBio = '';
  String _originalLocation = '';
  String _originalHeadline = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    
    // Add listeners to detect changes
    _fullNameController.addListener(_checkForChanges);
    _usernameController.addListener(_checkForChanges);
    _bioController.addListener(_checkForChanges);
    _locationController.addListener(_checkForChanges);
    _headlineController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _headlineController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final profileState = ref.read(profileStateProvider);
    final user = profileState.user;
    
    if (user != null) {
      _fullNameController.text = user.fullName;
      _usernameController.text = user.username;
      _bioController.text = user.bio ?? '';
      _locationController.text = user.location ?? '';
      _headlineController.text = user.headline ?? '';
      _currentAvatarUrl = user.avatarUrl;
      _currentCoverUrl = user.coverUrl;
      
      // Store original values
      _originalFullName = user.fullName;
      _originalUsername = user.username;
      _originalBio = user.bio ?? '';
      _originalLocation = user.location ?? '';
      _originalHeadline = user.headline ?? '';
    }
  }

  void _checkForChanges() {
    final hasTextChanges = 
        _fullNameController.text != _originalFullName ||
        _usernameController.text != _originalUsername ||
        _bioController.text != _originalBio ||
        _locationController.text != _originalLocation ||
        _headlineController.text != _originalHeadline;
    
    final hasImageChanges = _selectedAvatar != null || _selectedCover != null;
    
    setState(() {
      _hasChanges = hasTextChanges || hasImageChanges;
    });
  }

  // ─── Image Picking ───

  Future<void> _pickAvatar() async {
    _showImagePickerBottomSheet(
      title: 'Change Avatar',
      onCameraTap: () => _handleAvatarPick(useCamera: true),
      onGalleryTap: () => _handleAvatarPick(useCamera: false),
    );
  }

  Future<void> _pickCover() async {
    _showImagePickerBottomSheet(
      title: 'Change Cover Photo',
      onCameraTap: () => _handleCoverPick(useCamera: true),
      onGalleryTap: () => _handleCoverPick(useCamera: false),
    );
  }

  void _showImagePickerBottomSheet({
    required String title,
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
  }) {
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
            children: [
              Text(title, style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.l),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPickerOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      onCameraTap();
                    },
                  ),
                  _buildPickerOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      onGalleryTap();
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.m),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppShapes.paddingL),
        decoration: BoxDecoration(
          color: AppColors.primaryPeach.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.primaryGreen),
            const SizedBox(height: AppSpacing.s),
            Text(label, style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAvatarPick({required bool useCamera}) async {
    final service = ImageUploadService.instance;
    final result = useCamera
        ? await service.pickImageFromCamera()
        : await service.pickImageFromGallery();

    if (result.isValid && result.file != null) {
      // Validate file size
      final sizeResult = await service.validateFileSize(result.file!);
      if (!sizeResult.isValid) {
        if (mounted) {
          SystemNotificationPopup.error(context, message: sizeResult.errorMessage!);
        }
        return;
      }

      setState(() {
        _selectedAvatar = result.file;
        _hasChanges = true;
      });
    } else if (result.errorMessage != null && result.errorMessage != 'No image selected') {
      if (mounted) {
        SystemNotificationPopup.error(context, message: result.errorMessage!);
      }
    }
  }

  Future<void> _handleCoverPick({required bool useCamera}) async {
    final service = ImageUploadService.instance;
    final result = useCamera
        ? await service.pickImageFromCamera()
        : await service.pickImageFromGallery();

    if (result.isValid && result.file != null) {
      // Validate file size
      final sizeResult = await service.validateFileSize(result.file!);
      if (!sizeResult.isValid) {
        if (mounted) {
          SystemNotificationPopup.error(context, message: sizeResult.errorMessage!);
        }
        return;
      }

      setState(() {
        _selectedCover = result.file;
        _hasChanges = true;
      });
    } else if (result.errorMessage != null && result.errorMessage != 'No image selected') {
      if (mounted) {
        SystemNotificationPopup.error(context, message: result.errorMessage!);
      }
    }
  }

  // ─── Validation ───

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (value.length > 30) {
      return 'Username must be less than 30 characters';
    }
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_.]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, dots and underscores';
    }
    return null;
  }

  String? _validateBio(String? value) {
    if (value != null && value.length > 160) {
      return 'Bio must be less than 160 characters';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    if (value != null && value.length > 100) {
      return 'Location must be less than 100 characters';
    }
    return null;
  }

  String? _validateHeadline(String? value) {
    if (value != null && value.length > 100) {
      return 'Headline must be less than 100 characters';
    }
    return null;
  }

  // ─── Save Profile ───

  Future<void> _handleSaveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasChanges) return;

    setState(() => _isLoading = true);

    try {
      final profileState = ref.read(profileStateProvider);
      final user = profileState.user;
      if (user == null) {
        throw Exception('User not found');
      }

      final service = ImageUploadService.instance;
      String? newAvatarUrl = _currentAvatarUrl;
      String? newCoverUrl = _currentCoverUrl;

      // Upload new avatar if selected
      if (_selectedAvatar != null) {
        debugPrint('📤 Uploading new avatar...');
        final uploadResult = await service.uploadAvatar(_selectedAvatar!, user.id);
        if (uploadResult.isSuccess) {
          debugPrint('✅ Avatar uploaded: ${uploadResult.downloadUrl}');
          // Delete old avatar
          await service.deleteOldImage(_currentAvatarUrl);
          newAvatarUrl = uploadResult.downloadUrl;
        } else {
          debugPrint('❌ Avatar upload failed: ${uploadResult.errorMessage}');
          throw Exception(uploadResult.errorMessage);
        }
      }

      // Upload new cover if selected
      if (_selectedCover != null) {
        debugPrint('📤 Uploading new cover...');
        final uploadResult = await service.uploadCover(_selectedCover!, user.id);
        if (uploadResult.isSuccess) {
          debugPrint('✅ Cover uploaded: ${uploadResult.downloadUrl}');
          // Delete old cover
          await service.deleteOldImage(_currentCoverUrl);
          newCoverUrl = uploadResult.downloadUrl;
        } else {
          debugPrint('❌ Cover upload failed: ${uploadResult.errorMessage}');
          throw Exception(uploadResult.errorMessage);
        }
      }

      // Update profile in Supabase
      debugPrint('📤 Saving profile - avatarUrl: $newAvatarUrl');
      debugPrint('📤 Saving profile - coverUrl: $newCoverUrl');
      
      final notifier = ref.read(profileStateProvider.notifier);
      final success = await notifier.updateProfile(
        fullName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        avatarUrl: newAvatarUrl,
        coverUrl: newCoverUrl,
        headline: _headlineController.text.trim().isEmpty ? null : _headlineController.text.trim(),
        bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      );

      if (success && mounted) {
        SystemNotificationPopup.success(context, message: 'Profile updated successfully!');
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      if (mounted) {
        SystemNotificationPopup.error(context, message: 'Failed to save profile: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Edit Profile', style: AppTextStyles.h3),
        actions: [
          // Save button in app bar (alternative position)
          if (_hasChanges && !_isLoading)
            TextButton(
              onPressed: _handleSaveProfile,
              child: Text(
                'Save',
                style: AppTextStyles.buttonMedium.copyWith(
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cover Photo Section
              _buildCoverSection(),

              // Avatar Section (overlapping cover)
              _buildAvatarSection(),

              const SizedBox(height: AppSpacing.l),

              // Form Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppShapes.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Full Name
                    AuthInputField(
                      controller: _fullNameController,
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: Icons.person_outline,
                      validator: _validateFullName,
                      enabled: !_isLoading,
                    ),

                    const SizedBox(height: AppSpacing.m),

                    // Username
                    AuthInputField(
                      controller: _usernameController,
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      prefixIcon: Icons.alternate_email,
                      validator: _validateUsername,
                      enabled: !_isLoading,
                    ),

                    const SizedBox(height: AppSpacing.m),

                    // Headline
                    AuthInputField(
                      controller: _headlineController,
                      labelText: 'Headline (Optional)',
                      hintText: 'e.g., "Pet Lover | Dog Dad"',
                      prefixIcon: Icons.stars_outlined,
                      validator: _validateHeadline,
                      enabled: !_isLoading,
                    ),

                    const SizedBox(height: AppSpacing.m),

                    // Bio
                    _buildBioField(),

                    const SizedBox(height: AppSpacing.m),

                    // Location
                    AuthInputField(
                      controller: _locationController,
                      labelText: 'Location (Optional)',
                      hintText: 'e.g., "Saigon, Vietnam"',
                      prefixIcon: Icons.location_on_outlined,
                      validator: _validateLocation,
                      enabled: !_isLoading,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Save Button
                    _buildSaveButton(),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverSection() {
    return GestureDetector(
      onTap: _isLoading ? null : _pickCover,
      child: Stack(
        children: [
          // Cover Image
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryPeach.withOpacity(0.5),
            ),
            child: _selectedCover != null
                ? Image.file(
                    File(_selectedCover!.path),
                    fit: BoxFit.cover,
                  )
                : (_currentCoverUrl != null && _currentCoverUrl!.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: _currentCoverUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.primaryPeach.withOpacity(0.5),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.primaryPeach.withOpacity(0.5),
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: AppColors.textHint,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.primaryPeach.withOpacity(0.5),
                        child: const Center(
                          child: Icon(
                            Icons.add_photo_alternate,
                            size: 50,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
          ),

          // Edit overlay
          Positioned(
            right: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.camera_alt, color: Colors.white, size: 18),
                  SizedBox(width: 4),
                  Text(
                    'Edit Cover',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Transform.translate(
      offset: const Offset(0, -50),
      child: Center(
        child: GestureDetector(
          onTap: _isLoading ? null : _pickAvatar,
          child: Stack(
            children: [
              // Avatar
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.backgroundLight, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _selectedAvatar != null
                      ? Image.file(
                          File(_selectedAvatar!.path),
                          fit: BoxFit.cover,
                        )
                      : (_currentAvatarUrl != null && _currentAvatarUrl!.isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: _currentAvatarUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppColors.primaryPeach,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.primaryPeach,
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppColors.textHint,
                                ),
                              ),
                            )
                          : Container(
                              color: AppColors.primaryPeach,
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.textHint,
                              ),
                            ),
                ),
              ),

              // Edit button
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.backgroundLight, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bio (Optional)',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        TextFormField(
          controller: _bioController,
          maxLines: 4,
          maxLength: 160,
          enabled: !_isLoading,
          decoration: InputDecoration(
            hintText: 'Tell us about yourself...',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: AppShapes.button,
              borderSide: const BorderSide(color: AppColors.textHint),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppShapes.button,
              borderSide: const BorderSide(color: AppColors.textHint),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppShapes.button,
              borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
            ),
            contentPadding: const EdgeInsets.all(AppShapes.paddingM),
          ),
          validator: _validateBio,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _hasChanges && !_isLoading ? _handleSaveProfile : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _hasChanges ? AppColors.primaryGreen : AppColors.textHint,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: AppShapes.paddingM),
        shape: RoundedRectangleBorder(borderRadius: AppShapes.button),
        elevation: _hasChanges ? 2 : 0,
      ),
      child: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              'Save Profile',
              style: AppTextStyles.buttonMedium.copyWith(
                color: Colors.white,
              ),
            ),
    );
  }
}
