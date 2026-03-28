import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/presentation/state_holders/operation_state.dart';

class AddFirebase {
  String? city;
  String? email_address;
  String? first_name;
  String? last_name;
  String? mobile;
  String? shipping_address;
  String? password;
  AddFirebase(
    this.city,
    this.email_address,
    this.first_name,
    this.last_name,
    this.mobile,
    this.shipping_address,
    this.password
  );

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'email_address': email_address,
      'first_name': first_name,
      'last_name': last_name,
      'mobile': mobile,
      'shipping_address': shipping_address,
    };
  }

  static Future<OperationState> addData(AddFirebase user) async {
    try {
      FirebaseFirestore.instance.collection('user').add(user.toMap());
      return OperationState("Account Created Successfully");
    } catch (e) {
      return OperationState("New Account Creation Failed", isFailed: false);
    }
  }
}
