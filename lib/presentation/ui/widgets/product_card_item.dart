import 'package:ecommerce/presentation/ui/screens/product/product_details_page.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class ProductCardItem extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCardItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final images = product['images'];
    final image = (images is List && images.isNotEmpty)
        ? images[0]
        : (product['image'] ?? '');

    final name = product['product_name'] ?? product['name'] ?? 'No Name';
    final price = product['price'] ?? 0;
    final rating = product['rating'] ?? 0;
    final discountPrice = product['discount_price'];
    final hasDiscount =
        product['is_discount_active'] == true && discountPrice != null;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.to(() => ProductDetailsPage(product: product));
      },
      child: SizedBox(
        height: 200,
        width: 160,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: image.isNotEmpty
                    ? Image.network(image, width: 160, height: 100)
                    : Container(
                        width: 160,
                        height: 100,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported),
                      ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        hasDiscount
                            ? Column(
                                children: [
                                  /// ORIGINAL PRICE (STRIKETHROUGH)
                                  Text(
                                    "৳${price.toString()}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.black,
                                    ),
                                  ),

                                  /// DISCOUNT PRICE
                                  Text(
                                    "৳${discountPrice.toString()}",
                                    style: const TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "৳${price.toString()}",
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.amber,
                            ),
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          color: AppColors.primaryColor,
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.favorite_border_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
