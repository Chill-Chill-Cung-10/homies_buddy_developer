import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/common_widgets.dart';
import '../../../../../data/models/moment_note_model.dart';
import '../../../mock_data/mock_moment_notes.dart';
import 'card_notes_item.dart';
import 'media_preview_grid.dart';

/// Modal content for creating moments/posts
/// Contains input field and media selection functionality
class MomentsModalContent extends StatefulWidget {
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
  State<MomentsModalContent> createState() => _MomentsModalContentState();
}

class _MomentsModalContentState extends State<MomentsModalContent> {
  final TextEditingController _textController = TextEditingController();
  final List<XFile> _selectedMedia = [];
  final List<MomentNote> _postedNotes = List.from(MockMomentNotes.sampleNotes);

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

  void _removeMedia(int index) {
    setState(() => _selectedMedia.removeAt(index));
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty && _selectedMedia.isEmpty) return;

    // Tạo note mới và thêm vào đầu danh sách
    final newNote = MomentNote(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      authorName: 'Me',
      authorAvatarUrl: 'https://i.pravatar.cc/150?img=3',
      createdAt: DateTime.now(),
      textContent: text,
      // Media từ local file chưa có URL, để trống tạm
      mediaUrls: [],
    );

    setState(() {
      _postedNotes.insert(0, newNote);
      _textController.clear();
      _selectedMedia.clear();
    });

    widget.onSend?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  // Input row
                  _buildInputRow(),

                  // Media preview section
                  if (_selectedMedia.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    MediaPreviewGrid(
                      mediaFiles: _selectedMedia,
                      onRemoveMedia: _removeMedia,
                    ),
                  ],

                  // Posted notes list
                  if (_postedNotes.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Divider(height: 1, color: AppColors.surfaceColor),
                    const SizedBox(height: 16),
                    ..._postedNotes.map((note) => CardNoteItem(
                      note: note,
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
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
              style: TextStyle(
                fontSize: 15,
                color: Colors.brown.shade700,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.brown.shade400,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
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
