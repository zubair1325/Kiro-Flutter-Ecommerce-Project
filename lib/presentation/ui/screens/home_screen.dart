import 'package:ecommerce/presentation/ui/widgets/app_bar_logo.dart';
import 'package:ecommerce/presentation/ui/widgets/circle_icon_button.dart';
import 'package:ecommerce/presentation/ui/widgets/image_carousel.dart';
import 'package:ecommerce/presentation/ui/widgets/section_title.dart';
import 'package:flutter/material.dart';

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
              SectionTitle(categoryType: "All Categories", onTapAction: () {}),
               const SizedBox(height: 18),

               Card()
            ],
          ),
        ),
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
