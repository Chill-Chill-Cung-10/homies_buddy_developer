// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  // --- 1. Identity (Định danh) ---
  String get id => throw _privateConstructorUsedError;
  String get username =>
      throw _privateConstructorUsedError; // @salahhh (Unique ID)
  String get fullName =>
      throw _privateConstructorUsedError; // "Salahhh Home" / "Robert Fox"
  String get avatarUrl => throw _privateConstructorUsedError; // Avatar tròn nhỏ
  // --- 2. Visual & Profile Header (Phần Yoga UI) ---
  String? get coverUrl =>
      throw _privateConstructorUsedError; // Ảnh nền full màn hình (như cô gái tập Yoga)
  String? get headline =>
      throw _privateConstructorUsedError; // Title lớn: "YOGA IN LIFE"
  String? get bio =>
      throw _privateConstructorUsedError; // Subtitle/Quote: "To the degree that..."
  String? get location =>
      throw _privateConstructorUsedError; // "California, USA"
  // --- 3. Social Graph (Mạng lưới bạn bè - Homies) ---
  List<UserModel> get humanBuddies =>
      throw _privateConstructorUsedError; // List bạn bè (human) (Jack, Jane...)
  // Stats
  int get followerCount => throw _privateConstructorUsedError;
  int get followingCount => throw _privateConstructorUsedError;
  bool get isFollowedByMe =>
      throw _privateConstructorUsedError; // --- 4. Content (Bài đăng) ---
  // Lưu ý: Trong thực tế, Post List thường được fetch riêng (pagination API).
  // Tuy nhiên, để map với UI Model mong muốn, ta có thể để trường này ở đây.
  List<Post> get posts =>
      throw _privateConstructorUsedError; // --- 5. System Fields ---
  UserRole get role => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String id,
    String username,
    String fullName,
    String avatarUrl,
    String? coverUrl,
    String? headline,
    String? bio,
    String? location,
    List<UserModel> humanBuddies,
    int followerCount,
    int followingCount,
    bool isFollowedByMe,
    List<Post> posts,
    UserRole role,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? fullName = null,
    Object? avatarUrl = null,
    Object? coverUrl = freezed,
    Object? headline = freezed,
    Object? bio = freezed,
    Object? location = freezed,
    Object? humanBuddies = null,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? isFollowedByMe = null,
    Object? posts = null,
    Object? role = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarUrl: null == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            coverUrl: freezed == coverUrl
                ? _value.coverUrl
                : coverUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            headline: freezed == headline
                ? _value.headline
                : headline // ignore: cast_nullable_to_non_nullable
                      as String?,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            humanBuddies: null == humanBuddies
                ? _value.humanBuddies
                : humanBuddies // ignore: cast_nullable_to_non_nullable
                      as List<UserModel>,
            followerCount: null == followerCount
                ? _value.followerCount
                : followerCount // ignore: cast_nullable_to_non_nullable
                      as int,
            followingCount: null == followingCount
                ? _value.followingCount
                : followingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isFollowedByMe: null == isFollowedByMe
                ? _value.isFollowedByMe
                : isFollowedByMe // ignore: cast_nullable_to_non_nullable
                      as bool,
            posts: null == posts
                ? _value.posts
                : posts // ignore: cast_nullable_to_non_nullable
                      as List<Post>,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as UserRole,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String username,
    String fullName,
    String avatarUrl,
    String? coverUrl,
    String? headline,
    String? bio,
    String? location,
    List<UserModel> humanBuddies,
    int followerCount,
    int followingCount,
    bool isFollowedByMe,
    List<Post> posts,
    UserRole role,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? fullName = null,
    Object? avatarUrl = null,
    Object? coverUrl = freezed,
    Object? headline = freezed,
    Object? bio = freezed,
    Object? location = freezed,
    Object? humanBuddies = null,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? isFollowedByMe = null,
    Object? posts = null,
    Object? role = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarUrl: null == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        coverUrl: freezed == coverUrl
            ? _value.coverUrl
            : coverUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        headline: freezed == headline
            ? _value.headline
            : headline // ignore: cast_nullable_to_non_nullable
                  as String?,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        humanBuddies: null == humanBuddies
            ? _value._humanBuddies
            : humanBuddies // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>,
        followerCount: null == followerCount
            ? _value.followerCount
            : followerCount // ignore: cast_nullable_to_non_nullable
                  as int,
        followingCount: null == followingCount
            ? _value.followingCount
            : followingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isFollowedByMe: null == isFollowedByMe
            ? _value.isFollowedByMe
            : isFollowedByMe // ignore: cast_nullable_to_non_nullable
                  as bool,
        posts: null == posts
            ? _value._posts
            : posts // ignore: cast_nullable_to_non_nullable
                  as List<Post>,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as UserRole,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.username,
    required this.fullName,
    required this.avatarUrl,
    this.coverUrl,
    this.headline,
    this.bio,
    this.location,
    final List<UserModel> humanBuddies = const [],
    this.followerCount = 0,
    this.followingCount = 0,
    this.isFollowedByMe = false,
    final List<Post> posts = const [],
    this.role = UserRole.user,
    this.createdAt,
  }) : _humanBuddies = humanBuddies,
       _posts = posts;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  // --- 1. Identity (Định danh) ---
  @override
  final String id;
  @override
  final String username;
  // @salahhh (Unique ID)
  @override
  final String fullName;
  // "Salahhh Home" / "Robert Fox"
  @override
  final String avatarUrl;
  // Avatar tròn nhỏ
  // --- 2. Visual & Profile Header (Phần Yoga UI) ---
  @override
  final String? coverUrl;
  // Ảnh nền full màn hình (như cô gái tập Yoga)
  @override
  final String? headline;
  // Title lớn: "YOGA IN LIFE"
  @override
  final String? bio;
  // Subtitle/Quote: "To the degree that..."
  @override
  final String? location;
  // "California, USA"
  // --- 3. Social Graph (Mạng lưới bạn bè - Homies) ---
  final List<UserModel> _humanBuddies;
  // "California, USA"
  // --- 3. Social Graph (Mạng lưới bạn bè - Homies) ---
  @override
  @JsonKey()
  List<UserModel> get humanBuddies {
    if (_humanBuddies is EqualUnmodifiableListView) return _humanBuddies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_humanBuddies);
  }

  // List bạn bè (human) (Jack, Jane...)
  // Stats
  @override
  @JsonKey()
  final int followerCount;
  @override
  @JsonKey()
  final int followingCount;
  @override
  @JsonKey()
  final bool isFollowedByMe;
  // --- 4. Content (Bài đăng) ---
  // Lưu ý: Trong thực tế, Post List thường được fetch riêng (pagination API).
  // Tuy nhiên, để map với UI Model mong muốn, ta có thể để trường này ở đây.
  final List<Post> _posts;
  // --- 4. Content (Bài đăng) ---
  // Lưu ý: Trong thực tế, Post List thường được fetch riêng (pagination API).
  // Tuy nhiên, để map với UI Model mong muốn, ta có thể để trường này ở đây.
  @override
  @JsonKey()
  List<Post> get posts {
    if (_posts is EqualUnmodifiableListView) return _posts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_posts);
  }

  // --- 5. System Fields ---
  @override
  @JsonKey()
  final UserRole role;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, fullName: $fullName, avatarUrl: $avatarUrl, coverUrl: $coverUrl, headline: $headline, bio: $bio, location: $location, humanBuddies: $humanBuddies, followerCount: $followerCount, followingCount: $followingCount, isFollowedByMe: $isFollowedByMe, posts: $posts, role: $role, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.headline, headline) ||
                other.headline == headline) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(
              other._humanBuddies,
              _humanBuddies,
            ) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.isFollowedByMe, isFollowedByMe) ||
                other.isFollowedByMe == isFollowedByMe) &&
            const DeepCollectionEquality().equals(other._posts, _posts) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    username,
    fullName,
    avatarUrl,
    coverUrl,
    headline,
    bio,
    location,
    const DeepCollectionEquality().hash(_humanBuddies),
    followerCount,
    followingCount,
    isFollowedByMe,
    const DeepCollectionEquality().hash(_posts),
    role,
    createdAt,
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required final String id,
    required final String username,
    required final String fullName,
    required final String avatarUrl,
    final String? coverUrl,
    final String? headline,
    final String? bio,
    final String? location,
    final List<UserModel> humanBuddies,
    final int followerCount,
    final int followingCount,
    final bool isFollowedByMe,
    final List<Post> posts,
    final UserRole role,
    final DateTime? createdAt,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  // --- 1. Identity (Định danh) ---
  @override
  String get id;
  @override
  String get username; // @salahhh (Unique ID)
  @override
  String get fullName; // "Salahhh Home" / "Robert Fox"
  @override
  String get avatarUrl; // Avatar tròn nhỏ
  // --- 2. Visual & Profile Header (Phần Yoga UI) ---
  @override
  String? get coverUrl; // Ảnh nền full màn hình (như cô gái tập Yoga)
  @override
  String? get headline; // Title lớn: "YOGA IN LIFE"
  @override
  String? get bio; // Subtitle/Quote: "To the degree that..."
  @override
  String? get location; // "California, USA"
  // --- 3. Social Graph (Mạng lưới bạn bè - Homies) ---
  @override
  List<UserModel> get humanBuddies; // List bạn bè (human) (Jack, Jane...)
  // Stats
  @override
  int get followerCount;
  @override
  int get followingCount;
  @override
  bool get isFollowedByMe; // --- 4. Content (Bài đăng) ---
  // Lưu ý: Trong thực tế, Post List thường được fetch riêng (pagination API).
  // Tuy nhiên, để map với UI Model mong muốn, ta có thể để trường này ở đây.
  @override
  List<Post> get posts; // --- 5. System Fields ---
  @override
  UserRole get role;
  @override
  DateTime? get createdAt;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
