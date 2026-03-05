import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Firebase Service - Single source of truth cho Firebase instances
/// 
/// Cung cấp các instance đã được initialize của Firebase services
/// để sử dụng trong repositories và providers.
class FirebaseService {
  // Singleton pattern
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();
  factory FirebaseService() => instance;

  // Firebase instances
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;

  // Current user helper
  User? get currentUser => auth.currentUser;
  String? get currentUserId => currentUser?.uid;
  bool get isAuthenticated => currentUser != null;

  // Firestore collections references (typed)
  CollectionReference<Map<String, dynamic>> get usersCollection =>
      firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get postsCollection =>
      firestore.collection('posts');

  CollectionReference<Map<String, dynamic>> get usernamesCollection =>
      firestore.collection('usernames');

  // Subcollections helpers
  CollectionReference<Map<String, dynamic>> postComments(String postId) =>
      postsCollection.doc(postId).collection('comments');

  CollectionReference<Map<String, dynamic>> postReacts(String postId) =>
      postsCollection.doc(postId).collection('reacts');

  CollectionReference<Map<String, dynamic>> userFollowers(String userId) =>
      usersCollection.doc(userId).collection('followers');

  CollectionReference<Map<String, dynamic>> userFollowing(String userId) =>
      usersCollection.doc(userId).collection('following');

  CollectionReference<Map<String, dynamic>> userNotifications(String userId) =>
      usersCollection.doc(userId).collection('notifications');

  // Storage references helpers
  Reference get storageRoot => storage.ref();
  Reference avatarRef(String userId) => storageRoot.child('avatars/$userId');
  Reference coverRef(String userId) => storageRoot.child('covers/$userId');
  Reference postMediaRef(String postId) => storageRoot.child('posts/$postId');

  /// Batch write helper
  WriteBatch batch() => firestore.batch();

  /// Transaction helper
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction) transactionHandler,
  ) =>
      firestore.runTransaction(transactionHandler);
}
