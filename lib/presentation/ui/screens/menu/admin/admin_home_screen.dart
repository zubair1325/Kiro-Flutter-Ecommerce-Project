import 'package:ecommerce/presentation/ui/screens/menu/admin/add_category_screen.dart';
import 'package:ecommerce/presentation/ui/screens/menu/admin/admin_carousel_request_screen.dart';
import 'package:ecommerce/presentation/ui/screens/menu/admin/all_seller_list_screen.dart';
import 'package:ecommerce/presentation/ui/screens/menu/admin/seller_request_list_screen.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SingleSection(
              title: "Product Management",
              children: [
                _buildOptionCard(
                  context,
                  title: "Product Categories",
                  subtitle: "Product categories and sub categories",
                  icon: Icons.category_outlined,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SellerRequestListScreen(),
                      ),
                    );
                  },
                ),
                _buildOptionCard(
                  context,
                  title: "Add Product Categories",
                  subtitle: "Product categories and sub categories",
                  icon: Icons.add_box_outlined,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddCategoryScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            _SingleSection(
              title: "Seller Management",
              children: [
                _buildOptionCard(
                  context,
                  title: "Seller Requests",
                  subtitle: "Approve or reject seller applications",
                  icon: Icons.storefront_outlined,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SellerRequestListScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildOptionCard(
                  context,
                  title: "All Sellers",
                  subtitle: "View all active sellers",
                  icon: Icons.people_alt_outlined,
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AllSellerListScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            _SingleSection(
              title: "CarouselSlider Ad",
              children: [
                _buildOptionCard(
                  context,
                  title: "Add Request",
                  subtitle: "Approve or reject seller applications",
                  icon:
                      Icons.playlist_add_check_circle_outlined, // Add Request,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminCarouselRequestScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),
              ],
            ),
            const SizedBox(height: 16),

            // _SingleSection(
            //   title: "Account Management",
            //   children: [
            //     _buildOptionCard(
            //       context,
            //       title: "Account Deactivation",
            //       subtitle: "Manage user deactivation requests",
            //       icon: Icons.person_off_outlined,
            //       color: Colors.red,
            //       onTap: () {
            //         // Navigate later
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SingleSection({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(children: children),
      ],
    );
  }
}
