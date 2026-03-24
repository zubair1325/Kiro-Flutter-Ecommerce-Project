import 'package:ecommerce/presentation/ui/screens/authentication/login_screen.dart';
import 'package:ecommerce/presentation/ui/screens/main_bottom_nav_screen.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:ecommerce/presentation/ui/widgets/app_logo.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

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
  final bool _singUpInProgress = true;
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
                    TextFormField(
                      decoration: InputDecoration(
                        hint: Text(
                          "First Name",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      textInputAction: TextInputAction.next,

                      controller: _firstNameTEController,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Name is Required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hint: Text(
                          "Last Name",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      controller: _lastNameTEController,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Name is Required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hint: Text(
                          "Mobile",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      controller: _primaryMobileNumberTEController,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Mobile Number is Required";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 15),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hint: Text(
                          "Email",
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
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hint: Text(
                          "City",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      controller: _cityTEController,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "City Name is Required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
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
                    ),
                    SizedBox(height: 15),
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

                    SizedBox(height: 15),
                    Visibility(
                      visible: _singUpInProgress == true,
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
}
