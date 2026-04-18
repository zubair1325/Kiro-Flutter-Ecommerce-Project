import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/firebase/collection_holder.dart';
import 'package:ecommerce/presentation/controller/auth_controller.dart';
import 'package:ecommerce/presentation/state_holders/main_bottom_nav_controller.dart';
import 'package:ecommerce/presentation/ui/screens/home/product_list_type.dart';
import 'package:ecommerce/presentation/ui/screens/product/product_list_screen.dart';
import 'package:ecommerce/presentation/ui/widgets/app_bar_logo.dart';
import 'package:ecommerce/presentation/ui/widgets/category_item.dart';
import 'package:ecommerce/presentation/ui/widgets/home/circle_icon_button.dart';
import 'package:ecommerce/presentation/ui/widgets/home/image_carousel.dart';
import 'package:ecommerce/presentation/ui/widgets/home/section_title.dart';
import 'package:ecommerce/presentation/ui/widgets/product_card_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              const SizedBox(height: 10),
              searchTextField,
              const SizedBox(height: 18),
              ImageCarousel(),
              const SizedBox(height: 18),
              SectionTitle(
                categoryType: "All Categories",
                onTapAction: () {
                  Get.find<MainBottomNavController>().changeIndex(0);
                },
              ),
              const SizedBox(height: 18),
              categoryList,
              const SizedBox(height: 18),
              SectionTitle(
                categoryType: "All Products",
                onTapAction: () {
                  Get.to(
                    () => ProductListScreen(
                      productSection: ProductListType.allProduct,
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              partialProductList(future: allProductList()),
              const SizedBox(height: 18),
              SectionTitle(
                categoryType: "Popular",
                onTapAction: () {
                  Get.to(
                    () => ProductListScreen(
                      productSection: ProductListType.popular,
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              partialProductList(future: popularProduct()),
              const SizedBox(height: 18),
              SectionTitle(
                categoryType: "Special",
                onTapAction: () {
                  Get.to(
                    () => ProductListScreen(
                      productSection: ProductListType.special,
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              partialProductList(future: specialProductList()),
              const SizedBox(height: 18),
              SectionTitle(
                categoryType: "New",
                onTapAction: () {
                  Get.to(
                    () => ProductListScreen(
                      productSection: ProductListType.newArrival,
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              partialProductList(future: getNewArrivals()),
            ],
          ),
        ),
      ),
    );
  }

  Widget get categoryList {
    return FutureBuilder<List<String>>(
      future: findAllCategories(), // The function we wrote earlier
      builder: (context, snapshot) {
        // 1. Show a loader while waiting for Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 130,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Handle Errors (e.g., no internet)
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // 3. Handle Empty Data
        final categories = snapshot.data ?? [];
        if (categories.isEmpty) {
          return const Center(child: Text("No categories found"));
        }

        // 4. Success: Show the ListView
        return SizedBox(
          height: 130,
          child: ListView.separated(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return CategoryItem(
                name: categories[index],
              ); // Use data from list
            },
            separatorBuilder: (context, index) => const SizedBox(width: 10),
          ),
        );
      },
    );
  }

  // SizedBox get partialProductList {
  //   return SizedBox(
  //     height: 200,
  //     child: ListView.separated(
  //       itemCount: 10,
  //       shrinkWrap: true,
  //       primary: true,
  //       scrollDirection: Axis.horizontal,
  //       itemBuilder: (context, index) {
  //         //return ProductCardItem();
  //       },
  //       separatorBuilder: (BuildContext context, int index) {
  //         return SizedBox(width: 10);
  //       },
  //     ),
  //   );
  // }

  SizedBox partialProductList({
    required Future<List<Map<String, dynamic>>> future,
  }) {
    return SizedBox(
      height: 200,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          return ListView.separated(
            itemCount: products.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return ProductCardItem(product: products[index]);
            },
            separatorBuilder: (_, __) => const SizedBox(width: 10),
          );
        },
      ),
    );
  }

  TextFormField get searchTextField {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),

        hint: Text("Search", style: Theme.of(context).textTheme.titleSmall),
      ),
    );
  }

  AppBar get appBar {
    return AppBar(
      title: AppBarLogo(),
      actions: [
        AuthController.userLoginStatus
            ? CircleIconButton(iconData: Icons.person, onTap: () {})
            : SizedBox.shrink(),
        SizedBox(width: 15),
      ],
    );
  }

  Future<List<String>> findAllCategories() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(CollectionHolder.categories)
        .limit(10)
        .get();
    return snapshot.docs
        .map((doc) => doc.data()['category'] as String)
        .toList();
  }

  Future<List<Map<String, dynamic>>> allProductList() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(CollectionHolder.products)
          .limit(10)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> popularProduct() async {
    try {
      // Fetch all products to ensure we find the true top 10 after sorting
      final snapshot = await FirebaseFirestore.instance
          .collection(CollectionHolder.products)
          .get();

      final products = snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      // Sort by order_count, then by rating
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
      return products.take(10).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> specialProductList() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(CollectionHolder.products)
          .get();

      final products = snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      products.sort((a, b) {
        double getDiscount(Map item) {
          final percent = item['discount_percent'];
          final discountPrice = item['discount_price'];
          final price = item['price'] ?? 0;

          // Priority 1: Use direct percentage if it exists
          if (percent != null) return percent.toDouble();

          // Priority 2: Calculate percentage from discount price
          if (discountPrice != null && price != 0) {
            return ((price - discountPrice) / price) * 100;
          }

          return 0;
        }

        // Sort descending (highest discount first)
        return getDiscount(b).compareTo(getDiscount(a));
      });

      // Return only the top 10 most discounted items
      return products.take(10).toList();
    } catch (e) {
      //print("Error fetching special products: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getNewArrivals() async {
    try {
      final now = DateTime.now();
      final last7Days = now.subtract(const Duration(days: 7));

      final snapshot = await FirebaseFirestore.instance
          .collection(CollectionHolder.products)
          .where(
            'created_at',
            isGreaterThanOrEqualTo: Timestamp.fromDate(last7Days),
          )
          .orderBy('created_at', descending: true)
          .limit(10)
          .get();

      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      // print("Error fetching new arrivals: $e");
      return [];
    }
  }
}
