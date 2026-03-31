import 'package:carousel_slider/carousel_slider.dart';
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
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            height: widget.height ?? 190.0,
            autoPlay: true,
            onPageChanged: (index, reason) {
              _indexNotifier.value = index;
            },
          ),
          items: [1, 2, 3, 4, 5].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('text $i', style: TextStyle(fontSize: 16.0)),
                );
              },
            );
          }).toList(),
        ),
        ValueListenableBuilder(
          valueListenable: _indexNotifier,
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 5; i++)
                  Container(
                    height: 12,
                    width: 12,
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: i == value ? AppColors.primaryColor : Colors.white,
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
      ],
    );
  }
}
