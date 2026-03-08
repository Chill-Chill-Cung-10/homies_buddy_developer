// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'help_chat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HelpChatMessage {

 String get id;/// ⭐ **Thêm mới** — Session ID để biết message này thuộc conversation nào
 String get conversationId; String get text; bool get isUser; DateTime get timestamp; List<String> get imageUrls;
/// Create a copy of HelpChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelpChatMessageCopyWith<HelpChatMessage> get copyWith => _$HelpChatMessageCopyWithImpl<HelpChatMessage>(this as HelpChatMessage, _$identity);

  /// Serializes this HelpChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HelpChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.text, text) || other.text == text)&&(identical(other.isUser, isUser) || other.isUser == isUser)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,text,isUser,timestamp,const DeepCollectionEquality().hash(imageUrls));

@override
String toString() {
  return 'HelpChatMessage(id: $id, conversationId: $conversationId, text: $text, isUser: $isUser, timestamp: $timestamp, imageUrls: $imageUrls)';
}


}

/// @nodoc
abstract mixin class $HelpChatMessageCopyWith<$Res>  {
  factory $HelpChatMessageCopyWith(HelpChatMessage value, $Res Function(HelpChatMessage) _then) = _$HelpChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String text, bool isUser, DateTime timestamp, List<String> imageUrls
});




}
/// @nodoc
class _$HelpChatMessageCopyWithImpl<$Res>
    implements $HelpChatMessageCopyWith<$Res> {
  _$HelpChatMessageCopyWithImpl(this._self, this._then);

  final HelpChatMessage _self;
  final $Res Function(HelpChatMessage) _then;

/// Create a copy of HelpChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? text = null,Object? isUser = null,Object? timestamp = null,Object? imageUrls = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isUser: null == isUser ? _self.isUser : isUser // ignore: cast_nullable_to_non_nullable
as bool,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [HelpChatMessage].
extension HelpChatMessagePatterns on HelpChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HelpChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HelpChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HelpChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _HelpChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HelpChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _HelpChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String text,  bool isUser,  DateTime timestamp,  List<String> imageUrls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HelpChatMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.text,_that.isUser,_that.timestamp,_that.imageUrls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String text,  bool isUser,  DateTime timestamp,  List<String> imageUrls)  $default,) {final _that = this;
switch (_that) {
case _HelpChatMessage():
return $default(_that.id,_that.conversationId,_that.text,_that.isUser,_that.timestamp,_that.imageUrls);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String text,  bool isUser,  DateTime timestamp,  List<String> imageUrls)?  $default,) {final _that = this;
switch (_that) {
case _HelpChatMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.text,_that.isUser,_that.timestamp,_that.imageUrls);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HelpChatMessage implements HelpChatMessage {
  const _HelpChatMessage({required this.id, required this.conversationId, required this.text, required this.isUser, required this.timestamp, final  List<String> imageUrls = const []}): _imageUrls = imageUrls;
  factory _HelpChatMessage.fromJson(Map<String, dynamic> json) => _$HelpChatMessageFromJson(json);

@override final  String id;
/// ⭐ **Thêm mới** — Session ID để biết message này thuộc conversation nào
@override final  String conversationId;
@override final  String text;
@override final  bool isUser;
@override final  DateTime timestamp;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}


/// Create a copy of HelpChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelpChatMessageCopyWith<_HelpChatMessage> get copyWith => __$HelpChatMessageCopyWithImpl<_HelpChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HelpChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HelpChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.text, text) || other.text == text)&&(identical(other.isUser, isUser) || other.isUser == isUser)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,text,isUser,timestamp,const DeepCollectionEquality().hash(_imageUrls));

@override
String toString() {
  return 'HelpChatMessage(id: $id, conversationId: $conversationId, text: $text, isUser: $isUser, timestamp: $timestamp, imageUrls: $imageUrls)';
}


}

