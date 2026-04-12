import 'dart:convert';
import 'dart:io';
import 'package:ecommerce/data/cloudnary/cloud_preset.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

Future<void> uploadPDF() async {
  try {
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

    // 2. Cloudinary URL (use auto/upload for non-image files)
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/dxaj5s787/auto/upload',
    );

    // 3. Create request
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = CloudPreset.nidPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    // 4. Send request
    final response = await request.send();

    // 5. Handle response
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      String fileUrl = jsonMap['secure_url'];

      print("PDF Uploaded Successfully");
      print("📎 URL: $fileUrl");

    } else {
      print("Upload failed: ${response.statusCode}");
    }
  } catch (e) {
    print(" Error: $e");
  }
}
