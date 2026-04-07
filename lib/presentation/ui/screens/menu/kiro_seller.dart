import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class KiroSeller extends StatefulWidget {
  const KiroSeller({super.key});

  @override
  State<KiroSeller> createState() => _KiroSellerState();
}

class _KiroSellerState extends State<KiroSeller> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
