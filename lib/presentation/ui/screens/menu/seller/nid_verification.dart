import 'package:ecommerce/data/model/seller_information.dart';
import 'package:ecommerce/presentation/ui/utility/snack_message.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:ecommerce/data/cloudnary/cloud_preset.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

// ignore: must_be_immutable
class NidVerification extends StatefulWidget {
  String? storeName;
  NidVerification({super.key, required this.storeName});

  @override
  State<NidVerification> createState() => _NidVerificationState();
}

class _NidVerificationState extends State<NidVerification> {
  String fileName = "No file selected";
  bool isProgressing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NID Verification"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // Title
            const Text(
              "Upload Your NID PDF",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Upload Box
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.picture_as_pdf, size: 50, color: Colors.red),
                  const SizedBox(height: 10),
                  Text(fileName, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Upload Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Visibility(
                replacement: Center(child: CircularProgressIndicator()),
                visible: isProgressing == false,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await uploadPDF();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Upload PDF"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadPDF() async {
    try {
      isProgressing = true;
      if (mounted) {
        setState(() {});
      }
      // 1. Pick PDF file only
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null) {
        // print("No file selected");
        return;
      }

      File file = File(result.files.single.path!);

      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dxaj5s787/raw/upload',
      );

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = CloudPreset.nidPreset
        ..files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            contentType: MediaType('application', 'pdf'),
          ),
        );

      // 4. Send request
      final response = await request.send();

      // 5. Handle response
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);

        String fileUrl = jsonMap['secure_url'];
        SellerInformation sellerInfo = SellerInformation(
          nidLink: fileUrl,
          storeName: widget.storeName,
        );
        await SellerInformation.addData(sellerInfo);

        isProgressing = false;
        if (mounted) {
          setState(() {});
        }

        // ignore: use_build_context_synchronously
        showSnackMessage(context, "Document Uploaded Successfully");

        // print("PDF Uploaded Successfully");
        // print("📎 URL: $fileUrl");
      } else {
        // print("Upload failed: ${response.statusCode}");
        // ignore: use_build_context_synchronously
        showSnackMessage(context, "Something went wrong ", true);
      }
    } catch (e) {
      // print(" Error: $e");
    }
  }
}
