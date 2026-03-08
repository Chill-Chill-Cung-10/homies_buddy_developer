// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_reacts_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentReact {

/// User ID người react
 String get userId;/// Comment ID được react
 String get commentId;/// Thời gian react
 DateTime get createdAt;
/// Create a copy of CommentReact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentReactCopyWith<CommentReact> get copyWith => _$CommentReactCopyWithImpl<CommentReact>(this as CommentReact, _$identity);

  /// Serializes this CommentReact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentReact&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.commentId, commentId) || other.commentId == commentId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,commentId,createdAt);

@override
String toString() {
  return 'CommentReact(userId: $userId, commentId: $commentId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CommentReactCopyWith<$Res>  {
  factory $CommentReactCopyWith(CommentReact value, $Res Function(CommentReact) _then) = _$CommentReactCopyWithImpl;
@useResult
$Res call({
 String userId, String commentId, DateTime createdAt
});




}
/// @nodoc
class _$CommentReactCopyWithImpl<$Res>
    implements $CommentReactCopyWith<$Res> {
  _$CommentReactCopyWithImpl(this._self, this._then);

  final CommentReact _self;
  final $Res Function(CommentReact) _then;

/// Create a copy of CommentReact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? commentId = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,commentId: null == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentReact].
extension CommentReactPatterns on CommentReact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentReact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentReact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentReact value)  $default,){
final _that = this;
switch (_that) {
case _CommentReact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentReact value)?  $default,){
final _that = this;
switch (_that) {
case _CommentReact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String commentId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentReact() when $default != null:
return $default(_that.userId,_that.commentId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String commentId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CommentReact():
return $default(_that.userId,_that.commentId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String commentId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CommentReact() when $default != null:
return $default(_that.userId,_that.commentId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentReact implements CommentReact {
  const _CommentReact({required this.userId, required this.commentId, required this.createdAt});
  factory _CommentReact.fromJson(Map<String, dynamic> json) => _$CommentReactFromJson(json);

/// User ID người react
@override final  String userId;
/// Comment ID được react
@override final  String commentId;
/// Thời gian react
@override final  DateTime createdAt;

/// Create a copy of CommentReact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentReactCopyWith<_CommentReact> get copyWith => __$CommentReactCopyWithImpl<_CommentReact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentReactToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentReact&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.commentId, commentId) || other.commentId == commentId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,commentId,createdAt);

@override
String toString() {
  return 'CommentReact(userId: $userId, commentId: $commentId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CommentReactCopyWith<$Res> implements $CommentReactCopyWith<$Res> {
  factory _$CommentReactCopyWith(_CommentReact value, $Res Function(_CommentReact) _then) = __$CommentReactCopyWithImpl;
@override @useResult
$Res call({
 String userId, String commentId, DateTime createdAt
});




}
/// @nodoc
class __$CommentReactCopyWithImpl<$Res>
    implements _$CommentReactCopyWith<$Res> {
  __$CommentReactCopyWithImpl(this._self, this._then);

  final _CommentReact _self;
  final $Res Function(_CommentReact) _then;

/// Create a copy of CommentReact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? commentId = null,Object? createdAt = null,}) {
  return _then(_CommentReact(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,commentId: null == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
