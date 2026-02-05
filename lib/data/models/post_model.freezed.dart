// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Post _$PostFromJson(Map<String, dynamic> json) {
  return _Post.fromJson(json);
}

/// @nodoc
mixin _$Post {
  String get authorName => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorAvatar => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String get contentText => throw _privateConstructorUsedError;
  List<String> get hashtags => throw _privateConstructorUsedError;
  List<String> get mentions => throw _privateConstructorUsedError;
  List<MediaFile> get mediaFiles => throw _privateConstructorUsedError;
  int get reactsCount => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  bool get isLikedByMe => throw _privateConstructorUsedError;
  PostPrivacy get privacy => throw _privateConstructorUsedError;

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostCopyWith<Post> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) then) =
      _$PostCopyWithImpl<$Res, Post>;
  @useResult
  $Res call({
    String authorName,
    String authorId,
    String authorAvatar,
    String postId,
    DateTime createdAt,
    DateTime? updatedAt,
    String contentText,
    List<String> hashtags,
    List<String> mentions,
    List<MediaFile> mediaFiles,
    int reactsCount,
    int commentCount,
    bool isLikedByMe,
    PostPrivacy privacy,
  });
}

/// @nodoc
class _$PostCopyWithImpl<$Res, $Val extends Post>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authorName = null,
    Object? authorId = null,
    Object? authorAvatar = null,
    Object? postId = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? contentText = null,
    Object? hashtags = null,
    Object? mentions = null,
    Object? mediaFiles = null,
    Object? reactsCount = null,
    Object? commentCount = null,
    Object? isLikedByMe = null,
    Object? privacy = null,
  }) {
    return _then(
      _value.copyWith(
            authorName: null == authorName
                ? _value.authorName
                : authorName // ignore: cast_nullable_to_non_nullable
                      as String,
            authorId: null == authorId
                ? _value.authorId
                : authorId // ignore: cast_nullable_to_non_nullable
                      as String,
            authorAvatar: null == authorAvatar
                ? _value.authorAvatar
                : authorAvatar // ignore: cast_nullable_to_non_nullable
                      as String,
            postId: null == postId
                ? _value.postId
                : postId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            contentText: null == contentText
                ? _value.contentText
                : contentText // ignore: cast_nullable_to_non_nullable
                      as String,
            hashtags: null == hashtags
                ? _value.hashtags
                : hashtags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            mentions: null == mentions
                ? _value.mentions
                : mentions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            mediaFiles: null == mediaFiles
                ? _value.mediaFiles
                : mediaFiles // ignore: cast_nullable_to_non_nullable
                      as List<MediaFile>,
            reactsCount: null == reactsCount
                ? _value.reactsCount
                : reactsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            commentCount: null == commentCount
                ? _value.commentCount
                : commentCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isLikedByMe: null == isLikedByMe
                ? _value.isLikedByMe
                : isLikedByMe // ignore: cast_nullable_to_non_nullable
                      as bool,
            privacy: null == privacy
                ? _value.privacy
                : privacy // ignore: cast_nullable_to_non_nullable
                      as PostPrivacy,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostImplCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$$PostImplCopyWith(
    _$PostImpl value,
    $Res Function(_$PostImpl) then,
  ) = __$$PostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String authorName,
    String authorId,
    String authorAvatar,
    String postId,
    DateTime createdAt,
    DateTime? updatedAt,
    String contentText,
    List<String> hashtags,
    List<String> mentions,
    List<MediaFile> mediaFiles,
    int reactsCount,
    int commentCount,
    bool isLikedByMe,
    PostPrivacy privacy,
  });
}

