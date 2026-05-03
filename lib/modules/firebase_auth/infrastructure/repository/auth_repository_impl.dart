import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../service/firebase_auth_service_impl.dart';
import '../error/handle_exception_firebase.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  //
  final FirebaseAuthServiceImpl _firebaseAuthService;

  ///   [AuthRepositoryImpl] returns a clean (UserCredential? user, String? error).
  /// This removes the responsibility for exception handling from the UI, keeping the code clean and free of try-catch blocks in the view.
  AuthRepositoryImpl({
    FirebaseAuthServiceImpl? firebaseAuthService,
  }) : _firebaseAuthService = firebaseAuthService ??
            FirebaseAuthServiceImpl(firebaseAuth: FirebaseAuth.instance);

  ///  Returns a Record with two optional values
  @override
  Future<({User? user, String? error})> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _firebaseAuthService.createUserWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );

      //Returns the user and a null error
      return (user: user, error: null);
    } on FirebaseAuthException catch (e) {
      final handledException = HandleExceptionAuthService.handleFirebase(e);

      log('EXCEPTION $e');

      log('handledException $handledException');

      // It returns a null user and the error message
      return (user: null, error: handledException.messageError);
    } catch (e) {
      log('EXCEPTION $e');

      log('EXCEPTION ${e.runtimeType}');

      return (user: null, error: "An unknow exception occured: $e");
    }
  }
}
