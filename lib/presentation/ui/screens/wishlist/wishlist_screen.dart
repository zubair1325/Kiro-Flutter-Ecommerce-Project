import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/firebase/collection_holder.dart';
import 'package:ecommerce/presentation/state_holders/main_bottom_nav_controller.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:ecommerce/presentation/ui/widgets/product_card_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
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
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.find<MainBottomNavController>().bacToHome();
              Get.back();
            },
          ),
          title: Text("Wishlist", style: TextStyle(fontSize: 18)),

          elevation: 3,
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: getWishlist(),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              );
            }

            final allProducts = snapshot.data ?? [];

            if (allProducts.isEmpty) {
              return const Center(
                child: Text(
                  "No categories found",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.builder(
                itemCount: allProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 2 columns
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  return FittedBox(
                    child: ProductCardItem(product: allProducts[index]),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getWishlist() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      final wishlistSnapshot = await FirebaseFirestore.instance
          .collection(CollectionHolder.wishlist)
          .doc(user.uid)
          .collection('items')
          .get();

      List<Map<String, dynamic>> products = [];

      for (var doc in wishlistSnapshot.docs) {
        final productId = doc.id;

        final productDoc = await FirebaseFirestore.instance
            .collection(CollectionHolder.products)
            .doc(productId)
            .get();

        if (productDoc.exists) {
          products.add({'id': productDoc.id, ...productDoc.data()!});
        }
      }

      return products;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
