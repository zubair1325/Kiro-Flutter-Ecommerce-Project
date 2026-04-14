import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> productData;

  const EditProductScreen({
    super.key,
    required this.productId,
    required this.productData,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController quantityController;

  List<String> images = [];
  Map<String, dynamic> attributes = {};

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.productData["product_name"]);
    priceController =
        TextEditingController(text: widget.productData["price"].toString());
    quantityController =
        TextEditingController(text: widget.productData["quantity"].toString());

    images = List<String>.from(widget.productData["images"] ?? []);
    attributes = Map<String, dynamic>.from(
        widget.productData["attributes"] ?? {});
  }

  /// ================= IMAGE UPLOAD =================
  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    File file = File(image.path);

    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/dxaj5s787/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'your_upload_preset'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resData = await response.stream.toBytes();
      final jsonMap = jsonDecode(String.fromCharCodes(resData));

      setState(() {
        images.add(jsonMap['url']);
      });
    }
  }

  /// ================= UPDATE =================
  Future<void> updateProduct() async {
    setState(() => isLoading = true);

    await FirebaseFirestore.instance
        .collection("products")
        .doc(widget.productId)
        .update({
      "product_name": nameController.text,
      "price": double.parse(priceController.text),
      "quantity": int.parse(quantityController.text),
      "images": images,
      "attributes": attributes,
    });

    setState(() => isLoading = false);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _input(nameController, "Product Name"),
            _input(priceController, "Price", isNumber: true),
            _input(quantityController, "Quantity", isNumber: true),

            const SizedBox(height: 10),

            /// IMAGE GRID
            Wrap(
              spacing: 10,
              children: [
                ...images.map((url) => Stack(
                      children: [
                        Image.network(url,
                            height: 80, width: 80, fit: BoxFit.cover),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                images.remove(url);
                              });
                            },
                            child:
                                const Icon(Icons.close, color: Colors.red),
                          ),
                        )
                      ],
                    )),
                GestureDetector(
                  onTap: uploadImage,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: const Icon(Icons.add),
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            /// ATTRIBUTES
            ...attributes.keys.map((key) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller:
                      TextEditingController(text: attributes[key]),
                  onChanged: (val) => attributes[key] = val,
                  decoration: InputDecoration(
                    labelText: key,
                    border: OutlineInputBorder(),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : updateProduct,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Update Product"),
            )
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String label,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType:
            isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}