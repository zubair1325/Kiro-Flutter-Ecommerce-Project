import 'package:ecommerce/presentation/ui/utility/assets_path.dart';
import 'package:flutter/material.dart';

class AppBarLogo extends StatelessWidget {
  const AppBarLogo({super.key, this.height, this.width});
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsPath.appBarLogo,
      width: width ?? 110,
      height: height,
    );
  }
}