/// @nodoc
abstract mixin class _$HelpChatMessageCopyWith<$Res> implements $HelpChatMessageCopyWith<$Res> {
  factory _$HelpChatMessageCopyWith(_HelpChatMessage value, $Res Function(_HelpChatMessage) _then) = __$HelpChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String text, bool isUser, DateTime timestamp, List<String> imageUrls
});




}
/// @nodoc
class __$HelpChatMessageCopyWithImpl<$Res>
    implements _$HelpChatMessageCopyWith<$Res> {
  __$HelpChatMessageCopyWithImpl(this._self, this._then);

  final _HelpChatMessage _self;
  final $Res Function(_HelpChatMessage) _then;

/// Create a copy of HelpChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? text = null,Object? isUser = null,Object? timestamp = null,Object? imageUrls = null,}) {
  return _then(_HelpChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isUser: null == isUser ? _self.isUser : isUser // ignore: cast_nullable_to_non_nullable
as bool,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$HelpConversationHistory {

 String get id;/// ⭐ **Thêm mới** — User ID chủ sở hữu conversation
 String get userId; String get title; String get preview; DateTime get lastMessageAt; List<HelpChatMessage> get messages;
/// Create a copy of HelpConversationHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelpConversationHistoryCopyWith<HelpConversationHistory> get copyWith => _$HelpConversationHistoryCopyWithImpl<HelpConversationHistory>(this as HelpConversationHistory, _$identity);

  /// Serializes this HelpConversationHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HelpConversationHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&const DeepCollectionEquality().equals(other.messages, messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,preview,lastMessageAt,const DeepCollectionEquality().hash(messages));

@override
String toString() {
  return 'HelpConversationHistory(id: $id, userId: $userId, title: $title, preview: $preview, lastMessageAt: $lastMessageAt, messages: $messages)';
}


}

/// @nodoc
abstract mixin class $HelpConversationHistoryCopyWith<$Res>  {
  factory $HelpConversationHistoryCopyWith(HelpConversationHistory value, $Res Function(HelpConversationHistory) _then) = _$HelpConversationHistoryCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, String preview, DateTime lastMessageAt, List<HelpChatMessage> messages
});




}
/// @nodoc
class _$HelpConversationHistoryCopyWithImpl<$Res>
    implements $HelpConversationHistoryCopyWith<$Res> {
  _$HelpConversationHistoryCopyWithImpl(this._self, this._then);

  final HelpConversationHistory _self;
  final $Res Function(HelpConversationHistory) _then;

/// Create a copy of HelpConversationHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? preview = null,Object? lastMessageAt = null,Object? messages = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String,lastMessageAt: null == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<HelpChatMessage>,
  ));
}

}


/// Adds pattern-matching-related methods to [HelpConversationHistory].
extension HelpConversationHistoryPatterns on HelpConversationHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HelpConversationHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HelpConversationHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HelpConversationHistory value)  $default,){
final _that = this;
switch (_that) {
case _HelpConversationHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HelpConversationHistory value)?  $default,){
final _that = this;
switch (_that) {
case _HelpConversationHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String preview,  DateTime lastMessageAt,  List<HelpChatMessage> messages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HelpConversationHistory() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.preview,_that.lastMessageAt,_that.messages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String preview,  DateTime lastMessageAt,  List<HelpChatMessage> messages)  $default,) {final _that = this;
switch (_that) {
case _HelpConversationHistory():
return $default(_that.id,_that.userId,_that.title,_that.preview,_that.lastMessageAt,_that.messages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  String preview,  DateTime lastMessageAt,  List<HelpChatMessage> messages)?  $default,) {final _that = this;
switch (_that) {
case _HelpConversationHistory() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.preview,_that.lastMessageAt,_that.messages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HelpConversationHistory implements HelpConversationHistory {
  const _HelpConversationHistory({required this.id, required this.userId, required this.title, required this.preview, required this.lastMessageAt, final  List<HelpChatMessage> messages = const []}): _messages = messages;
  factory _HelpConversationHistory.fromJson(Map<String, dynamic> json) => _$HelpConversationHistoryFromJson(json);

@override final  String id;
/// ⭐ **Thêm mới** — User ID chủ sở hữu conversation
@override final  String userId;
@override final  String title;
@override final  String preview;
@override final  DateTime lastMessageAt;
 final  List<HelpChatMessage> _messages;
@override@JsonKey() List<HelpChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of HelpConversationHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelpConversationHistoryCopyWith<_HelpConversationHistory> get copyWith => __$HelpConversationHistoryCopyWithImpl<_HelpConversationHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HelpConversationHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HelpConversationHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&const DeepCollectionEquality().equals(other._messages, _messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,preview,lastMessageAt,const DeepCollectionEquality().hash(_messages));

@override
String toString() {
  return 'HelpConversationHistory(id: $id, userId: $userId, title: $title, preview: $preview, lastMessageAt: $lastMessageAt, messages: $messages)';
}


}

/// @nodoc
abstract mixin class _$HelpConversationHistoryCopyWith<$Res> implements $HelpConversationHistoryCopyWith<$Res> {
  factory _$HelpConversationHistoryCopyWith(_HelpConversationHistory value, $Res Function(_HelpConversationHistory) _then) = __$HelpConversationHistoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, String preview, DateTime lastMessageAt, List<HelpChatMessage> messages
});




}
/// @nodoc
class __$HelpConversationHistoryCopyWithImpl<$Res>
    implements _$HelpConversationHistoryCopyWith<$Res> {
  __$HelpConversationHistoryCopyWithImpl(this._self, this._then);

  final _HelpConversationHistory _self;
  final $Res Function(_HelpConversationHistory) _then;

/// Create a copy of HelpConversationHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? preview = null,Object? lastMessageAt = null,Object? messages = null,}) {
  return _then(_HelpConversationHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String,lastMessageAt: null == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<HelpChatMessage>,
  ));
}


}


