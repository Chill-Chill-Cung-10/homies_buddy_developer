/// [Refactored] Phase 3.5 — Extracted from profile_mock_data.dart
/// Mock pet profiles: PetOwner + PetProfile data
library;
import '../../../data/models/pet_profile_model.dart';
import '../../../data/models/pet_owner_model.dart';

class MockPets {
  static const salahOwner = PetOwner(
    ownerId: 'user1',
    ownerName: 'Salahhh Home',
    ownerAvatar: 'https://picsum.photos/800/450?random=10',
  );

  static const mickeyy = PetProfile(
    petId: 'pet1',
    petName: 'Mickeyy',
    petAvatar: 'https://picsum.photos/150/150?random=201',
    petOwner: salahOwner,
    petPitching: 'Chó cưng đáng yêu nhất',
    isFollowedByMe: true,
    followerCount: 850,
  );

  static const anniDogg = PetProfile(
    petId: 'pet2',
    petName: 'Anni Dogg',
    petAvatar: 'https://picsum.photos/150/150?random=202',
    petOwner: salahOwner,
    petPitching: 'Playful pup',
    isFollowedByMe: false,
    followerCount: 420,
  );

  static const petriCat = PetProfile(
    petId: 'pet3',
    petName: 'Petri Cat',
    petAvatar: 'https://picsum.photos/150/150?random=203',
    petOwner: salahOwner,
    petPitching: 'Lazy cat vibes',
    isFollowedByMe: true,
    followerCount: 1200,
  );
}
