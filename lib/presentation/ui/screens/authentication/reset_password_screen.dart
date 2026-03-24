import 'package:ecommerce/presentation/ui/screens/authentication/forget_password_screen.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/signup_screen.dart';
import 'package:ecommerce/presentation/ui/screens/main_bottom_nav_screen.dart';
import 'package:ecommerce/presentation/ui/widgets/app_logo.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool _loginInProgress = true;
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
                    SizedBox(height: 140),
                    AppLogo(),
                    SizedBox(height: 24),
                    Text(
                      "Reset Password",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      decoration: InputDecoration(
                        hint: Text(
                          "Password",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      controller: _passwordTEController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Provide Password";
                        } else if (value!.length < 8) {
                          return "Provide at least 8 characters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      decoration: InputDecoration(
                        hint: Text(
                          "Confirm Password",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      controller: _confirmPasswordTEController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Provide Exact Password";
                        } else if (value!.length < 8) {
                          return "Provide at least 8 characters";
                        } else if (_passwordTEController.text != value) {
                          return "Password not Matched";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    Visibility(
                      visible: _loginInProgress == true,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => MainBottomNavScreen(),
                              ),
                              (predicate) => false,
                            );
                          }
                        },
                        child: Text("Change Password"),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => ForgetPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => SignupScreen(),
                              ),
                            );
                          },
                          child: Text("SignUp"),
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
}
