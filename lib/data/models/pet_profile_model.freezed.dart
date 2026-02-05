// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PetProfile _$PetProfileFromJson(Map<String, dynamic> json) {
  return _PetProfile.fromJson(json);
}

/// @nodoc
mixin _$PetProfile {
  String get petId => throw _privateConstructorUsedError;
  String get petName => throw _privateConstructorUsedError;
  String get petAvatar => throw _privateConstructorUsedError;
  PetOwner get petOwner => throw _privateConstructorUsedError;
  String get petPitching => throw _privateConstructorUsedError;
  bool get isFollowedByMe => throw _privateConstructorUsedError;
  int get followerCount => throw _privateConstructorUsedError;

  /// Serializes this PetProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PetProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetProfileCopyWith<PetProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetProfileCopyWith<$Res> {
  factory $PetProfileCopyWith(
    PetProfile value,
    $Res Function(PetProfile) then,
  ) = _$PetProfileCopyWithImpl<$Res, PetProfile>;
  @useResult
  $Res call({
    String petId,
    String petName,
    String petAvatar,
    PetOwner petOwner,
    String petPitching,
    bool isFollowedByMe,
    int followerCount,
  });

  $PetOwnerCopyWith<$Res> get petOwner;
}

/// @nodoc
class _$PetProfileCopyWithImpl<$Res, $Val extends PetProfile>
    implements $PetProfileCopyWith<$Res> {
  _$PetProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PetProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? petId = null,
    Object? petName = null,
    Object? petAvatar = null,
    Object? petOwner = null,
    Object? petPitching = null,
    Object? isFollowedByMe = null,
    Object? followerCount = null,
  }) {
    return _then(
      _value.copyWith(
            petId: null == petId
                ? _value.petId
                : petId // ignore: cast_nullable_to_non_nullable
                      as String,
            petName: null == petName
                ? _value.petName
                : petName // ignore: cast_nullable_to_non_nullable
                      as String,
            petAvatar: null == petAvatar
                ? _value.petAvatar
                : petAvatar // ignore: cast_nullable_to_non_nullable
                      as String,
            petOwner: null == petOwner
                ? _value.petOwner
                : petOwner // ignore: cast_nullable_to_non_nullable
                      as PetOwner,
            petPitching: null == petPitching
                ? _value.petPitching
                : petPitching // ignore: cast_nullable_to_non_nullable
                      as String,
            isFollowedByMe: null == isFollowedByMe
                ? _value.isFollowedByMe
                : isFollowedByMe // ignore: cast_nullable_to_non_nullable
                      as bool,
            followerCount: null == followerCount
                ? _value.followerCount
                : followerCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of PetProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PetOwnerCopyWith<$Res> get petOwner {
    return $PetOwnerCopyWith<$Res>(_value.petOwner, (value) {
      return _then(_value.copyWith(petOwner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PetProfileImplCopyWith<$Res>
    implements $PetProfileCopyWith<$Res> {
  factory _$$PetProfileImplCopyWith(
    _$PetProfileImpl value,
    $Res Function(_$PetProfileImpl) then,
  ) = __$$PetProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String petId,
    String petName,
    String petAvatar,
    PetOwner petOwner,
    String petPitching,
    bool isFollowedByMe,
    int followerCount,
  });

  @override
  $PetOwnerCopyWith<$Res> get petOwner;
}

/// @nodoc
class __$$PetProfileImplCopyWithImpl<$Res>
    extends _$PetProfileCopyWithImpl<$Res, _$PetProfileImpl>
    implements _$$PetProfileImplCopyWith<$Res> {
  __$$PetProfileImplCopyWithImpl(
    _$PetProfileImpl _value,
    $Res Function(_$PetProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PetProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? petId = null,
    Object? petName = null,
    Object? petAvatar = null,
    Object? petOwner = null,
    Object? petPitching = null,
    Object? isFollowedByMe = null,
    Object? followerCount = null,
  }) {
    return _then(
      _$PetProfileImpl(
        petId: null == petId
            ? _value.petId
            : petId // ignore: cast_nullable_to_non_nullable
                  as String,
        petName: null == petName
            ? _value.petName
            : petName // ignore: cast_nullable_to_non_nullable
                  as String,
        petAvatar: null == petAvatar
            ? _value.petAvatar
            : petAvatar // ignore: cast_nullable_to_non_nullable
                  as String,
        petOwner: null == petOwner
            ? _value.petOwner
            : petOwner // ignore: cast_nullable_to_non_nullable
                  as PetOwner,
        petPitching: null == petPitching
            ? _value.petPitching
            : petPitching // ignore: cast_nullable_to_non_nullable
                  as String,
        isFollowedByMe: null == isFollowedByMe
            ? _value.isFollowedByMe
            : isFollowedByMe // ignore: cast_nullable_to_non_nullable
                  as bool,
        followerCount: null == followerCount
            ? _value.followerCount
            : followerCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PetProfileImpl implements _PetProfile {
  const _$PetProfileImpl({
    required this.petId,
    required this.petName,
    required this.petAvatar,
    required this.petOwner,
    required this.petPitching,
    required this.isFollowedByMe,
    required this.followerCount,
  });

  factory _$PetProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetProfileImplFromJson(json);

  @override
  final String petId;
  @override
  final String petName;
  @override
  final String petAvatar;
  @override
  final PetOwner petOwner;
  @override
  final String petPitching;
  @override
  final bool isFollowedByMe;
  @override
  final int followerCount;

  @override
  String toString() {
    return 'PetProfile(petId: $petId, petName: $petName, petAvatar: $petAvatar, petOwner: $petOwner, petPitching: $petPitching, isFollowedByMe: $isFollowedByMe, followerCount: $followerCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetProfileImpl &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.petName, petName) || other.petName == petName) &&
            (identical(other.petAvatar, petAvatar) ||
                other.petAvatar == petAvatar) &&
            (identical(other.petOwner, petOwner) ||
                other.petOwner == petOwner) &&
            (identical(other.petPitching, petPitching) ||
                other.petPitching == petPitching) &&
            (identical(other.isFollowedByMe, isFollowedByMe) ||
                other.isFollowedByMe == isFollowedByMe) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    petId,
    petName,
    petAvatar,
    petOwner,
    petPitching,
    isFollowedByMe,
    followerCount,
  );

  /// Create a copy of PetProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetProfileImplCopyWith<_$PetProfileImpl> get copyWith =>
      __$$PetProfileImplCopyWithImpl<_$PetProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetProfileImplToJson(this);
  }
}

abstract class _PetProfile implements PetProfile {
  const factory _PetProfile({
    required final String petId,
    required final String petName,
    required final String petAvatar,
    required final PetOwner petOwner,
    required final String petPitching,
    required final bool isFollowedByMe,
    required final int followerCount,
  }) = _$PetProfileImpl;

  factory _PetProfile.fromJson(Map<String, dynamic> json) =
      _$PetProfileImpl.fromJson;

  @override
  String get petId;
  @override
  String get petName;
  @override
  String get petAvatar;
  @override
  PetOwner get petOwner;
  @override
  String get petPitching;
  @override
  bool get isFollowedByMe;
  @override
  int get followerCount;

  /// Create a copy of PetProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetProfileImplCopyWith<_$PetProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
