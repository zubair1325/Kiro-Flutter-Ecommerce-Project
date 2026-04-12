import 'package:ecommerce/presentation/controller/auth_controller.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/mobile_auth_screen.dart';
import 'package:ecommerce/presentation/ui/utility/snack_message.dart';
import 'package:ecommerce/presentation/ui/widgets/app_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null && !user!.emailVerified) {
      AuthController.userEmailVerification();
    }
    _checkVerificationAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 155),
                const AppLogo(width: 140),
                const SizedBox(height: 15),
                Text(
                  "Email Verification",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 20),
                Text("Please Check you ${user!.email}"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendEmailVerificationLink,
                  child: const Text("Continue"),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Did not get any link?"),
                    TextButton(
                      onPressed: () {
                        AuthController.userEmailVerification();
                        showSnackMessage(
                          context,
                          "Verification link has been send to your account",
                        );
                      },
                      child: Text("Click here"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _sendEmailVerificationLink() async {
    await FirebaseAuth.instance.currentUser?.reload();

    user = FirebaseAuth.instance.currentUser;

    if (user != null && user!.emailVerified) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => const MobileAuthScreen()),
      );
    } else {
      // ignore: use_build_context_synchronously
      showSnackMessage(context, "Not Verified Yet, Try Again", true);
    }
  }

  void _checkVerificationAndNavigate() {
    if (user != null && user!.emailVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MobileAuthScreen()),
        );
      });
    }
  }
}
