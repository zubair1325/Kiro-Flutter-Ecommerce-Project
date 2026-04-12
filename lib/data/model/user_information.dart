import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/presentation/state_holders/operation_state.dart';

class UserInformation {
  String? city;
  String? emailAddress;
  String? firstName;
  String? lastName;
  String? mobile;
  String? shippingAddress;
  String? password;
  String? userAuthID;
  bool isSeller = false;
  bool isAdmin = false;
  bool isNumberVerified = false;
  UserInformation(
    this.city,
    this.emailAddress,
    this.firstName,
    this.lastName,
    this.mobile,
    this.shippingAddress,
    this.password,
    
  );

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'email_address': emailAddress,
      'first_name': firstName,
      'last_name': lastName,
      'mobile': mobile,
      'shipping_address': shippingAddress,
      'is_seller': isSeller,
      'is_admin': isAdmin,
      'is_number_verified': isNumberVerified,
      'user_auth_id': userAuthID,
    };
  }

  static Future<OperationState> addData(UserInformation user) async {
    try {
      FirebaseFirestore.instance.collection('user').add(user.toMap());
      return OperationState("Account Created Successfully");
    } catch (e) {
      return OperationState("New Account Creation Failed", isFailed: false);
    }
  }
}
