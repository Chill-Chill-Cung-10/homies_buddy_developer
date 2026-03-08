// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_state_snapshot_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PetStateSnapshot {

 String get id; String get petId; String get userId;/// Số giờ kể từ lần tương tác trước
 double get deltaT;/// Số lần mở app trong ngày
 int get visitCountToday;/// Số lần tương tác với pet trong ngày
 int get interactionCountToday;/// Giá trị energy tại thời điểm snapshot
 double get energyAtSnapshot;/// Trạng thái mood tại thời điểm snapshot
 PetMood get moodAtSnapshot;/// Giờ trong ngày (0–23) — dùng cho circadian modifier
 int get timeOfDay; DateTime get recordedAt;
/// Create a copy of PetStateSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetStateSnapshotCopyWith<PetStateSnapshot> get copyWith => _$PetStateSnapshotCopyWithImpl<PetStateSnapshot>(this as PetStateSnapshot, _$identity);

  /// Serializes this PetStateSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PetStateSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.petId, petId) || other.petId == petId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deltaT, deltaT) || other.deltaT == deltaT)&&(identical(other.visitCountToday, visitCountToday) || other.visitCountToday == visitCountToday)&&(identical(other.interactionCountToday, interactionCountToday) || other.interactionCountToday == interactionCountToday)&&(identical(other.energyAtSnapshot, energyAtSnapshot) || other.energyAtSnapshot == energyAtSnapshot)&&(identical(other.moodAtSnapshot, moodAtSnapshot) || other.moodAtSnapshot == moodAtSnapshot)&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,petId,userId,deltaT,visitCountToday,interactionCountToday,energyAtSnapshot,moodAtSnapshot,timeOfDay,recordedAt);

