import 'package:ecommerce/presentation/controller/auth_controller.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/forget_password_screen.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/signup_screen.dart';
import 'package:ecommerce/presentation/ui/screens/main_bottom_nav_screen.dart';
import 'package:ecommerce/presentation/ui/utility/snack_message.dart';
import 'package:ecommerce/presentation/ui/widgets/app_logo.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loginInProgress = false;
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
                    SizedBox(height: 80),
                    AppLogo(height: 80,),
                    SizedBox(height: 24),
                    Text(
                      "Welcome Back",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 24),
                    emailTextFormField(context),
                    SizedBox(height: 24),
                    passwordTextFormField(context),
                    SizedBox(height: 24),
                    Visibility(
                      visible: _loginInProgress == false,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: _login,
                        child: Text("LogIn"),
                      ),
                    ),
                    SizedBox(height: 15),
                    forgetPasswordTextButton(context),
                    singUpTextButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row singUpTextButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?"),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (builder) => SignupScreen()),
            );
          },
          child: Text("SignUp"),
        ),
      ],
    );
  }

  TextButton forgetPasswordTextButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (builder) => ForgetPasswordScreen()),
        );
      },
      child: Text(
        "Forgot Password",
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  TextFormField passwordTextFormField(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: InputDecoration(
        hint: Text("Password", style: Theme.of(context).textTheme.titleSmall),
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
    );
  }

  TextFormField emailTextFormField(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hint: Text("Email", style: Theme.of(context).textTheme.titleSmall),
      ),
      controller: _emailTEController,
      validator: (value) {
        if (value == null ||
            value.trim().isEmpty ||
            !EmailValidator.validate(value)) {
          return "Provide Valid Email Address";
        }

        return null;
      },
    );
  }

  Future _login() async {
    _loginInProgress = true;
    if (mounted) {
      setState(() {});
    }
    if (_formKey.currentState!.validate()) {
      final result = await AuthController.userLogin(
        _emailTEController.text.trim(),
        _passwordTEController.text,
      );
      _loginInProgress = false;
      if (mounted) {
        setState(() {});
      }
      if (result.credential != null) {
        // ignore: use_build_context_synchronously
        showSnackMessage(context, "Logged in Success");
        Get.offAll(() => MainBottomNavScreen());
      } else {
        showSnackMessage(
          // ignore: use_build_context_synchronously
          context,
          result.errorMessage ?? "Unknown Error",
          true,
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
  }
}
