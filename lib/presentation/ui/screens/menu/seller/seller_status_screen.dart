import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/presentation/controller/auth_controller.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerStatusScreen extends StatefulWidget {
  const SellerStatusScreen({super.key});

  @override
  State<SellerStatusScreen> createState() => _SellerStatusScreenState();
}

class _SellerStatusScreenState extends State<SellerStatusScreen> {
  Map<String, dynamic>? sellerData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    sellerData = await AuthController.sellerInformation;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> toggleStatus(bool value) async {
    final success = await updateAccountStatus(value);

    if (success) {
      setState(() {
        sellerData!['account_active_status'] = value;
      });
    }
  }

  Future<void> openPdf(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (sellerData == null) {
      return const Scaffold(body: Center(child: Text("No Seller Data Found")));
    }

    final bool isActive = sellerData!['account_active_status'] ?? false;
    final String nidLink = sellerData!['nid_link'] ?? '';
    final bool sellerStatus = sellerData!['seller_status'] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(title: const Text("Seller Status")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Seller Status (Read-only)
            sellerStatus
                ? Text(
                    "Seller Status: Yes",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    "Seller Status: No",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

            const SizedBox(height: 20),

            /// 🔹 Account Active Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Account Active",
                  style: TextStyle(color: AppColors.primaryColor, fontSize: 18),
                ),
                Switch(
                  activeThumbColor: AppColors.primaryColor,
                  value: isActive,
                  onChanged: (value) => toggleStatus(value),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 NID PDF Download
            ElevatedButton(
              onPressed: nidLink.isEmpty ? null : () => openPdf(nidLink),
              child: const Text("View / Download NID PDF"),
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool> updateAccountStatus(bool status) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final query = await FirebaseFirestore.instance
          .collection('seller')
          .where('user_auth_id', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return false;

      final docId = query.docs.first.id;

      await FirebaseFirestore.instance.collection('seller').doc(docId).update({
        'account_active_status': status,
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}