/// @nodoc
class __$$PostImplCopyWithImpl<$Res>
    extends _$PostCopyWithImpl<$Res, _$PostImpl>
    implements _$$PostImplCopyWith<$Res> {
  __$$PostImplCopyWithImpl(_$PostImpl _value, $Res Function(_$PostImpl) _then)
    : super(_value, _then);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authorName = null,
    Object? authorId = null,
    Object? authorAvatar = null,
    Object? postId = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? contentText = null,
    Object? hashtags = null,
    Object? mentions = null,
    Object? mediaFiles = null,
    Object? reactsCount = null,
    Object? commentCount = null,
    Object? isLikedByMe = null,
    Object? privacy = null,
  }) {
    return _then(
      _$PostImpl(
        authorName: null == authorName
            ? _value.authorName
            : authorName // ignore: cast_nullable_to_non_nullable
                  as String,
        authorId: null == authorId
            ? _value.authorId
            : authorId // ignore: cast_nullable_to_non_nullable
                  as String,
        authorAvatar: null == authorAvatar
            ? _value.authorAvatar
            : authorAvatar // ignore: cast_nullable_to_non_nullable
                  as String,
        postId: null == postId
            ? _value.postId
            : postId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        contentText: null == contentText
            ? _value.contentText
            : contentText // ignore: cast_nullable_to_non_nullable
                  as String,
        hashtags: null == hashtags
            ? _value._hashtags
            : hashtags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        mentions: null == mentions
            ? _value._mentions
            : mentions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        mediaFiles: null == mediaFiles
            ? _value._mediaFiles
            : mediaFiles // ignore: cast_nullable_to_non_nullable
                  as List<MediaFile>,
        reactsCount: null == reactsCount
            ? _value.reactsCount
            : reactsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        commentCount: null == commentCount
            ? _value.commentCount
            : commentCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isLikedByMe: null == isLikedByMe
            ? _value.isLikedByMe
            : isLikedByMe // ignore: cast_nullable_to_non_nullable
                  as bool,
        privacy: null == privacy
            ? _value.privacy
            : privacy // ignore: cast_nullable_to_non_nullable
                  as PostPrivacy,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostImpl implements _Post {
  const _$PostImpl({
    required this.authorName,
    required this.authorId,
    required this.authorAvatar,
    required this.postId,
    required this.createdAt,
    this.updatedAt,
    required this.contentText,
    required final List<String> hashtags,
    required final List<String> mentions,
    required final List<MediaFile> mediaFiles,
    required this.reactsCount,
    required this.commentCount,
    required this.isLikedByMe,
    required this.privacy,
  }) : _hashtags = hashtags,
       _mentions = mentions,
       _mediaFiles = mediaFiles;

  factory _$PostImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostImplFromJson(json);

  @override
  final String authorName;
  @override
  final String authorId;
  @override
  final String authorAvatar;
  @override
  final String postId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String contentText;
  final List<String> _hashtags;
  @override
  List<String> get hashtags {
    if (_hashtags is EqualUnmodifiableListView) return _hashtags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hashtags);
  }

  final List<String> _mentions;
  @override
  List<String> get mentions {
    if (_mentions is EqualUnmodifiableListView) return _mentions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mentions);
  }

  final List<MediaFile> _mediaFiles;
  @override
  List<MediaFile> get mediaFiles {
    if (_mediaFiles is EqualUnmodifiableListView) return _mediaFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mediaFiles);
  }

  @override
  final int reactsCount;
  @override
  final int commentCount;
  @override
  final bool isLikedByMe;
  @override
  final PostPrivacy privacy;

  @override
  String toString() {
    return 'Post(authorName: $authorName, authorId: $authorId, authorAvatar: $authorAvatar, postId: $postId, createdAt: $createdAt, updatedAt: $updatedAt, contentText: $contentText, hashtags: $hashtags, mentions: $mentions, mediaFiles: $mediaFiles, reactsCount: $reactsCount, commentCount: $commentCount, isLikedByMe: $isLikedByMe, privacy: $privacy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostImpl &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorAvatar, authorAvatar) ||
                other.authorAvatar == authorAvatar) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.contentText, contentText) ||
                other.contentText == contentText) &&
            const DeepCollectionEquality().equals(other._hashtags, _hashtags) &&
            const DeepCollectionEquality().equals(other._mentions, _mentions) &&
            const DeepCollectionEquality().equals(
              other._mediaFiles,
              _mediaFiles,
            ) &&
            (identical(other.reactsCount, reactsCount) ||
                other.reactsCount == reactsCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.isLikedByMe, isLikedByMe) ||
                other.isLikedByMe == isLikedByMe) &&
            (identical(other.privacy, privacy) || other.privacy == privacy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    authorName,
    authorId,
    authorAvatar,
    postId,
    createdAt,
    updatedAt,
    contentText,
    const DeepCollectionEquality().hash(_hashtags),
    const DeepCollectionEquality().hash(_mentions),
    const DeepCollectionEquality().hash(_mediaFiles),
    reactsCount,
    commentCount,
    isLikedByMe,
    privacy,
  );

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      __$$PostImplCopyWithImpl<_$PostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostImplToJson(this);
  }
}

abstract class _Post implements Post {
  const factory _Post({
    required final String authorName,
    required final String authorId,
    required final String authorAvatar,
    required final String postId,
    required final DateTime createdAt,
    final DateTime? updatedAt,
    required final String contentText,
    required final List<String> hashtags,
    required final List<String> mentions,
    required final List<MediaFile> mediaFiles,
    required final int reactsCount,
    required final int commentCount,
    required final bool isLikedByMe,
    required final PostPrivacy privacy,
  }) = _$PostImpl;

  factory _Post.fromJson(Map<String, dynamic> json) = _$PostImpl.fromJson;

  @override
  String get authorName;
  @override
  String get authorId;
  @override
  String get authorAvatar;
  @override
  String get postId;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String get contentText;
  @override
  List<String> get hashtags;
  @override
  List<String> get mentions;
  @override
  List<MediaFile> get mediaFiles;
  @override
  int get reactsCount;
  @override
  int get commentCount;
  @override
  bool get isLikedByMe;
  @override
  PostPrivacy get privacy;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
