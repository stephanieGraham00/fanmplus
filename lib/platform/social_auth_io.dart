import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<Map<String, String?>> platformSignInWithApple() async {
  final credential = await SignInWithApple.getAppleIDCredential(scopes: [
    AppleIDAuthorizationScopes.email,
    AppleIDAuthorizationScopes.fullName,
  ]);
  return {
    'identityToken': credential.identityToken,
    'authorizationCode': credential.authorizationCode,
  };
}

Future<Map<String, String?>> platformSignInWithFacebook() async {
  final result = await FacebookAuth.instance.login();
  return {
    'accessToken': result.accessToken?.tokenString,
  };
}
