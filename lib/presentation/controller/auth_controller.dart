import 'package:ecommerce/presentation/state_holders/operation_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final UserCredential? credential;
  final String? errorMessage;
  AuthController({this.credential, this.errorMessage});

  static bool userLoginStatus() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static Future<AuthController> userLogin(
    String emailAddress,
    String password,
  ) async {
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return AuthController(credential: user);
    } on FirebaseAuthException catch (e) {
      return AuthController(errorMessage: e.code);
    }
  }

  static singOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<OperationState> resetPassword(String emailAddress) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);
      return OperationState("A rest link send to $emailAddress");
    } catch (e) {
      return OperationState("Account not Found", isFailed: true);
    }
  }
}
