
import 'package:count_button/count_button.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:flutter/material.dart';

class CartProductItem extends StatefulWidget {
  const CartProductItem({super.key});

  @override
  State<CartProductItem> createState() => _CartProductItemState();
}

class _CartProductItemState extends State<CartProductItem> {
  final ValueNotifier<int> _cartItemCount = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              width: 160,
              height: 100,
              fit: BoxFit.cover,
              "https://images.unsplash.com/photo-1608231387042-66d1773070a5?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "New Year Special Shoe",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Color: Red",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Size: XL",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(Icons.delete_forever_outlined),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$100",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),

                    ValueListenableBuilder(
                      valueListenable: _cartItemCount,
                      builder: (context, value, child) {
                        return CountButton(
                          selectedValue: value,
                          minValue: 0,
                          maxValue: 99,
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primaryColor,
                          buttonSize: const Size(24, 24),
                          borderRadius: 4.0,
                          onChanged: (value) {
                            setState(() {
                              _cartItemCount.value = value;
                            });
                          },
                          valueBuilder: (value) {
                            return Text(
                              value.toString(),
                              style: const TextStyle(fontSize: 14.0),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
