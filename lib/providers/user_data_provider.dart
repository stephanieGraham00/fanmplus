import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import 'auth_provider.dart';

final currentUserDataProvider = FutureProvider<UserModel?>((ref) {
  final authUser = ref.watch(authStateProvider).valueOrNull;
  if (authUser == null) return Future.value(null);
  return ref.read(firestoreServiceProvider).getUser(authUser.uid);
});
