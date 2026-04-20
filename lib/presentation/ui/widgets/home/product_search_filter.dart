import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductSearchFilter extends StatefulWidget {
  const ProductSearchFilter({super.key});

  @override
  State<ProductSearchFilter> createState() => _ProductSearchFilterState();
}

class _ProductSearchFilterState extends State<ProductSearchFilter> {
  final TextEditingController _searchController = TextEditingController();

  String? _selectedCategory;
  double _minPrice = 0;
  double _maxPrice = 100000;

  /// 🔥 FIRESTORE QUERY
  Stream<QuerySnapshot<Map<String, dynamic>>> getFilteredProducts() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(
      'products',
    );

    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      query = query.where('category', isEqualTo: _selectedCategory);
    }

    query = query
        .where('price', isGreaterThanOrEqualTo: _minPrice)
        .where('price', isLessThanOrEqualTo: _maxPrice);

    return query.snapshots();
  }

  /// 🔍 SEARCH FILTER
  List<Map<String, dynamic>> applySearch(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final query = _searchController.text.toLowerCase();

    return docs
        .where((doc) {
          final name = (doc.data()['product_name'] ?? '')
              .toString()
              .toLowerCase();
          return name.contains(query);
        })
        .map((doc) {
          return {'id': doc.id, ...doc.data()};
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔍 SEARCH FIELD
        TextFormField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            filled: true,
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: "Search product...",
          ),
        ),

        const SizedBox(height: 12),

        /// 🔥 CATEGORY DROPDOWN (FIXED)
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('categories')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();

            final categories = snapshot.data!.docs;

            return DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: const Text("Select Category"),

              /// ✅ FIX: Proper typing + casting
              items: categories.map<DropdownMenuItem<String>>((doc) {
                final data = doc.data();

                final category = data['category']?.toString() ?? '';

                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            );
          },
        ),

        const SizedBox(height: 12),

        /// 💰 PRICE FILTER
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Filter by Price"),
            RangeSlider(
              values: RangeValues(_minPrice, _maxPrice),
              min: 0,
              max: 100000,
              divisions: 100,
              labels: RangeLabels(
                _minPrice.toStringAsFixed(0),
                _maxPrice.toStringAsFixed(0),
              ),
              onChanged: (values) {
                setState(() {
                  _minPrice = values.start;
                  _maxPrice = values.end;
                });
              },
            ),
          ],
        ),

        const SizedBox(height: 16),

        /// 🛒 FILTERED PRODUCTS
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: getFilteredProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data?.docs ?? [];
            final products = applySearch(docs);

            if (products.isEmpty) {
              return const Center(child: Text("No products found"));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return ListTile(
                  title: Text(product['product_name'] ?? ''),
                  subtitle: Text("৳${product['price']}"),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
