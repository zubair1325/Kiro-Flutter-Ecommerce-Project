import 'package:ecommerce/presentation/state_holders/main_bottom_nav_controller.dart';
import 'package:ecommerce/presentation/ui/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
          title: Text("Categories", style: TextStyle(fontSize: 18)),
          elevation: 3,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.builder(
            itemCount: 30,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 2 columns
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return FittedBox(child: CategoryItem());
            },
          ),
        ),
      ),
    );
  }
}
