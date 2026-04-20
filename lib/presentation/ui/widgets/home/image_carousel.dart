import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/presentation/ui/screens/product/product_details_page.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key, this.height});

  final double? height;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final ValueNotifier<int> _indexNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('carousel_items')
          .where('expire_at', isGreaterThan: Timestamp.now())
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox();
        }

        final items = snapshot.data!.docs;

        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,
                height: widget.height ?? 190.0,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  _indexNotifier.value = index;
                },
              ),
              items: items.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final product = data['product_data'];

                final images = product['images'] as List<dynamic>? ?? [];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsPage(product: product),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white70,
                      image: images.isNotEmpty
                          ? DecorationImage(image: NetworkImage(images[0]))
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 8),

            ValueListenableBuilder<int>(
              valueListenable: _indexNotifier,
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(items.length, (i) {
                    return Container(
                      height: 10,
                      width: 10,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: i == value
                            ? AppColors.primaryColor
                            : Colors.white,
                        border: Border.all(
                          color: i == value
                              ? AppColors.primaryColor
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:ecommerce/presentation/ui/screens/product/product_details_page.dart';
// import 'package:flutter/material.dart';

// class ImageCarousel extends StatelessWidget {
//   const ImageCarousel({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('carousel_items')
//           .where('expire_at', isGreaterThan: Timestamp.now())
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const SizedBox();

//         final items = snapshot.data!.docs;

//         return CarouselSlider(
//           options: CarouselOptions(
//             height: 180,
//             autoPlay: true,
//             enlargeCenterPage: true,
//           ),
//           items: items.map((doc) {
//             final data = doc.data();
//             final product = data['product_data'];

//             return GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => ProductDetailsPage(product: product),
//                   ),
//                 );
//               },
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 5),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   image: DecorationImage(
//                     image: NetworkImage(product['images'][0]),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }
