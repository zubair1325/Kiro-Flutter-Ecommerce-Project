import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/firebase/collection_holder.dart';
import 'package:ecommerce/presentation/state_holders/main_bottom_nav_controller.dart';
import 'package:ecommerce/presentation/ui/screens/product/product_list_screen.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:ecommerce/presentation/ui/utility/snack_message.dart';
import 'package:ecommerce/presentation/ui/widgets/product_details/color_parser.dart';
import 'package:ecommerce/presentation/ui/widgets/product_details/color_selector.dart';
import 'package:ecommerce/presentation/ui/widgets/product_details/product_description.dart';
import 'package:ecommerce/presentation/ui/widgets/product_details/product_image_carousel.dart';
import 'package:ecommerce/presentation/ui/widgets/product_details/size_parser.dart';
import 'package:ecommerce/presentation/ui/widgets/product_details/size_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
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
                children: [
                  ProductImageCarousel(images: widget.product['images'] ?? []),
                  productDetailsBody(widget.product),
                ],
              ),
            ),
          ),
          buyAndAddToCartSection,
        ],
      ),
    );
  }

  Padding productDetailsBody(Map<String, dynamic> product) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [productPrice(), addToWishListColumn()],
            ),
          ),
          SizedBox(height: 15),
          Row(children: [productName(product)]),
          SizedBox(height: 8),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (builder) =>
                      ProductListScreen(sellerId: product['seller_id']),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.storefront_outlined,
                  color: AppColors.primaryColor,
                  size: 28,
                ),
                SizedBox(width: 8),
                Text(
                  "Visit Store",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          product['colors'] != null
              ? Text(
                  "Color",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                )
              : SizedBox.shrink(),

          SizedBox(height: 8),
          ColorSelector(
            allColors: parseColors(product['colors'] ?? ""),
            onChange: (color) {
              setState(() {
                selectedColor = color;
              });
            },
          ),
          SizedBox(height: 16),
          product['sizes'] != null
              ? Text(
                  "Size",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                )
              : SizedBox.shrink(),
          SizedBox(height: 8),

          SizeSelector(
            allSize: parseSize(product['sizes'] ?? ""),
            onChange: (size) {
              setState(() {
                selectedSize = size;
              });
            },
          ),
          SizedBox(height: 16),
          product['description'] != null
              ? Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                )
              : SizedBox.shrink(),
          SizedBox(height: 8),
          product['description'] != null
              ? ProductDescription(description: product['description'] ?? "")
              : SizedBox.shrink(),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reviews & Ratings",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              (product['rating'] != null && product['rating'] >= 0)
                  ? productRating(product)
                  : SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Wrap productRating(Map<String, dynamic> product) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(Icons.star, size: 16, color: Colors.amber),

        Text(
          (product['rating'] ?? 0).toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Expanded productName(Map<String, dynamic> product) {
    return Expanded(
      child: Text(
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        product['product_name'],
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Column addToWishListColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () async {
            await toggleWishlist();
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            color: AppColors.primaryColor,
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const Text(
          "Wish List",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Column productPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Price",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
        Text(
          '৳${widget.product['price'] != null ? widget.product['price'].toString() : "0"}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }

  Container get buyAndAddToCartSection {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  await addToCart(
                    productId: widget.product['id'],
                    name: widget.product['product_name'],
                    image: widget.product['images'][0],
                    price: widget.product['price'],
                    size: selectedSize ?? "",
                    color: selectedColor != null
                        ? getColorName(selectedColor!)
                        : null,
                  );
                },

                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Buy Now",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> toggleWishlist() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final productId = widget.product['id'];

      final docRef = FirebaseFirestore.instance
          .collection(CollectionHolder.wishlist)
          .doc(user.uid)
          .collection('items')
          .doc(productId);

      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.delete();
        // ignore: use_build_context_synchronously
        showSnackMessage(context, "Removed from wishlist");
        return false;
      } else {
        await docRef.set({
          'product_id': productId,
          'name': widget.product['product_name'],
          'image': widget.product['images'][0],
          'price': widget.product['price'],
          'added_at': FieldValue.serverTimestamp(),
        });
        // ignore: use_build_context_synchronously
        showSnackMessage(context, "Added to wishlist");
        return true;
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackMessage(context, "Something went wrong", true);
      return false;
    }
  }

  Future<void> addToCart({
    required String productId,
    required String name,
    required String image,
    required double price,
    String? color,
    String? size,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final cartRef = FirebaseFirestore.instance
          .collection(CollectionHolder.cart)
          .doc(user.uid)
          .collection('items')
          .doc(productId);

      final doc = await cartRef.get();

      if (doc.exists) {
        await cartRef.update({'quantity': FieldValue.increment(1)});
        // ignore: use_build_context_synchronously
        showSnackMessage(context, "Product already on Cart", true);
      } else {
        await cartRef.set({
          'product_id': productId,
          'name': name,
          'image': image,
          'price': price,
          'quantity': 1,
          'color': color,
          'size': size,
          'added_at': FieldValue.serverTimestamp(),
        });
        // ignore: use_build_context_synchronously
        showSnackMessage(context, "Product added on Cart");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackMessage(context, "Failed to add on Cart", true);
    }
  }
}
