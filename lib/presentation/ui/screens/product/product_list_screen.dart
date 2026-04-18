import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/firebase/collection_holder.dart';
import 'package:ecommerce/presentation/state_holders/main_bottom_nav_controller.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:ecommerce/presentation/ui/widgets/product_card_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({
    super.key,
    this.category,
    this.sellerId,
    this.productSection,
  });
  final String? category;
  final String? sellerId;
  final String? productSection;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
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
          title:
              (widget.category != null && widget.category!.isNotEmpty) ||
                  (widget.productSection != null &&
                      widget.productSection!.isNotEmpty)
              ? (widget.category != null && widget.category!.isNotEmpty)
                    ? Text(
                        widget.category!.capitalizeFirst!,
                        style: TextStyle(fontSize: 18),
                      )
                    : Text(
                        widget.productSection!
                            .split('_')
                            .join(" ")
                            .capitalizeFirst!,
                        style: TextStyle(fontSize: 18),
                      )
              : Text("Products", style: TextStyle(fontSize: 18)),

          elevation: 3,
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: findProductList(),

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

  Future<List<Map<String, dynamic>>> findProductList() async {
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(
        CollectionHolder.products,
      );

      // Apply filters
      if (widget.category != null) {
        query = query.where('category', isEqualTo: widget.category);
      }

      if (widget.sellerId != null) {
        query = query.where('seller_id', isEqualTo: widget.sellerId);
      }

      // Handle new arrival
      if (widget.productSection == 'new_arrival') {
        final last7Days = DateTime.now().subtract(const Duration(days: 7));

        query = query
            .where(
              'created_at',
              isGreaterThanOrEqualTo: Timestamp.fromDate(last7Days),
            )
            .orderBy('created_at', descending: true);
      }

      final snapshot = await query.get();

      final products = snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      // Apply in-memory sorting
      if (widget.productSection == 'popular') {
        products.sort((a, b) {
          final orderA = a['order_count'] ?? 0;
          final orderB = b['order_count'] ?? 0;

          if (orderA != orderB) {
            return orderB.compareTo(orderA);
          }

          final ratingA = a['rating'] ?? 0;
          final ratingB = b['rating'] ?? 0;

          return ratingB.compareTo(ratingA);
        });
      }

      if (widget.productSection == 'special') {
        double getDiscount(Map item) {
          final percent = item['discount_percent'];
          final discountPrice = item['discount_price'];
          final price = item['price'] ?? 0;

          if (percent != null) return percent.toDouble();

          if (discountPrice != null && price != 0) {
            return ((price - discountPrice) / price) * 100;
          }

          return 0;
        }

        products.sort((a, b) => getDiscount(b).compareTo(getDiscount(a)));
      }

      return products;
    } catch (e) {
      return [];
    }
  }
}
