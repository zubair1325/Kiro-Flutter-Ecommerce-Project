import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/firebase/collection_holder.dart';
import 'package:ecommerce/presentation/ui/screens/menu/edit_profile_page.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("My Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => EditProfilePage()),
              );
            },
          ),
        ],
      ),

      //  Using FutureBuilder instead of StreamBuilder
      body: FutureBuilder<Map<String, dynamic>?>(
        future: findUserInformation(),
        builder: (context, snapshot) {
          //  Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //  Error
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          //  No data found
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No profile data found"));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                //  Profile Image
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),

                const SizedBox(height: 20),

                //  Name
                Text(
                  "${data['first_name'] ?? ''} ${data['last_name'] ?? ''}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _buildTile("Email", data['email_address'] ?? ""),
                _buildTile("Mobile", data['mobile'] ?? ""),
                _buildTile("City", data['city'] ?? ""),
                _buildTile("Shipping Address", data['shipping_address'] ?? ""),

                const SizedBox(height: 10),

                _buildTile("Admin", (data['is_admin'] ?? false) ? "Yes" : "No"),
                _buildTile(
                  "Seller",
                  (data['is_seller'] ?? false) ? "Yes" : "No",
                ),
                _buildTile(
                  "Number Verified",
                  (data['is_number_verified'] ?? false) ? "Yes" : "No",
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> findUserInformation() async {
    final userAuthData = FirebaseAuth.instance.currentUser;
    // print(userAuthData);

    final querySnapshot = await FirebaseFirestore.instance
        .collection(CollectionHolder.user)
        .where('user_auth_id', isEqualTo: userAuthData?.uid)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return querySnapshot.docs.first.data();
  }

  Widget _buildTile(String title, String value) {
    return ListTile(title: Text(title), subtitle: Text(value));
  }
}
