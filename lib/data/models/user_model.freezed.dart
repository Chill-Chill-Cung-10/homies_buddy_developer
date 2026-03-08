// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

// --- 1. Identity (Định danh) ---
 String get id; String get username;// @salahhh (Unique ID)
 String get fullName;// "Salahhh Home" / "Robert Fox"
 String get avatarUrl;// Avatar tròn nhỏ
// --- 2. Visual & Profile Header (Phần Yoga UI) ---
 String? get coverUrl;// Ảnh nền full màn hình (như cô gái tập Yoga)
 String? get headline;// Title lớn: "YOGA IN LIFE"
 String? get bio;// Subtitle/Quote: "To the degree that..."
 String? get location;// "California, USA"
// --- 3. Social Graph (Mạng lưới bạn bè - Homies) ---
 List<UserModel> get humanBuddies;// List bạn bè (human) (Jack, Jane...)
// Stats
 int get followerCount; int get followingCount; bool get isFollowedByMe;// --- 4. Content (Bài đăng) ---
// Lưu ý: Trong thực tế, Post List thường được fetch riêng (pagination API).
// Tuy nhiên, để map với UI Model mong muốn, ta có thể để trường này ở đây.
 List<Post> get posts;// --- 5. System Fields ---
 UserRole get role; DateTime? get createdAt;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other.humanBuddies, humanBuddies)&&(identical(other.followerCount, followerCount) || other.followerCount == followerCount)&&(identical(other.followingCount, followingCount) || other.followingCount == followingCount)&&(identical(other.isFollowedByMe, isFollowedByMe) || other.isFollowedByMe == isFollowedByMe)&&const DeepCollectionEquality().equals(other.posts, posts)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,fullName,avatarUrl,coverUrl,headline,bio,location,const DeepCollectionEquality().hash(humanBuddies),followerCount,followingCount,isFollowedByMe,const DeepCollectionEquality().hash(posts),role,createdAt);

@override
String toString() {
  return 'UserModel(id: $id, username: $username, fullName: $fullName, avatarUrl: $avatarUrl, coverUrl: $coverUrl, headline: $headline, bio: $bio, location: $location, humanBuddies: $humanBuddies, followerCount: $followerCount, followingCount: $followingCount, isFollowedByMe: $isFollowedByMe, posts: $posts, role: $role, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String username, String fullName, String avatarUrl, String? coverUrl, String? headline, String? bio, String? location, List<UserModel> humanBuddies, int followerCount, int followingCount, bool isFollowedByMe, List<Post> posts, UserRole role, DateTime? createdAt
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? fullName = null,Object? avatarUrl = null,Object? coverUrl = freezed,Object? headline = freezed,Object? bio = freezed,Object? location = freezed,Object? humanBuddies = null,Object? followerCount = null,Object? followingCount = null,Object? isFollowedByMe = null,Object? posts = null,Object? role = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,headline: freezed == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,humanBuddies: null == humanBuddies ? _self.humanBuddies : humanBuddies // ignore: cast_nullable_to_non_nullable
as List<UserModel>,followerCount: null == followerCount ? _self.followerCount : followerCount // ignore: cast_nullable_to_non_nullable
as int,followingCount: null == followingCount ? _self.followingCount : followingCount // ignore: cast_nullable_to_non_nullable
as int,isFollowedByMe: null == isFollowedByMe ? _self.isFollowedByMe : isFollowedByMe // ignore: cast_nullable_to_non_nullable
as bool,posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<Post>,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String fullName,  String avatarUrl,  String? coverUrl,  String? headline,  String? bio,  String? location,  List<UserModel> humanBuddies,  int followerCount,  int followingCount,  bool isFollowedByMe,  List<Post> posts,  UserRole role,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.fullName,_that.avatarUrl,_that.coverUrl,_that.headline,_that.bio,_that.location,_that.humanBuddies,_that.followerCount,_that.followingCount,_that.isFollowedByMe,_that.posts,_that.role,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String fullName,  String avatarUrl,  String? coverUrl,  String? headline,  String? bio,  String? location,  List<UserModel> humanBuddies,  int followerCount,  int followingCount,  bool isFollowedByMe,  List<Post> posts,  UserRole role,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.username,_that.fullName,_that.avatarUrl,_that.coverUrl,_that.headline,_that.bio,_that.location,_that.humanBuddies,_that.followerCount,_that.followingCount,_that.isFollowedByMe,_that.posts,_that.role,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String fullName,  String avatarUrl,  String? coverUrl,  String? headline,  String? bio,  String? location,  List<UserModel> humanBuddies,  int followerCount,  int followingCount,  bool isFollowedByMe,  List<Post> posts,  UserRole role,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.fullName,_that.avatarUrl,_that.coverUrl,_that.headline,_that.bio,_that.location,_that.humanBuddies,_that.followerCount,_that.followingCount,_that.isFollowedByMe,_that.posts,_that.role,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.id, required this.username, required this.fullName, required this.avatarUrl, this.coverUrl, this.headline, this.bio, this.location, final  List<UserModel> humanBuddies = const [], this.followerCount = 0, this.followingCount = 0, this.isFollowedByMe = false, final  List<Post> posts = const [], this.role = UserRole.user, this.createdAt}): _humanBuddies = humanBuddies,_posts = posts;
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

