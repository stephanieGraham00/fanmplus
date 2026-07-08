import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
});

final userProvider = FutureProvider.family<UserModel?, String>((ref, userId) async {
  return ref.read(firestoreServiceProvider).getUser(userId);
});

final loginProvider = Provider.autoDispose((ref) {
  final authService = ref.read(authServiceProvider);
  return LoginActions(authService, ref);
});

class LoginActions {
  final AuthService _authService;
  final Ref _ref;

  LoginActions(this._authService, this._ref);

  Future<UserCredential> login(String email, String password) async {
    return await _authService.loginWithEmail(email, password);
  }

  Future<UserCredential> register(String email, String password, String name) async {
    final cred = await _authService.registerWithEmail(email, password, name);
    final user = UserModel(
      id: cred.user!.uid,
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );
    await _ref.read(firestoreServiceProvider).createUser(user);
    return cred;
  }

  Future<UserCredential> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  Future<UserCredential> signInWithApple() async {
    return await _authService.signInWithApple();
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
