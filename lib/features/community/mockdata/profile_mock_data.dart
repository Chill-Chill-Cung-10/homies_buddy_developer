import '../../../data/models/user_model.dart';
import '../../../data/models/pet_profile_model.dart';
import '../../../data/models/pet_owner_model.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/media_file_model.dart';
import '../../../data/models/enums/post_privacy.dart';
import '../../../data/models/enums/media_type.dart';

/// Mock data cho Profile Screen
class ProfileMockData {
  /// Lấy UserModel theo authorId
  static UserModel getUserByAuthorId(String authorId) {
    return _usersMap[authorId] ?? _defaultUser(authorId);
  }

  /// Lấy UserModel theo username (cho mention tap)
  static UserModel? getUserByUsername(String username) {
    final cleanUsername = username.startsWith('@') ? username.substring(1) : username;
    try {
      return _usersMap.values.firstWhere(
        (user) => user.username.toLowerCase() == cleanUsername.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Default user khi không tìm thấy
  static UserModel _defaultUser(String authorId) {
    return UserModel(
      id: authorId,
      username: 'user_$authorId',
      fullName: 'Unknown User',
      avatarUrl: 'https://picsum.photos/150/150?random=999',
      coverUrl: 'https://picsum.photos/800/1200?random=999',
      headline: 'Welcome',
      bio: 'Hello world!',
      location: 'Unknown',
      followerCount: 0,
      followingCount: 0,
      isFollowedByMe: false,
    );
  }

  // ---- Pet Buddies ----
  static const _salahOwner = PetOwner(
    ownerId: 'user1',
    ownerName: 'Salahhh Home',
    ownerAvatar: 'https://picsum.photos/800/450?random=10',
  );

  static const _mickeyy = PetProfile(
    petId: 'pet1',
    petName: 'Mickeyy',
    petAvatar: 'https://picsum.photos/150/150?random=201',
    petOwner: _salahOwner,
    petPitching: 'Chó cưng đáng yêu nhất',
    isFollowedByMe: true,
    followerCount: 850,
  );

  static const _anniDogg = PetProfile(
    petId: 'pet2',
    petName: 'Anni Dogg',
    petAvatar: 'https://picsum.photos/150/150?random=202',
    petOwner: _salahOwner,
    petPitching: 'Playful pup',
    isFollowedByMe: false,
    followerCount: 420,
  );

  static const _petriCat = PetProfile(
    petId: 'pet3',
    petName: 'Petri Cat',
    petAvatar: 'https://picsum.photos/150/150?random=203',
    petOwner: _salahOwner,
    petPitching: 'Lazy cat vibes',
    isFollowedByMe: true,
    followerCount: 1200,
  );

  // ---- Human Buddies ----
  static final _jackUser = UserModel(
    id: 'buddy1',
    username: 'jack_roserna',
    fullName: 'Jack Roserna',
    avatarUrl: 'https://picsum.photos/150/150?random=301',
    coverUrl: 'https://picsum.photos/800/1200?random=301',
    headline: 'ADVENTURE SEEKER',
    bio: 'Life is short, explore the world with your furry friends!',
    location: 'New York, USA',
    followerCount: 3200,
    followingCount: 180,
    isFollowedByMe: true,
  );

  static final _haiiaUser = UserModel(
    id: 'buddy2',
    username: 'haiia',
    fullName: 'Haiia Nguyen',
    avatarUrl: 'https://picsum.photos/150/150?random=302',
    coverUrl: 'https://picsum.photos/800/1200?random=302',
    headline: 'PET LOVER',
    bio: 'Spreading love one paw at a time.',
    location: 'Ho Chi Minh, Vietnam',
    followerCount: 1499,
    followingCount: 220,
    isFollowedByMe: false,
  );

  static final _homiesbuddyUser = UserModel(
    id: 'user6',
    username: 'homiesbuddy',
    fullName: 'Homies Buddy Official',
    avatarUrl: 'https://picsum.photos/150/150?random=401',
    coverUrl: 'https://picsum.photos/800/1200?random=401',
    headline: 'CONNECTING PETS',
    bio: 'Official Homies Buddy account. Building community for pet lovers worldwide.',
    location: 'Global',
    followerCount: 25000,
    followingCount: 500,
    isFollowedByMe: true,
  );

  static final _buddyUser = UserModel(
    id: 'user7',
    username: 'buddy',
    fullName: 'Buddy',
    avatarUrl: 'https://picsum.photos/150/150?random=402',
    coverUrl: 'https://picsum.photos/800/1200?random=402',
    headline: 'GOOD BOY',
    bio: 'Just a good boy living my best life!',
    location: 'Everywhere',
    followerCount: 8500,
    followingCount: 150,
    isFollowedByMe: false,
  );

  // ---- Posts for users ----
  static final List<Post> _salahPosts = [
    Post(
      postId: 'p_user1_1',
      authorId: 'user1',
      authorName: 'Salahhh Home',
      authorAvatar: 'https://picsum.photos/800/450?random=10',
      createdAt: DateTime.now().subtract(const Duration(minutes: 18)),
      contentText: 'Xin chào tôi là Salahhh\n# SSG104',
      hashtags: ['SSG104'],
      mentions: ['@haiia'],
      mediaFiles: [
        MediaFile(
          id: 'pm1',
          mediaType: MediaType.image,
          mediaAspectRatio: 16 / 9,
          mediaUrl: 'https://picsum.photos/800/450?random=1',
          thumbnailUrl: 'https://picsum.photos/400/225?random=1',
          width: 800,
          height: 450,
        ),
      ],
      reactsCount: 2500,
      commentCount: 4,
      isLikedByMe: true,
      privacy: PostPrivacy.public,
    ),
    Post(
      postId: 'p_user1_2',
      authorId: 'user1',
      authorName: 'Salahhh Home',
      authorAvatar: 'https://picsum.photos/800/450?random=10',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      contentText: 'Beautiful sunset with my pets 🌅',
      hashtags: ['sunset', 'petlife'],
      mentions: [],
      mediaFiles: [
        MediaFile(
          id: 'pm2',
          mediaType: MediaType.image,
          mediaAspectRatio: 4 / 3,
          mediaUrl: 'https://picsum.photos/800/600?random=50',
          thumbnailUrl: 'https://picsum.photos/400/300?random=50',
          width: 800,
          height: 600,
        ),
      ],
      reactsCount: 1800,
      commentCount: 2,
      isLikedByMe: false,
      privacy: PostPrivacy.public,
    ),
  ];

  static final List<Post> _buddyPosts = [
    Post(
      postId: 'p_user2_1',
      authorId: 'user2',
      authorName: 'Buddy the Golden',
      authorAvatar: 'https://picsum.photos/150/150?random=102',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      contentText: 'Beautiful day at the park! 🌳☀️',
      hashtags: ['parklife', 'doglife'],
      mentions: ['@homiesbuddy', '@buddy'],
      mediaFiles: [
        MediaFile(
          id: 'pm3',
          mediaType: MediaType.image,
          mediaAspectRatio: 4 / 3,
          mediaUrl: 'https://picsum.photos/800/600?random=2',
          thumbnailUrl: 'https://picsum.photos/400/300?random=2',
          width: 800,
          height: 600,
        ),
      ],
      reactsCount: 1230,
      commentCount: 3,
      isLikedByMe: false,
      privacy: PostPrivacy.public,
    ),
  ];

  static final List<Post> _lunaPosts = [
    Post(
      postId: 'p_user3_1',
      authorId: 'user3',
      authorName: 'Luna & Max',
      authorAvatar: 'https://picsum.photos/150/150?random=103',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      contentText: 'Our first photoshoot together! 📸',
      hashtags: ['petphotography', 'bestfriends'],
      mentions: [],
      mediaFiles: [
        MediaFile(
          id: 'pm4',
          mediaType: MediaType.image,
          mediaAspectRatio: 1.0,
          mediaUrl: 'https://picsum.photos/800/800?random=3',
          thumbnailUrl: 'https://picsum.photos/400/400?random=3',
          width: 800,
          height: 800,
        ),
      ],
      reactsCount: 3450,
      commentCount: 4,
      isLikedByMe: true,
      privacy: PostPrivacy.friends,
    ),
  ];

  // ---- User Map ----
  static final Map<String, UserModel> _usersMap = {
    'user1': UserModel(
      id: 'user1',
      username: 'salahhh',
      fullName: 'Salahhh Home',
      avatarUrl: 'https://picsum.photos/800/450?random=10',
      coverUrl: 'https://picsum.photos/800/1200?random=10',
      headline: 'YOGA IN LIFE',
      bio: 'To the degree that we look clearly and compassionately at ourselves, we feel confident and fearless about looking into someone else\'s eyes.',
      location: 'California, USA',
      humanBuddies: [_jackUser, _haiiaUser],
      petBuddies: [_mickeyy, _anniDogg, _petriCat],
      followerCount: 1499,
      followingCount: 340,
      isFollowedByMe: false,
      posts: _salahPosts,
    ),
    'user2': UserModel(
      id: 'user2',
      username: 'buddy_golden',
      fullName: 'Buddy the Golden',
      avatarUrl: 'https://picsum.photos/150/150?random=102',
      coverUrl: 'https://picsum.photos/800/1200?random=20',
      headline: 'GOLDEN DAYS',
      bio: 'Living my best life with my hooman. Fetch is life!',
      location: 'Texas, USA',
      humanBuddies: [_jackUser],
      petBuddies: [_mickeyy],
      followerCount: 2100,
      followingCount: 150,
      isFollowedByMe: true,
      posts: _buddyPosts,
    ),
    'user3': UserModel(
      id: 'user3',
      username: 'luna_max',
      fullName: 'Luna & Max',
      avatarUrl: 'https://picsum.photos/150/150?random=103',
      coverUrl: 'https://picsum.photos/800/1200?random=30',
      headline: 'BEST FRIENDS',
      bio: 'Two paws, one heart. Adventures and naps together.',
      location: 'London, UK',
      humanBuddies: [_haiiaUser],
      petBuddies: [_anniDogg, _petriCat],
      followerCount: 8700,
      followingCount: 420,
      isFollowedByMe: true,
      posts: _lunaPosts,
    ),
    'user4': UserModel(
      id: 'user4',
      username: 'charlie_corgi',
      fullName: 'Charlie the Corgi',
      avatarUrl: 'https://picsum.photos/150/150?random=104',
      coverUrl: 'https://picsum.photos/800/1200?random=40',
      headline: 'CORGI LIFE',
      bio: 'Short legs, big heart. Trained and fabulous!',
      location: 'Sydney, Australia',
      humanBuddies: [_jackUser, _haiiaUser],
      petBuddies: [_mickeyy],
      followerCount: 1500,
      followingCount: 90,
      isFollowedByMe: false,
      posts: [],
    ),
    'user5': UserModel(
      id: 'user5',
      username: 'milo_cat',
      fullName: 'Milo the Cat',
      avatarUrl: 'https://picsum.photos/150/150?random=105',
      coverUrl: 'https://picsum.photos/800/1200?random=50',
      headline: 'NAP KING',
      bio: 'Professional napper. Part-time food taster.',
      location: 'Tokyo, Japan',
      humanBuddies: [],
      petBuddies: [_petriCat, _anniDogg],
      followerCount: 950,
      followingCount: 60,
      isFollowedByMe: true,
      posts: [],
    ),
    // Buddy users referenced by username for mention taps
    'buddy1': _jackUser,
    'buddy2': _haiiaUser,
    'user6': _homiesbuddyUser,
    'user7': _buddyUser,
  };
}
