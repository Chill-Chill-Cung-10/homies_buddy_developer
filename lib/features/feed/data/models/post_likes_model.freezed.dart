// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_likes_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostLike {

/// User ID người like
 String get userId;/// Post ID được like
 String get postId;/// Thời gian like
 DateTime get createdAt;
/// Create a copy of PostLike
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostLikeCopyWith<PostLike> get copyWith => _$PostLikeCopyWithImpl<PostLike>(this as PostLike, _$identity);

  /// Serializes this PostLike to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostLike&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,postId,createdAt);

@override
String toString() {
  return 'PostLike(userId: $userId, postId: $postId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PostLikeCopyWith<$Res>  {
  factory $PostLikeCopyWith(PostLike value, $Res Function(PostLike) _then) = _$PostLikeCopyWithImpl;
@useResult
$Res call({
 String userId, String postId, DateTime createdAt
});




}
/// @nodoc
class _$PostLikeCopyWithImpl<$Res>
    implements $PostLikeCopyWith<$Res> {
  _$PostLikeCopyWithImpl(this._self, this._then);

  final PostLike _self;
  final $Res Function(PostLike) _then;

/// Create a copy of PostLike
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? postId = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PostLike].
extension PostLikePatterns on PostLike {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostLike value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostLike() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostLike value)  $default,){
final _that = this;
switch (_that) {
case _PostLike():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostLike value)?  $default,){
final _that = this;
switch (_that) {
case _PostLike() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String postId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostLike() when $default != null:
return $default(_that.userId,_that.postId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String postId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PostLike():
return $default(_that.userId,_that.postId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String postId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PostLike() when $default != null:
return $default(_that.userId,_that.postId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostLike implements PostLike {
  const _PostLike({required this.userId, required this.postId, required this.createdAt});
  factory _PostLike.fromJson(Map<String, dynamic> json) => _$PostLikeFromJson(json);

/// User ID người like
@override final  String userId;
/// Post ID được like
@override final  String postId;
/// Thời gian like
@override final  DateTime createdAt;

/// Create a copy of PostLike
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostLikeCopyWith<_PostLike> get copyWith => __$PostLikeCopyWithImpl<_PostLike>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostLikeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostLike&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,postId,createdAt);

@override
String toString() {
  return 'PostLike(userId: $userId, postId: $postId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PostLikeCopyWith<$Res> implements $PostLikeCopyWith<$Res> {
  factory _$PostLikeCopyWith(_PostLike value, $Res Function(_PostLike) _then) = __$PostLikeCopyWithImpl;
@override @useResult
$Res call({
 String userId, String postId, DateTime createdAt
});




}
/// @nodoc
class __$PostLikeCopyWithImpl<$Res>
    implements _$PostLikeCopyWith<$Res> {
  __$PostLikeCopyWithImpl(this._self, this._then);

  final _PostLike _self;
  final $Res Function(_PostLike) _then;

/// Create a copy of PostLike
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? postId = null,Object? createdAt = null,}) {
  return _then(_PostLike(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
