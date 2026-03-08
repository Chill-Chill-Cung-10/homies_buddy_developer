// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationModel {

/// User ID người **GỬI** / thực hiện action
 String get actorId;/// ⭐ **Thêm mới** — User ID người **NHẬN** notification
 String get recipientId; String get actorName; String get actorAvatar; String get notificationId; NotificationType get type; DateTime get createdAt; bool get isRead; String get postId; String? get commentId; String get deepLink; String? get contentPreview;
/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationModelCopyWith<NotificationModel> get copyWith => _$NotificationModelCopyWithImpl<NotificationModel>(this as NotificationModel, _$identity);

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationModel&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.recipientId, recipientId) || other.recipientId == recipientId)&&(identical(other.actorName, actorName) || other.actorName == actorName)&&(identical(other.actorAvatar, actorAvatar) || other.actorAvatar == actorAvatar)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.commentId, commentId) || other.commentId == commentId)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.contentPreview, contentPreview) || other.contentPreview == contentPreview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actorId,recipientId,actorName,actorAvatar,notificationId,type,createdAt,isRead,postId,commentId,deepLink,contentPreview);

@override
String toString() {
  return 'NotificationModel(actorId: $actorId, recipientId: $recipientId, actorName: $actorName, actorAvatar: $actorAvatar, notificationId: $notificationId, type: $type, createdAt: $createdAt, isRead: $isRead, postId: $postId, commentId: $commentId, deepLink: $deepLink, contentPreview: $contentPreview)';
}


}

/// @nodoc
abstract mixin class $NotificationModelCopyWith<$Res>  {
  factory $NotificationModelCopyWith(NotificationModel value, $Res Function(NotificationModel) _then) = _$NotificationModelCopyWithImpl;
@useResult
$Res call({
 String actorId, String recipientId, String actorName, String actorAvatar, String notificationId, NotificationType type, DateTime createdAt, bool isRead, String postId, String? commentId, String deepLink, String? contentPreview
});




}
/// @nodoc
class _$NotificationModelCopyWithImpl<$Res>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._self, this._then);

  final NotificationModel _self;
  final $Res Function(NotificationModel) _then;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actorId = null,Object? recipientId = null,Object? actorName = null,Object? actorAvatar = null,Object? notificationId = null,Object? type = null,Object? createdAt = null,Object? isRead = null,Object? postId = null,Object? commentId = freezed,Object? deepLink = null,Object? contentPreview = freezed,}) {
  return _then(_self.copyWith(
actorId: null == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String,recipientId: null == recipientId ? _self.recipientId : recipientId // ignore: cast_nullable_to_non_nullable
as String,actorName: null == actorName ? _self.actorName : actorName // ignore: cast_nullable_to_non_nullable
as String,actorAvatar: null == actorAvatar ? _self.actorAvatar : actorAvatar // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,commentId: freezed == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as String?,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,contentPreview: freezed == contentPreview ? _self.contentPreview : contentPreview // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationModel].
extension NotificationModelPatterns on NotificationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String actorId,  String recipientId,  String actorName,  String actorAvatar,  String notificationId,  NotificationType type,  DateTime createdAt,  bool isRead,  String postId,  String? commentId,  String deepLink,  String? contentPreview)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
return $default(_that.actorId,_that.recipientId,_that.actorName,_that.actorAvatar,_that.notificationId,_that.type,_that.createdAt,_that.isRead,_that.postId,_that.commentId,_that.deepLink,_that.contentPreview);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String actorId,  String recipientId,  String actorName,  String actorAvatar,  String notificationId,  NotificationType type,  DateTime createdAt,  bool isRead,  String postId,  String? commentId,  String deepLink,  String? contentPreview)  $default,) {final _that = this;
switch (_that) {
case _NotificationModel():
return $default(_that.actorId,_that.recipientId,_that.actorName,_that.actorAvatar,_that.notificationId,_that.type,_that.createdAt,_that.isRead,_that.postId,_that.commentId,_that.deepLink,_that.contentPreview);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String actorId,  String recipientId,  String actorName,  String actorAvatar,  String notificationId,  NotificationType type,  DateTime createdAt,  bool isRead,  String postId,  String? commentId,  String deepLink,  String? contentPreview)?  $default,) {final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
return $default(_that.actorId,_that.recipientId,_that.actorName,_that.actorAvatar,_that.notificationId,_that.type,_that.createdAt,_that.isRead,_that.postId,_that.commentId,_that.deepLink,_that.contentPreview);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationModel implements NotificationModel {
  const _NotificationModel({required this.actorId, required this.recipientId, required this.actorName, required this.actorAvatar, required this.notificationId, required this.type, required this.createdAt, required this.isRead, required this.postId, this.commentId, required this.deepLink, this.contentPreview});
  factory _NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

/// User ID người **GỬI** / thực hiện action
@override final  String actorId;
/// ⭐ **Thêm mới** — User ID người **NHẬN** notification
@override final  String recipientId;
@override final  String actorName;
@override final  String actorAvatar;
@override final  String notificationId;
@override final  NotificationType type;
@override final  DateTime createdAt;
@override final  bool isRead;
@override final  String postId;
@override final  String? commentId;
@override final  String deepLink;
@override final  String? contentPreview;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationModelCopyWith<_NotificationModel> get copyWith => __$NotificationModelCopyWithImpl<_NotificationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationModel&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.recipientId, recipientId) || other.recipientId == recipientId)&&(identical(other.actorName, actorName) || other.actorName == actorName)&&(identical(other.actorAvatar, actorAvatar) || other.actorAvatar == actorAvatar)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.commentId, commentId) || other.commentId == commentId)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.contentPreview, contentPreview) || other.contentPreview == contentPreview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actorId,recipientId,actorName,actorAvatar,notificationId,type,createdAt,isRead,postId,commentId,deepLink,contentPreview);

