// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moment_note_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MomentNote {

 String get id;/// ⭐ **Thêm mới** — User ID chủ sở hữu note
 String get userId; String get authorName; String get authorAvatarUrl; DateTime get createdAt; String get textContent; List<String> get mediaUrls;
/// Create a copy of MomentNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MomentNoteCopyWith<MomentNote> get copyWith => _$MomentNoteCopyWithImpl<MomentNote>(this as MomentNote, _$identity);

  /// Serializes this MomentNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MomentNote&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorAvatarUrl, authorAvatarUrl) || other.authorAvatarUrl == authorAvatarUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.textContent, textContent) || other.textContent == textContent)&&const DeepCollectionEquality().equals(other.mediaUrls, mediaUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,authorName,authorAvatarUrl,createdAt,textContent,const DeepCollectionEquality().hash(mediaUrls));

@override
String toString() {
  return 'MomentNote(id: $id, userId: $userId, authorName: $authorName, authorAvatarUrl: $authorAvatarUrl, createdAt: $createdAt, textContent: $textContent, mediaUrls: $mediaUrls)';
}


}

/// @nodoc
abstract mixin class $MomentNoteCopyWith<$Res>  {
  factory $MomentNoteCopyWith(MomentNote value, $Res Function(MomentNote) _then) = _$MomentNoteCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String authorName, String authorAvatarUrl, DateTime createdAt, String textContent, List<String> mediaUrls
});




}
/// @nodoc
class _$MomentNoteCopyWithImpl<$Res>
    implements $MomentNoteCopyWith<$Res> {
  _$MomentNoteCopyWithImpl(this._self, this._then);

  final MomentNote _self;
  final $Res Function(MomentNote) _then;

/// Create a copy of MomentNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? authorName = null,Object? authorAvatarUrl = null,Object? createdAt = null,Object? textContent = null,Object? mediaUrls = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorAvatarUrl: null == authorAvatarUrl ? _self.authorAvatarUrl : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,textContent: null == textContent ? _self.textContent : textContent // ignore: cast_nullable_to_non_nullable
as String,mediaUrls: null == mediaUrls ? _self.mediaUrls : mediaUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MomentNote].
extension MomentNotePatterns on MomentNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MomentNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MomentNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MomentNote value)  $default,){
final _that = this;
switch (_that) {
case _MomentNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MomentNote value)?  $default,){
final _that = this;
switch (_that) {
case _MomentNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String authorName,  String authorAvatarUrl,  DateTime createdAt,  String textContent,  List<String> mediaUrls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MomentNote() when $default != null:
return $default(_that.id,_that.userId,_that.authorName,_that.authorAvatarUrl,_that.createdAt,_that.textContent,_that.mediaUrls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String authorName,  String authorAvatarUrl,  DateTime createdAt,  String textContent,  List<String> mediaUrls)  $default,) {final _that = this;
switch (_that) {
case _MomentNote():
return $default(_that.id,_that.userId,_that.authorName,_that.authorAvatarUrl,_that.createdAt,_that.textContent,_that.mediaUrls);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String authorName,  String authorAvatarUrl,  DateTime createdAt,  String textContent,  List<String> mediaUrls)?  $default,) {final _that = this;
switch (_that) {
case _MomentNote() when $default != null:
return $default(_that.id,_that.userId,_that.authorName,_that.authorAvatarUrl,_that.createdAt,_that.textContent,_that.mediaUrls);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MomentNote implements MomentNote {
  const _MomentNote({required this.id, required this.userId, required this.authorName, required this.authorAvatarUrl, required this.createdAt, this.textContent = '', final  List<String> mediaUrls = const []}): _mediaUrls = mediaUrls;
  factory _MomentNote.fromJson(Map<String, dynamic> json) => _$MomentNoteFromJson(json);

@override final  String id;
/// ⭐ **Thêm mới** — User ID chủ sở hữu note
@override final  String userId;
@override final  String authorName;
@override final  String authorAvatarUrl;
@override final  DateTime createdAt;
@override@JsonKey() final  String textContent;
 final  List<String> _mediaUrls;
@override@JsonKey() List<String> get mediaUrls {
  if (_mediaUrls is EqualUnmodifiableListView) return _mediaUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaUrls);
}


/// Create a copy of MomentNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MomentNoteCopyWith<_MomentNote> get copyWith => __$MomentNoteCopyWithImpl<_MomentNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MomentNoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MomentNote&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorAvatarUrl, authorAvatarUrl) || other.authorAvatarUrl == authorAvatarUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.textContent, textContent) || other.textContent == textContent)&&const DeepCollectionEquality().equals(other._mediaUrls, _mediaUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,authorName,authorAvatarUrl,createdAt,textContent,const DeepCollectionEquality().hash(_mediaUrls));

@override
String toString() {
  return 'MomentNote(id: $id, userId: $userId, authorName: $authorName, authorAvatarUrl: $authorAvatarUrl, createdAt: $createdAt, textContent: $textContent, mediaUrls: $mediaUrls)';
}


}

/// @nodoc
abstract mixin class _$MomentNoteCopyWith<$Res> implements $MomentNoteCopyWith<$Res> {
  factory _$MomentNoteCopyWith(_MomentNote value, $Res Function(_MomentNote) _then) = __$MomentNoteCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String authorName, String authorAvatarUrl, DateTime createdAt, String textContent, List<String> mediaUrls
});




}
/// @nodoc
class __$MomentNoteCopyWithImpl<$Res>
    implements _$MomentNoteCopyWith<$Res> {
  __$MomentNoteCopyWithImpl(this._self, this._then);

  final _MomentNote _self;
  final $Res Function(_MomentNote) _then;

/// Create a copy of MomentNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? authorName = null,Object? authorAvatarUrl = null,Object? createdAt = null,Object? textContent = null,Object? mediaUrls = null,}) {
  return _then(_MomentNote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorAvatarUrl: null == authorAvatarUrl ? _self.authorAvatarUrl : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,textContent: null == textContent ? _self.textContent : textContent // ignore: cast_nullable_to_non_nullable
as String,mediaUrls: null == mediaUrls ? _self._mediaUrls : mediaUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
