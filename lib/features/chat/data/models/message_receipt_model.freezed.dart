// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_receipt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageReceipt {

 String get messageId; String get userId; DateTime? get deliveredAt; DateTime? get seenAt;
/// Create a copy of MessageReceipt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageReceiptCopyWith<MessageReceipt> get copyWith => _$MessageReceiptCopyWithImpl<MessageReceipt>(this as MessageReceipt, _$identity);

  /// Serializes this MessageReceipt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageReceipt&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt)&&(identical(other.seenAt, seenAt) || other.seenAt == seenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,userId,deliveredAt,seenAt);

@override
String toString() {
  return 'MessageReceipt(messageId: $messageId, userId: $userId, deliveredAt: $deliveredAt, seenAt: $seenAt)';
}


}

/// @nodoc
abstract mixin class $MessageReceiptCopyWith<$Res>  {
  factory $MessageReceiptCopyWith(MessageReceipt value, $Res Function(MessageReceipt) _then) = _$MessageReceiptCopyWithImpl;
@useResult
$Res call({
 String messageId, String userId, DateTime? deliveredAt, DateTime? seenAt
});




}
/// @nodoc
class _$MessageReceiptCopyWithImpl<$Res>
    implements $MessageReceiptCopyWith<$Res> {
  _$MessageReceiptCopyWithImpl(this._self, this._then);

  final MessageReceipt _self;
  final $Res Function(MessageReceipt) _then;

/// Create a copy of MessageReceipt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? userId = null,Object? deliveredAt = freezed,Object? seenAt = freezed,}) {
  return _then(_self.copyWith(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,seenAt: freezed == seenAt ? _self.seenAt : seenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageReceipt].
extension MessageReceiptPatterns on MessageReceipt {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageReceipt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageReceipt() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageReceipt value)  $default,){
final _that = this;
switch (_that) {
case _MessageReceipt():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageReceipt value)?  $default,){
final _that = this;
switch (_that) {
case _MessageReceipt() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String messageId,  String userId,  DateTime? deliveredAt,  DateTime? seenAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageReceipt() when $default != null:
return $default(_that.messageId,_that.userId,_that.deliveredAt,_that.seenAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String messageId,  String userId,  DateTime? deliveredAt,  DateTime? seenAt)  $default,) {final _that = this;
switch (_that) {
case _MessageReceipt():
return $default(_that.messageId,_that.userId,_that.deliveredAt,_that.seenAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String messageId,  String userId,  DateTime? deliveredAt,  DateTime? seenAt)?  $default,) {final _that = this;
switch (_that) {
case _MessageReceipt() when $default != null:
return $default(_that.messageId,_that.userId,_that.deliveredAt,_that.seenAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageReceipt implements MessageReceipt {
  const _MessageReceipt({required this.messageId, required this.userId, this.deliveredAt, this.seenAt});
  factory _MessageReceipt.fromJson(Map<String, dynamic> json) => _$MessageReceiptFromJson(json);

@override final  String messageId;
@override final  String userId;
@override final  DateTime? deliveredAt;
@override final  DateTime? seenAt;

/// Create a copy of MessageReceipt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageReceiptCopyWith<_MessageReceipt> get copyWith => __$MessageReceiptCopyWithImpl<_MessageReceipt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageReceiptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageReceipt&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt)&&(identical(other.seenAt, seenAt) || other.seenAt == seenAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,userId,deliveredAt,seenAt);

@override
String toString() {
  return 'MessageReceipt(messageId: $messageId, userId: $userId, deliveredAt: $deliveredAt, seenAt: $seenAt)';
}


}

/// @nodoc
abstract mixin class _$MessageReceiptCopyWith<$Res> implements $MessageReceiptCopyWith<$Res> {
  factory _$MessageReceiptCopyWith(_MessageReceipt value, $Res Function(_MessageReceipt) _then) = __$MessageReceiptCopyWithImpl;
@override @useResult
$Res call({
 String messageId, String userId, DateTime? deliveredAt, DateTime? seenAt
});




}
/// @nodoc
class __$MessageReceiptCopyWithImpl<$Res>
    implements _$MessageReceiptCopyWith<$Res> {
  __$MessageReceiptCopyWithImpl(this._self, this._then);

  final _MessageReceipt _self;
  final $Res Function(_MessageReceipt) _then;

/// Create a copy of MessageReceipt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? userId = null,Object? deliveredAt = freezed,Object? seenAt = freezed,}) {
  return _then(_MessageReceipt(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,seenAt: freezed == seenAt ? _self.seenAt : seenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
