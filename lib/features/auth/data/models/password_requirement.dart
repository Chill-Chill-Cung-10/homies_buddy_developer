/// [Refactored] Phase 2.2 — Extracted from register_request.dart & change_password_request.dart
/// Password Requirement — Để hiển thị trong UI
class PasswordRequirement {
  final String label;
  final bool isMet;

  PasswordRequirement({
    required this.label,
    required this.isMet,
  });
}
