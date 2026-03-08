// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_analysis_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoteAnalysis {

 String get id;/// Note ID — 1:1 với MOMENT_NOTE (unique)
 String get noteId; String get userId;/// Tone của note trước đó
 UserTone? get lastUserTone;/// Tone dự đoán của note hiện tại
 UserTone get currentTonePredict;/// Tone có lặp lại so với note trước?
 bool get toneRepeat;/// Cường độ cảm xúc (1–5)
 int get level; DateTime get analyzedAt;/// Raw output của LLM (nullable, dùng để debug)
 String? get rawLLMResponse;
/// Create a copy of NoteAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteAnalysisCopyWith<NoteAnalysis> get copyWith => _$NoteAnalysisCopyWithImpl<NoteAnalysis>(this as NoteAnalysis, _$identity);

  /// Serializes this NoteAnalysis to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteAnalysis&&(identical(other.id, id) || other.id == id)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.lastUserTone, lastUserTone) || other.lastUserTone == lastUserTone)&&(identical(other.currentTonePredict, currentTonePredict) || other.currentTonePredict == currentTonePredict)&&(identical(other.toneRepeat, toneRepeat) || other.toneRepeat == toneRepeat)&&(identical(other.level, level) || other.level == level)&&(identical(other.analyzedAt, analyzedAt) || other.analyzedAt == analyzedAt)&&(identical(other.rawLLMResponse, rawLLMResponse) || other.rawLLMResponse == rawLLMResponse));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,noteId,userId,lastUserTone,currentTonePredict,toneRepeat,level,analyzedAt,rawLLMResponse);

@override
String toString() {
  return 'NoteAnalysis(id: $id, noteId: $noteId, userId: $userId, lastUserTone: $lastUserTone, currentTonePredict: $currentTonePredict, toneRepeat: $toneRepeat, level: $level, analyzedAt: $analyzedAt, rawLLMResponse: $rawLLMResponse)';
}


}

