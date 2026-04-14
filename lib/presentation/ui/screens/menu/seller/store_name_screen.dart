import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/presentation/ui/screens/menu/seller/nid_verification.dart';
import 'package:ecommerce/presentation/ui/utility/snack_message.dart';
import 'package:ecommerce/presentation/ui/widgets/app_logo.dart';
import 'package:flutter/material.dart';

class StoreNameScreen extends StatefulWidget {
  const StoreNameScreen({super.key});

  @override
  State<StoreNameScreen> createState() => _StoreNameScreenState();
}

class _StoreNameScreenState extends State<StoreNameScreen> {
  TextEditingController storeNameTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Store Name")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 130),
                    const AppLogo(width: 110),
                    const SizedBox(height: 15),
                    Text(
                      "Provide Store Name",
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: storeNameTEController,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Provide Store Name";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(hintText: "Store Name"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool isAvailable = await isStoreNameAvailable;
                          if (isAvailable) {
                            Navigator.pushReplacement(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (builder) => NidVerification(
                                  storeName: storeNameTEController.text.trim(),
                                ),
                              ),
                            );
                          } else {
                            showSnackMessage(
                              // ignore: use_build_context_synchronously
                              context,
                              "Store name not available",
                              true,
                            );
                          }
                        }
                      },
                      child: const Text("Continue"),
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

  Future<bool> get isStoreNameAvailable async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('seller')
          .where('store_name', isEqualTo: storeNameTEController.text.trim())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }
}
