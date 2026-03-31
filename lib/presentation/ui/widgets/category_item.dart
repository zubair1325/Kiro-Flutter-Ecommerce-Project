import 'package:ecommerce/presentation/ui/screens/product_list_screen.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductListScreen(category: "Electronics"));
      },
      child: Column(
        children: [
          Card(
            color: AppColors.primaryColor.withAlpha(60),
            child: const Padding(
              padding: EdgeInsets.all(24.0),
              child: Icon(
                Icons.computer,
                size: 32,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          Text(
            "Electronics",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
