import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/firebase/collection_holder.dart';
import 'package:ecommerce/presentation/state_holders/operation_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SellerInformation {
  String? authID = FirebaseAuth.instance.currentUser!.uid;
  bool? sellerStatus;
  bool? accountActiveStatus;
  bool? isRejected;
  String? nidLink;
  String? storeName;

  SellerInformation({
    this.sellerStatus = false,
    this.accountActiveStatus = false,
    this.isRejected = false,
    required this.nidLink,
    required this.storeName,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_auth_id': authID,
      'seller_status': sellerStatus,
      'account_active_status': accountActiveStatus,
      'nid_link': nidLink,
      'is_rejected': isRejected,
      'store_name': storeName,
    };
  }

  static Future<OperationState> addData(SellerInformation user) async {
    try {
      FirebaseFirestore.instance.collection(CollectionHolder.seller).add(user.toMap());
      return OperationState("Requested Submitted Successfully");
    } catch (e) {
      return OperationState("Operation Failed", isFailed: false);
    }
  }
}
