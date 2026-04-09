import 'package:ecommerce/data/users/user_information.dart';
import 'package:ecommerce/presentation/controller/auth_wrapper.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/login_screen.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:ecommerce/presentation/ui/utility/snack_message.dart';
import 'package:ecommerce/presentation/ui/widgets/app_logo.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _primaryMobileNumberTEController =
      TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _cityTEController = TextEditingController();
  final TextEditingController _addressTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _singUpInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: Center(
                child: Column(
                  children: [
                    AppLogo(width: 140),
                    SizedBox(height: 15),
                    Text(
                      "Complect Profile",
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 28),
                    ),
                    Text(
                      "Get Started with us with your details",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(height: 15),

                    firstNameTextField(context),
                    SizedBox(height: 15),
                    lastNameTextField(context),
                    SizedBox(height: 15),

                    phoneNumberTextField(context),

                    SizedBox(height: 15),
                    emailAddressTextField(context),
                    SizedBox(height: 15),
                    cityTextField(context),
                    SizedBox(height: 15),
                    shippingAddressTextField(context),
                    SizedBox(height: 15),
                    passwordTextField(context),
                    SizedBox(height: 15),
                    confirmPasswordTextField(context),

                    SizedBox(height: 15),
                    Visibility(
                      visible: _singUpInProgress == false,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: _singUpFireStore,
                        child: Text("SingUp"),
                      ),
                    ),
                    SizedBox(height: 15),
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
                          child: Text(
                            "Login",
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

  TextFormField confirmPasswordTextField(BuildContext context) {
    return TextFormField(
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
    );
  }

  TextFormField passwordTextField(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
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

  TextFormField shippingAddressTextField(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      maxLines: 4,
      decoration: InputDecoration(
        hint: Text(
          "Shipping Address",
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      controller: _addressTEController,
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return "Provide Current Address";
        }
        return null;
      },
    );
  }

  TextFormField cityTextField(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hint: Text("City", style: Theme.of(context).textTheme.titleSmall),
      ),
      controller: _cityTEController,
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return "City Name is Required";
        }
        return null;
      },
    );
  }

  TextFormField emailAddressTextField(BuildContext context) {
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

  TextFormField phoneNumberTextField(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hint: Text("Mobile", style: Theme.of(context).textTheme.titleSmall),
      ),
      controller: _primaryMobileNumberTEController,
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return "Mobile Number is Required";
        }
        return null;
      },
    );
  }

  TextFormField lastNameTextField(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hint: Text("Last Name", style: Theme.of(context).textTheme.titleSmall),
      ),
      controller: _lastNameTEController,
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return "Name is Required";
        }
        return null;
      },
    );
  }

  TextFormField firstNameTextField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hint: Text("First Name", style: Theme.of(context).textTheme.titleSmall),
      ),
      textInputAction: TextInputAction.next,

      controller: _firstNameTEController,
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return "Name is Required";
        }
        return null;
      },
    );
  }

  Future _singUpFireStore() async {
    _singUpInProgress = true;
    if (mounted) {
      setState(() {});
    }
    if (_formKey.currentState!.validate()) {
      UserInformation user = UserInformation(
        _cityTEController.text.trim(),
        _emailTEController.text.trim(),
        _firstNameTEController.text.trim(),
        _lastNameTEController.text.trim(),
        _primaryMobileNumberTEController.text.toString().trim(),
        _addressTEController.text.trim(),
        _passwordTEController.text,
      );
      await _singUpAuth(user);
      String authUserID = FirebaseAuth.instance.currentUser!.uid;
      user.userAuthID = authUserID;
      final operationState = await UserInformation.addData(user);
      showSnackMessage(
        // ignore: use_build_context_synchronously
        context,
        operationState.message ?? "Unknown error on singUp_screen",
        operationState.isFailed,
      );
      Get.offAll(AuthWrapper());
    }
    _singUpInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future _singUpAuth(UserInformation user) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.emailAddress!,
            password: user.password!,
          );
      await credential.user?.updateDisplayName(
        "${user.firstName} ${user.lastName}",
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _addressTEController.dispose();
    _cityTEController.dispose();
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    _emailTEController.dispose();
    _primaryMobileNumberTEController.dispose();
  }
}
