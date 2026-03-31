import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.categoryType,
    required this.onTapAction,
  });
  final String categoryType;
  final VoidCallback onTapAction;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          categoryType,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        TextButton(
          onPressed: onTapAction,
          child: Text(
            "See All",
            style: TextStyle(color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}
