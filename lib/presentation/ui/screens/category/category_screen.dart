import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/firebase/collection_holder.dart';
import 'package:ecommerce/presentation/state_holders/main_bottom_nav_controller.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:ecommerce/presentation/ui/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        Get.find<MainBottomNavController>().bacToHome();
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff8f9fb),

        appBar: AppBar(
          title: const Text(
            "Categories",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Get.find<MainBottomNavController>().bacToHome();
              Get.back();
            },
          ),
        ),

        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: findAllCategories(),
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

            final categoryList = snapshot.data ?? [];

            if (categoryList.isEmpty) {
              return const Center(
                child: Text(
                  "No categories found",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: categoryList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 2.8,
                ),
                itemBuilder: (context, index) {
                  final categoryName = categoryList[index]['category'] ?? '';

                  return CategoryItem(name: categoryName);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> findAllCategories() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(CollectionHolder.categories)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
