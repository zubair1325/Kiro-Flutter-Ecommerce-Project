import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/presentation/ui/screens/menu/admin/seller_request_details_screen.dart';
import 'package:flutter/material.dart';

class SellerRequestListScreen extends StatelessWidget {
  const SellerRequestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seller Requests")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('seller')
            .where('seller_status', isEqualTo: false)
            .where('is_rejected', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Requests Found"));
          }

          final sellers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: sellers.length,
            itemBuilder: (context, index) {
              final sellerData = sellers[index].data() as Map<String, dynamic>;

              final userAuthId = sellerData['user_auth_id'];

              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('user')
                    .where('user_auth_id', isEqualTo: userAuthId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData ||
                      userSnapshot.data!.docs.isEmpty) {
                    return const SizedBox();
                  }

                  final userData =
                      userSnapshot.data!.docs.first.data()
                          as Map<String, dynamic>;

                  return ListTile(
                    title: Text(
                      "${userData['first_name']} ${userData['last_name']}",
                    ),
                    subtitle: Text(userData['email_address']),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SellerRequestDetailsScreen(
                            sellerDocId: sellers[index].id,
                            userAuthId: userAuthId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
