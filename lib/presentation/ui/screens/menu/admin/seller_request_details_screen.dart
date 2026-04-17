import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/firebase/collection_holder.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerRequestDetailsScreen extends StatefulWidget {
  final String sellerDocId;
  final String userAuthId;

  const SellerRequestDetailsScreen({
    super.key,
    required this.sellerDocId,
    required this.userAuthId,
  });

  @override
  State<SellerRequestDetailsScreen> createState() =>
      _SellerRequestDetailsScreenState();
}

class _SellerRequestDetailsScreenState
    extends State<SellerRequestDetailsScreen> {
  bool isLoading = false;

  Future<Map<String, dynamic>?> getUserData() async {
    final query = await FirebaseFirestore.instance
        .collection(CollectionHolder.user)
        .where('user_auth_id', isEqualTo: widget.userAuthId)
        .get();

    if (query.docs.isEmpty) return null;

    return query.docs.first.data();
  }

  Future<Map<String, dynamic>?> getSellerData() async {
    final doc = await FirebaseFirestore.instance
        .collection(CollectionHolder.seller)
        .doc(widget.sellerDocId)
        .get();

    return doc.data();
  }

  Future<void> approveSeller() async {
    setState(() => isLoading = true);

    final batch = FirebaseFirestore.instance.batch();

    final sellerRef = FirebaseFirestore.instance
        .collection(CollectionHolder.seller)
        .doc(widget.sellerDocId);

    final userQuery = await FirebaseFirestore.instance
        .collection(CollectionHolder.user)
        .where('user_auth_id', isEqualTo: widget.userAuthId)
        .get();

    final userRef = userQuery.docs.first.reference;

    batch.update(sellerRef, {
      'account_active_status': true,
      'seller_status': true,
    });

    batch.update(userRef, {'is_seller': true});

    await batch.commit();

    setState(() => isLoading = false);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future<void> rejectSeller() async {
    setState(() => isLoading = true);

    await FirebaseFirestore.instance
        .collection(CollectionHolder.seller)
        .doc(widget.sellerDocId)
        .update({'is_rejected': true});

    setState(() => isLoading = false);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future<void> openNid(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Request Details")),
      body: FutureBuilder(
        future: Future.wait([getUserData(), getSellerData()]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data![0] as Map<String, dynamic>;
          final sellerData = snapshot.data![1] as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: ${userData['first_name']} ${userData['last_name']}",
                ),
                Text("Email: ${userData['email_address']}"),
                Text("Phone: ${userData['mobile']}"),
                Text("City: ${userData['city']}"),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => openNid(sellerData['nid_link']),
                  child: const Text("View NID PDF"),
                ),

                const Spacer(),

                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: approveSeller,
                          child: const Text("Approve"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: rejectSeller,
                          child: const Text("Reject"),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