/// @nodoc
mixin _$HelpSuggestion {

 String get id; String get title; IconType get iconType;
/// Create a copy of HelpSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelpSuggestionCopyWith<HelpSuggestion> get copyWith => _$HelpSuggestionCopyWithImpl<HelpSuggestion>(this as HelpSuggestion, _$identity);

  /// Serializes this HelpSuggestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HelpSuggestion&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.iconType, iconType) || other.iconType == iconType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,iconType);

@override
String toString() {
  return 'HelpSuggestion(id: $id, title: $title, iconType: $iconType)';
}


}

/// @nodoc
abstract mixin class $HelpSuggestionCopyWith<$Res>  {
  factory $HelpSuggestionCopyWith(HelpSuggestion value, $Res Function(HelpSuggestion) _then) = _$HelpSuggestionCopyWithImpl;
@useResult
$Res call({
 String id, String title, IconType iconType
});




}
/// @nodoc
class _$HelpSuggestionCopyWithImpl<$Res>
    implements $HelpSuggestionCopyWith<$Res> {
  _$HelpSuggestionCopyWithImpl(this._self, this._then);

  final HelpSuggestion _self;
  final $Res Function(HelpSuggestion) _then;

/// Create a copy of HelpSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? iconType = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,iconType: null == iconType ? _self.iconType : iconType // ignore: cast_nullable_to_non_nullable
as IconType,
  ));
}

}


/// Adds pattern-matching-related methods to [HelpSuggestion].
extension HelpSuggestionPatterns on HelpSuggestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HelpSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HelpSuggestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HelpSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _HelpSuggestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HelpSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _HelpSuggestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  IconType iconType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HelpSuggestion() when $default != null:
return $default(_that.id,_that.title,_that.iconType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  IconType iconType)  $default,) {final _that = this;
switch (_that) {
case _HelpSuggestion():
return $default(_that.id,_that.title,_that.iconType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  IconType iconType)?  $default,) {final _that = this;
switch (_that) {
case _HelpSuggestion() when $default != null:
return $default(_that.id,_that.title,_that.iconType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HelpSuggestion implements HelpSuggestion {
  const _HelpSuggestion({required this.id, required this.title, required this.iconType});
  factory _HelpSuggestion.fromJson(Map<String, dynamic> json) => _$HelpSuggestionFromJson(json);

@override final  String id;
@override final  String title;
@override final  IconType iconType;

/// Create a copy of HelpSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelpSuggestionCopyWith<_HelpSuggestion> get copyWith => __$HelpSuggestionCopyWithImpl<_HelpSuggestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HelpSuggestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HelpSuggestion&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.iconType, iconType) || other.iconType == iconType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,iconType);

@override
String toString() {
  return 'HelpSuggestion(id: $id, title: $title, iconType: $iconType)';
}


}

/// @nodoc
abstract mixin class _$HelpSuggestionCopyWith<$Res> implements $HelpSuggestionCopyWith<$Res> {
  factory _$HelpSuggestionCopyWith(_HelpSuggestion value, $Res Function(_HelpSuggestion) _then) = __$HelpSuggestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, IconType iconType
});




}
/// @nodoc
class __$HelpSuggestionCopyWithImpl<$Res>
    implements _$HelpSuggestionCopyWith<$Res> {
  __$HelpSuggestionCopyWithImpl(this._self, this._then);

  final _HelpSuggestion _self;
  final $Res Function(_HelpSuggestion) _then;

/// Create a copy of HelpSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? iconType = null,}) {
  return _then(_HelpSuggestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,iconType: null == iconType ? _self.iconType : iconType // ignore: cast_nullable_to_non_nullable
as IconType,
  ));
}


}

// dart format on
