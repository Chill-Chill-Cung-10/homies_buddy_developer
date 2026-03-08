import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_receipt_model.freezed.dart';
part 'message_receipt_model.g.dart';

/// Message Receipt Model
///
/// Tracks when a message was delivered and seen by a user
@freezed
abstract class MessageReceipt with _$MessageReceipt {
  const factory MessageReceipt({
    required String messageId,
    required String userId,
    DateTime? deliveredAt,
    DateTime? seenAt,
  }) = _MessageReceipt;

  factory MessageReceipt.fromJson(Map<String, dynamic> json) =>
      _$MessageReceiptFromJson(json);
}

/// Extension để thêm các helper methods
extension MessageReceiptX on MessageReceipt {
  /// Kiểm tra xem message đã delivered chưa
  bool get isDelivered => deliveredAt != null;

  /// Kiểm tra xem message đã seen chưa
  bool get isSeen => seenAt != null;

  /// Composite ID để tracking
  String get compositeId => '$messageId:$userId';
}
