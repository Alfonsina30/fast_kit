import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  //
  final FirebaseAuth firebaseAuth;

  FirebaseAuthService({required this.firebaseAuth});

  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    //
    try {
      final userData = await firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (userData.user != null) {
        return userData;
        //
      } else {
        throw HandleExceptionAuthService(
            messageError: 'user is currently signed out');
      }
    } on FirebaseAuthException catch (e) {
      throw HandleExceptionAuthService.handleFirebase(e);
    } catch (e) {
      throw HandleExceptionAuthService(messageError: 'Error not controlled');
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    //
    try {
      final userData = await firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (userData.user != null) {
        return userData;
        //
      } else {
        throw HandleExceptionAuthService(
            messageError: 'User is currently signed out');
      }
    } on FirebaseAuthException catch (e) {
      throw HandleExceptionAuthService.handleFirebase(e);
    } catch (e) {
      throw HandleExceptionAuthService(messageError: e.toString());
    }
  }

  Future<void> sendEmailCodeResetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      throw HandleExceptionAuthService.handleFirebase(e);
    } catch (e) {
      throw HandleExceptionAuthService();
    }
  }

  Future<void> logOut() async {
    try {
      await firebaseAuth.signOut();
      //
    } on FirebaseAuthException catch (e) {
      HandleExceptionAuthService.handleFirebase(e);
    } catch (e) {
      throw HandleExceptionAuthService();
    }
  }
}



//! HANDLE EXCEPTION
class HandleExceptionAuthService {

  //
  final String messageError;

  
  HandleExceptionAuthService(
      {this.messageError = 'An unknow exception occured'});
  //
  //! firebase
  factory HandleExceptionAuthService.handleFirebase(
      FirebaseAuthException exceptionFire) {
    final exception = exceptionFire.code;

    switch (exception) {
      case 'invalid-email' || 'auth/invalid-email':
        return HandleExceptionAuthService(
            messageError: 'Email address is not valid');
      case 'email-already-in-use':
        return HandleExceptionAuthService(messageError: 'Email already in use');
      case 'user-disabled':
        return HandleExceptionAuthService(
            messageError: ' The given email has been disabled');

      case 'user-not-found' || 'auth/user-not-found':
        return HandleExceptionAuthService(
            messageError: 'Does not user corresponding to the given email');
      case 'wrong-password':
        return HandleExceptionAuthService(
            messageError: 'The password is invalid');

      case 'too-many-requests':
        return HandleExceptionAuthService(
            messageError:
                'Was sent too many requests at the same time, for security the need to wait for some time');

      case 'INVALID_LOGIN_CREDENTIALS' || 'invalid-credential':
        return HandleExceptionAuthService(
            messageError: 'The credential is not valid');

      case 'expired-action-code':
        return HandleExceptionAuthService(messageError: 'The code has expired');

      case 'invalid-action-code':
        return HandleExceptionAuthService(
            messageError: 'The code is malformed or has already been used');

//**********use when user create account from google, facebook */
      case 'provider-already-linked':
        return HandleExceptionAuthService(
            messageError:
                'The Google Account has already been linked to the user.');

      case 'credential-already-in-use':
        return HandleExceptionAuthService(
            messageError:
                'The account corresponding to the credential already exists');

      default:
        return HandleExceptionAuthService();
    }
  }
}
