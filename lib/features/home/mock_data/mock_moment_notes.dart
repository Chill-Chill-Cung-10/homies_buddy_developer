import '../../../data/models/moment_note_model.dart';

/// Mock data để test giao diện CardNoteItem trong user moments list
class MockMomentNotes {
  static const _avatarUrl1 =
      'https://i.pravatar.cc/150?img=3';
  static const _avatarUrl2 =
      'https://i.pravatar.cc/150?img=5';
  static const _avatarUrl3 =
      'https://i.pravatar.cc/150?img=12';

  /// Danh sách mock notes để test
  static List<MomentNote> get sampleNotes => [
        // Note 1: Chỉ text, không media
        MomentNote(
          id: 'note_001',
          authorName: 'Manh Nguyen',
          authorAvatarUrl: _avatarUrl1,
          createdAt: DateTime(2026, 2, 28, 14, 40),
          textContent:
              'Today was a great day! Finished all my tasks and had some quality time with friends 🎉',
        ),

        // Note 2: Text + 1 ảnh
        MomentNote(
          id: 'note_002',
          authorName: 'Haiia Tran',
          authorAvatarUrl: _avatarUrl2,
          createdAt: DateTime(2026, 2, 28, 12, 15),
          textContent: 'Beautiful sunset from my balcony 🌅',
          mediaUrls: [
            'https://picsum.photos/seed/sunset/600/400',
          ],
        ),

        // Note 3: Text + 2 ảnh
        MomentNote(
          id: 'note_003',
          authorName: 'Linh Pham',
          authorAvatarUrl: _avatarUrl3,
          createdAt: DateTime(2026, 2, 27, 18, 30),
          textContent: 'Coffee date with besties ☕',
          mediaUrls: [
            'https://picsum.photos/seed/coffee1/600/400',
            'https://picsum.photos/seed/coffee2/600/400',
          ],
        ),

        // Note 4: Text + 3 ảnh
        MomentNote(
          id: 'note_004',
          authorName: 'Manh Nguyen',
          authorAvatarUrl: _avatarUrl1,
          createdAt: DateTime(2026, 2, 27, 10, 5),
          textContent: 'Weekend trip to Da Lat 🏔️ So refreshing!',
          mediaUrls: [
            'https://picsum.photos/seed/dalat1/600/400',
            'https://picsum.photos/seed/dalat2/400/400',
            'https://picsum.photos/seed/dalat3/400/400',
          ],
        ),

        // Note 5: Chỉ media, không text
        MomentNote(
          id: 'note_005',
          authorName: 'Haiia Tran',
          authorAvatarUrl: _avatarUrl2,
          createdAt: DateTime(2026, 2, 26, 20, 0),
          mediaUrls: [
            'https://picsum.photos/seed/food1/600/400',
            'https://picsum.photos/seed/food2/600/400',
            'https://picsum.photos/seed/food3/600/400',
            'https://picsum.photos/seed/food4/600/400',
          ],
        ),

        // Note 6: Text + 5 ảnh (test overlay "+N")
        MomentNote(
          id: 'note_006',
          authorName: 'Linh Pham',
          authorAvatarUrl: _avatarUrl3,
          createdAt: DateTime(2026, 2, 26, 15, 45),
          textContent:
              'Team building photos! What an amazing day we had together 🤩🎊',
          mediaUrls: [
            'https://picsum.photos/seed/team1/600/400',
            'https://picsum.photos/seed/team2/600/400',
            'https://picsum.photos/seed/team3/600/400',
            'https://picsum.photos/seed/team4/600/400',
            'https://picsum.photos/seed/team5/600/400',
            'https://picsum.photos/seed/team6/600/400',
          ],
        ),
      ];
}
