import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController subSubCategoryController =
      TextEditingController();

  List<Map<String, dynamic>> fields = [];

  void addField() {
    setState(() {
      fields.add({
        "label_controller": TextEditingController(),
        "type": "text",
        "options": <TextEditingController>[],
      });
    });
  }

  void addDropdownOption(int index) {
    setState(() {
      fields[index]["options"].add(TextEditingController());
    });
  }

  Future<void> saveCategory() async {
    List<Map<String, dynamic>> finalFields = [];

    for (var field in fields) {
      List<TextEditingController> optionControllers =
          List<TextEditingController>.from(field["options"]);

      List<String> options = [];

      if (field["type"] == "dropdown") {
        options = optionControllers
            .map((e) => e.text.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }

      finalFields.add({
        "label": field["label_controller"].text.trim(),
        "type": field["type"],
        "options": options,
      });
    }

    await FirebaseFirestore.instance.collection("categories").add({
      "category": categoryController.text.trim(),
      "sub_category": subCategoryController.text.trim(),
      "sub_sub_category": subSubCategoryController.text.trim(),

      "fields": finalFields,

      "system_fields": {
        "product_name": true,
        "price": true,
        "quantity": true,
        "images": true,
        "rating": true,
        'colors': true,
        "description": true,
        'sizes': true,
      },

      "created_at": Timestamp.now(),
    });

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Widget buildFieldCard(int index) {
    final field = fields[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: field["label_controller"],
                  decoration: const InputDecoration(labelText: "Field Name"),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    fields.removeAt(index);
                  });
                },
                icon: const Icon(Icons.close, color: Colors.red),
              ),
            ],
          ),

          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            value: field["type"],
            items: const [
              DropdownMenuItem(value: "text", child: Text("Text")),
              DropdownMenuItem(value: "number", child: Text("Number")),
              DropdownMenuItem(value: "dropdown", child: Text("Dropdown")),
            ],
            onChanged: (value) {
              setState(() {
                field["type"] = value!;
              });
            },
            decoration: const InputDecoration(labelText: "Field Type"),
          ),

          /// Dropdown Options
          if (field["type"] == "dropdown") ...[
            const SizedBox(height: 10),

            Column(
              children: List.generate(field["options"].length, (i) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: field["options"][i],
                        decoration: InputDecoration(
                          labelText: "Option ${i + 1}",
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          field["options"].removeAt(i);
                        });
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                );
              }),
            ),

            TextButton.icon(
              onPressed: () => addDropdownOption(index),
              icon: const Icon(Icons.add),
              label: const Text("Add Option"),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(title: const Text("Add Category"), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// CATEGORY STRUCTURE
                  _sectionCard(
                    title: "Category Structure",
                    children: [
                      _inputField(categoryController, "Category"),
                      _inputField(subCategoryController, "Sub Category"),
                      _inputField(subSubCategoryController, "Sub Sub Category"),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _sectionCard(
                    title: "System Fields",
                    children: const [
                      _InfoText(
                        "Product Name, Price, Quantity, Ratings, Sizes, Description and Multiple Images will be automatically added by the system.",
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _sectionCard(
                    title: "Custom Fields",
                    children: [
                      ...List.generate(fields.length, buildFieldCard),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: addField,
                        icon: const Icon(Icons.add),
                        label: const Text("Add Field"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: saveCategory,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Save Category"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String text;
  const _InfoText(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
