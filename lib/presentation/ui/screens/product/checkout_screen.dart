import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/firebase/collection_holder.dart';
import 'package:ecommerce/presentation/ui/screens/product/invoice_screen.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final bool fromCart;

  const CheckoutScreen({super.key, required this.items, this.fromCart = false});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Map<String, dynamic>? selectedAddress;
  bool addressLoaded = false;
  bool isPlacingOrder = false;

  double calculateTotal() {
    double total = 0;
    for (var item in widget.items) {
      final price = (item['price'] ?? 0).toDouble();
      final qty = (item['quantity'] ?? 1) as int;
      total += price * qty;
    }
    return total;
  }

  /// 🔹 GET USER ADDRESS
  Stream<Map<String, dynamic>?> getUserAddress() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection(CollectionHolder.user)
        .where('user_auth_id', isEqualTo: user.uid)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return snapshot.docs.first.data();
        });
  }

  /// 🔥 PLACE ORDER (FIXED PROPERLY)
  Future<void> placeOrder() async {
    if (isPlacingOrder) return;

    setState(() {
      isPlacingOrder = true;
    });

    final user = FirebaseAuth.instance.currentUser;

    if (user == null || selectedAddress == null) {
      Get.snackbar("Error", "Address not selected");
      setState(() => isPlacingOrder = false);
      return;
    }

    final firestore = FirebaseFirestore.instance;
    final total = calculateTotal();

    try {
      final orderId = await firestore.runTransaction((transaction) async {
        /// 🔹 CHECK + UPDATE STOCK
        for (var item in widget.items) {
          final String productId = item['product_id'];
          final int orderQty = (item['quantity'] ?? 1) as int;

          final productRef = firestore.collection('products').doc(productId);

          final productSnap = await transaction.get(productRef);

          if (!productSnap.exists) {
            throw Exception("Product not found");
          }

          final currentStock = (productSnap['quantity'] ?? 0) as int;

          if (currentStock < orderQty) {
            throw Exception(
              "Not enough stock for ${productSnap['product_name']}",
            );
          }

          transaction.update(productRef, {'quantity': currentStock - orderQty});
        }

        /// 🔹 CREATE ORDER
        final orderRef = firestore.collection('orders').doc();

        transaction.set(orderRef, {
          'order_id': orderRef.id,
          'user_id': user.uid,
          'total_price': total,
          'status': 'pending',
          'created_at': FieldValue.serverTimestamp(),
          'items': widget.items,
          'address': selectedAddress,
        });

        return orderRef.id;
      });

      /// 🔹 CLEAR CART
      if (widget.fromCart) {
        final cartRef = firestore
            .collection(CollectionHolder.cart)
            .doc(user.uid)
            .collection('items');

        final cartItems = await cartRef.get();
        final batch = firestore.batch();

        for (var doc in cartItems.docs) {
          batch.delete(doc.reference);
        }

        await batch.commit();
      }

      /// 🔹 NAVIGATE
      Get.off(
        () => InvoiceScreen(
          orderId: orderId,
          orderData: {
            'items': widget.items,
            'total_price': total,
            'address': selectedAddress,
          },
        ),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isPlacingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = calculateTotal();

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Order Summary",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                ...widget.items.map((item) {
                  return ListTile(
                    leading: Image.network(
                      item['image'] ?? '',
                      width: 50,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported),
                    ),
                    title: Text(item['name'] ?? ''),
                    subtitle: Text("Qty: ${item['quantity']}"),
                    trailing: Text("৳${item['price']}"),
                  );
                }),

                const SizedBox(height: 20),

                const Text(
                  "Delivery Address",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                /// 🔹 ADDRESS STREAM
                StreamBuilder<Map<String, dynamic>?>(
                  stream: getUserAddress(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    final userData = snapshot.data;
                    print(userData);

                    if (userData == null) {
                      return const Text("No address found");
                    }

                    /// ✅ FIX: avoid rebuild loop safely
                    if (!addressLoaded) {
                      Future.microtask(() {
                        if (mounted) {
                          setState(() {
                            selectedAddress = userData;
                            addressLoaded = true;
                          });
                        }
                      });
                    }

                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(
                          "${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}",
                        ),
                        subtitle: Text(
                          "${userData['shipping_address'] ?? ''}, ${userData['city'] ?? ''}",
                        ),
                        trailing: Text(userData['mobile'] ?? ''),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          /// 🔹 BOTTOM BAR
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withAlpha(30),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "৳${total.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: (selectedAddress == null || isPlacingOrder)
                        ? null
                        : placeOrder,
                    child: isPlacingOrder
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Place Order"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
