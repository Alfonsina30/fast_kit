import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/service/auth_service.dart';

class FirebaseAuthServiceImpl extends AuthService {
  //
  final FirebaseAuth firebaseAuth;

  FirebaseAuthServiceImpl({required this.firebaseAuth});

  @override
  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    //

    final UserCredential userCredential =
        await firebaseAuth.signInWithEmailAndPassword(
            email: email.trim(), password: password.trim());

    final user = userCredential.user;

    if (user == null) return null;

    return user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    //

    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());

    final user = userCredential.user;

    if (user == null) return null;

    return user;
  }

  @override
  Future<void> sendEmailCodeResetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  @override
  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }
}
