// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_follows_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserFollow {

/// User ID người follow
 String get followerId;/// User ID người được follow
 String get followingId;/// Thời gian follow
 DateTime get createdAt;
/// Create a copy of UserFollow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserFollowCopyWith<UserFollow> get copyWith => _$UserFollowCopyWithImpl<UserFollow>(this as UserFollow, _$identity);

  /// Serializes this UserFollow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserFollow&&(identical(other.followerId, followerId) || other.followerId == followerId)&&(identical(other.followingId, followingId) || other.followingId == followingId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,followerId,followingId,createdAt);

@override
String toString() {
  return 'UserFollow(followerId: $followerId, followingId: $followingId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserFollowCopyWith<$Res>  {
  factory $UserFollowCopyWith(UserFollow value, $Res Function(UserFollow) _then) = _$UserFollowCopyWithImpl;
@useResult
$Res call({
 String followerId, String followingId, DateTime createdAt
});




}
/// @nodoc
class _$UserFollowCopyWithImpl<$Res>
    implements $UserFollowCopyWith<$Res> {
  _$UserFollowCopyWithImpl(this._self, this._then);

  final UserFollow _self;
  final $Res Function(UserFollow) _then;

/// Create a copy of UserFollow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? followerId = null,Object? followingId = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
followerId: null == followerId ? _self.followerId : followerId // ignore: cast_nullable_to_non_nullable
as String,followingId: null == followingId ? _self.followingId : followingId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserFollow].
extension UserFollowPatterns on UserFollow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserFollow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserFollow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserFollow value)  $default,){
final _that = this;
switch (_that) {
case _UserFollow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserFollow value)?  $default,){
final _that = this;
switch (_that) {
case _UserFollow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String followerId,  String followingId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserFollow() when $default != null:
return $default(_that.followerId,_that.followingId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String followerId,  String followingId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserFollow():
return $default(_that.followerId,_that.followingId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String followerId,  String followingId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserFollow() when $default != null:
return $default(_that.followerId,_that.followingId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserFollow implements UserFollow {
  const _UserFollow({required this.followerId, required this.followingId, required this.createdAt});
  factory _UserFollow.fromJson(Map<String, dynamic> json) => _$UserFollowFromJson(json);

/// User ID người follow
@override final  String followerId;
/// User ID người được follow
@override final  String followingId;
/// Thời gian follow
@override final  DateTime createdAt;

/// Create a copy of UserFollow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserFollowCopyWith<_UserFollow> get copyWith => __$UserFollowCopyWithImpl<_UserFollow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserFollowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserFollow&&(identical(other.followerId, followerId) || other.followerId == followerId)&&(identical(other.followingId, followingId) || other.followingId == followingId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,followerId,followingId,createdAt);

@override
String toString() {
  return 'UserFollow(followerId: $followerId, followingId: $followingId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserFollowCopyWith<$Res> implements $UserFollowCopyWith<$Res> {
  factory _$UserFollowCopyWith(_UserFollow value, $Res Function(_UserFollow) _then) = __$UserFollowCopyWithImpl;
@override @useResult
$Res call({
 String followerId, String followingId, DateTime createdAt
});




}
/// @nodoc
class __$UserFollowCopyWithImpl<$Res>
    implements _$UserFollowCopyWith<$Res> {
  __$UserFollowCopyWithImpl(this._self, this._then);

  final _UserFollow _self;
  final $Res Function(_UserFollow) _then;

/// Create a copy of UserFollow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? followerId = null,Object? followingId = null,Object? createdAt = null,}) {
  return _then(_UserFollow(
followerId: null == followerId ? _self.followerId : followerId // ignore: cast_nullable_to_non_nullable
as String,followingId: null == followingId ? _self.followingId : followingId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
