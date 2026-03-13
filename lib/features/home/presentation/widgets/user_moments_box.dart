import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../feedback/presentation/feedback_bottom_sheet.dart';
import 'user_moments_box/typing_text_button.dart';
import 'user_moments_box/moments_input_field.dart';
import 'user_moments_box/moments_modal_content.dart';

/// Main UserMomentsBox widget - simplified by using reusable components
class UserMomentsBox extends StatefulWidget {
  const UserMomentsBox({super.key});

  @override
  State<UserMomentsBox> createState() => _UserMomentsBoxState();
}

class _UserMomentsBoxState extends State<UserMomentsBox> {
  bool isOpenModal = false;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();

  // Typing animation texts
  final List<String> _typingTexts = [
    'Share your thoughts...',
    'Show me your story...',
    'How are you today...!',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _openModal() {
    setState(() => isOpenModal = true);

    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => MomentsModalContent(imagePicker: _imagePicker),
    ).then((shouldShowFeedback) {
      if (mounted) {
        setState(() => isOpenModal = false);
        _focusNode.unfocus();
        _textController.clear();

        // Show feedback popup after 2s delay if 3rd note was created
        if (shouldShowFeedback == true) {
          final userId = FirebaseService.instance.currentUserId;
          if (userId != null) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                FeedbackBottomSheet.show(context, userId: userId);
              }
            });
          }
        }
      }
    });
  }

  void _handleSend() {
    // TODO: Implement send functionality
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: isOpenModal
          ? MomentsInputField(
              key: const ValueKey('input_box'),
              controller: _textController,
              focusNode: _focusNode,
              onAddPressed: () {
                // Visual only when modal is open
              },
              onSendPressed: _handleSend,
            )
          : TypingTextButton(
              key: const ValueKey('text_button'),
              onTap: _openModal,
              texts: _typingTexts,
            ),
    );
  }
}
