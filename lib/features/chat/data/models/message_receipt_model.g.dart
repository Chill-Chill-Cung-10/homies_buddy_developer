// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_receipt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageReceipt _$MessageReceiptFromJson(Map<String, dynamic> json) =>
    _MessageReceipt(
      messageId: json['messageId'] as String,
      userId: json['userId'] as String,
      deliveredAt: json['deliveredAt'] == null
          ? null
          : DateTime.parse(json['deliveredAt'] as String),
      seenAt: json['seenAt'] == null
          ? null
          : DateTime.parse(json['seenAt'] as String),
    );

Map<String, dynamic> _$MessageReceiptToJson(_MessageReceipt instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'userId': instance.userId,
      'deliveredAt': instance.deliveredAt?.toIso8601String(),
      'seenAt': instance.seenAt?.toIso8601String(),
    };
