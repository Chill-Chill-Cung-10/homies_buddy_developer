// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Pet {

 String get id; String get userId; String get name; PetAvatarType get avatarType;/// ⚡ Năng lượng bẩm sinh — random lúc tạo, **bất biến**
/// Xác định personality archetype:
/// - < 0.25 → Lazy
/// - 0.25–0.5 → Calm
/// - 0.5–0.75 → Curious
/// - > 0.75 → Hyper
 double get baselineEnergy;/// Năng lượng hiện tại (realtime, decay theo thời gian)
 double get energy;/// Trạng thái cảm xúc hiện tại
 PetMood get currentMood;/// Số ngày liên tiếp user active
 int get streak;/// Lần tương tác cuối — dùng để tính `delta_t`
 DateTime get lastInteractedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetCopyWith<Pet> get copyWith => _$PetCopyWithImpl<Pet>(this as Pet, _$identity);

  /// Serializes this Pet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pet&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarType, avatarType) || other.avatarType == avatarType)&&(identical(other.baselineEnergy, baselineEnergy) || other.baselineEnergy == baselineEnergy)&&(identical(other.energy, energy) || other.energy == energy)&&(identical(other.currentMood, currentMood) || other.currentMood == currentMood)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.lastInteractedAt, lastInteractedAt) || other.lastInteractedAt == lastInteractedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,avatarType,baselineEnergy,energy,currentMood,streak,lastInteractedAt,createdAt,updatedAt);

@override
String toString() {
  return 'Pet(id: $id, userId: $userId, name: $name, avatarType: $avatarType, baselineEnergy: $baselineEnergy, energy: $energy, currentMood: $currentMood, streak: $streak, lastInteractedAt: $lastInteractedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PetCopyWith<$Res>  {
  factory $PetCopyWith(Pet value, $Res Function(Pet) _then) = _$PetCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, PetAvatarType avatarType, double baselineEnergy, double energy, PetMood currentMood, int streak, DateTime lastInteractedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$PetCopyWithImpl<$Res>
    implements $PetCopyWith<$Res> {
  _$PetCopyWithImpl(this._self, this._then);

  final Pet _self;
  final $Res Function(Pet) _then;

/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? avatarType = null,Object? baselineEnergy = null,Object? energy = null,Object? currentMood = null,Object? streak = null,Object? lastInteractedAt = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarType: null == avatarType ? _self.avatarType : avatarType // ignore: cast_nullable_to_non_nullable
as PetAvatarType,baselineEnergy: null == baselineEnergy ? _self.baselineEnergy : baselineEnergy // ignore: cast_nullable_to_non_nullable
as double,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as double,currentMood: null == currentMood ? _self.currentMood : currentMood // ignore: cast_nullable_to_non_nullable
as PetMood,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,lastInteractedAt: null == lastInteractedAt ? _self.lastInteractedAt : lastInteractedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Pet].
extension PetPatterns on Pet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pet value)  $default,){
final _that = this;
switch (_that) {
case _Pet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pet value)?  $default,){
final _that = this;
switch (_that) {
case _Pet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  PetAvatarType avatarType,  double baselineEnergy,  double energy,  PetMood currentMood,  int streak,  DateTime lastInteractedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pet() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.avatarType,_that.baselineEnergy,_that.energy,_that.currentMood,_that.streak,_that.lastInteractedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  PetAvatarType avatarType,  double baselineEnergy,  double energy,  PetMood currentMood,  int streak,  DateTime lastInteractedAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Pet():
return $default(_that.id,_that.userId,_that.name,_that.avatarType,_that.baselineEnergy,_that.energy,_that.currentMood,_that.streak,_that.lastInteractedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  PetAvatarType avatarType,  double baselineEnergy,  double energy,  PetMood currentMood,  int streak,  DateTime lastInteractedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Pet() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.avatarType,_that.baselineEnergy,_that.energy,_that.currentMood,_that.streak,_that.lastInteractedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Pet implements Pet {
  const _Pet({required this.id, required this.userId, required this.name, required this.avatarType, required this.baselineEnergy, required this.energy, required this.currentMood, this.streak = 0, required this.lastInteractedAt, required this.createdAt, required this.updatedAt});
  factory _Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String name;
@override final  PetAvatarType avatarType;
/// ⚡ Năng lượng bẩm sinh — random lúc tạo, **bất biến**
/// Xác định personality archetype:
/// - < 0.25 → Lazy
/// - 0.25–0.5 → Calm
/// - 0.5–0.75 → Curious
/// - > 0.75 → Hyper
@override final  double baselineEnergy;
/// Năng lượng hiện tại (realtime, decay theo thời gian)
@override final  double energy;
/// Trạng thái cảm xúc hiện tại
@override final  PetMood currentMood;
/// Số ngày liên tiếp user active
@override@JsonKey() final  int streak;
/// Lần tương tác cuối — dùng để tính `delta_t`
@override final  DateTime lastInteractedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetCopyWith<_Pet> get copyWith => __$PetCopyWithImpl<_Pet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pet&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarType, avatarType) || other.avatarType == avatarType)&&(identical(other.baselineEnergy, baselineEnergy) || other.baselineEnergy == baselineEnergy)&&(identical(other.energy, energy) || other.energy == energy)&&(identical(other.currentMood, currentMood) || other.currentMood == currentMood)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.lastInteractedAt, lastInteractedAt) || other.lastInteractedAt == lastInteractedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,avatarType,baselineEnergy,energy,currentMood,streak,lastInteractedAt,createdAt,updatedAt);

@override
String toString() {
  return 'Pet(id: $id, userId: $userId, name: $name, avatarType: $avatarType, baselineEnergy: $baselineEnergy, energy: $energy, currentMood: $currentMood, streak: $streak, lastInteractedAt: $lastInteractedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PetCopyWith<$Res> implements $PetCopyWith<$Res> {
  factory _$PetCopyWith(_Pet value, $Res Function(_Pet) _then) = __$PetCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, PetAvatarType avatarType, double baselineEnergy, double energy, PetMood currentMood, int streak, DateTime lastInteractedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$PetCopyWithImpl<$Res>
    implements _$PetCopyWith<$Res> {
  __$PetCopyWithImpl(this._self, this._then);

  final _Pet _self;
  final $Res Function(_Pet) _then;

/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? avatarType = null,Object? baselineEnergy = null,Object? energy = null,Object? currentMood = null,Object? streak = null,Object? lastInteractedAt = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Pet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarType: null == avatarType ? _self.avatarType : avatarType // ignore: cast_nullable_to_non_nullable
as PetAvatarType,baselineEnergy: null == baselineEnergy ? _self.baselineEnergy : baselineEnergy // ignore: cast_nullable_to_non_nullable
as double,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as double,currentMood: null == currentMood ? _self.currentMood : currentMood // ignore: cast_nullable_to_non_nullable
as PetMood,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,lastInteractedAt: null == lastInteractedAt ? _self.lastInteractedAt : lastInteractedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
