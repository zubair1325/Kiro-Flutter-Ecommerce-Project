// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:count_button/count_button.dart';
// import 'package:ecommerce/data/firebase/collection_holder.dart';
// import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class CartProductItem extends StatefulWidget {
//   final Map<String, dynamic> product;

//   const CartProductItem({super.key, required this.product});

//   @override
//   State<CartProductItem> createState() => _CartProductItemState();
// }

// class _CartProductItemState extends State<CartProductItem> {
//   late ValueNotifier<int> _cartItemCount;

//   @override
//   void initState() {
//     super.initState();
//     _cartItemCount = ValueNotifier<int>((widget.product['quantity'] ?? 1));
//   }

//   Future<void> _deleteItem() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     await FirebaseFirestore.instance
//         .collection(CollectionHolder.cart)
//         .doc(user.uid)
//         .collection('items')
//         .doc(widget.product['id'])
//         .delete();
//   }

//   Future<void> _updateQuantity(int value) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     await FirebaseFirestore.instance
//         .collection(CollectionHolder.cart)
//         .doc(user.uid)
//         .collection('items')
//         .doc(widget.product['id'])
//         .update({'quantity': value});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(16),
//               bottomLeft: Radius.circular(16),
//             ),
//             child: Image.network(
//               widget.product['image'] ?? '',
//               width: 120,
//               height: 100,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) =>
//                   const Icon(Icons.image_not_supported),
//             ),
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           widget.product['name'] ?? '',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black54,
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: _deleteItem,
//                         icon: const Icon(Icons.delete_forever_outlined),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       widget.product['color'] == null ||
//                               widget.product['color'] == ''
//                           ? SizedBox.shrink()
//                           : Text("Color: ${widget.product['color'] ?? ''}"),
//                       const SizedBox(width: 8),
//                       widget.product['size'] == null ||
//                               widget.product['size'] == ''
//                           ? SizedBox.shrink()
//                           : Text("Size: ${widget.product['size'] ?? ''}"),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "৳${(widget.product['price'] ?? 0).toString()}",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.primaryColor,
//                         ),
//                       ),
//                       ValueListenableBuilder<int>(
//                         valueListenable: _cartItemCount,
//                         builder: (context, value, child) {
//                           return CountButton(
//                             selectedValue: value,
//                             minValue: 1,
//                             maxValue: 99,
//                             foregroundColor: Colors.white,
//                             backgroundColor: AppColors.primaryColor,
//                             buttonSize: const Size(24, 24),
//                             borderRadius: 4.0,
//                             onChanged: (value) {
//                               _cartItemCount.value = value;
//                               _updateQuantity(value);
//                             },
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:count_button/count_button.dart';
import 'package:ecommerce/data/firebase/collection_holder.dart';
import 'package:ecommerce/presentation/ui/utility/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartProductItem extends StatefulWidget {
  final Map<String, dynamic> product;

  const CartProductItem({super.key, required this.product});

  @override
  State<CartProductItem> createState() => _CartProductItemState();
}

class _CartProductItemState extends State<CartProductItem> {
  late ValueNotifier<int> _cartItemCount;

  @override
  void initState() {
    super.initState();
    _cartItemCount = ValueNotifier<int>((widget.product['quantity'] ?? 1));
  }

  Future<void> _deleteItem() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection(CollectionHolder.cart)
        .doc(user.uid)
        .collection('items')
        .doc(widget.product['id'])
        .delete();
  }

  /// 🔥 FIXED: Check stock before updating quantity
  Future<void> _updateQuantity(int value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 👉 Get product ID (IMPORTANT: make sure you saved this in cart)
      final productId = widget.product['product_id'];

      if (productId == null) return;

      // 👉 Fetch real stock from products collection
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (!productDoc.exists) return;

      final stock = productDoc.data()?['quantity'] ?? 0;

      // ❌ If user tries to exceed stock
      if (value > stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Only $stock items available in stock")),
        );

        // reset to max available stock
        _cartItemCount.value = stock;
        value = stock;
      }

      // ✅ Update cart with valid quantity
      await FirebaseFirestore.instance
          .collection(CollectionHolder.cart)
          .doc(user.uid)
          .collection('items')
          .doc(widget.product['id'])
          .update({'quantity': value});
    } catch (e) {
      debugPrint("Error updating quantity: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              widget.product['image'] ?? '',
              width: 120,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.product['name'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _deleteItem,
                        icon: const Icon(Icons.delete_forever_outlined),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      widget.product['color'] == null ||
                              widget.product['color'] == ''
                          ? SizedBox.shrink()
                          : Text("Color: ${widget.product['color'] ?? ''}"),
                      const SizedBox(width: 8),
                      widget.product['size'] == null ||
                              widget.product['size'] == ''
                          ? SizedBox.shrink()
                          : Text("Size: ${widget.product['size'] ?? ''}"),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "৳${(widget.product['price'] ?? 0).toString()}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      ValueListenableBuilder<int>(
                        valueListenable: _cartItemCount,
                        builder: (context, value, child) {
                          return CountButton(
                            selectedValue: value,
                            minValue: 1,

                            /// 🔥 OPTIONAL IMPROVEMENT:
                            /// Set high max, real limit handled by DB check
                            maxValue: 999,

                            foregroundColor: Colors.white,
                            backgroundColor: AppColors.primaryColor,
                            buttonSize: const Size(24, 24),
                            borderRadius: 4.0,
                            onChanged: (value) {
                              _cartItemCount.value = value;
                              _updateQuantity(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
