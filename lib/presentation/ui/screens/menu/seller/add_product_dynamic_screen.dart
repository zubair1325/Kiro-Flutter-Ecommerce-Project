import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/cloudnary/cloud_preset.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddProductDynamicScreen extends StatefulWidget {
  const AddProductDynamicScreen({super.key});

  @override
  State<AddProductDynamicScreen> createState() =>
      _AddProductDynamicScreenState();
}

class _AddProductDynamicScreenState extends State<AddProductDynamicScreen> {
  String? selectedCategoryId;
  Map<String, dynamic>? selectedCategoryData;

  /// DEFAULT FIELDS
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  /// DYNAMIC FIELDS
  Map<String, dynamic> formData = {};

  /// IMAGES
  List<String> imageUrls = [];
  bool isUploading = false;

  bool isLoading = false;

  /// ================= LOAD CATEGORY =================
  Future<void> loadCategory(String docId) async {
    final doc = await FirebaseFirestore.instance
        .collection("categories")
        .doc(docId)
        .get();

    setState(() {
      selectedCategoryId = docId;
      selectedCategoryData = doc.data();
      formData.clear();
    });
  }

  /// ================= IMAGE UPLOAD =================
  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() => isUploading = true);

    File file = File(image.path);

    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dxaj5s787/upload');

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = CloudPreset
            .productPreset // 🔴 CHANGE THIS
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final resData = await response.stream.toBytes();
        final jsonMap = jsonDecode(String.fromCharCodes(resData));

        setState(() {
          imageUrls.add(jsonMap['url']);
        });
      }
    } catch (e) {
      debugPrint("Upload error: $e");
    }

    setState(() => isUploading = false);
  }

  /// ================= SAVE PRODUCT =================
  Future<void> saveProduct() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        imageUrls.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Fill all required fields")));
      return;
    }

    setState(() => isLoading = true);

    await FirebaseFirestore.instance.collection("products").add({
      "seller_id": userId,

      /// DEFAULT FIELDS
      "product_name": nameController.text.trim(),
      "price": double.tryParse(priceController.text.trim()) ?? 0,
      "quantity": int.tryParse(quantityController.text.trim()) ?? 0,
      "images": imageUrls,

      /// CATEGORY
      "category_id": selectedCategoryId,
      "category": selectedCategoryData?["category"],
      "sub_category": selectedCategoryData?["sub_category"],

      /// DYNAMIC
      "attributes": formData,

      "created_at": Timestamp.now(),
    });

    setState(() => isLoading = false);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  /// ================= BUILD FIELD =================
  Widget buildField(Map<String, dynamic> field) {
    final label = field["label"];
    final type = field["type"];

    if (type == "text") return _textField(label);
    if (type == "number") return _textField(label, isNumber: true);
    if (type == "dropdown") return _dropdownField(label, field["options"]);

    return const SizedBox();
  }

  Widget _textField(String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) => formData[label] = value,
      ),
    );
  }

  Widget _dropdownField(String label, List<dynamic> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField(
        items: options
            .map<DropdownMenuItem>(
              (e) => DropdownMenuItem(value: e, child: Text(e.toString())),
            )
            .toList(),
        onChanged: (value) => formData[label] = value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  /// ================= IMAGE GRID =================
  Widget buildImageGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ...imageUrls.map(
          (url) => Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  url,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      imageUrls.remove(url);
                    });
                  },
                  child: const Icon(Icons.close, color: Colors.red),
                ),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: uploadImage,
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: isUploading
                ? const Center(child: CircularProgressIndicator())
                : const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(title: const Text("Add Product")),
      body: Column(
        children: [
          /// CATEGORY SELECT
          Padding(
            padding: const EdgeInsets.all(16),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("categories")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return DropdownButtonFormField(
                  hint: const Text("Select Category"),
                  items: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: doc.id,
                      child: Text(
                        "${data['category']} > ${data['sub_category']}",
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => loadCategory(val.toString()),
                );
              },
            ),
          ),

          Expanded(
            child: selectedCategoryData == null
                ? const Center(child: Text("Select category first"))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        /// DEFAULT FIELDS
                        _textInput(nameController, "Product Name"),
                        _textInput(priceController, "Price", isNumber: true),
                        _textInput(
                          quantityController,
                          "Quantity",
                          isNumber: true,
                        ),

                        const SizedBox(height: 10),

                        /// IMAGES
                        buildImageGrid(),

                        const SizedBox(height: 20),

                        /// DYNAMIC FIELDS
                        ...List.generate(
                          selectedCategoryData!["fields"].length,
                          (i) => buildField(selectedCategoryData!["fields"][i]),
                        ),
                      ],
                    ),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: isLoading ? null : saveProduct,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Add Product"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textInput(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
