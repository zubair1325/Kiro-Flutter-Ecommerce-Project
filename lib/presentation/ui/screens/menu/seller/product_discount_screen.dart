import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDiscountScreen extends StatefulWidget {
  const ProductDiscountScreen({super.key});

  @override
  State<ProductDiscountScreen> createState() => _ProductDiscountScreenState();
}

class _ProductDiscountScreenState extends State<ProductDiscountScreen> {
  final TextEditingController _discountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? selectedProductId;
  Map<String, dynamic>? selectedProduct;

  bool isLoading = false;

  int selectedHours = 24; // default 1 day

  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> applyDiscount() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedProductId == null || selectedProduct == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a product")));
      return;
    }

    final double discount = double.parse(_discountController.text.trim());

    if (discount <= 0 || discount > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Discount must be between 1 - 100%")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final now = DateTime.now();
      final endTime = now.add(Duration(hours: selectedHours));

      final productRef = FirebaseFirestore.instance
          .collection('products')
          .doc(selectedProductId);

      await productRef.update({
        "discount_percent": discount,
        "is_discount_active": true,
        "discount_start": Timestamp.fromDate(now),
        "discount_end": Timestamp.fromDate(endTime),
        "updated_at": Timestamp.now(),
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Discount applied successfully")),
      );

      setState(() {
        selectedProductId = null;
        selectedProduct = null;
        _discountController.clear();
        selectedHours = 24;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Discount Manager")),

      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('seller_id', isEqualTo: userId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PRODUCT SELECT
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedProductId,
                    hint: const Text("Select Product"),
                    items: products.map((doc) {
                      final data = doc.data();

                      return DropdownMenuItem(
                        value: doc.id,
                        child: Text(
                          data['product_name'] ?? 'No Name',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final doc = products.firstWhere((e) => e.id == value);

                      setState(() {
                        selectedProductId = value;
                        selectedProduct = doc.data();
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// DISCOUNT INPUT
                  TextFormField(
                    controller: _discountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter Discount (%)",
                      border: OutlineInputBorder(),
                      hintText: "e.g. 10",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Discount required";
                      }

                      final num = double.tryParse(value);

                      if (num == null) {
                        return "Enter valid number";
                      }

                      if (num <= 0 || num > 100) {
                        return "Must be 1 - 100";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// DURATION SELECTOR
                  const Text(
                    "Discount Duration",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<int>(
                    value: selectedHours,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("1 Hour")),
                      DropdownMenuItem(value: 6, child: Text("6 Hours")),
                      DropdownMenuItem(value: 12, child: Text("12 Hours")),
                      DropdownMenuItem(value: 24, child: Text("1 Day")),
                      DropdownMenuItem(value: 72, child: Text("3 Days")),
                      DropdownMenuItem(value: 168, child: Text("7 Days")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedHours = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  /// SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : applyDiscount,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Apply Discount"),
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