/// @nodoc
abstract mixin class $NoteAnalysisCopyWith<$Res>  {
  factory $NoteAnalysisCopyWith(NoteAnalysis value, $Res Function(NoteAnalysis) _then) = _$NoteAnalysisCopyWithImpl;
@useResult
$Res call({
 String id, String noteId, String userId, UserTone? lastUserTone, UserTone currentTonePredict, bool toneRepeat, int level, DateTime analyzedAt, String? rawLLMResponse
});




}
/// @nodoc
class _$NoteAnalysisCopyWithImpl<$Res>
    implements $NoteAnalysisCopyWith<$Res> {
  _$NoteAnalysisCopyWithImpl(this._self, this._then);

  final NoteAnalysis _self;
  final $Res Function(NoteAnalysis) _then;

/// Create a copy of NoteAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? noteId = null,Object? userId = null,Object? lastUserTone = freezed,Object? currentTonePredict = null,Object? toneRepeat = null,Object? level = null,Object? analyzedAt = null,Object? rawLLMResponse = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,lastUserTone: freezed == lastUserTone ? _self.lastUserTone : lastUserTone // ignore: cast_nullable_to_non_nullable
as UserTone?,currentTonePredict: null == currentTonePredict ? _self.currentTonePredict : currentTonePredict // ignore: cast_nullable_to_non_nullable
as UserTone,toneRepeat: null == toneRepeat ? _self.toneRepeat : toneRepeat // ignore: cast_nullable_to_non_nullable
as bool,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,analyzedAt: null == analyzedAt ? _self.analyzedAt : analyzedAt // ignore: cast_nullable_to_non_nullable
as DateTime,rawLLMResponse: freezed == rawLLMResponse ? _self.rawLLMResponse : rawLLMResponse // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteAnalysis].
extension NoteAnalysisPatterns on NoteAnalysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteAnalysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteAnalysis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteAnalysis value)  $default,){
final _that = this;
switch (_that) {
case _NoteAnalysis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteAnalysis value)?  $default,){
final _that = this;
switch (_that) {
case _NoteAnalysis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String noteId,  String userId,  UserTone? lastUserTone,  UserTone currentTonePredict,  bool toneRepeat,  int level,  DateTime analyzedAt,  String? rawLLMResponse)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteAnalysis() when $default != null:
return $default(_that.id,_that.noteId,_that.userId,_that.lastUserTone,_that.currentTonePredict,_that.toneRepeat,_that.level,_that.analyzedAt,_that.rawLLMResponse);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String noteId,  String userId,  UserTone? lastUserTone,  UserTone currentTonePredict,  bool toneRepeat,  int level,  DateTime analyzedAt,  String? rawLLMResponse)  $default,) {final _that = this;
switch (_that) {
case _NoteAnalysis():
return $default(_that.id,_that.noteId,_that.userId,_that.lastUserTone,_that.currentTonePredict,_that.toneRepeat,_that.level,_that.analyzedAt,_that.rawLLMResponse);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String noteId,  String userId,  UserTone? lastUserTone,  UserTone currentTonePredict,  bool toneRepeat,  int level,  DateTime analyzedAt,  String? rawLLMResponse)?  $default,) {final _that = this;
switch (_that) {
case _NoteAnalysis() when $default != null:
return $default(_that.id,_that.noteId,_that.userId,_that.lastUserTone,_that.currentTonePredict,_that.toneRepeat,_that.level,_that.analyzedAt,_that.rawLLMResponse);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoteAnalysis implements NoteAnalysis {
  const _NoteAnalysis({required this.id, required this.noteId, required this.userId, this.lastUserTone, required this.currentTonePredict, required this.toneRepeat, required this.level, required this.analyzedAt, this.rawLLMResponse});
  factory _NoteAnalysis.fromJson(Map<String, dynamic> json) => _$NoteAnalysisFromJson(json);

@override final  String id;
/// Note ID — 1:1 với MOMENT_NOTE (unique)
@override final  String noteId;
@override final  String userId;
/// Tone của note trước đó
@override final  UserTone? lastUserTone;
/// Tone dự đoán của note hiện tại
@override final  UserTone currentTonePredict;
/// Tone có lặp lại so với note trước?
@override final  bool toneRepeat;
/// Cường độ cảm xúc (1–5)
@override final  int level;
@override final  DateTime analyzedAt;
/// Raw output của LLM (nullable, dùng để debug)
@override final  String? rawLLMResponse;

/// Create a copy of NoteAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteAnalysisCopyWith<_NoteAnalysis> get copyWith => __$NoteAnalysisCopyWithImpl<_NoteAnalysis>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoteAnalysisToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteAnalysis&&(identical(other.id, id) || other.id == id)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.lastUserTone, lastUserTone) || other.lastUserTone == lastUserTone)&&(identical(other.currentTonePredict, currentTonePredict) || other.currentTonePredict == currentTonePredict)&&(identical(other.toneRepeat, toneRepeat) || other.toneRepeat == toneRepeat)&&(identical(other.level, level) || other.level == level)&&(identical(other.analyzedAt, analyzedAt) || other.analyzedAt == analyzedAt)&&(identical(other.rawLLMResponse, rawLLMResponse) || other.rawLLMResponse == rawLLMResponse));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,noteId,userId,lastUserTone,currentTonePredict,toneRepeat,level,analyzedAt,rawLLMResponse);

@override
String toString() {
  return 'NoteAnalysis(id: $id, noteId: $noteId, userId: $userId, lastUserTone: $lastUserTone, currentTonePredict: $currentTonePredict, toneRepeat: $toneRepeat, level: $level, analyzedAt: $analyzedAt, rawLLMResponse: $rawLLMResponse)';
}


}

/// @nodoc
abstract mixin class _$NoteAnalysisCopyWith<$Res> implements $NoteAnalysisCopyWith<$Res> {
  factory _$NoteAnalysisCopyWith(_NoteAnalysis value, $Res Function(_NoteAnalysis) _then) = __$NoteAnalysisCopyWithImpl;
@override @useResult
$Res call({
 String id, String noteId, String userId, UserTone? lastUserTone, UserTone currentTonePredict, bool toneRepeat, int level, DateTime analyzedAt, String? rawLLMResponse
});




}
/// @nodoc
class __$NoteAnalysisCopyWithImpl<$Res>
    implements _$NoteAnalysisCopyWith<$Res> {
  __$NoteAnalysisCopyWithImpl(this._self, this._then);

  final _NoteAnalysis _self;
  final $Res Function(_NoteAnalysis) _then;

/// Create a copy of NoteAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? noteId = null,Object? userId = null,Object? lastUserTone = freezed,Object? currentTonePredict = null,Object? toneRepeat = null,Object? level = null,Object? analyzedAt = null,Object? rawLLMResponse = freezed,}) {
  return _then(_NoteAnalysis(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,noteId: null == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,lastUserTone: freezed == lastUserTone ? _self.lastUserTone : lastUserTone // ignore: cast_nullable_to_non_nullable
as UserTone?,currentTonePredict: null == currentTonePredict ? _self.currentTonePredict : currentTonePredict // ignore: cast_nullable_to_non_nullable
as UserTone,toneRepeat: null == toneRepeat ? _self.toneRepeat : toneRepeat // ignore: cast_nullable_to_non_nullable
as bool,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,analyzedAt: null == analyzedAt ? _self.analyzedAt : analyzedAt // ignore: cast_nullable_to_non_nullable
as DateTime,rawLLMResponse: freezed == rawLLMResponse ? _self.rawLLMResponse : rawLLMResponse // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
