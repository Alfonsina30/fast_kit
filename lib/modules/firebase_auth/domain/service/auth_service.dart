import 'package:firebase_auth/firebase_auth.dart';


abstract class AuthService {
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<User?> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendEmailCodeResetPassword({
    required String email,
  });

  Future<void> logOut();
}
