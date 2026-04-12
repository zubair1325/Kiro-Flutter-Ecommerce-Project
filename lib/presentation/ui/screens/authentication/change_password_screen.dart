import 'package:ecommerce/presentation/controller/auth_controller.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/login_screen.dart';
import 'package:ecommerce/presentation/ui/screens/menu/login_state.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:ecommerce/presentation/ui/utility/snack_message.dart';
import 'package:ecommerce/presentation/ui/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordTEController =
      TextEditingController();
  final TextEditingController _newPasswordTEController =
      TextEditingController();
  final TextEditingController _confirmNewPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool changePasswordProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "Change Password",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 25,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 45),
                    AppLogo(width: 120),
                    SizedBox(height: 30),
                    currentPassword(context),
                    SizedBox(height: 15),
                    newPassword(context),
                    SizedBox(height: 15),
                    confirmNewPassword(context),
                    SizedBox(height: 15),
                    Visibility(
                      visible: changePasswordProgress == false,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: _userPasswordChange,
                        child: Text("Continue"),
                      ),
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

  Future _userPasswordChange() async {
    changePasswordProgress = true;
    if (mounted) {
      setState(() {});
    }
    if (_formKey.currentState!.validate()) {
      final operationState = await AuthController.changePassword(
        _currentPasswordTEController.text,
        _confirmNewPasswordTEController.text,
      );
      if (operationState.isFailed!) {
        showSnackMessage(
          // ignore: use_build_context_synchronously
          context,
          operationState.message ?? "Unknown error on singUp_screen",
          operationState.isFailed!,
        );
      } else {
        showSnackMessage(
          // ignore: use_build_context_synchronously
          context,
          operationState.message ?? "Unknown error on singUp_screen",
          
        );
        await AuthController.singOut();
        Get.offAll(LoginScreen());
      }
    }
    changePasswordProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  TextFormField confirmNewPassword(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: InputDecoration(
        hint: Text(
          "Confirm New Password",
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      controller: _confirmNewPasswordTEController,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return "Provide Exact Password";
        } else if (value!.length < 8) {
          return "Provide at least 8 characters";
        } else if (_newPasswordTEController.text != value) {
          return "Password not Matched";
        }
        return null;
      },
    );
  }

  TextFormField newPassword(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      obscureText: true,
      decoration: InputDecoration(
        hint: Text(
          "New Password",
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      controller: _newPasswordTEController,
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

  TextFormField currentPassword(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      obscureText: true,
      decoration: InputDecoration(
        hint: Text(
          "Current Password",
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      controller: _currentPasswordTEController,
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

  @override
  void dispose() {
    super.dispose();
    _confirmNewPasswordTEController.dispose();
    _currentPasswordTEController.dispose();
    _newPasswordTEController.dispose();
  }
}
