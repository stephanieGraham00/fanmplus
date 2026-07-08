import 'dart:convert';
import 'dart:math';

class SecurityUtils {
  SecurityUtils._();

  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final salt = 'FanmPlusSalt2026!';
    final salted = utf8.encode(password + salt);
    int hash = 0;
    for (final byte in salted) {
      hash = (hash * 31 + byte) & 0xFFFFFFFF;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }

  static bool verifyPassword(String input, String storedHash) {
    return hashPassword(input) == storedHash;
  }

  static String generateToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  static String obscureData(String data) {
    if (data.length < 4) return '****';
    return data[0] + '*' * (data.length - 2) + data[data.length - 1];
  }

  static bool isInputSafe(String input) {
    final dangerous = RegExp(r'[<>\'";]');
    return !dangerous.hasMatch(input);
  }

  static String sanitizeInput(String input) {
    return input.replaceAll(RegExp(r'[<>\'";]'), '');
  }
}
