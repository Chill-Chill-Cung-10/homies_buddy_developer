// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Post {

 String get authorName; String get authorId; String get authorAvatar; String get postId; DateTime get createdAt; DateTime? get updatedAt; String get contentText; List<String> get hashtags; List<String> get mentions; List<MediaFile> get mediaFiles; int get reactsCount; int get commentCount;// ❌ isLikedByMe REMOVED — computed field (query từ POST_LIKES)
 PostPrivacy get privacy;
/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCopyWith<Post> get copyWith => _$PostCopyWithImpl<Post>(this as Post, _$identity);

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Post&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorAvatar, authorAvatar) || other.authorAvatar == authorAvatar)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.contentText, contentText) || other.contentText == contentText)&&const DeepCollectionEquality().equals(other.hashtags, hashtags)&&const DeepCollectionEquality().equals(other.mentions, mentions)&&const DeepCollectionEquality().equals(other.mediaFiles, mediaFiles)&&(identical(other.reactsCount, reactsCount) || other.reactsCount == reactsCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.privacy, privacy) || other.privacy == privacy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,authorName,authorId,authorAvatar,postId,createdAt,updatedAt,contentText,const DeepCollectionEquality().hash(hashtags),const DeepCollectionEquality().hash(mentions),const DeepCollectionEquality().hash(mediaFiles),reactsCount,commentCount,privacy);

@override
String toString() {
  return 'Post(authorName: $authorName, authorId: $authorId, authorAvatar: $authorAvatar, postId: $postId, createdAt: $createdAt, updatedAt: $updatedAt, contentText: $contentText, hashtags: $hashtags, mentions: $mentions, mediaFiles: $mediaFiles, reactsCount: $reactsCount, commentCount: $commentCount, privacy: $privacy)';
}


}

/// @nodoc
abstract mixin class $PostCopyWith<$Res>  {
  factory $PostCopyWith(Post value, $Res Function(Post) _then) = _$PostCopyWithImpl;
@useResult
$Res call({
 String authorName, String authorId, String authorAvatar, String postId, DateTime createdAt, DateTime? updatedAt, String contentText, List<String> hashtags, List<String> mentions, List<MediaFile> mediaFiles, int reactsCount, int commentCount, PostPrivacy privacy
});




}
/// @nodoc
class _$PostCopyWithImpl<$Res>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._self, this._then);

  final Post _self;
  final $Res Function(Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authorName = null,Object? authorId = null,Object? authorAvatar = null,Object? postId = null,Object? createdAt = null,Object? updatedAt = freezed,Object? contentText = null,Object? hashtags = null,Object? mentions = null,Object? mediaFiles = null,Object? reactsCount = null,Object? commentCount = null,Object? privacy = null,}) {
  return _then(_self.copyWith(
authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,authorAvatar: null == authorAvatar ? _self.authorAvatar : authorAvatar // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,contentText: null == contentText ? _self.contentText : contentText // ignore: cast_nullable_to_non_nullable
as String,hashtags: null == hashtags ? _self.hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<String>,mentions: null == mentions ? _self.mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<String>,mediaFiles: null == mediaFiles ? _self.mediaFiles : mediaFiles // ignore: cast_nullable_to_non_nullable
as List<MediaFile>,reactsCount: null == reactsCount ? _self.reactsCount : reactsCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,privacy: null == privacy ? _self.privacy : privacy // ignore: cast_nullable_to_non_nullable
as PostPrivacy,
  ));
}

}


