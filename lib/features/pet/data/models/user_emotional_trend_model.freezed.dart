// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_emotional_trend_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserEmotionalTrend {

 String get id;/// User ID — 1 record per user (unique)
 String get userId;/// Xu hướng: improving, declining, stable, volatile
 EmotionalTrend get emotionalTrend;/// Hướng thay đổi cảm xúc (−1.0 → +1.0)
/// -1.0 = hoàn toàn xấu đi
/// 0.0 = ổn định
/// +1.0 = hoàn toàn tốt dần
 double get emotionalMomentum;/// Danh sách tone 7 ngày gần nhất (mảng ordered by date)
 List<UserTone> get toneHistory7d;/// Tone xuất hiện nhiều nhất trong 7 ngày
 UserTone get dominantTone; DateTime get updatedAt;
/// Create a copy of UserEmotionalTrend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserEmotionalTrendCopyWith<UserEmotionalTrend> get copyWith => _$UserEmotionalTrendCopyWithImpl<UserEmotionalTrend>(this as UserEmotionalTrend, _$identity);

  /// Serializes this UserEmotionalTrend to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserEmotionalTrend&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.emotionalTrend, emotionalTrend) || other.emotionalTrend == emotionalTrend)&&(identical(other.emotionalMomentum, emotionalMomentum) || other.emotionalMomentum == emotionalMomentum)&&const DeepCollectionEquality().equals(other.toneHistory7d, toneHistory7d)&&(identical(other.dominantTone, dominantTone) || other.dominantTone == dominantTone)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,emotionalTrend,emotionalMomentum,const DeepCollectionEquality().hash(toneHistory7d),dominantTone,updatedAt);

