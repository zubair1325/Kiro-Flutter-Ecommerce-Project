import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminCarouselRequestScreen extends StatelessWidget {
  const AdminCarouselRequestScreen({super.key});

  Future<void> acceptRequest(String docId, Map<String, dynamic> data) async {
    final expireAt = Timestamp.fromDate(
      DateTime.now().add(const Duration(days: 7)),
    );

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final reqRef = FirebaseFirestore.instance
          .collection('carousel_requests')
          .doc(docId);

      final carouselRef =
          FirebaseFirestore.instance.collection('carousel_items').doc();

      tx.update(reqRef, {"status": "approved"});

      tx.set(carouselRef, {
        "product_id": data['product_id'] ?? "",
        "product_data": data['product_data'] ?? {},
        "created_at": Timestamp.now(),
        "expire_at": expireAt,
      });
    });
  }

  Future<void> rejectRequest(String docId) async {
    await FirebaseFirestore.instance
        .collection('carousel_requests')
        .doc(docId)
        .update({"status": "rejected"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(title: const Text("Admin Dashboard")),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('carousel_requests')
            .where('status', isEqualTo: 'pending')
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          final validDocs = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>?;

            final product =
                data?['product_data'] as Map<String, dynamic>?;

            final images = product?['images'];

            return product != null &&
                images is List &&
                images.isNotEmpty;
          }).toList();

          if (validDocs.isEmpty) {
            return const Center(child: Text("No pending requests"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: validDocs.length,
            itemBuilder: (context, index) {
              final doc = validDocs[index];
              final data = doc.data() as Map<String, dynamic>;
              final product = data['product_data'];

              final images = product['images'] as List;
              final imageUrl = images[0];

              return _SafeCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            product['product_name'] ?? "No name",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "৳ ${data['amount'] ?? 0}",
                      style: const TextStyle(color: Colors.green),
                    ),

                    const SizedBox(height: 12),

                    /// 🔥 SAFE BUTTON ROW (NO INFINITY POSSIBLE)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => rejectRequest(doc.id),
                                child: const Text("Reject"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    acceptRequest(doc.id, data),
                                child: const Text("Accept"),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// 🔥 THIS FIXES ALL LAYOUT ISSUES
class _SafeCard extends StatelessWidget {
  final Widget child;

  const _SafeCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // IMPORTANT FIX
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: child,
    );
  }
}