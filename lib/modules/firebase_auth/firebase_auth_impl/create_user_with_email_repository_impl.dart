import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_auth_service.dart';

abstract class CreateUserWithEmailRepository {
  Future<({UserCredential? user, String? error})> createUser({
    required String name,
    required String email,
    required String password,
  });
}

class CreateUserWithEmailRepositoryImpl extends CreateUserWithEmailRepository {
  //
  final FirebaseAuthService _firebaseAuthService;

  ///   [CreateUserWithEmailRepositoryImpl] returns a clean (UserCredential? user, String? error).
  /// This removes the responsibility for exception handling from the UI, keeping the code clean and free of try-catch blocks in the view.
  CreateUserWithEmailRepositoryImpl({
    FirebaseAuthService? firebaseAuthService,
  }) : _firebaseAuthService = firebaseAuthService ??
            FirebaseAuthService(firebaseAuth: FirebaseAuth.instance);

  ///  Returns a Record with two optional values
  @override
  Future<({UserCredential? user, String? error})> createUser({
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

      // It returns a null user and the error message
      return (user: null, error: handledException.toString());
    } catch (e) {
      return (user: null, error: "An unknow exception occured: $e");
    }
  }
}