@override
String toString() {
  return 'NotificationModel(actorId: $actorId, recipientId: $recipientId, actorName: $actorName, actorAvatar: $actorAvatar, notificationId: $notificationId, type: $type, createdAt: $createdAt, isRead: $isRead, postId: $postId, commentId: $commentId, deepLink: $deepLink, contentPreview: $contentPreview)';
}


}

/// @nodoc
abstract mixin class _$NotificationModelCopyWith<$Res> implements $NotificationModelCopyWith<$Res> {
  factory _$NotificationModelCopyWith(_NotificationModel value, $Res Function(_NotificationModel) _then) = __$NotificationModelCopyWithImpl;
@override @useResult
$Res call({
 String actorId, String recipientId, String actorName, String actorAvatar, String notificationId, NotificationType type, DateTime createdAt, bool isRead, String postId, String? commentId, String deepLink, String? contentPreview
});




}
/// @nodoc
class __$NotificationModelCopyWithImpl<$Res>
    implements _$NotificationModelCopyWith<$Res> {
  __$NotificationModelCopyWithImpl(this._self, this._then);

  final _NotificationModel _self;
  final $Res Function(_NotificationModel) _then;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actorId = null,Object? recipientId = null,Object? actorName = null,Object? actorAvatar = null,Object? notificationId = null,Object? type = null,Object? createdAt = null,Object? isRead = null,Object? postId = null,Object? commentId = freezed,Object? deepLink = null,Object? contentPreview = freezed,}) {
  return _then(_NotificationModel(
actorId: null == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String,recipientId: null == recipientId ? _self.recipientId : recipientId // ignore: cast_nullable_to_non_nullable
as String,actorName: null == actorName ? _self.actorName : actorName // ignore: cast_nullable_to_non_nullable
as String,actorAvatar: null == actorAvatar ? _self.actorAvatar : actorAvatar // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,commentId: freezed == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as String?,deepLink: null == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String,contentPreview: freezed == contentPreview ? _self.contentPreview : contentPreview // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
