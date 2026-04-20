import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CarouselRequestScreen extends StatefulWidget {
  const CarouselRequestScreen({super.key});

  @override
  State<CarouselRequestScreen> createState() =>
      _CarouselRequestScreenState();
}

class _CarouselRequestScreenState
    extends State<CarouselRequestScreen> {
  final TextEditingController _amountController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? selectedProductId;
  Map<String, dynamic>? selectedProduct;

  bool isLoading = false;

  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a product"),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('carousel_requests')
          .add({
        "product_id": selectedProductId,
        "seller_id": userId,
        "amount":
            double.parse(_amountController.text.trim()),
        "status": "pending",
        "created_at": Timestamp.now(),
        "product_data": selectedProduct,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Request submitted successfully"),
        ),
      );

      setState(() {
        selectedProduct = null;
        selectedProductId = null;
        _amountController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Carousel Request")),

      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('seller_id', isEqualTo: userId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// PRODUCT SELECT
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedProductId,
                    hint:
                        const Text("Select Product"),
                    items: products.map((doc) {
                      final data = doc.data();

                      return DropdownMenuItem(
                        value: doc.id,
                        child: Text(
                          data['product_name'],
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final doc = products.firstWhere(
                          (e) => e.id == value);

                      setState(() {
                        selectedProductId = value;
                        selectedProduct =
                            doc.data();
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// AMOUNT FIELD
                  TextFormField(
                    controller: _amountController,
                    keyboardType:
                        TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter Amount (BDT)",
                      border: OutlineInputBorder(),
                    ),

                    /// VALIDATION
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return "Amount is required";
                      }

                      final number =
                          double.tryParse(value);

                      if (number == null) {
                        return "Enter valid number";
                      }

                      if (number <= 0) {
                        return "Amount must be greater than 0";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : submitRequest,
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Submit Request"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}