import 'package:ecommerce/presentation/state_holders/main_bottom_nav_controller.dart';
import 'package:ecommerce/presentation/ui/widgets/product_card_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key, this.category});
  final String? category;

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
          title: Text(
            widget.category ?? "Products",
            style: TextStyle(fontSize: 18),
          ),

          elevation: 3,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.builder(
            itemCount: 30,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 2 columns
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              return FittedBox(child: ProductCardItem());
            },
          ),
        ),
      ),
    );
  }
}
