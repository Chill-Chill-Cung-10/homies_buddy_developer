// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Conversation {

 String get id; List<String> get participantIds; String get participantName;// Home name
 String get participantAvatar;// Home avatar
 String get lastMessage; DateTime get lastUpdated; int get unreadCount; String? get nickname;// Custom nickname set by current user
 DateTime? get mutedUntil;
/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationCopyWith<Conversation> get copyWith => _$ConversationCopyWithImpl<Conversation>(this as Conversation, _$identity);

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conversation&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.participantIds, participantIds)&&(identical(other.participantName, participantName) || other.participantName == participantName)&&(identical(other.participantAvatar, participantAvatar) || other.participantAvatar == participantAvatar)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.mutedUntil, mutedUntil) || other.mutedUntil == mutedUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(participantIds),participantName,participantAvatar,lastMessage,lastUpdated,unreadCount,nickname,mutedUntil);

@override
String toString() {
  return 'Conversation(id: $id, participantIds: $participantIds, participantName: $participantName, participantAvatar: $participantAvatar, lastMessage: $lastMessage, lastUpdated: $lastUpdated, unreadCount: $unreadCount, nickname: $nickname, mutedUntil: $mutedUntil)';
}


}

/// @nodoc
abstract mixin class $ConversationCopyWith<$Res>  {
  factory $ConversationCopyWith(Conversation value, $Res Function(Conversation) _then) = _$ConversationCopyWithImpl;
@useResult
$Res call({
 String id, List<String> participantIds, String participantName, String participantAvatar, String lastMessage, DateTime lastUpdated, int unreadCount, String? nickname, DateTime? mutedUntil
});




}
/// @nodoc
class _$ConversationCopyWithImpl<$Res>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._self, this._then);

  final Conversation _self;
  final $Res Function(Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? participantIds = null,Object? participantName = null,Object? participantAvatar = null,Object? lastMessage = null,Object? lastUpdated = null,Object? unreadCount = null,Object? nickname = freezed,Object? mutedUntil = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participantIds: null == participantIds ? _self.participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,participantName: null == participantName ? _self.participantName : participantName // ignore: cast_nullable_to_non_nullable
as String,participantAvatar: null == participantAvatar ? _self.participantAvatar : participantAvatar // ignore: cast_nullable_to_non_nullable
as String,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,mutedUntil: freezed == mutedUntil ? _self.mutedUntil : mutedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Conversation].
extension ConversationPatterns on Conversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Conversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Conversation value)  $default,){
final _that = this;
switch (_that) {
case _Conversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Conversation value)?  $default,){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<String> participantIds,  String participantName,  String participantAvatar,  String lastMessage,  DateTime lastUpdated,  int unreadCount,  String? nickname,  DateTime? mutedUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.participantIds,_that.participantName,_that.participantAvatar,_that.lastMessage,_that.lastUpdated,_that.unreadCount,_that.nickname,_that.mutedUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<String> participantIds,  String participantName,  String participantAvatar,  String lastMessage,  DateTime lastUpdated,  int unreadCount,  String? nickname,  DateTime? mutedUntil)  $default,) {final _that = this;
switch (_that) {
case _Conversation():
return $default(_that.id,_that.participantIds,_that.participantName,_that.participantAvatar,_that.lastMessage,_that.lastUpdated,_that.unreadCount,_that.nickname,_that.mutedUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<String> participantIds,  String participantName,  String participantAvatar,  String lastMessage,  DateTime lastUpdated,  int unreadCount,  String? nickname,  DateTime? mutedUntil)?  $default,) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.participantIds,_that.participantName,_that.participantAvatar,_that.lastMessage,_that.lastUpdated,_that.unreadCount,_that.nickname,_that.mutedUntil);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Conversation implements Conversation {
  const _Conversation({required this.id, required final  List<String> participantIds, required this.participantName, required this.participantAvatar, required this.lastMessage, required this.lastUpdated, required this.unreadCount, this.nickname, this.mutedUntil}): _participantIds = participantIds;
  factory _Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);

@override final  String id;
 final  List<String> _participantIds;
@override List<String> get participantIds {
  if (_participantIds is EqualUnmodifiableListView) return _participantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantIds);
}

@override final  String participantName;
// Home name
@override final  String participantAvatar;
// Home avatar
@override final  String lastMessage;
@override final  DateTime lastUpdated;
@override final  int unreadCount;
@override final  String? nickname;
// Custom nickname set by current user
@override final  DateTime? mutedUntil;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationCopyWith<_Conversation> get copyWith => __$ConversationCopyWithImpl<_Conversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conversation&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._participantIds, _participantIds)&&(identical(other.participantName, participantName) || other.participantName == participantName)&&(identical(other.participantAvatar, participantAvatar) || other.participantAvatar == participantAvatar)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.mutedUntil, mutedUntil) || other.mutedUntil == mutedUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_participantIds),participantName,participantAvatar,lastMessage,lastUpdated,unreadCount,nickname,mutedUntil);

@override
String toString() {
  return 'Conversation(id: $id, participantIds: $participantIds, participantName: $participantName, participantAvatar: $participantAvatar, lastMessage: $lastMessage, lastUpdated: $lastUpdated, unreadCount: $unreadCount, nickname: $nickname, mutedUntil: $mutedUntil)';
}


}

/// @nodoc
abstract mixin class _$ConversationCopyWith<$Res> implements $ConversationCopyWith<$Res> {
  factory _$ConversationCopyWith(_Conversation value, $Res Function(_Conversation) _then) = __$ConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, List<String> participantIds, String participantName, String participantAvatar, String lastMessage, DateTime lastUpdated, int unreadCount, String? nickname, DateTime? mutedUntil
});




}
/// @nodoc
class __$ConversationCopyWithImpl<$Res>
    implements _$ConversationCopyWith<$Res> {
  __$ConversationCopyWithImpl(this._self, this._then);

  final _Conversation _self;
  final $Res Function(_Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? participantIds = null,Object? participantName = null,Object? participantAvatar = null,Object? lastMessage = null,Object? lastUpdated = null,Object? unreadCount = null,Object? nickname = freezed,Object? mutedUntil = freezed,}) {
  return _then(_Conversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participantIds: null == participantIds ? _self._participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,participantName: null == participantName ? _self.participantName : participantName // ignore: cast_nullable_to_non_nullable
as String,participantAvatar: null == participantAvatar ? _self.participantAvatar : participantAvatar // ignore: cast_nullable_to_non_nullable
as String,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,mutedUntil: freezed == mutedUntil ? _self.mutedUntil : mutedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