@override
String toString() {
  return 'PetStateSnapshot(id: $id, petId: $petId, userId: $userId, deltaT: $deltaT, visitCountToday: $visitCountToday, interactionCountToday: $interactionCountToday, energyAtSnapshot: $energyAtSnapshot, moodAtSnapshot: $moodAtSnapshot, timeOfDay: $timeOfDay, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $PetStateSnapshotCopyWith<$Res>  {
  factory $PetStateSnapshotCopyWith(PetStateSnapshot value, $Res Function(PetStateSnapshot) _then) = _$PetStateSnapshotCopyWithImpl;
@useResult
$Res call({
 String id, String petId, String userId, double deltaT, int visitCountToday, int interactionCountToday, double energyAtSnapshot, PetMood moodAtSnapshot, int timeOfDay, DateTime recordedAt
});




}
/// @nodoc
class _$PetStateSnapshotCopyWithImpl<$Res>
    implements $PetStateSnapshotCopyWith<$Res> {
  _$PetStateSnapshotCopyWithImpl(this._self, this._then);

  final PetStateSnapshot _self;
  final $Res Function(PetStateSnapshot) _then;

/// Create a copy of PetStateSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? petId = null,Object? userId = null,Object? deltaT = null,Object? visitCountToday = null,Object? interactionCountToday = null,Object? energyAtSnapshot = null,Object? moodAtSnapshot = null,Object? timeOfDay = null,Object? recordedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,petId: null == petId ? _self.petId : petId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deltaT: null == deltaT ? _self.deltaT : deltaT // ignore: cast_nullable_to_non_nullable
as double,visitCountToday: null == visitCountToday ? _self.visitCountToday : visitCountToday // ignore: cast_nullable_to_non_nullable
as int,interactionCountToday: null == interactionCountToday ? _self.interactionCountToday : interactionCountToday // ignore: cast_nullable_to_non_nullable
as int,energyAtSnapshot: null == energyAtSnapshot ? _self.energyAtSnapshot : energyAtSnapshot // ignore: cast_nullable_to_non_nullable
as double,moodAtSnapshot: null == moodAtSnapshot ? _self.moodAtSnapshot : moodAtSnapshot // ignore: cast_nullable_to_non_nullable
as PetMood,timeOfDay: null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as int,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PetStateSnapshot].
extension PetStateSnapshotPatterns on PetStateSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PetStateSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PetStateSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PetStateSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _PetStateSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PetStateSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _PetStateSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String petId,  String userId,  double deltaT,  int visitCountToday,  int interactionCountToday,  double energyAtSnapshot,  PetMood moodAtSnapshot,  int timeOfDay,  DateTime recordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PetStateSnapshot() when $default != null:
return $default(_that.id,_that.petId,_that.userId,_that.deltaT,_that.visitCountToday,_that.interactionCountToday,_that.energyAtSnapshot,_that.moodAtSnapshot,_that.timeOfDay,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String petId,  String userId,  double deltaT,  int visitCountToday,  int interactionCountToday,  double energyAtSnapshot,  PetMood moodAtSnapshot,  int timeOfDay,  DateTime recordedAt)  $default,) {final _that = this;
switch (_that) {
case _PetStateSnapshot():
return $default(_that.id,_that.petId,_that.userId,_that.deltaT,_that.visitCountToday,_that.interactionCountToday,_that.energyAtSnapshot,_that.moodAtSnapshot,_that.timeOfDay,_that.recordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String petId,  String userId,  double deltaT,  int visitCountToday,  int interactionCountToday,  double energyAtSnapshot,  PetMood moodAtSnapshot,  int timeOfDay,  DateTime recordedAt)?  $default,) {final _that = this;
switch (_that) {
case _PetStateSnapshot() when $default != null:
return $default(_that.id,_that.petId,_that.userId,_that.deltaT,_that.visitCountToday,_that.interactionCountToday,_that.energyAtSnapshot,_that.moodAtSnapshot,_that.timeOfDay,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PetStateSnapshot implements PetStateSnapshot {
  const _PetStateSnapshot({required this.id, required this.petId, required this.userId, required this.deltaT, required this.visitCountToday, required this.interactionCountToday, required this.energyAtSnapshot, required this.moodAtSnapshot, required this.timeOfDay, required this.recordedAt});
  factory _PetStateSnapshot.fromJson(Map<String, dynamic> json) => _$PetStateSnapshotFromJson(json);

@override final  String id;
@override final  String petId;
@override final  String userId;
/// Số giờ kể từ lần tương tác trước
@override final  double deltaT;
/// Số lần mở app trong ngày
@override final  int visitCountToday;
/// Số lần tương tác với pet trong ngày
@override final  int interactionCountToday;
/// Giá trị energy tại thời điểm snapshot
@override final  double energyAtSnapshot;
/// Trạng thái mood tại thời điểm snapshot
@override final  PetMood moodAtSnapshot;
/// Giờ trong ngày (0–23) — dùng cho circadian modifier
@override final  int timeOfDay;
@override final  DateTime recordedAt;

/// Create a copy of PetStateSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetStateSnapshotCopyWith<_PetStateSnapshot> get copyWith => __$PetStateSnapshotCopyWithImpl<_PetStateSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PetStateSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PetStateSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.petId, petId) || other.petId == petId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deltaT, deltaT) || other.deltaT == deltaT)&&(identical(other.visitCountToday, visitCountToday) || other.visitCountToday == visitCountToday)&&(identical(other.interactionCountToday, interactionCountToday) || other.interactionCountToday == interactionCountToday)&&(identical(other.energyAtSnapshot, energyAtSnapshot) || other.energyAtSnapshot == energyAtSnapshot)&&(identical(other.moodAtSnapshot, moodAtSnapshot) || other.moodAtSnapshot == moodAtSnapshot)&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,petId,userId,deltaT,visitCountToday,interactionCountToday,energyAtSnapshot,moodAtSnapshot,timeOfDay,recordedAt);

@override
String toString() {
  return 'PetStateSnapshot(id: $id, petId: $petId, userId: $userId, deltaT: $deltaT, visitCountToday: $visitCountToday, interactionCountToday: $interactionCountToday, energyAtSnapshot: $energyAtSnapshot, moodAtSnapshot: $moodAtSnapshot, timeOfDay: $timeOfDay, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class _$PetStateSnapshotCopyWith<$Res> implements $PetStateSnapshotCopyWith<$Res> {
  factory _$PetStateSnapshotCopyWith(_PetStateSnapshot value, $Res Function(_PetStateSnapshot) _then) = __$PetStateSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String id, String petId, String userId, double deltaT, int visitCountToday, int interactionCountToday, double energyAtSnapshot, PetMood moodAtSnapshot, int timeOfDay, DateTime recordedAt
});




}
/// @nodoc
class __$PetStateSnapshotCopyWithImpl<$Res>
    implements _$PetStateSnapshotCopyWith<$Res> {
  __$PetStateSnapshotCopyWithImpl(this._self, this._then);

  final _PetStateSnapshot _self;
  final $Res Function(_PetStateSnapshot) _then;

/// Create a copy of PetStateSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? petId = null,Object? userId = null,Object? deltaT = null,Object? visitCountToday = null,Object? interactionCountToday = null,Object? energyAtSnapshot = null,Object? moodAtSnapshot = null,Object? timeOfDay = null,Object? recordedAt = null,}) {
  return _then(_PetStateSnapshot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,petId: null == petId ? _self.petId : petId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deltaT: null == deltaT ? _self.deltaT : deltaT // ignore: cast_nullable_to_non_nullable
as double,visitCountToday: null == visitCountToday ? _self.visitCountToday : visitCountToday // ignore: cast_nullable_to_non_nullable
as int,interactionCountToday: null == interactionCountToday ? _self.interactionCountToday : interactionCountToday // ignore: cast_nullable_to_non_nullable
as int,energyAtSnapshot: null == energyAtSnapshot ? _self.energyAtSnapshot : energyAtSnapshot // ignore: cast_nullable_to_non_nullable
as double,moodAtSnapshot: null == moodAtSnapshot ? _self.moodAtSnapshot : moodAtSnapshot // ignore: cast_nullable_to_non_nullable
as PetMood,timeOfDay: null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as int,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
