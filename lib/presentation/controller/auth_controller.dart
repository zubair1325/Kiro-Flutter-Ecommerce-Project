import 'package:ecommerce/presentation/state_holders/operation_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final UserCredential? credential;
  final String? errorMessage;
  AuthController({this.credential, this.errorMessage});

  static bool get userLoginStatus {
    return FirebaseAuth.instance.currentUser != null;
  }

  static void userProfilePicture(String imageLink) async {
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageLink);
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

  static Future<void> singOut() async {
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

  static Future<OperationState> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && user.email != null) {
      try {
        // 1. Re-authenticate the user
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // 2. Update the password
        await user.updatePassword(newPassword);
        print("Password updated successfully.");
        return OperationState("Password updated successfully.");
      } on FirebaseAuthException catch (e) {
        print("Error: ${e.message}");
      }
    }
    return OperationState("Account not Found", isFailed: true);
  }
}
