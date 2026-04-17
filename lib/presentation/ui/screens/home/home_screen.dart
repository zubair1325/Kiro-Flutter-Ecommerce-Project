import 'package:ecommerce/presentation/state_holders/main_bottom_nav_controller.dart';
import 'package:ecommerce/presentation/ui/screens/product/product_list_screen.dart';
import 'package:ecommerce/presentation/ui/widgets/app_bar_logo.dart';
import 'package:ecommerce/presentation/ui/widgets/category_item.dart';
import 'package:ecommerce/presentation/ui/widgets/home/circle_icon_button.dart';
import 'package:ecommerce/presentation/ui/widgets/home/image_carousel.dart';
import 'package:ecommerce/presentation/ui/widgets/home/section_title.dart';
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
                categoryType: "Popular",
                onTapAction: () {
                  Get.to(() => ProductListScreen());
                },
              ),
              const SizedBox(height: 18),
              popularProductList,
              const SizedBox(height: 18),
              SectionTitle(categoryType: "Special", onTapAction: () {}),
              const SizedBox(height: 18),
              popularProductList,
              const SizedBox(height: 18),
              SectionTitle(categoryType: "New", onTapAction: () {}),
              const SizedBox(height: 18),
              popularProductList,
            ],
          ),
        ),
      ),
    );
  }

  SizedBox get categoryList {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        itemCount: 10,
        shrinkWrap: true,
        primary: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return CategoryItem(name: "Electronics");
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 10);
        },
      ),
    );
  }

  SizedBox get popularProductList {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        itemCount: 10,
        shrinkWrap: true,
        primary: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          //return ProductCardItem();
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 10);
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
        CircleIconButton(iconData: Icons.person, onTap: () {}),
        SizedBox(width: 15),
        CircleIconButton(iconData: Icons.call, onTap: () {}),
        SizedBox(width: 15),
        CircleIconButton(iconData: Icons.notifications, onTap: () {}),
        SizedBox(width: 20),
      ],
    );
  }
}