@override
String toString() {
  return 'UserEmotionalTrend(id: $id, userId: $userId, emotionalTrend: $emotionalTrend, emotionalMomentum: $emotionalMomentum, toneHistory7d: $toneHistory7d, dominantTone: $dominantTone, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserEmotionalTrendCopyWith<$Res>  {
  factory $UserEmotionalTrendCopyWith(UserEmotionalTrend value, $Res Function(UserEmotionalTrend) _then) = _$UserEmotionalTrendCopyWithImpl;
@useResult
$Res call({
 String id, String userId, EmotionalTrend emotionalTrend, double emotionalMomentum, List<UserTone> toneHistory7d, UserTone dominantTone, DateTime updatedAt
});




}
/// @nodoc
class _$UserEmotionalTrendCopyWithImpl<$Res>
    implements $UserEmotionalTrendCopyWith<$Res> {
  _$UserEmotionalTrendCopyWithImpl(this._self, this._then);

  final UserEmotionalTrend _self;
  final $Res Function(UserEmotionalTrend) _then;

/// Create a copy of UserEmotionalTrend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? emotionalTrend = null,Object? emotionalMomentum = null,Object? toneHistory7d = null,Object? dominantTone = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,emotionalTrend: null == emotionalTrend ? _self.emotionalTrend : emotionalTrend // ignore: cast_nullable_to_non_nullable
as EmotionalTrend,emotionalMomentum: null == emotionalMomentum ? _self.emotionalMomentum : emotionalMomentum // ignore: cast_nullable_to_non_nullable
as double,toneHistory7d: null == toneHistory7d ? _self.toneHistory7d : toneHistory7d // ignore: cast_nullable_to_non_nullable
as List<UserTone>,dominantTone: null == dominantTone ? _self.dominantTone : dominantTone // ignore: cast_nullable_to_non_nullable
as UserTone,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserEmotionalTrend].
extension UserEmotionalTrendPatterns on UserEmotionalTrend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserEmotionalTrend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserEmotionalTrend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserEmotionalTrend value)  $default,){
final _that = this;
switch (_that) {
case _UserEmotionalTrend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserEmotionalTrend value)?  $default,){
final _that = this;
switch (_that) {
case _UserEmotionalTrend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  EmotionalTrend emotionalTrend,  double emotionalMomentum,  List<UserTone> toneHistory7d,  UserTone dominantTone,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserEmotionalTrend() when $default != null:
return $default(_that.id,_that.userId,_that.emotionalTrend,_that.emotionalMomentum,_that.toneHistory7d,_that.dominantTone,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  EmotionalTrend emotionalTrend,  double emotionalMomentum,  List<UserTone> toneHistory7d,  UserTone dominantTone,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserEmotionalTrend():
return $default(_that.id,_that.userId,_that.emotionalTrend,_that.emotionalMomentum,_that.toneHistory7d,_that.dominantTone,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  EmotionalTrend emotionalTrend,  double emotionalMomentum,  List<UserTone> toneHistory7d,  UserTone dominantTone,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserEmotionalTrend() when $default != null:
return $default(_that.id,_that.userId,_that.emotionalTrend,_that.emotionalMomentum,_that.toneHistory7d,_that.dominantTone,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserEmotionalTrend implements UserEmotionalTrend {
  const _UserEmotionalTrend({required this.id, required this.userId, required this.emotionalTrend, required this.emotionalMomentum, required final  List<UserTone> toneHistory7d, required this.dominantTone, required this.updatedAt}): _toneHistory7d = toneHistory7d;
  factory _UserEmotionalTrend.fromJson(Map<String, dynamic> json) => _$UserEmotionalTrendFromJson(json);

@override final  String id;
/// User ID — 1 record per user (unique)
@override final  String userId;
/// Xu hướng: improving, declining, stable, volatile
@override final  EmotionalTrend emotionalTrend;
/// Hướng thay đổi cảm xúc (−1.0 → +1.0)
/// -1.0 = hoàn toàn xấu đi
/// 0.0 = ổn định
/// +1.0 = hoàn toàn tốt dần
@override final  double emotionalMomentum;
/// Danh sách tone 7 ngày gần nhất (mảng ordered by date)
 final  List<UserTone> _toneHistory7d;
/// Danh sách tone 7 ngày gần nhất (mảng ordered by date)
@override List<UserTone> get toneHistory7d {
  if (_toneHistory7d is EqualUnmodifiableListView) return _toneHistory7d;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_toneHistory7d);
}

/// Tone xuất hiện nhiều nhất trong 7 ngày
@override final  UserTone dominantTone;
@override final  DateTime updatedAt;

/// Create a copy of UserEmotionalTrend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserEmotionalTrendCopyWith<_UserEmotionalTrend> get copyWith => __$UserEmotionalTrendCopyWithImpl<_UserEmotionalTrend>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserEmotionalTrendToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserEmotionalTrend&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.emotionalTrend, emotionalTrend) || other.emotionalTrend == emotionalTrend)&&(identical(other.emotionalMomentum, emotionalMomentum) || other.emotionalMomentum == emotionalMomentum)&&const DeepCollectionEquality().equals(other._toneHistory7d, _toneHistory7d)&&(identical(other.dominantTone, dominantTone) || other.dominantTone == dominantTone)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,emotionalTrend,emotionalMomentum,const DeepCollectionEquality().hash(_toneHistory7d),dominantTone,updatedAt);

@override
String toString() {
  return 'UserEmotionalTrend(id: $id, userId: $userId, emotionalTrend: $emotionalTrend, emotionalMomentum: $emotionalMomentum, toneHistory7d: $toneHistory7d, dominantTone: $dominantTone, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserEmotionalTrendCopyWith<$Res> implements $UserEmotionalTrendCopyWith<$Res> {
  factory _$UserEmotionalTrendCopyWith(_UserEmotionalTrend value, $Res Function(_UserEmotionalTrend) _then) = __$UserEmotionalTrendCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, EmotionalTrend emotionalTrend, double emotionalMomentum, List<UserTone> toneHistory7d, UserTone dominantTone, DateTime updatedAt
});




}
/// @nodoc
class __$UserEmotionalTrendCopyWithImpl<$Res>
    implements _$UserEmotionalTrendCopyWith<$Res> {
  __$UserEmotionalTrendCopyWithImpl(this._self, this._then);

  final _UserEmotionalTrend _self;
  final $Res Function(_UserEmotionalTrend) _then;

/// Create a copy of UserEmotionalTrend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? emotionalTrend = null,Object? emotionalMomentum = null,Object? toneHistory7d = null,Object? dominantTone = null,Object? updatedAt = null,}) {
  return _then(_UserEmotionalTrend(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,emotionalTrend: null == emotionalTrend ? _self.emotionalTrend : emotionalTrend // ignore: cast_nullable_to_non_nullable
as EmotionalTrend,emotionalMomentum: null == emotionalMomentum ? _self.emotionalMomentum : emotionalMomentum // ignore: cast_nullable_to_non_nullable
as double,toneHistory7d: null == toneHistory7d ? _self._toneHistory7d : toneHistory7d // ignore: cast_nullable_to_non_nullable
as List<UserTone>,dominantTone: null == dominantTone ? _self.dominantTone : dominantTone // ignore: cast_nullable_to_non_nullable
as UserTone,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
