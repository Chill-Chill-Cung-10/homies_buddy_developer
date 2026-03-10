import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/system_notification_popup.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../domain/entities/note_entity.dart';
import '../../providers/home_providers.dart';
import '../../providers/notes_providers.dart';
import 'card_notes_item.dart';
import 'media_preview_grid.dart';

/// Modal content for creating moments/posts
/// Contains input field and media selection functionality
class MomentsModalContent extends ConsumerStatefulWidget {
  final ImagePicker imagePicker;
  final String title;
  final String hintText;
  final VoidCallback? onSend;
  final double heightFactor;

  const MomentsModalContent({
    super.key,
    required this.imagePicker,
    this.title = 'My Daily Notes!',
    this.hintText = 'What\'s on your mind?',
    this.onSend,
    this.heightFactor = 0.83,
  });

  @override
  ConsumerState<MomentsModalContent> createState() =>
      _MomentsModalContentState();
}

class _MomentsModalContentState extends ConsumerState<MomentsModalContent> {
  final TextEditingController _textController = TextEditingController();
  final List<XFile> _selectedMedia = [];

  @override
  void initState() {
    super.initState();
    // Load notes after first frame to avoid modify during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotesForSelectedDate();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    final source = await MediaPickerBottomSheet.show(context);
    if (source == null) return;

    try {
      if (source == 'photo') {
        final images = await widget.imagePicker.pickMultiImage(
          imageQuality: 85,
        );
        if (images.isNotEmpty) {
          setState(() => _selectedMedia.addAll(images));
        }
      } else if (source == 'video') {
        final video = await widget.imagePicker.pickVideo(
          source: ImageSource.gallery,
        );
        if (video != null) {
          setState(() => _selectedMedia.add(video));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Please grant gallery access in Settings to continue.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.errorRed,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  void _loadNotesForSelectedDate() {
    final selectedDate = ref.read(selectedDateProvider);
    ref.read(notesProvider.notifier).loadNotesByDate(selectedDate);
  }

  void _removeMedia(int index) {
    setState(() => _selectedMedia.removeAt(index));
  }

  Future<void> _handleSend() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _selectedMedia.isEmpty) return;

    final mediaPaths = _selectedMedia.map((f) => f.path).toList();
    final success = await ref.read(notesProvider.notifier).createNote(
          textContent: text,
          mediaFilePaths: mediaPaths,
        );

    if (!mounted) return;

    if (success) {
      _textController.clear();
      setState(() => _selectedMedia.clear());
      widget.onSend?.call();
      SystemNotificationPopup.show(
        context,
        message: 'Note posted!',
        type: NotificationType.success,
      );
    } else {
      final error = ref.read(notesProvider).errorMessage ?? 'Unknown error';
      SystemNotificationPopup.show(
        context,
        message: error,
        type: NotificationType.error,
      );
    }
  }

  void _showEditDialog(NoteEntity note) {
    final editController = TextEditingController(text: note.textContent);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(
          controller: editController,
          maxLines: 5,
          minLines: 2,
          decoration: const InputDecoration(
            hintText: 'Edit your note...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final newText = editController.text.trim();
              if (newText.isEmpty) return;

              final success = await ref
                  .read(notesProvider.notifier)
                  .updateNote(noteId: note.id, textContent: newText);

              if (!mounted) return;
              SystemNotificationPopup.show(
                context,
                message: success ? 'Note updated!' : 'Failed to update note',
                type: success
                    ? NotificationType.success
                    : NotificationType.error,
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(NoteEntity note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success =
                  await ref.read(notesProvider.notifier).deleteNote(note.id);

              if (!mounted) return;
              SystemNotificationPopup.show(
                context,
                message: success ? 'Note deleted!' : 'Failed to delete note',
                type: success
                    ? NotificationType.success
                    : NotificationType.error,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for selectedDate changes and reload notes
    ref.listen<DateTime>(selectedDateProvider, (previous, next) {
      if (previous != null && previous != next) {
        // Use Future.microtask to avoid modifying state during build
        Future.microtask(() => _loadNotesForSelectedDate());
      }
    });
    
    final notesState = ref.watch(notesProvider);
    final isToday = ref.watch(isSelectedDateTodayProvider);

    // Determine loading text based on context
    String? loadingText;
    if (notesState.isCreating) {
      loadingText = 'Đang đăng bài...';
    } else if (notesState.isLoading) {
      loadingText = 'Đang tải ghi chú...';
    }

    return LoadingOverlay(
      isLoading: notesState.isCreating || notesState.isLoading,
      loadingText: loadingText,
      child: Container(
        height: MediaQuery.of(context).size.height * widget.heightFactor,
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textHint.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          const Divider(height: 1, color: AppColors.surfaceColor),

          // Scrollable content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input row — only show for today
                  if (isToday) ...[
                    _buildInputRow(),

                    // Media preview section
                    if (_selectedMedia.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      MediaPreviewGrid(
                        mediaFiles: _selectedMedia,
                        onRemoveMedia: _removeMedia,
                      ),
                    ],
                  ],

                  // Error state
                  if (!notesState.isLoading &&
                      notesState.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline,
                                color: AppColors.errorRed, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              notesState.errorMessage!,
                              style: const TextStyle(
                                color: AppColors.errorRed,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: _loadNotesForSelectedDate,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Notes list
                  if (notesState.notes.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Divider(height: 1, color: AppColors.surfaceColor),
                    const SizedBox(height: 16),
                    ...notesState.notes.map(
                      (note) => CardNoteItem(
                        note: note,
                        onEdit: isToday ? () => _showEditDialog(note) : null,
                        onDelete:
                            isToday ? () => _confirmDelete(note) : null,
                      ),
                    ),
                  ],

                  // Empty state
                  if (!notesState.isLoading &&
                      notesState.errorMessage == null &&
                      notesState.notes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No notes for this day',
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildInputRow() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          // Add circle button
          IconButton(
            onPressed: _pickMedia,
            icon: Icon(
              Icons.add_circle,
              color: Colors.brown.shade600,
              size: 28,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),

          // Text field
          Expanded(
            child: TextField(
              controller: _textController,
              maxLines: 3,
              minLines: 1,
              style: TextStyle(fontSize: 15, color: Colors.brown.shade700),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.brown.shade400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 15,
                ),
                isDense: true,
              ),
            ),
          ),

          // Send button
          IconButton(
            onPressed: _handleSend,
            icon: SvgPicture.asset(
              'assets/images/icons/send_button_icon.svg',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                Colors.brown.shade600,
                BlendMode.srcIn,
              ),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}
