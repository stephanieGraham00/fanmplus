import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../platform/social_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> loginWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerWithEmail(String email, String password, String name) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await cred.user?.updateDisplayName(name);
    await cred.user?.reload();
    return cred;
  }

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');
    final auth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithApple() async {
    final result = await platformSignInWithApple();
    final credential = OAuthProvider('apple.com').credential(
      idToken: result['identityToken'],
      accessToken: result['authorizationCode'],
    );
    return await _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    final result = await platformSignInWithFacebook();
    final accessToken = result['accessToken'];
    if (accessToken == null) throw Exception('Facebook login failed');
    final credential = FacebookAuthProvider.credential(accessToken);
    return await _auth.signInWithCredential(credential);
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> saveLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
  }

  Future<bool> checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }
}
