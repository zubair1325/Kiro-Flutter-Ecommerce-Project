import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class InvoiceScreen extends StatelessWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const InvoiceScreen({
    super.key,
    required this.orderId,
    required this.orderData,
  });

  Future<pw.Document> generatePdf() async {
    final pdf = pw.Document();

    final items = orderData['items'] as List;
    final address = orderData['address'];
    final total = (orderData['total_price'] ?? 0).toDouble();

    final date = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "INVOICE",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Text("Order ID: $orderId"),
              pw.Text("Date: $date"),

              pw.Divider(),

              pw.Text(
                "Delivery Address",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),

              pw.Text("${address['name']}"),
              pw.Text("${address['phone']}"),
              pw.Text("${address['address_line']}, ${address['city']}"),

              pw.SizedBox(height: 20),

              pw.Text(
                "Items",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),

              pw.SizedBox(height: 10),

              ...items.map((item) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(child: pw.Text(item['name'] ?? '')),
                    pw.Text("x${item['quantity']}"),
                    pw.Text("৳${item['price']}"),
                  ],
                );
              }).toList(),

              pw.Divider(),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Total: ৳${total.toStringAsFixed(2)}",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  Future<void> downloadPdf() async {
    final pdf = await generatePdf();

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/invoice_$orderId.pdf");

    await file.writeAsBytes(await pdf.save());

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "invoice_$orderId.pdf",
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = orderData['items'] as List;
    final address = orderData['address'];
    final total = (orderData['total_price'] ?? 0).toDouble();

    final now = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice"),
        actions: [
          IconButton(icon: const Icon(Icons.download), onPressed: downloadPdf),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "INVOICE",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Order ID: $orderId"),
                        Text("Date: $now"),
                      ],
                    ),
                  ],
                ),

                const Divider(height: 30),

                // ADDRESS
                const Text(
                  "Delivery Address",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(address['name'] ?? ''),
                Text(address['phone'] ?? ''),
                Text("${address['shipping_address']}, ${address['city']}"),

                const SizedBox(height: 20),

                // ITEMS
                const Text(
                  "Items",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Column(
                  children: items.map<Widget>((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              item['name'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(child: Text("x${item['quantity']}")),
                          Expanded(child: Text("৳${item['price']}")),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const Divider(height: 30),

                // TOTAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "৳${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                const Center(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 50),
                      SizedBox(height: 8),
                      Text(
                        "Order Placed Successfully!",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
