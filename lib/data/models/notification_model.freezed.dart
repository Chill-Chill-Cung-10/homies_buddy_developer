// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  String get actorId => throw _privateConstructorUsedError;
  String get actorName => throw _privateConstructorUsedError;
  String get actorAvatar => throw _privateConstructorUsedError;
  String get notificationId => throw _privateConstructorUsedError;
  NotificationType get type => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String? get commentId => throw _privateConstructorUsedError;
  String get deepLink => throw _privateConstructorUsedError;
  String? get contentPreview => throw _privateConstructorUsedError;

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
    NotificationModel value,
    $Res Function(NotificationModel) then,
  ) = _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call({
    String actorId,
    String actorName,
    String actorAvatar,
    String notificationId,
    NotificationType type,
    DateTime createdAt,
    bool isRead,
    String postId,
    String? commentId,
    String deepLink,
    String? contentPreview,
  });
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actorId = null,
    Object? actorName = null,
    Object? actorAvatar = null,
    Object? notificationId = null,
    Object? type = null,
    Object? createdAt = null,
    Object? isRead = null,
    Object? postId = null,
    Object? commentId = freezed,
    Object? deepLink = null,
    Object? contentPreview = freezed,
  }) {
    return _then(
      _value.copyWith(
            actorId: null == actorId
                ? _value.actorId
                : actorId // ignore: cast_nullable_to_non_nullable
                      as String,
            actorName: null == actorName
                ? _value.actorName
                : actorName // ignore: cast_nullable_to_non_nullable
                      as String,
            actorAvatar: null == actorAvatar
                ? _value.actorAvatar
                : actorAvatar // ignore: cast_nullable_to_non_nullable
                      as String,
            notificationId: null == notificationId
                ? _value.notificationId
                : notificationId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as NotificationType,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            postId: null == postId
                ? _value.postId
                : postId // ignore: cast_nullable_to_non_nullable
                      as String,
            commentId: freezed == commentId
                ? _value.commentId
                : commentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            deepLink: null == deepLink
                ? _value.deepLink
                : deepLink // ignore: cast_nullable_to_non_nullable
                      as String,
            contentPreview: freezed == contentPreview
                ? _value.contentPreview
                : contentPreview // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(
    _$NotificationModelImpl value,
    $Res Function(_$NotificationModelImpl) then,
  ) = __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String actorId,
    String actorName,
    String actorAvatar,
    String notificationId,
    NotificationType type,
    DateTime createdAt,
    bool isRead,
    String postId,
    String? commentId,
    String deepLink,
    String? contentPreview,
  });
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(
    _$NotificationModelImpl _value,
    $Res Function(_$NotificationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actorId = null,
    Object? actorName = null,
    Object? actorAvatar = null,
    Object? notificationId = null,
    Object? type = null,
    Object? createdAt = null,
    Object? isRead = null,
    Object? postId = null,
    Object? commentId = freezed,
    Object? deepLink = null,
    Object? contentPreview = freezed,
  }) {
    return _then(
      _$NotificationModelImpl(
        actorId: null == actorId
            ? _value.actorId
            : actorId // ignore: cast_nullable_to_non_nullable
                  as String,
        actorName: null == actorName
            ? _value.actorName
            : actorName // ignore: cast_nullable_to_non_nullable
                  as String,
        actorAvatar: null == actorAvatar
            ? _value.actorAvatar
            : actorAvatar // ignore: cast_nullable_to_non_nullable
                  as String,
        notificationId: null == notificationId
            ? _value.notificationId
            : notificationId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as NotificationType,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        postId: null == postId
            ? _value.postId
            : postId // ignore: cast_nullable_to_non_nullable
                  as String,
        commentId: freezed == commentId
            ? _value.commentId
            : commentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        deepLink: null == deepLink
            ? _value.deepLink
            : deepLink // ignore: cast_nullable_to_non_nullable
                  as String,
        contentPreview: freezed == contentPreview
            ? _value.contentPreview
            : contentPreview // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl implements _NotificationModel {
  const _$NotificationModelImpl({
    required this.actorId,
    required this.actorName,
    required this.actorAvatar,
    required this.notificationId,
    required this.type,
    required this.createdAt,
    required this.isRead,
    required this.postId,
    this.commentId,
    required this.deepLink,
    this.contentPreview,
  });

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  final String actorId;
  @override
  final String actorName;
  @override
  final String actorAvatar;
  @override
  final String notificationId;
  @override
  final NotificationType type;
  @override
  final DateTime createdAt;
  @override
  final bool isRead;
  @override
  final String postId;
  @override
  final String? commentId;
  @override
  final String deepLink;
  @override
  final String? contentPreview;

  @override
  String toString() {
    return 'NotificationModel(actorId: $actorId, actorName: $actorName, actorAvatar: $actorAvatar, notificationId: $notificationId, type: $type, createdAt: $createdAt, isRead: $isRead, postId: $postId, commentId: $commentId, deepLink: $deepLink, contentPreview: $contentPreview)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.actorId, actorId) || other.actorId == actorId) &&
            (identical(other.actorName, actorName) ||
                other.actorName == actorName) &&
            (identical(other.actorAvatar, actorAvatar) ||
                other.actorAvatar == actorAvatar) &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId) &&
            (identical(other.deepLink, deepLink) ||
                other.deepLink == deepLink) &&
            (identical(other.contentPreview, contentPreview) ||
                other.contentPreview == contentPreview));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    actorId,
    actorName,
    actorAvatar,
    notificationId,
    type,
    createdAt,
    isRead,
    postId,
    commentId,
    deepLink,
    contentPreview,
  );

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(this);
  }
}

abstract class _NotificationModel implements NotificationModel {
  const factory _NotificationModel({
    required final String actorId,
    required final String actorName,
    required final String actorAvatar,
    required final String notificationId,
    required final NotificationType type,
    required final DateTime createdAt,
    required final bool isRead,
    required final String postId,
    final String? commentId,
    required final String deepLink,
    final String? contentPreview,
  }) = _$NotificationModelImpl;

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  String get actorId;
  @override
  String get actorName;
  @override
  String get actorAvatar;
  @override
  String get notificationId;
  @override
  NotificationType get type;
  @override
  DateTime get createdAt;
  @override
  bool get isRead;
  @override
  String get postId;
  @override
  String? get commentId;
  @override
  String get deepLink;
  @override
  String? get contentPreview;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
