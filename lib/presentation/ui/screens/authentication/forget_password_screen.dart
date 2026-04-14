import 'package:ecommerce/presentation/controller/auth_controller.dart';
import 'package:ecommerce/presentation/controller/auth_wrapper.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/signup_screen.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:ecommerce/presentation/ui/utility/snack_message.dart';
import 'package:ecommerce/presentation/ui/widgets/app_logo.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _forgetPasswordInProgress = false;
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
                      "Recover Your Account",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Please enter yor email address",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: 5),
                    emailAddressTextFormField(context),

                    SizedBox(height: 15),
                    Visibility(
                      visible: _forgetPasswordInProgress == false,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: _sendRestPasswordLink,
                        child: Text("Send Code"),
                      ),
                    ),

                    SizedBox(height: 10),
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => SignupScreen()),
              (predicate) => false,
            );
          },
          child: Text(
            "SignUp",
            style: TextStyle(color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }

  Future _sendRestPasswordLink() async {
    _forgetPasswordInProgress = true;
    if (mounted) {
      setState(() {});
    }
    if (_formKey.currentState!.validate()) {
      final operationState = await AuthController.resetPassword(
        _emailTEController.text.trim(),
      );
      showSnackMessage(
        // ignore: use_build_context_synchronously
        context,
        operationState.message!,
        operationState.isFailed!,
      );
      Get.to(AuthWrapper());
    }
  }

  TextFormField emailAddressTextFormField(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hint: Text(
          "Email Address",
          style: Theme.of(context).textTheme.titleSmall,
        ),
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

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
  }
}