/// Adds pattern-matching-related methods to [Post].
extension PostPatterns on Post {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Post value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Post() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Post value)  $default,){
final _that = this;
switch (_that) {
case _Post():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Post value)?  $default,){
final _that = this;
switch (_that) {
case _Post() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String authorName,  String authorId,  String authorAvatar,  String postId,  DateTime createdAt,  DateTime? updatedAt,  String contentText,  List<String> hashtags,  List<String> mentions,  List<MediaFile> mediaFiles,  int reactsCount,  int commentCount,  PostPrivacy privacy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that.authorName,_that.authorId,_that.authorAvatar,_that.postId,_that.createdAt,_that.updatedAt,_that.contentText,_that.hashtags,_that.mentions,_that.mediaFiles,_that.reactsCount,_that.commentCount,_that.privacy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String authorName,  String authorId,  String authorAvatar,  String postId,  DateTime createdAt,  DateTime? updatedAt,  String contentText,  List<String> hashtags,  List<String> mentions,  List<MediaFile> mediaFiles,  int reactsCount,  int commentCount,  PostPrivacy privacy)  $default,) {final _that = this;
switch (_that) {
case _Post():
return $default(_that.authorName,_that.authorId,_that.authorAvatar,_that.postId,_that.createdAt,_that.updatedAt,_that.contentText,_that.hashtags,_that.mentions,_that.mediaFiles,_that.reactsCount,_that.commentCount,_that.privacy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String authorName,  String authorId,  String authorAvatar,  String postId,  DateTime createdAt,  DateTime? updatedAt,  String contentText,  List<String> hashtags,  List<String> mentions,  List<MediaFile> mediaFiles,  int reactsCount,  int commentCount,  PostPrivacy privacy)?  $default,) {final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that.authorName,_that.authorId,_that.authorAvatar,_that.postId,_that.createdAt,_that.updatedAt,_that.contentText,_that.hashtags,_that.mentions,_that.mediaFiles,_that.reactsCount,_that.commentCount,_that.privacy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Post implements Post {
  const _Post({required this.authorName, required this.authorId, required this.authorAvatar, required this.postId, required this.createdAt, this.updatedAt, required this.contentText, required final  List<String> hashtags, required final  List<String> mentions, required final  List<MediaFile> mediaFiles, required this.reactsCount, required this.commentCount, required this.privacy}): _hashtags = hashtags,_mentions = mentions,_mediaFiles = mediaFiles;
  factory _Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

@override final  String authorName;
@override final  String authorId;
@override final  String authorAvatar;
@override final  String postId;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;
@override final  String contentText;
 final  List<String> _hashtags;
@override List<String> get hashtags {
  if (_hashtags is EqualUnmodifiableListView) return _hashtags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hashtags);
}

 final  List<String> _mentions;
@override List<String> get mentions {
  if (_mentions is EqualUnmodifiableListView) return _mentions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mentions);
}

 final  List<MediaFile> _mediaFiles;
@override List<MediaFile> get mediaFiles {
  if (_mediaFiles is EqualUnmodifiableListView) return _mediaFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaFiles);
}

@override final  int reactsCount;
@override final  int commentCount;
// ❌ isLikedByMe REMOVED — computed field (query từ POST_LIKES)
@override final  PostPrivacy privacy;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCopyWith<_Post> get copyWith => __$PostCopyWithImpl<_Post>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Post&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorAvatar, authorAvatar) || other.authorAvatar == authorAvatar)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.contentText, contentText) || other.contentText == contentText)&&const DeepCollectionEquality().equals(other._hashtags, _hashtags)&&const DeepCollectionEquality().equals(other._mentions, _mentions)&&const DeepCollectionEquality().equals(other._mediaFiles, _mediaFiles)&&(identical(other.reactsCount, reactsCount) || other.reactsCount == reactsCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.privacy, privacy) || other.privacy == privacy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,authorName,authorId,authorAvatar,postId,createdAt,updatedAt,contentText,const DeepCollectionEquality().hash(_hashtags),const DeepCollectionEquality().hash(_mentions),const DeepCollectionEquality().hash(_mediaFiles),reactsCount,commentCount,privacy);

@override
String toString() {
  return 'Post(authorName: $authorName, authorId: $authorId, authorAvatar: $authorAvatar, postId: $postId, createdAt: $createdAt, updatedAt: $updatedAt, contentText: $contentText, hashtags: $hashtags, mentions: $mentions, mediaFiles: $mediaFiles, reactsCount: $reactsCount, commentCount: $commentCount, privacy: $privacy)';
}


}

/// @nodoc
abstract mixin class _$PostCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$PostCopyWith(_Post value, $Res Function(_Post) _then) = __$PostCopyWithImpl;
@override @useResult
$Res call({
 String authorName, String authorId, String authorAvatar, String postId, DateTime createdAt, DateTime? updatedAt, String contentText, List<String> hashtags, List<String> mentions, List<MediaFile> mediaFiles, int reactsCount, int commentCount, PostPrivacy privacy
});




}
/// @nodoc
class __$PostCopyWithImpl<$Res>
    implements _$PostCopyWith<$Res> {
  __$PostCopyWithImpl(this._self, this._then);

  final _Post _self;
  final $Res Function(_Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authorName = null,Object? authorId = null,Object? authorAvatar = null,Object? postId = null,Object? createdAt = null,Object? updatedAt = freezed,Object? contentText = null,Object? hashtags = null,Object? mentions = null,Object? mediaFiles = null,Object? reactsCount = null,Object? commentCount = null,Object? privacy = null,}) {
  return _then(_Post(
authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,authorAvatar: null == authorAvatar ? _self.authorAvatar : authorAvatar // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,contentText: null == contentText ? _self.contentText : contentText // ignore: cast_nullable_to_non_nullable
as String,hashtags: null == hashtags ? _self._hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<String>,mentions: null == mentions ? _self._mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<String>,mediaFiles: null == mediaFiles ? _self._mediaFiles : mediaFiles // ignore: cast_nullable_to_non_nullable
as List<MediaFile>,reactsCount: null == reactsCount ? _self.reactsCount : reactsCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,privacy: null == privacy ? _self.privacy : privacy // ignore: cast_nullable_to_non_nullable
as PostPrivacy,
  ));
}


}

// dart format on
