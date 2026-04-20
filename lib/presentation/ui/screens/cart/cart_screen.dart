import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/firebase/collection_holder.dart';
import 'package:ecommerce/presentation/state_holders/main_bottom_nav_controller.dart';
import 'package:ecommerce/presentation/ui/screens/product/checkout_screen.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:ecommerce/presentation/ui/widgets/cart/cart_product_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Stream<List<Map<String, dynamic>>> getCartStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection(CollectionHolder.cart)
        .doc(user.uid)
        .collection('items')
        .orderBy('added_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();
        });
  }

  double calculateTotal(List<Map<String, dynamic>> items) {
    double total = 0;

    for (var item in items) {
      final price = (item['price'] ?? 0).toDouble();
      final qty = (item['quantity'] ?? 1);
      total += price * qty;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (value) async {
        Get.find<MainBottomNavController>().bacToHome();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.find<MainBottomNavController>().bacToHome();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text("Cart"),
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: getCartStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final cartItems = snapshot.data ?? [];

            if (cartItems.isEmpty) {
              return const Center(child: Text("Cart is empty"));
            }

            final total = calculateTotal(cartItems);

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cartItems.length,
                    // ignore: unnecessary_underscores
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return CartProductItem(product: cartItems[index]);
                    },
                  ),
                ),

                totalPriceAndCheckOutSection(total, cartItems),
              ],
            );
          },
        ),
      ),
    );
  }

  // ✅ FIXED: receive cartItems
  Widget totalPriceAndCheckOutSection(
    double total,
    List<Map<String, dynamic>> cartItems,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withAlpha(35),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      height: 120,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Total Price",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
                Text(
                  "৳${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),

            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: cartItems.isEmpty
                    ? null
                    : () {
                        Get.to(
                          () =>
                              CheckoutScreen(items: cartItems, fromCart: true),
                        );
                      },
                child: const Text("Check Out"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
