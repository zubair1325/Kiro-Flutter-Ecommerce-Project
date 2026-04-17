import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:flutter/material.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<dynamic> images;
  const ProductImageCarousel({super.key, this.height, required this.images});
  final double? height;

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  final ValueNotifier<int> _indexNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            height: widget.height ?? 220.0,
            onPageChanged: (index, reason) {
              _indexNotifier.value = index;
            },
          ),
          items: widget.images.map((img) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      img,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain, // 🔥 FIXED
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),

        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: ValueListenableBuilder(
            valueListenable: _indexNotifier,
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < widget.images.length; i++)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 10,
                      width: 10,
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
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}