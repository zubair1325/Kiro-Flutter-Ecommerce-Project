import 'package:ecommerce/presentation/controller/auth_controller.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/nid_verification.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/otp_verify_screen.dart';
import 'package:ecommerce/presentation/ui/screens/main_bottom_nav_screen.dart';
import 'package:ecommerce/presentation/ui/utility/snack_message.dart';
import 'package:ecommerce/presentation/ui/widgets/app_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class MobileAuthScreen extends StatefulWidget {
  const MobileAuthScreen({super.key});

  @override
  State<MobileAuthScreen> createState() => _MobileAuthScreenState();
}

class _MobileAuthScreenState extends State<MobileAuthScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _mobileNumberTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isProgressing = false;
  String? verificationId;

  @override
  void initState() {
    super.initState();
    _checkVerificationAndNavigate();
    _loadUserMobile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 140),
                    const AppLogo(),
                    const SizedBox(height: 24),
                    Text(
                      "Phone Verification",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),

                    ///  Mobile Input
                    userPhoneNumber(),

                    const SizedBox(height: 24),

                    /// Button / Loader
                    Visibility(
                      replacement: Center(
                        child: const CircularProgressIndicator(),
                      ),
                      visible: _isProgressing == false,
                      child: ElevatedButton(
                        onPressed: _userMobileNumberVerification,
                        child: const Text("Continue"),
                      ),
                    ),

                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField userPhoneNumber() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      controller: _mobileNumberTEController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(hintText: "Mobile Number"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Provide Valid Mobile Number";
        }
        if (value.length < 10) {
          return "Invalid number";
        }
        return null;
      },
    );
  }

  void _checkVerificationAndNavigate() {
    if (user != null && user!.phoneNumber != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NidVerification()),
        );
      });
    }
  }

  Future<void> _loadUserMobile() async {
    final mobile = await AuthController.userInformation;
    if (mounted) {
      _mobileNumberTEController.text = mobile;
    }
  }

  ///  PHONE AUTH FUNCTION
  Future<void> _userMobileNumberVerification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProgressing = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _mobileNumberTEController.text.trim(),

        /// Auto verification (Android)
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);

          // ignore: use_build_context_synchronously
          showSnackMessage(context, "Logged in Successfully");
          Get.offAll(() => const MainBottomNavScreen());
        },

        /// Error
        verificationFailed: (FirebaseAuthException e) {
          showSnackMessage(context, e.message ?? "Verification Failed", true);
        },

        /// OTP Sent
        codeSent: (String verificationId, int? resendToken) {
          verificationId = verificationId;

          showSnackMessage(context, "OTP Sent to your phone");
          Get.to(() => OtpVerifyScreen(verificationId: verificationId));
        },

        /// Timeout
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackMessage(context, "Something went wrong", true);
    }

    setState(() => _isProgressing = false);
  }

  @override
  void dispose() {
    _mobileNumberTEController.dispose();
    super.dispose();
  }
}
