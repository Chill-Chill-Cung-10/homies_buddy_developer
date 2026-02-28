/// [Refactored] Phase 1.2 — Barrel export cho tất cả core widgets.
///
/// Import file này thay vì common_widgets.dart cũ:
/// ```dart
/// import 'package:homies_buddy_developer/core/widgets/widgets.dart';
/// ```
library;

// Buttons
export 'buttons/custom_button.dart';

// Text Fields
export 'text_fields/custom_text_field.dart';
export 'text_fields/password_text_field.dart';

// Dialogs
export 'dialogs/custom_dialog.dart';

// Feedback
export 'feedback/loading_overlay.dart';
export 'feedback/empty_state_widget.dart';
export 'feedback/blinking_cursor.dart';

// Cards
export 'cards/info_card.dart';

// Media
export 'media/media_picker_bottom_sheet.dart';
