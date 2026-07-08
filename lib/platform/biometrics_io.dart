import 'package:local_auth/local_auth.dart';

final _auth = LocalAuthentication();

Future<bool> canCheckBiometrics() async {
  try {
    return await _auth.canCheckBiometrics;
  } catch (_) {
    return false;
  }
}

Future<bool> authenticateWithBiometrics(String reason) async {
  try {
    return await _auth.authenticate(
      localizedReason: reason,
      options: const AuthenticationOptions(biometricOnly: true),
    );
  } catch (_) {
    return false;
  }
}
