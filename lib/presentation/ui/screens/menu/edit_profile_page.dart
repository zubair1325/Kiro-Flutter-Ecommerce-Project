import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/cloudnary/cloud_preset.dart';
import 'package:ecommerce/data/cloudnary/image_upload.dart';
import 'package:ecommerce/presentation/ui/screens/authentication/email_auth_screen.dart';
import 'package:ecommerce/presentation/ui/utility/snack_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditProfilePage extends StatefulWidget {
  bool? isKiroSeller;
  EditProfilePage({super.key, this.isKiroSeller = false});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();

  String? userDocId;
  bool isLoading = true;
  bool isProgressing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: 50),
                ImageUpload(imagePreset: CloudPreset.userPreset, isUser: true),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          _buildField("First Name", firstNameController),
                          _buildField("Last Name", lastNameController),
                          _buildField("Mobile", mobileController),
                          _buildField("City", cityController),
                          _buildField("Shipping Address", addressController),

                          const SizedBox(height: 20),

                          Visibility(
                            visible: isProgressing = true,
                            replacement: Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              onPressed: _updateProfile,
                              child: const Text("Continue"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    final query = await FirebaseFirestore.instance
        .collection('user')
        .where('user_auth_id', isEqualTo: user?.uid)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;

      userDocId = doc.id;
      final data = doc.data();

      firstNameController.text = data['first_name'] ?? "";
      lastNameController.text = data['last_name'] ?? "";
      mobileController.text = data['mobile'] ?? "";
      cityController.text = data['city'] ?? "";
      addressController.text = data['shipping_address'] ?? "";
    }

    isLoading = false;
    setState(() {});
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      isProgressing = true;
      if (mounted) {
        setState(() {});
      }

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userDocId)
          .update({
            "first_name": firstNameController.text.trim(),
            "last_name": lastNameController.text.trim(),
            "mobile": mobileController.text.trim(),
            "city": cityController.text.trim(),
            "shipping_address": addressController.text.trim(),
          });

      // ignore: use_build_context_synchronously
      showSnackMessage(context, "Profile Updated Successfully");
      // ignore: use_build_context_synchronously
      // print(widget.isKiroSeller);
      widget.isKiroSeller!
          ? Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (_) => EmailAuthScreen()),
            )
          // ignore: use_build_context_synchronously
          : Navigator.pop(context);
    }
    if (userDocId == null) {
      // ignore: use_build_context_synchronously
      showSnackMessage(context, "User not found", true);
    }
    isProgressing = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    cityController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }
}
