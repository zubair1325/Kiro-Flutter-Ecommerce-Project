import 'package:ecommerce/presentation/ui/screens/authentication/login_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _primaryMobileNumberTEController =
      TextEditingController();
  final TextEditingController _secondaryMobileNumberTEController =
      TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _addressTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _singUpInProgress = true;
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
                    Text("Create an Account"),
                    TextFormField(
                      decoration: InputDecoration(hint: Text("*Full name")),
                      controller: _nameTEController,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter your name";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hint: Text("*Mobile Number 1"),
                      ),
                      controller: _primaryMobileNumberTEController,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Provide Mobile Number";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hint: Text("Mobile Number 2 (Optional)"),
                      ),
                      controller: _secondaryMobileNumberTEController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hint: Text("Address")),
                      controller: _addressTEController,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Provide Current Address";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(hint: Text("Email")),
                      controller: _emailTEController,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Provide Valid Email Address";
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(hint: Text("Password")),
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

                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hint: Text("Confirm Password"),
                      ),
                      controller: _confirmPasswordTEController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Provide Password";
                        } else if (value!.length < 8) {
                          return "Provide at least 8 characters";
                        } else if (_passwordTEController.text != value) {
                          return "Password not Matched";
                        }
                        return null;
                      },
                    ),
                    Visibility(
                      visible: _singUpInProgress == true,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {}
                        },
                        child: Text("SingUp"),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => LoginScreen(),
                              ),
                              (predicate) => false,
                            );
                          },
                          child: Text("Login"),
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
