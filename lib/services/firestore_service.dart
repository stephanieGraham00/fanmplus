import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/cycle_model.dart';
import '../models/tracker_model.dart';
import '../models/post_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Users
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUser(String id) async {
    final doc = await _db.collection('users').doc(id).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!, doc.id);
  }

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _db.collection('users').doc(id).update(data);
  }

  // Cycle
  Future<void> logCycle(CycleLog log) async {
    await _db.collection('cycle_logs').add(log.toMap());
  }

  Stream<QuerySnapshot> getCycleLogs(String userId) {
    return _db
        .collection('cycle_logs')
        .where('user_id', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Mood
  Future<void> logMood(MoodLog log) async {
    await _db.collection('moods').add(log.toMap());
  }

  Stream<QuerySnapshot> getMoodLogs(String userId) {
    return _db
        .collection('moods')
        .where('user_id', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Symptoms
  Future<void> logSymptom(SymptomLog log) async {
    await _db.collection('symptoms').add(log.toMap());
  }

  // Water
  Future<void> logWater(WaterLog log) async {
    await _db.collection('water').add(log.toMap());
  }

  // Exercise
  Future<void> logExercise(ExerciseLog log) async {
    await _db.collection('exercise').add(log.toMap());
  }

  // Sleep
  Future<void> logSleep(SleepLog log) async {
    await _db.collection('sleep').add(log.toMap());
  }

  // Community Posts
  Future<void> createPost(CommunityPost post) async {
    await _db.collection('posts').add(post.toMap());
  }

  Stream<QuerySnapshot> getPosts() {
    return _db
        .collection('posts')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Future<void> likePost(String postId, String userId) async {
    final postRef = _db.collection('posts').doc(postId);
    await postRef.update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> unlikePost(String postId, String userId) async {
    final postRef = _db.collection('posts').doc(postId);
    await postRef.update({
      'likes': FieldValue.arrayRemove([userId]),
    });
  }

  Future<void> addComment(String postId, Comment comment) async {
    final postRef = _db.collection('posts').doc(postId);
    await postRef.update({
      'comments': FieldValue.arrayUnion([comment.toMap()]),
    });
  }

  // Activity Log
  Future<void> logActivity(String userId, String action, {String? details}) async {
    await _db.collection('activity_log').add({
      'user_id': userId,
      'action': action,
      'details': details ?? '',
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
