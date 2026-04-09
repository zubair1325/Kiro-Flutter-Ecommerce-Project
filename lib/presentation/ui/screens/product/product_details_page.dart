import 'package:ecommerce/presentation/state_holders/main_bottom_nav_controller.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:ecommerce/presentation/ui/widgets/product_details/color_selector.dart';
import 'package:ecommerce/presentation/ui/widgets/product_details/product_description.dart';
import 'package:ecommerce/presentation/ui/widgets/product_details/product_image_carousel.dart';
import 'package:ecommerce/presentation/ui/widgets/product_details/size_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  List<Color> allColors = [
    Colors.yellow,
    Colors.black,
    Colors.blue,
    Colors.pink,
  ];
  List<String> allSize = ["M", "L", "XL", "XXL", "XXXL"];
  Color? selectedColor;
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.find<MainBottomNavController>().bacToHome();
            Get.back();
          },
        ),
        title: Text("Product Details", style: TextStyle(fontSize: 18)),
        elevation: 3,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [const ProductImageCarousel(), productDetailsBody],
              ),
            ),
          ),
          priceAndAddToCartSection,
        ],
      ),
    );
  }

  Padding get productDetailsBody {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  "Nike Sport Shoe 2023 Edition ED26R - Save up to 30%",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(Icons.star, size: 16, color: Colors.amber),
                  Text(
                    "4.8",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
              Text(
                "Reviews",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(4),
                ),
                color: AppColors.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.favorite_border_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Color",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(height: 8),
          ColorSelector(
            allColors: allColors,
            onChange: (selectedColor) {
              selectedColor = selectedColor;
            },
          ),
          SizedBox(height: 16),
          Text(
            "Size",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(height: 8),
          SizeSelector(
            allSize: allSize,
            onChange: (selectedSize) {
              selectedSize = selectedSize;
            },
          ),
          SizedBox(height: 16),
          Text(
            "Description",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(height: 8),
          ProductDescription(),
        ],
      ),
    );
  }

  Container get priceAndAddToCartSection {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withAlpha(35),
        borderRadius: BorderRadius.only(
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
                Text(
                  "Price",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
                Text(
                  "99999",
                  style: TextStyle(
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
                onPressed: () {},
                child: Text("Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
