import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../data/models/chat_message_model.dart';
import '../../mockdata/help_mock_data.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/help_suggestion_card.dart';
import '../widgets/conversation_history_sidebar.dart';
import '../widgets/typing_animation_text.dart';

/// Ask For Help Screen - Chat assistant with mascot, 
/// typing animation, help cards, and conversation history
class AskForHelpScreen extends StatefulWidget {
  const AskForHelpScreen({super.key});

  @override
  State<AskForHelpScreen> createState() => _AskForHelpScreenState();
}

class _AskForHelpScreenState extends State<AskForHelpScreen> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Chat state
  bool _isNewChat = true;
  bool _isTypingAnimationComplete = false;
  bool _isBotTyping = false;
  final List<ChatMessage> _messages = [];
  final List<String> _attachedImages = [];

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Actions ───

  void _sendMessage(String text) {
    if (text.trim().isEmpty && _attachedImages.isEmpty) return;

    final userMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      imageUrls: List.from(_attachedImages),
    );

    setState(() {
      _isNewChat = false;
      _messages.add(userMessage);
      _attachedImages.clear();
      _isBotTyping = true;
    });

    _inputController.clear();
    _scrollToBottom();

    // Simulate bot response after delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final botResponse = ChatMessage(
        id: 'msg_bot_${DateTime.now().millisecondsSinceEpoch}',
        text: HelpMockData.getBotResponse(text),
        isUser: false,
        timestamp: DateTime.now(),
      );
      setState(() {
        _isBotTyping = false;
        _messages.add(botResponse);
      });
      _scrollToBottom();
    });
  }

  void _handleSuggestionTap(HelpSuggestion suggestion) {
    _sendMessage(suggestion.title);
  }

  void _loadConversation(ConversationHistory conversation) {
    setState(() {
      _isNewChat = false;
      _messages.clear();
      _messages.addAll(conversation.messages);
    });
    Navigator.of(context).pop(); // Close the sidebar
    _scrollToBottom();
  }

  void _startNewChat() {
    setState(() {
      _isNewChat = true;
      _isTypingAnimationComplete = false;
      _messages.clear();
      _attachedImages.clear();
    });
    Navigator.of(context).pop(); // Close the sidebar
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 70);
    if (image != null) {
      setState(() {
        _attachedImages.add(image.path);
      });
    }
  }

  void _showMediaMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(AppShapes.paddingM),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: AppShapes.card,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: AppColors.textPrimary),
                ),
                title: Text('Take Photo', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library, color: AppColors.textPrimary),
                ),
                title: Text('Choose Image', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Build ───

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ConversationHistorySidebar(
        conversations: HelpMockData.conversationHistories,
        onConversationTap: _loadConversation,
        onNewChatTap: _startNewChat,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _isNewChat
                    ? _buildNewChatView()
                    : _buildActiveChatView(),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppShapes.paddingS,
        vertical: AppShapes.paddingS,
      ),
      child: Row(
        children: [
          const SizedBox(width: 48), // Balance the right icon
          const Expanded(
            child: Text(
              'Ask For Help',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
    );
  }

  // ─── New Chat View ───

  Widget _buildNewChatView() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: AppShapes.paddingM),
      child: Column(
        children: [
          const SizedBox(height: 32),

          // Typing welcome message
          _buildWelcomeMessage(),

          const SizedBox(height: 32),

          // Help suggestion cards
          _buildSuggestionCards(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Small mascot icon
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceColor,
            border: Border.all(
              color: AppColors.primaryPeach,
              width: 1.5,
            ),
          ),
          child: const Center(
            child: Text('🌱', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 8),

        // Message bubble with typing animation
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TypingAnimationText(
              text: HelpMockData.welcomeMessage,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                height: 1.4,
              ),
              onComplete: () {
                setState(() {
                  _isTypingAnimationComplete = true;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionCards() {
    return AnimatedOpacity(
      opacity: _isTypingAnimationComplete ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95,
        ),
        itemCount: HelpMockData.helpSuggestions.length,
        itemBuilder: (context, index) {
          final suggestion = HelpMockData.helpSuggestions[index];
          return HelpSuggestionCard(
            suggestion: suggestion,
            onTap: () => _handleSuggestionTap(suggestion),
          );
        },
      ),
    );
  }

  // ─── Active Chat View ───

  Widget _buildActiveChatView() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppShapes.paddingM,
        vertical: AppShapes.paddingS,
      ),
      itemCount: _messages.length + (_isBotTyping ? 1 : 0),
      itemBuilder: (context, index) {
        // Show typing indicator at the end
        if (index == _messages.length && _isBotTyping) {
          return _buildTypingIndicator();
        }
        final message = _messages[index];
        return ChatBubble(message: message);
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceColor,
              border: Border.all(color: AppColors.primaryPeach, width: 1.5),
            ),
            child: const Center(
              child: Text('🌱', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const _BouncingDots(),
          ),
        ],
      ),
    );
  }

  // ─── Input Area ───

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(
        left: AppShapes.paddingM,
        right: AppShapes.paddingM,
        bottom: AppShapes.paddingS,
        top: AppShapes.paddingS,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Attached images preview
          if (_attachedImages.isNotEmpty) _buildAttachedImagesPreview(),

          // Input row
          Row(
            children: [
              // Plus button for media
              GestureDetector(
                onTap: _showMediaMenu,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Text input
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.primaryPeach.withValues(alpha: 0.5),
                    ),
                  ),
                  child: TextField(
                    controller: _inputController,
                    focusNode: _inputFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textHint,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    style: AppTextStyles.bodyLarge,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (text) => _sendMessage(text),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Send button
              GestureDetector(
                onTap: () => _sendMessage(_inputController.text),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentOrange.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachedImagesPreview() {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _attachedImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.surfaceColor,
              border: Border.all(color: AppColors.primaryPeach),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.image,
                    color: AppColors.textHint,
                    size: 28,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _attachedImages.removeAt(index);
                      });
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.errorRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Bouncing dots animation for bot typing indicator
class _BouncingDots extends StatefulWidget {
  const _BouncingDots();

  @override
  State<_BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<_BouncingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: -6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Stagger the animations
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.translate(
                offset: Offset(0, _animations[index].value),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.textHint,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
