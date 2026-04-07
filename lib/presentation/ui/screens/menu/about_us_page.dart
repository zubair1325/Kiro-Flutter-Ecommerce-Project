import 'package:ecommerce/presentation/ui/screens/menu/login_state.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(onPressed: ()=>Get.offAll(LoginState()), icon: Icon(Icons.arrow_back_ios),),
        title: const Text("About Us", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 25)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Who We Are",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Text(
              "We are a team of passionate developers dedicated to building smart digital solutions. "
              "This B2B e-commerce platform is developed as part of our academic project with the goal "
              "of solving real-world business challenges in bulk buying and selling.",
              style: TextStyle(fontSize: 15),
            ),

            SizedBox(height: 20),

            Text(
              "Our Mission",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Text(
              "Our mission is to simplify business-to-business transactions by creating a fast, reliable, "
              "and user-friendly platform. We aim to connect suppliers and buyers efficiently, reduce manual work, "
              "and bring transparency into the wholesale marketplace.",
              style: TextStyle(fontSize: 15),
            ),

            SizedBox(height: 20),

            Text(
              "What We Built",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Text(
              "This application enables businesses to browse products, place bulk orders, and manage transactions seamlessly. "
              "It is built using Flutter to ensure smooth performance across platforms and a modern user experience.",
              style: TextStyle(fontSize: 15),
            ),

            SizedBox(height: 30),

            Text(
              "Our Team",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 15),

            _TeamMember(id: "242220005101325", name: "Md. Zubair Rahman"),
            _TeamMember(id: "24222005101321", name: "Mahadi Hasan Rakib"),
            _TeamMember(id: "242220005101317", name: "Ashraful Alam Chowdhury"),
            _TeamMember(id: "242220005101330", name: "Mohammed Saiful Islam"),
            _TeamMember(id: "242220005101300", name: "Taslima Tasbir"),

            SizedBox(height: 30),

            Center(
              child: Text(
                "© 2026 Kiro E-Commerce App\nAll rights reserved.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamMember extends StatelessWidget {
  final String id;
  final String name;

  const _TeamMember({required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.person, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 15))),
          Text(id, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
