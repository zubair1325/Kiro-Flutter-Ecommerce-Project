import 'package:ecommerce/presentation/ui/screens/authentication/reset_password_screen.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/signup_screen.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';

import 'package:ecommerce/presentation/ui/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OptVerifyScreen extends StatefulWidget {
  const OptVerifyScreen({super.key});

  @override
  State<OptVerifyScreen> createState() => _OptVerifyScreenState();
}

class _OptVerifyScreenState extends State<OptVerifyScreen> {
  @override
  void initState() {
    super.initState();
    decreaseCount();
  }

  int _optExpireTime = 120;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool _forgetPasswordInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 160),
                    AppLogo(width: 150),
                    SizedBox(height: 24),
                    Text(
                      "Enter OTP Code",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "A 6 digits pin has been send",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: 15),
                    // ---------------------------------------------------------
                    MaterialPinField(
                      obscureText: true,
                      length: 4,
                      onCompleted: (pin) => print('PIN: $pin'),
                      onChanged: (value) => print('Changed: $value'),
                      theme: MaterialPinTheme(
                        shape: MaterialPinShape.outlined,
                        cellSize: Size(56, 64),
                        borderColor: AppColors.primaryColor,
                        cursorColor: AppColors.primaryColor,
                        filledBorderColor: AppColors.primaryColor,
                        focusedBorderColor: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    // --------------------------------------------------
                    SizedBox(height: 25),
                    Visibility(
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => ResetPasswordScreen(),
                              ),
                              (predicate) => false,
                            );
                          }
                        },
                        child: Text("Verify Code"),
                      ),
                    ),
                    SizedBox(height: 15),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "This code will expired in ",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          TextSpan(
                            text: "$_optExpireTime s",

                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15),
                    TextButton(
                      onPressed: _optExpireTime == 0
                          ? () {
                              Navigator.pushAndRemoveUntil(

                                
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => SignupScreen(),
                                ),
                                (predicate) => false,
                              );
                            }
                          : null,
                      child: Text(
                        "Resend Code",
                        style: _optExpireTime == 0
                            ? TextStyle(color: AppColors.primaryColor)
                            : Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => SignupScreen(),
                              ),
                              (predicate) => false,
                            );
                          },
                          child: Text(
                            "SignUp",
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void decreaseCount() async {
    while (_optExpireTime != 0) {
      await Future.delayed(Duration(seconds: 1));
      _optExpireTime--;
      setState(() {});
    }
  }
}
