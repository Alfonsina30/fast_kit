import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../error/handle_exception_firebase.dart';
import '../model/user_model.dart';
import '../service/firebase_auth_service_impl.dart';

class AuthRepositoryImpl extends AuthRepository {
  //
  final FirebaseAuthServiceImpl _firebaseAuthService;
  AuthRepositoryImpl({
    FirebaseAuthServiceImpl? firebaseAuthService,
  }) : _firebaseAuthService = firebaseAuthService ??
            FirebaseAuthServiceImpl(firebaseAuth: FirebaseAuth.instance);

  @override
  Future<AuthResult> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      //
      final user = await _firebaseAuthService.createUserWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );

      return AuthResult(
          user: UserModel(
                  id: user?.uid, email: user?.email, name: user?.displayName)
              .modelToEntity(),
          error: null);
      //
    } on FirebaseAuthException catch (e) {
      final handledException = HandleExceptionAuthService.handleFirebase(e);

      log('EXCEPTION $e');

      log('handledException $handledException');

      // It returns a null user and the error message
      return AuthResult(user: null, error: handledException.messageError);
    } catch (e) {
      log('EXCEPTION $e');

      log('EXCEPTION ${e.runtimeType}');
      return AuthResult(user: null, error: "An unknow exception occured: $e");
    }
  }
}

class AuthResult {
  final UserEntity? user;
  final String? error;

  AuthResult({required this.user, required this.error});
}
