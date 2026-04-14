import 'dart:async';
import 'package:ecommerce/presentation/ui/screens/menu/login_state.dart';
import 'package:ecommerce/presentation/ui/screens/menu/seller/store_name_screen.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:ecommerce/presentation/ui/utility/snack_message.dart';
import 'package:ecommerce/presentation/ui/widgets/app_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String verificationId;

  const OtpVerifyScreen({super.key, required this.verificationId});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  int _otpExpireTime = 120;

  bool _isVerifying = false;
  String _otpCode = '';

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 140),
                const AppLogo(width: 135),
                const SizedBox(height: 24),

                Text(
                  "Enter OTP Code",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 5),

                Text(
                  "A 6 digits pin has been sent",
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                const SizedBox(height: 20),

                /// MATERIAL PIN FIELD (FIXED)
                MaterialPinField(
                  length: 6,
                  obscureText: false,
                  onChanged: (value) {
                    _otpCode = value;
                  },
                  onCompleted: (pin) {
                    _otpCode = pin;
                  },
                  theme: MaterialPinTheme(
                    shape: MaterialPinShape.outlined,
                    cellSize: const Size(50, 50),
                    borderColor: AppColors.primaryColor,
                    cursorColor: AppColors.primaryColor,
                    focusedBorderColor: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                const SizedBox(height: 25),

                /// VERIFY BUTTON
                Visibility(
                  replacement: Center(child: const CircularProgressIndicator()),
                  visible: _isVerifying == false,
                  child: ElevatedButton(
                    onPressed: _verifyOtp,
                    child: const Text("Verify Code"),
                  ),
                ),

                const SizedBox(height: 15),

                /// TIMER
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "This code will expire in ",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      TextSpan(
                        text: "$_otpExpireTime s",
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                /// RESEND
                TextButton(
                  onPressed: _otpExpireTime == 0
                      ? () {
                          Get.offAll(() => const LoginState());
                        }
                      : null,
                  child: Text(
                    "Resend Code",
                    style: _otpExpireTime == 0
                        ? TextStyle(color: AppColors.primaryColor)
                        : Theme.of(context).textTheme.titleSmall,
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// TIMER FIX
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpExpireTime == 0) {
        timer.cancel();
      } else {
        setState(() {
          _otpExpireTime--;
        });
      }
    });
  }

  /// VERIFY OTP
  Future<void> _verifyOtp() async {
    if (_otpCode.length != 6) {
      showSnackMessage(context, "Enter valid 6 digit OTP", true);
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpCode,
      );

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.linkWithCredential(credential);

        //  refresh user
        await user.reload();

        // ignore: use_build_context_synchronously
        showSnackMessage(context, "Phone Number Linked Successfully");

        Get.offAll(() => const StoreNameScreen());
      } else {
        showSnackMessage(context, "User not logged in", true);
      }
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showSnackMessage(context, e.message ?? "OTP Failed", true);
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackMessage(context, "Something went wrong", true);
    }

    setState(() => _isVerifying = false);
  }
}
