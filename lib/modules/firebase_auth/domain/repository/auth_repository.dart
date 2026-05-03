import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<({User? user, String? error})> createUser({
    required String name,
    required String email,
    required String password,
  });
}
