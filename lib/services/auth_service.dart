import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/security_utils.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isAuthenticated = false;
  bool _biometricEnabled = false;
  String? _authToken;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get biometricEnabled => _biometricEnabled;
  String? get authToken => _authToken;

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;

      final userRaw = prefs.getString('current_user');
      final token = prefs.getString('auth_token');

      if (userRaw != null && token != null) {
        final decoded = jsonDecode(userRaw);
        _currentUser = UserModel.fromJson(decoded as Map<String, dynamic>);
        _authToken = token;
        _isAuthenticated = true;
      }
    } catch (e) {
      debugPrint('Auth init error: $e');
    }
  }

  Future<bool> signUp(String username, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hashedPassword = SecurityUtils.hashPassword(password);
      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';

      await prefs.setString('user_${email}_password', hashedPassword);

      _currentUser = UserModel(
        id: userId,
        username: username,
        email: email,
      );

      _authToken = SecurityUtils.generateToken();
      await prefs.setString('auth_token', _authToken!);
      await _saveCurrentUser();

      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('SignUp error: $e');
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedHash = prefs.getString('user_${email}_password');

      if (storedHash == null) return false;
      if (!SecurityUtils.verifyPassword(password, storedHash)) return false;

      _authToken = SecurityUtils.generateToken();
      await prefs.setString('auth_token', _authToken!);

      _currentUser = UserModel(
        id: 'user_${email.hashCode}',
        username: email.split('@').first,
        email: email,
      );

      await _saveCurrentUser();
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('SignIn error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('current_user');

      _currentUser = null;
      _authToken = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      debugPrint('SignOut error: $e');
    }
  }

  Future<bool> toggleAnonymous() async {
    if (_currentUser == null) return false;

    try {
      _currentUser = _currentUser!.copyWith(
        isAnonymous: !_currentUser!.isAnonymous,
      );
      await _saveCurrentUser();
      notifyListeners();
      return _currentUser!.isAnonymous;
    } catch (e) {
      debugPrint('ToggleAnonymous error: $e');
      return false;
    }
  }

  Future<void> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      username: username,
      bio: bio,
      avatarUrl: avatarUrl,
    );

    await _saveCurrentUser();
    notifyListeners();
  }

  Future<void> toggleBiometric() async {
    _biometricEnabled = !_biometricEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', _biometricEnabled);
    notifyListeners();
  }

  Future<void> _saveCurrentUser() async {
    if (_currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', jsonEncode(_currentUser!.toJson()));
  }
}