// --- 1. Identity (Định danh) ---
@override final  String id;
@override final  String username;
// @salahhh (Unique ID)
@override final  String fullName;
// "Salahhh Home" / "Robert Fox"
@override final  String avatarUrl;
// Avatar tròn nhỏ
// --- 2. Visual & Profile Header (Phần Yoga UI) ---
@override final  String? coverUrl;
// Ảnh nền full màn hình (như cô gái tập Yoga)
@override final  String? headline;
// Title lớn: "YOGA IN LIFE"
@override final  String? bio;
// Subtitle/Quote: "To the degree that..."
@override final  String? location;
// "California, USA"
// --- 3. Social Graph (Mạng lưới bạn bè - Homies) ---
 final  List<UserModel> _humanBuddies;
// "California, USA"
// --- 3. Social Graph (Mạng lưới bạn bè - Homies) ---
@override@JsonKey() List<UserModel> get humanBuddies {
  if (_humanBuddies is EqualUnmodifiableListView) return _humanBuddies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_humanBuddies);
}

// List bạn bè (human) (Jack, Jane...)
// Stats
@override@JsonKey() final  int followerCount;
@override@JsonKey() final  int followingCount;
@override@JsonKey() final  bool isFollowedByMe;
// --- 4. Content (Bài đăng) ---
// Lưu ý: Trong thực tế, Post List thường được fetch riêng (pagination API).
// Tuy nhiên, để map với UI Model mong muốn, ta có thể để trường này ở đây.
 final  List<Post> _posts;
// --- 4. Content (Bài đăng) ---
// Lưu ý: Trong thực tế, Post List thường được fetch riêng (pagination API).
// Tuy nhiên, để map với UI Model mong muốn, ta có thể để trường này ở đây.
@override@JsonKey() List<Post> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

// --- 5. System Fields ---
@override@JsonKey() final  UserRole role;
@override final  DateTime? createdAt;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other._humanBuddies, _humanBuddies)&&(identical(other.followerCount, followerCount) || other.followerCount == followerCount)&&(identical(other.followingCount, followingCount) || other.followingCount == followingCount)&&(identical(other.isFollowedByMe, isFollowedByMe) || other.isFollowedByMe == isFollowedByMe)&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,fullName,avatarUrl,coverUrl,headline,bio,location,const DeepCollectionEquality().hash(_humanBuddies),followerCount,followingCount,isFollowedByMe,const DeepCollectionEquality().hash(_posts),role,createdAt);

@override
String toString() {
  return 'UserModel(id: $id, username: $username, fullName: $fullName, avatarUrl: $avatarUrl, coverUrl: $coverUrl, headline: $headline, bio: $bio, location: $location, humanBuddies: $humanBuddies, followerCount: $followerCount, followingCount: $followingCount, isFollowedByMe: $isFollowedByMe, posts: $posts, role: $role, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String fullName, String avatarUrl, String? coverUrl, String? headline, String? bio, String? location, List<UserModel> humanBuddies, int followerCount, int followingCount, bool isFollowedByMe, List<Post> posts, UserRole role, DateTime? createdAt
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? fullName = null,Object? avatarUrl = null,Object? coverUrl = freezed,Object? headline = freezed,Object? bio = freezed,Object? location = freezed,Object? humanBuddies = null,Object? followerCount = null,Object? followingCount = null,Object? isFollowedByMe = null,Object? posts = null,Object? role = null,Object? createdAt = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,headline: freezed == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,humanBuddies: null == humanBuddies ? _self._humanBuddies : humanBuddies // ignore: cast_nullable_to_non_nullable
as List<UserModel>,followerCount: null == followerCount ? _self.followerCount : followerCount // ignore: cast_nullable_to_non_nullable
as int,followingCount: null == followingCount ? _self.followingCount : followingCount // ignore: cast_nullable_to_non_nullable
as int,isFollowedByMe: null == isFollowedByMe ? _self.isFollowedByMe : isFollowedByMe // ignore: cast_nullable_to_non_nullable
as bool,posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<Post>,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
