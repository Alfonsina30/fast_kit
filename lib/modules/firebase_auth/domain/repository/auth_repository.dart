import 'package:fast_kit/modules/firebase_auth/firebase_auth_files.dart';

abstract class AuthRepository {
  //
  Future<AuthResult> createUser({
    required String name,
    required String email,
    required String password,
  });
}
