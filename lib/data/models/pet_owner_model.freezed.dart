// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_owner_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PetOwner _$PetOwnerFromJson(Map<String, dynamic> json) {
  return _PetOwner.fromJson(json);
}

/// @nodoc
mixin _$PetOwner {
  String get ownerId => throw _privateConstructorUsedError;
  String get ownerName => throw _privateConstructorUsedError;
  String get ownerAvatar => throw _privateConstructorUsedError;

  /// Serializes this PetOwner to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PetOwner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetOwnerCopyWith<PetOwner> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetOwnerCopyWith<$Res> {
  factory $PetOwnerCopyWith(PetOwner value, $Res Function(PetOwner) then) =
      _$PetOwnerCopyWithImpl<$Res, PetOwner>;
  @useResult
  $Res call({String ownerId, String ownerName, String ownerAvatar});
}

/// @nodoc
class _$PetOwnerCopyWithImpl<$Res, $Val extends PetOwner>
    implements $PetOwnerCopyWith<$Res> {
  _$PetOwnerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PetOwner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ownerId = null,
    Object? ownerName = null,
    Object? ownerAvatar = null,
  }) {
    return _then(
      _value.copyWith(
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerName: null == ownerName
                ? _value.ownerName
                : ownerName // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerAvatar: null == ownerAvatar
                ? _value.ownerAvatar
                : ownerAvatar // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PetOwnerImplCopyWith<$Res>
    implements $PetOwnerCopyWith<$Res> {
  factory _$$PetOwnerImplCopyWith(
    _$PetOwnerImpl value,
    $Res Function(_$PetOwnerImpl) then,
  ) = __$$PetOwnerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String ownerId, String ownerName, String ownerAvatar});
}

/// @nodoc
class __$$PetOwnerImplCopyWithImpl<$Res>
    extends _$PetOwnerCopyWithImpl<$Res, _$PetOwnerImpl>
    implements _$$PetOwnerImplCopyWith<$Res> {
  __$$PetOwnerImplCopyWithImpl(
    _$PetOwnerImpl _value,
    $Res Function(_$PetOwnerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PetOwner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ownerId = null,
    Object? ownerName = null,
    Object? ownerAvatar = null,
  }) {
    return _then(
      _$PetOwnerImpl(
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerName: null == ownerName
            ? _value.ownerName
            : ownerName // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerAvatar: null == ownerAvatar
            ? _value.ownerAvatar
            : ownerAvatar // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PetOwnerImpl implements _PetOwner {
  const _$PetOwnerImpl({
    required this.ownerId,
    required this.ownerName,
    required this.ownerAvatar,
  });

  factory _$PetOwnerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetOwnerImplFromJson(json);

  @override
  final String ownerId;
  @override
  final String ownerName;
  @override
  final String ownerAvatar;

  @override
  String toString() {
    return 'PetOwner(ownerId: $ownerId, ownerName: $ownerName, ownerAvatar: $ownerAvatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetOwnerImpl &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.ownerAvatar, ownerAvatar) ||
                other.ownerAvatar == ownerAvatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ownerId, ownerName, ownerAvatar);

  /// Create a copy of PetOwner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetOwnerImplCopyWith<_$PetOwnerImpl> get copyWith =>
      __$$PetOwnerImplCopyWithImpl<_$PetOwnerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetOwnerImplToJson(this);
  }
}

abstract class _PetOwner implements PetOwner {
  const factory _PetOwner({
    required final String ownerId,
    required final String ownerName,
    required final String ownerAvatar,
  }) = _$PetOwnerImpl;

  factory _PetOwner.fromJson(Map<String, dynamic> json) =
      _$PetOwnerImpl.fromJson;

  @override
  String get ownerId;
  @override
  String get ownerName;
  @override
  String get ownerAvatar;

  /// Create a copy of PetOwner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetOwnerImplCopyWith<_$PetOwnerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
