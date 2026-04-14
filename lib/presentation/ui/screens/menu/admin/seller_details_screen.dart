import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerDetailsScreen extends StatelessWidget {
  final String sellerDocId;
  final String userAuthId;

  const SellerDetailsScreen({
    super.key,
    required this.sellerDocId,
    required this.userAuthId,
  });

  Future<Map<String, dynamic>> getAllData() async {
    final sellerDoc = await FirebaseFirestore.instance
        .collection('seller')
        .doc(sellerDocId)
        .get();

    final userQuery = await FirebaseFirestore.instance
        .collection('user')
        .where('user_auth_id', isEqualTo: userAuthId)
        .get();

    return {
      'seller': sellerDoc.data(),
      'user': userQuery.docs.first.data(),
    };
  }

  Future<void> openNid(String url) async {
    await launchUrl(Uri.parse(url));
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildInfoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text("$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(title: const Text("Seller Details")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getAllData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final seller = snapshot.data!['seller'];
          final user = snapshot.data!['user'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Store Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.store, color: Colors.white, size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          seller['store_name'] ?? "Store",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                /// User Info
                buildSectionTitle("Owner Information"),
                buildInfoTile("Name",
                    "${user['first_name']} ${user['last_name']}"),
                buildInfoTile("Email", user['email_address']),
                buildInfoTile("Phone", user['mobile']),
                buildInfoTile("City", user['city']),

                /// Seller Info
                buildSectionTitle("Seller Information"),
                buildInfoTile("Account Active",
                    seller['account_active_status'].toString()),
                buildInfoTile(
                    "Rejected", seller['is_rejected'].toString()),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () => openNid(seller['nid_link']),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("View NID Document"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}