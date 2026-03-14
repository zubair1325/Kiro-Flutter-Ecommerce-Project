import 'package:ecommerce/presentation/ui/screens/authentication/forget_password_screen.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loginInProgress = true;
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
                    Text("Login"),
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
                    Visibility(
                      visible: _loginInProgress == true,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {}
                        },
                        child: Text("LogIn"),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => ForgetPasswordScreen(),
                          ),
                          (predicate) => false,
                        );
                      },
                      child: Text("Forgot Password"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
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
